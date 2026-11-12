import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'meta_ads_service.dart';

class RevenueCatService {
  static const String _iosApiKey = 'appl_gZbgVJRKEBpZNBeYWpdisQiQjYw';
  // TODO: Add Android API key when configured in RevenueCat
  static const String _androidApiKey = '';

  static const String entitlementId = 'premium';

  static RevenueCatService? _instance;
  bool _isInitialized = false;

  /// Elegibilidad de trial (null = desconocida). Se cachea en memoria y se
  /// persiste en disco para tenerla disponible al instante en cold start.
  bool? _trialEligible;
  static const String _kTrialEligibleKey = 'trial_eligible';

  /// Atributos de cliente pendientes de enviar (si se fijan antes de que el
  /// SDK termine de inicializarse, se envían al acabar `init`).
  final Map<String, String> _pendingAttributes = {};

  RevenueCatService._();

  static RevenueCatService get instance {
    _instance ??= RevenueCatService._();
    return _instance!;
  }

  bool get isAvailable => !kIsWeb && _isInitialized;

  Future<void> init(String supabaseUserId) async {
    if (_isInitialized) return;

    // RevenueCat no funciona en web
    if (kIsWeb) {
      debugPrint('RevenueCat: Not available on web');
      return;
    }

    // Determinar API key según plataforma
    final apiKey = defaultTargetPlatform == TargetPlatform.iOS
        ? _iosApiKey
        : _androidApiKey;

    if (apiKey.isEmpty) {
      debugPrint('RevenueCat: API key not configured for $defaultTargetPlatform');
      return;
    }

    try {
      final configuration = PurchasesConfiguration(apiKey)
        ..appUserID = supabaseUserId;

      await Purchases.configure(configuration);
      _isInitialized = true;
      debugPrint('RevenueCat: Initialized successfully');
      await _flushPendingAttributes();

      // Apple Search Ads: recolecta el token de AdServices y lo envía a Apple
      // vía RevenueCat (atribución de revenue por keyword/campaña).
      // Solo iOS 14.3+; en Android es no-op. El token solo es fetchable en
      // las primeras ~24h del install.
      try {
        await Purchases.enableAdServicesAttributionTokenCollection();
        debugPrint('RevenueCat: AdServices attribution token collection enabled');
      } catch (e) {
        if (kDebugMode) debugPrint('RevenueCat: AdServices token failed - $e');
      }

      // Meta Ads: vincula fb_anonymous_id + identificadores de dispositivo
      // con RevenueCat para que la integración CAPI atribuya trials/compras.
      await MetaAdsService().syncWithRevenueCat();
    } catch (e) {
      debugPrint('RevenueCat: Init error - $e');
    }
  }

  /// Envía la denominación como atributo de cliente a RevenueCat, para poder
  /// cruzar denominación con ingresos en Charts/Customer Lists. Si el SDK aún
  /// no está listo, se envía al terminar `init`.
  Future<void> setDenomination(String? denomination) async {
    if (denomination == null || denomination.isEmpty) return;
    _pendingAttributes['denomination'] = denomination;
    await _flushPendingAttributes();
  }

  Future<void> _flushPendingAttributes() async {
    if (!isAvailable || _pendingAttributes.isEmpty) return;
    final attrs = Map<String, String>.from(_pendingAttributes);
    try {
      await Purchases.setAttributes(attrs);
      _pendingAttributes.clear();
    } catch (e) {
      if (kDebugMode) debugPrint('RevenueCat: setAttributes failed - $e');
    }
  }

  /// Valor cacheado de elegibilidad de trial (null si aún no se ha comprobado).
  /// Permite que el paywall lo lea de forma síncrona en el primer frame.
  bool? get trialEligible => _trialEligible;

  /// Inyecta un valor persistido (desde SharedPreferences) si aún no se conoce
  /// en esta sesión. Lo usa el splash para el paywall-puerta en cold start.
  void seedTrialEligibility(bool? value) {
    if (value != null) _trialEligible ??= value;
  }

  /// Comprueba si el usuario es elegible para el trial de alguno de los
  /// productos dados (en Apple la elegibilidad es por grupo de suscripción,
  /// así que un solo bool vale para todo el offering).
  ///
  /// - `eligible` en cualquiera → true (se persiste).
  /// - `ineligible` en cualquiera → false (se persiste).
  /// - Solo `unknown` / sin intro / error → no se persiste; devuelve el valor
  ///   cacheado si existe y, si no, true. Ser optimista aquí es seguro: la
  ///   hoja de pago de Apple siempre muestra las condiciones reales antes de
  ///   confirmar, así que no se cobra nada que el usuario no haya visto.
  Future<bool> isEligibleForTrial(List<String> productIds) async {
    if (!isAvailable || productIds.isEmpty) return _trialEligible ?? true;
    try {
      final result =
          await Purchases.checkTrialOrIntroductoryPriceEligibility(productIds);
      final statuses = productIds.map((id) => result[id]?.status).toList();
      bool? eligible;
      if (statuses
          .contains(IntroEligibilityStatus.introEligibilityStatusEligible)) {
        eligible = true;
      } else if (statuses
          .contains(IntroEligibilityStatus.introEligibilityStatusIneligible)) {
        eligible = false;
      }
      if (eligible != null) {
        _trialEligible = eligible;
        _persistEligibility(eligible);
        return eligible;
      }
      return _trialEligible ?? true;
    } catch (e) {
      if (kDebugMode) debugPrint('RevenueCat: eligibility check failed - $e');
      return _trialEligible ?? true;
    }
  }

  /// Persiste la elegibilidad en disco (fire-and-forget, no-crítico).
  Future<void> _persistEligibility(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kTrialEligibleKey, value);
    } catch (_) {}
  }

  Future<Offerings?> getOfferings() async {
    if (!isAvailable) return null;
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('RevenueCat: getOfferings error - $e');
      return null;
    }
  }

  /// Returns: true = success, false = error, null = user cancelled
  Future<bool?> purchasePackage(Package package) async {
    if (!isAvailable) return false;
    try {
      await Purchases.purchasePackage(package);
      return true;
    } on PlatformException catch (e) {
      // User cancelled the purchase — not an error
      if (e.code == '1' ||
          e.message?.contains('PURCHASE_CANCELLED') == true ||
          e.message?.contains('userCancelled') == true) {
        debugPrint('RevenueCat: purchase cancelled by user');
        return null;
      }
      debugPrint('RevenueCat: purchasePackage error - $e');
      return false;
    } catch (e) {
      debugPrint('RevenueCat: purchasePackage error - $e');
      return false;
    }
  }

  Future<bool> restorePurchases() async {
    if (!isAvailable) return false;
    try {
      await Purchases.restorePurchases();
      return true;
    } catch (e) {
      debugPrint('RevenueCat: restorePurchases error - $e');
      return false;
    }
  }

  Future<bool> checkPremiumStatus() async {
    if (!isAvailable) return false;
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey(entitlementId);
    } catch (e) {
      debugPrint('RevenueCat: checkPremiumStatus error - $e');
      return false;
    }
  }

  /// Switch RevenueCat to a different user (e.g. after login)
  Future<void> logIn(String userId) async {
    if (!isAvailable) return;
    try {
      await Purchases.logIn(userId);
      debugPrint('RevenueCat: logIn successful for $userId');
    } catch (e) {
      debugPrint('RevenueCat: logIn error - $e');
    }
  }

  Future<CustomerInfo?> getCustomerInfo() async {
    if (!isAvailable) return null;
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      debugPrint('RevenueCat: getCustomerInfo error - $e');
      return null;
    }
  }

  Stream<CustomerInfo> get customerInfoStream {
    // En web, el SDK no tiene customerInfoStream
    if (kIsWeb || !_isInitialized) {
      return const Stream.empty();
    }
    // Usar llamada dinámica para evitar error de compilación en web
    // ignore: avoid_dynamic_calls
    return (Purchases as dynamic).customerInfoStream as Stream<CustomerInfo>;
  }
}
