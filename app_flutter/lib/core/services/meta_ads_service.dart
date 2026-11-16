import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'revenue_cat_service.dart';

/// Atribución dual de Meta Ads:
///
/// - **Meta SDK** (`facebook_app_events`): auto-loguea install/activación y
///   los manda a Meta directamente desde el dispositivo (señal client-side).
/// - **CAPI vía RevenueCat**: enviamos a RevenueCat el `fb_anonymous_id` y
///   los identificadores del dispositivo (IDFA/IDFV/GAID); la integración
///   "Meta Ads" del dashboard de RevenueCat reenvía trials, compras y
///   renovaciones a la Conversions API de Meta (señal server-side).
///
/// En web es no-op.
class MetaAdsService {
  static final MetaAdsService _instance = MetaAdsService._internal();
  factory MetaAdsService() => _instance;
  MetaAdsService._internal();

  final FacebookAppEvents _events = FacebookAppEvents();

  bool get _supported => !kIsWeb;

  /// Vincula el dispositivo con RevenueCat para la atribución de Meta:
  /// manda el `fb_anonymous_id` del SDK de Meta y recolecta los
  /// identificadores de dispositivo (el IDFA solo si el usuario aceptó ATT).
  ///
  /// Llamar después de `Purchases.configure()`. Idempotente y no-crítico.
  Future<void> syncWithRevenueCat() async {
    if (!_supported || !RevenueCatService.instance.isAvailable) return;
    try {
      final anonymousId = await _events.getAnonymousId();
      if (anonymousId != null && anonymousId.isNotEmpty) {
        await Purchases.setFBAnonymousID(anonymousId);
      }
      await Purchases.collectDeviceIdentifiers();
      debugPrint('MetaAds: synced fb_anonymous_id + device ids with RevenueCat');
    } catch (e) {
      if (kDebugMode) debugPrint('MetaAds: syncWithRevenueCat failed - $e');
    }
  }

  /// Informa al SDK de Meta del resultado del prompt ATT (solo hace algo en
  /// iOS) y re-recolecta identificadores para que RevenueCat capture el IDFA
  /// si el usuario lo autorizó.
  Future<void> onAttResolved({required bool granted}) async {
    if (!_supported) return;
    try {
      await _events.setAdvertiserTracking(enabled: granted);
    } catch (e) {
      if (kDebugMode) debugPrint('MetaAds: setAdvertiserTracking failed - $e');
    }
    if (RevenueCatService.instance.isAvailable) {
      try {
        await Purchases.collectDeviceIdentifiers();
      } catch (e) {
        if (kDebugMode) {
          debugPrint('MetaAds: collectDeviceIdentifiers failed - $e');
        }
      }
    }
  }
}
