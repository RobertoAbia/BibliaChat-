import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static const String _iosApiKey = 'appl_gZbgVJRKEBpZNBeYWpdisQiQjYw';
  // TODO: Add Android API key when configured in RevenueCat
  static const String _androidApiKey = '';

  static const String entitlementId = 'premium';

  static RevenueCatService? _instance;
  bool _isInitialized = false;

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
    } catch (e) {
      debugPrint('RevenueCat: Init error - $e');
    }
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
