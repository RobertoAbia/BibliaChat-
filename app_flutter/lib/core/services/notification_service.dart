import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  String? _currentUserId;

  /// Inicializa el servicio de notificaciones.
  /// NO muestra diálogo de permisos - solo configura listeners y token si ya autorizado.
  /// Para pedir permiso, llamar requestPermissionIfNeeded() después.
  Future<void> init(String userId, GoRouter router) async {
    if (kIsWeb) return;

    _router = router;

    // Si ya está inicializado pero cambió el usuario, solo actualizamos el token
    if (_isInitialized && _currentUserId != userId) {
      _currentUserId = userId;
      final token = await _messaging.getToken();
      if (token != null) {
        await _saveTokenToSupabase(token, userId);
        debugPrint('FCM token updated for new user: $userId');
      }
      return;
    }

    if (_isInitialized) return;

    _currentUserId = userId;

    // 1. Configurar handler para mensajes en background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 2. Verificar si YA tiene permiso (sin mostrar diálogo)
    final settings = await _messaging.getNotificationSettings();
    final alreadyAuthorized =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    // 3. Si ya autorizado, configurar local notifications + token
    if (alreadyAuthorized) {
      await _setupAfterPermission(userId);
    }

    // 4. Configurar handlers para mensajes (funcionan sin permiso)
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // 5. Verificar si la app se abrió desde una notificación
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleMessageTap(initialMessage);
      });
    }

    _isInitialized = true;
    debugPrint('NotificationService initialized');
  }

  /// Pide permiso de notificaciones si aún no lo tiene.
  /// Llamar DESPUÉS de que la UI sea visible (ej: desde HomeScreen).
  Future<void> requestPermissionIfNeeded() async {
    if (kIsWeb || !_isInitialized) return;

    // Verificar estado actual sin mostrar diálogo
    final settings = await _messaging.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      return; // Ya tiene permiso
    }

    // Mostrar diálogo del sistema
    final hasPermission = await requestPermission();
    if (hasPermission && _currentUserId != null) {
      await _setupAfterPermission(_currentUserId!);
    }
  }

  /// Configura local notifications, obtiene token y escucha cambios.
  Future<void> _setupAfterPermission(String userId) async {
    await _setupLocalNotifications();

    final token = await _messaging.getToken();
    if (token != null) {
      await _saveTokenToSupabase(token, userId);
      debugPrint('FCM Token: $token');
    }

    _messaging.onTokenRefresh.listen((newToken) {
      _saveTokenToSupabase(newToken, userId);
    });
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

  /// Guarda el token FCM en Supabase
  Future<void> _saveTokenToSupabase(String token, String userId) async {
    try {
      final platform = Platform.isIOS ? 'ios' : 'android';

      await Supabase.instance.client.from('user_devices').upsert(
        {
          'user_id': userId,
          'device_token': token,
          'platform': platform,
          'last_seen_at': DateTime.now().toUtc().toIso8601String(),
        },
        onConflict: 'device_token',
      );

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
