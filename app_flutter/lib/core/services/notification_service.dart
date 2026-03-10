import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'analytics_service.dart';

/// Handler para mensajes en background (debe ser top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No necesitamos hacer nada aquí, Firebase muestra la notificación automáticamente
  debugPrint('Background message received: ${message.messageId}');
}

/// Servicio singleton para Firebase Cloud Messaging
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  GoRouter? _router;
  bool _isInitialized = false;
  bool _timezoneInitialized = false;
  String? _currentUserId;

  /// Inicializa el servicio de notificaciones.
  /// Siempre guarda el token FCM (en Android funciona sin permiso).
  /// Para pedir permiso de mostrar notificaciones, llamar requestPermissionIfNeeded().
  Future<void> init(String userId, GoRouter router) async {
    if (kIsWeb) return;

    _router = router;

    // Si ya está inicializado pero cambió el usuario, solo actualizamos el token
    if (_isInitialized && _currentUserId != userId) {
      _currentUserId = userId;
      await _saveToken(userId);
      return;
    }

    if (_isInitialized) return;

    _currentUserId = userId;

    // 1. Configurar handler para mensajes en background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 2. SIEMPRE intentar guardar el token (en Android funciona sin permiso)
    await _saveToken(userId);

    // 3. Verificar si YA tiene permiso para configurar local notifications
    final settings = await _messaging.getNotificationSettings();
    final alreadyAuthorized =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (alreadyAuthorized) {
      await _setupLocalNotifications();
    }

    // 4. Escuchar cambios de token
    _messaging.onTokenRefresh.listen((newToken) {
      if (_currentUserId != null) {
        _saveTokenToSupabase(newToken, _currentUserId!);
      }
    });

    // 5. Configurar handlers para mensajes (funcionan sin permiso)
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // 6. Verificar si la app se abrió desde una notificación
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleMessageTap(initialMessage);
      });
    }

    // 7. Limpiar badge del icono de la app
    _clearBadge();

    _isInitialized = true;
    debugPrint('NotificationService initialized for user: $userId');
  }

  /// Pide permiso de notificaciones si aún no lo tiene.
  /// Llamar DESPUÉS de que la UI sea visible (ej: desde HomeScreen).
  Future<void> requestPermissionIfNeeded() async {
    if (kIsWeb || !_isInitialized) return;

    // Verificar estado actual sin mostrar diálogo
    final settings = await _messaging.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // Ya tiene permiso — asegurar que local notifications están configuradas
      await _setupLocalNotifications();
      // Asegurar que el token está guardado (por si init() falló)
      await _saveToken(_currentUserId!);
      return;
    }

    // Mostrar diálogo del sistema
    final hasPermission = await requestPermission();
    if (hasPermission && _currentUserId != null) {
      await _setupLocalNotifications();
      await _saveToken(_currentUserId!);
    }
  }

  /// Obtiene el token FCM y lo guarda en Supabase.
  /// Timeout de 5s para evitar que bloquee la splash (iOS sin APNs se cuelga).
  Future<void> _saveToken(String userId) async {
    try {
      final token = await _messaging.getToken().timeout(
        const Duration(seconds: 5),
        onTimeout: () => null,
      );
      if (token != null) {
        await _saveTokenToSupabase(token, userId);
        debugPrint('FCM token saved for user: $userId');
      } else {
        debugPrint('FCM token is null (timeout or permission required on iOS)');
      }
    } catch (e) {
      debugPrint('Error getting/saving FCM token: $e');
    }
  }

  /// Solicita permiso para notificaciones
  Future<bool> requestPermission() async {
    if (kIsWeb) return false;

    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final authorized =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;

    if (authorized) {
      AnalyticsService().logNotificationPermissionGranted();
    } else {
      AnalyticsService().logNotificationPermissionDenied();
    }

    return authorized;
  }

  /// Configura local notifications para mostrar en foreground (Android)
  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        // Manejar tap en notificación local
        final payload = response.payload;
        if (payload != null) {
          _navigateToScreen(payload);
        }
      },
    );

    // Crear canal de notificación para Android
    const channel = AndroidNotificationChannel(
      'biblia_chat_channel',
      'Biblia Chat',
      description: 'Notificaciones de Biblia Chat',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Guarda el token FCM en Supabase usando función SECURITY DEFINER
  /// (resuelve RLS violation cuando el mismo dispositivo cambia de usuario)
  Future<void> _saveTokenToSupabase(String token, String userId) async {
    try {
      final platform = Platform.isIOS ? 'ios' : 'android';

      await Supabase.instance.client.rpc('register_device_token', params: {
        'p_token': token,
        'p_platform': platform,
      });

      debugPrint('FCM token saved to Supabase');
    } catch (e) {
      debugPrint('Error saving FCM token: $e');
    }
  }

  /// Maneja mensajes recibidos en foreground
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message: ${message.notification?.title}');

    final notification = message.notification;
    if (notification == null) return;

    // Mostrar notificación local en Android (iOS lo hace automáticamente)
    if (Platform.isAndroid) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'biblia_chat_channel',
            'Biblia Chat',
            channelDescription: 'Notificaciones de Biblia Chat',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: message.data['screen'],
      );
    }
  }

  /// Maneja tap en notificación (app en background o cerrada)
  void _handleMessageTap(RemoteMessage message) {
    debugPrint('Message tap: ${message.data}');
    final screen = message.data['screen'] as String?;
    if (screen != null) {
      AnalyticsService().logNotificationOpened(screen: screen);
      _navigateToScreen(screen);
    }
  }

  /// Navega a la pantalla especificada
  void _navigateToScreen(String screen) {
    if (_router == null) return;

    switch (screen) {
      case 'stories':
        _router!.go('/home/stories');
        break;
      case 'study':
        _router!.go('/study');
        break;
      case 'chat':
        _router!.go('/chat');
        break;
      case 'home':
      default:
        _router!.go('/home');
        break;
    }
  }

  /// Programa una notificación local para recordar que el trial termina en 2 días.
  /// Se llama 1 día después de la compra con trial (3 días - 1 = 2 días restantes).
  static const int _trialReminderId = 9999;

  Future<void> scheduleTrialReminder() async {
    if (kIsWeb) return;

    try {
      // Asegurar que tiene permiso de notificaciones
      final settings = await _messaging.getNotificationSettings();
      final hasPermission =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      if (!hasPermission) {
        final granted = await requestPermission();
        if (!granted) {
          debugPrint('Trial reminder: notification permission denied');
          return;
        }
        await _setupLocalNotifications();
      }

      // Inicializar timezone si no se ha hecho
      if (!_timezoneInitialized) {
        tz.initializeTimeZones();
        _timezoneInitialized = true;
      }

      final scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(days: 1));

      await _localNotifications.zonedSchedule(
        _trialReminderId,
        '⏰ Tu prueba gratuita termina pronto',
        'Quedan 2 días de tu prueba gratuita. ¡Disfruta de todas las funciones!',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'biblia_chat_channel',
            'Biblia Chat',
            channelDescription: 'Notificaciones de Biblia Chat',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/ic_notification',
          ),
          iOS: DarwinNotificationDetails(
            sound: 'default',
            badgeNumber: 1,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: null,
        payload: 'home',
      );

      debugPrint('Trial reminder scheduled for: $scheduledDate');
    } catch (e) {
      debugPrint('Error scheduling trial reminder: $e');
    }
  }

  /// Cancela el recordatorio del trial (por si el usuario cancela antes)
  Future<void> cancelTrialReminder() async {
    if (kIsWeb) return;
    try {
      await _localNotifications.cancel(_trialReminderId);
    } catch (e) {
      debugPrint('Error cancelling trial reminder: $e');
    }
  }

  /// Limpia el badge del icono de la app (iOS)
  /// Usa una notificación invisible con badgeNumber: 0 que se cancela inmediatamente
  Future<void> _clearBadge() async {
    if (Platform.isIOS) {
      try {
        await _localNotifications.show(
          0,
          null,
          null,
          const NotificationDetails(
            iOS: DarwinNotificationDetails(
              badgeNumber: 0,
              presentAlert: false,
              presentSound: false,
              presentBadge: true,
            ),
          ),
        );
        await _localNotifications.cancel(0);
      } catch (e) {
        debugPrint('Error clearing badge: $e');
      }
    }
  }

  /// Obtiene el token FCM actual
  Future<String?> getToken() async {
    if (kIsWeb) return null;
    return await _messaging.getToken();
  }

  /// Elimina el token FCM (para logout)
  Future<void> deleteToken() async {
    if (kIsWeb) return;
    await _messaging.deleteToken();
  }
}
