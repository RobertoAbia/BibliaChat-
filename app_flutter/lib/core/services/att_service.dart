import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';

import 'analytics_service.dart';

/// Servicio para el permiso de App Tracking Transparency (ATT) de iOS.
///
/// Pide el permiso de tracking, necesario para que la atribución de Meta
/// (IDFA) funcione. En Android y web es no-op.
class AttService {
  static final AttService _instance = AttService._internal();
  factory AttService() => _instance;
  AttService._internal();

  bool _requested = false;

  /// Pide el permiso de tracking si aplica.
  ///
  /// Idempotente: si el usuario ya respondió, iOS no vuelve a mostrar el
  /// prompt, solo devuelve el estado actual. Solo se ejecuta en iOS.
  Future<void> requestPermission() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) return;
    if (_requested) return;
    _requested = true;

    try {
      final status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      await AnalyticsService().logAttPromptResult(status.name);
    } catch (e) {
      if (kDebugMode) debugPrint('ATT request failed: $e');
    }
  }
}
