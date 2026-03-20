import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Servicio singleton para Firebase Analytics
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  late final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: _analytics);

  // ============ ONBOARDING ============

  /// Tracking de cada paso del onboarding (funnel)
  Future<void> logOnboardingStep({
    required int stepNumber,
    required String stepName,
  }) async {
    if (kIsWeb) return;
    await _analytics.logEvent(
      name: 'onboarding_step',
      parameters: {
        'step_number': stepNumber,
        'step_name': stepName,
      },
    );
  }

  /// Usuario completa el onboarding
  Future<void> logOnboardingComplete({
    required String denomination,
    required String origin,
    required String ageGroup,
    String? gender,
  }) async {
    if (kIsWeb) return;
    await _analytics.logEvent(
      name: 'onboarding_complete',
      parameters: {
        'denomination': denomination,
        'origin': origin,
        'age_group': ageGroup,
        if (gender != null) 'gender': gender,
      },
    );
  }

  // ============ CHAT ============

  /// Usuario envía un mensaje en el chat
  Future<void> logChatMessageSent({
    String? topicKey,
    required bool isPremium,
  }) async {
    if (kIsWeb) return;
    await _analytics.logEvent(
      name: 'chat_message_sent',
      parameters: {
        'topic_key': topicKey ?? 'free_chat',
        'is_premium': isPremium.toString(),
      },
    );
  }

  /// Usuario crea una nueva conversación
  Future<void> logChatCreated({String? topicKey}) async {
    if (kIsWeb) return;
    await _analytics.logEvent(
      name: 'chat_created',
      parameters: {
        'topic_key': topicKey ?? 'free_chat',
      },
    );
  }

  // ============ STORIES ============

  /// Usuario ve una story del evangelio
  Future<void> logStoryViewed({required int slideNumber}) async {
    if (kIsWeb) return;
    await _analytics.logEvent(
      name: 'story_viewed',
      parameters: {
        'slide_number': slideNumber,
      },
    );
  }

  /// Usuario completa las 3 stories
  Future<void> logStoryCompleted() async {
    if (kIsWeb) return;
    await _analytics.logEvent(name: 'story_completed');
  }

  /// Usuario comparte imagen desde Stories
  Future<void> logShareImage({required String backgroundType}) async {
    if (kIsWeb) return;
    await _analytics.logEvent(
      name: 'share_image',
      parameters: {
        'background_type': backgroundType,
      },
    );
  }

  // ============ PLANES DE ESTUDIO ============

  /// Usuario inicia un plan de estudio
  Future<void> logPlanStarted({
    required String planId,
    required String planName,
  }) async {
    if (kIsWeb) return;
    await _analytics.logEvent(
      name: 'plan_started',
      parameters: {
        'plan_id': planId,
        'plan_name': planName,
      },
    );
  }

  /// Usuario completa un día del plan
  Future<void> logPlanDayCompleted({
    required String planId,
    required int dayNumber,
  }) async {
    if (kIsWeb) return;
    await _analytics.logEvent(
      name: 'plan_day_completed',
      parameters: {
        'plan_id': planId,
        'day_number': dayNumber,
      },
    );
  }

  /// Usuario completa un plan de 7 días
  Future<void> logPlanCompleted({required String planId}) async {
    if (kIsWeb) return;
    await _analytics.logEvent(
      name: 'plan_completed',
      parameters: {
        'plan_id': planId,
      },
    );
  }

  /// Usuario abandona un plan
  Future<void> logPlanAbandoned({
    required String planId,
    required int dayNumber,
  }) async {
    if (kIsWeb) return;
    await _analytics.logEvent(
      name: 'plan_abandoned',
      parameters: {
        'plan_id': planId,
        'day_number': dayNumber,
      },
    );
  }

  // ============ MENSAJES GUARDADOS ============

  /// Usuario guarda un mensaje como favorito
  Future<void> logMessageSaved() async {
    if (kIsWeb) return;
    await _analytics.logEvent(name: 'message_saved');
  }

  /// Usuario elimina un mensaje guardado
  Future<void> logMessageUnsaved() async {
    if (kIsWeb) return;
    await _analytics.logEvent(name: 'message_unsaved');
  }

  // ============ SUSCRIPCIÓN ============

  /// Usuario ve el paywall
  Future<void> logPaywallViewed({required String source}) async {
    if (kIsWeb) return;
    await _analytics.logEvent(
      name: 'paywall_viewed',
      parameters: {
        'source': source,
      },
    );
  }

  /// Usuario inicia suscripción
  Future<void> logSubscriptionStarted({required String planType}) async {
    if (kIsWeb) return;
    await _analytics.logEvent(
      name: 'subscription_started',
      parameters: {
        'plan_type': planType,
      },
    );
  }

  /// Usuario restaura compras
  Future<void> logPurchaseRestored() async {
    if (kIsWeb) return;
    await _analytics.logEvent(name: 'purchase_restored');
  }

  // ============ AUTH ============

  /// Usuario vincula email a cuenta anónima
  Future<void> logEmailLinked() async {
    if (kIsWeb) return;
    await _analytics.logEvent(name: 'email_linked');
  }

  /// Usuario hace login
  Future<void> logLogin({required String method}) async {
    if (kIsWeb) return;
    await _analytics.logLogin(loginMethod: method);
  }

  /// Usuario borra su cuenta
  Future<void> logAccountDeleted() async {
    if (kIsWeb) return;
    await _analytics.logEvent(name: 'account_deleted');
  }

  // ============ LÍMITE DE MENSAJES ============

  /// Usuario alcanza el límite de mensajes diarios
  Future<void> logMessageLimitReached() async {
    if (kIsWeb) return;
    await _analytics.logEvent(name: 'message_limit_reached');
  }

  // ============ NOTIFICACIONES ============

  /// Usuario acepta permisos de notificaciones
  Future<void> logNotificationPermissionGranted() async {
    if (kIsWeb) return;
    await _analytics.logEvent(name: 'notification_permission_granted');
  }

  /// Usuario rechaza permisos de notificaciones
  Future<void> logNotificationPermissionDenied() async {
    if (kIsWeb) return;
    await _analytics.logEvent(name: 'notification_permission_denied');
  }

  /// Usuario abre la app desde una notificación
  Future<void> logNotificationOpened({required String screen}) async {
    if (kIsWeb) return;
    await _analytics.logEvent(
      name: 'notification_opened',
      parameters: {
        'screen': screen,
      },
    );
  }

  // ============ USER PROPERTIES ============

  /// Establece propiedades del usuario para segmentación
  Future<void> setUserProperties({
    String? denomination,
    String? origin,
    String? ageGroup,
    String? gender,
    bool? isPremium,
    String? motive,
    String? motiveDetail,
  }) async {
    if (kIsWeb) return;
    if (denomination != null) {
      await _analytics.setUserProperty(
        name: 'denomination',
        value: denomination,
      );
    }
    if (origin != null) {
      await _analytics.setUserProperty(name: 'origin', value: origin);
    }
    if (ageGroup != null) {
      await _analytics.setUserProperty(name: 'age_group', value: ageGroup);
    }
    if (gender != null) {
      await _analytics.setUserProperty(name: 'gender', value: gender);
    }
    if (isPremium != null) {
      await _analytics.setUserProperty(
        name: 'is_premium',
        value: isPremium.toString(),
      );
    }
    if (motive != null) {
      await _analytics.setUserProperty(name: 'motive', value: motive);
    }
    if (motiveDetail != null) {
      await _analytics.setUserProperty(
        name: 'motive_detail',
        value: motiveDetail,
      );
    }
  }

  /// Establece el user ID para cross-device tracking
  Future<void> setUserId(String? userId) async {
    if (kIsWeb) return;
    await _analytics.setUserId(id: userId);
  }
}
