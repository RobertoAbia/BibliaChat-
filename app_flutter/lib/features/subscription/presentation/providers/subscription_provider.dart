import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../../core/services/revenue_cat_service.dart';

// Estado de la suscripción
class SubscriptionState {
  final bool isPremium;
  final bool isLoading;
  final String? error;
  final Offerings? offerings;
  final bool isPurchasing;

  const SubscriptionState({
    this.isPremium = false,
    this.isLoading = true,
    this.error,
    this.offerings,
    this.isPurchasing = false,
  });

  SubscriptionState copyWith({
    bool? isPremium,
    bool? isLoading,
    String? error,
    Offerings? offerings,
    bool? isPurchasing,
  }) {
    return SubscriptionState(
      isPremium: isPremium ?? this.isPremium,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      offerings: offerings ?? this.offerings,
      isPurchasing: isPurchasing ?? this.isPurchasing,
    );
  }
}

// StateNotifier para manejar suscripciones
class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  final RevenueCatService _revenueCatService;
  StreamSubscription<CustomerInfo>? _customerInfoSubscription;

  SubscriptionNotifier(this._revenueCatService)
      : super(const SubscriptionState()) {
    _init();
  }

  Future<void> _init() async {
    // En web, RevenueCat no está disponible
    if (kIsWeb) {
      state = state.copyWith(isLoading: false);
      return;
    }

    _customerInfoSubscription = _revenueCatService.customerInfoStream.listen(
      (customerInfo) {
        _updatePremiumStatus(customerInfo);
      },
    );

    await _checkPremiumStatus();
    await _loadOfferings();
  }

  void _updatePremiumStatus(CustomerInfo customerInfo) {
    final isPremium = customerInfo.entitlements.active
        .containsKey(RevenueCatService.entitlementId);
    state = state.copyWith(isPremium: isPremium);
  }

  Future<void> _checkPremiumStatus() async {
    final isPremium = await _revenueCatService.checkPremiumStatus();
    state = state.copyWith(isPremium: isPremium, isLoading: false);
  }

  Future<void> _loadOfferings() async {
    final offerings = await _revenueCatService.getOfferings();
    state = state.copyWith(offerings: offerings);
  }

  Future<bool> purchasePackage(Package package) async {
    state = state.copyWith(isPurchasing: true, error: null);

    final success = await _revenueCatService.purchasePackage(package);

    if (success) {
      await _checkPremiumStatus();
    } else {
      state = state.copyWith(
        isPurchasing: false,
        error: 'No se pudo completar la compra',
      );
    }

    state = state.copyWith(isPurchasing: false);
    return success;
  }

  Future<bool> restorePurchases() async {
    state = state.copyWith(isLoading: true, error: null);

    final success = await _revenueCatService.restorePurchases();

    if (success) {
      await _checkPremiumStatus();
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'No se encontraron compras para restaurar',
      );
    }

    state = state.copyWith(isLoading: false);
    return success;
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _checkPremiumStatus();
    await _loadOfferings();
  }

  @override
  void dispose() {
    _customerInfoSubscription?.cancel();
    super.dispose();
  }
}

// Provider del servicio
final revenueCatServiceProvider = Provider<RevenueCatService>((ref) {
  return RevenueCatService.instance;
});

// Provider principal de suscripción
final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  final service = ref.watch(revenueCatServiceProvider);
  return SubscriptionNotifier(service);
});

// Provider simple para verificar si es premium
final isPremiumProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionProvider).isPremium;
});

// Provider para obtener offerings
final offeringsProvider = Provider<Offerings?>((ref) {
  return ref.watch(subscriptionProvider).offerings;
});

// Provider para el paquete mensual
final monthlyPackageProvider = Provider<Package?>((ref) {
  final offerings = ref.watch(offeringsProvider);
  return offerings?.current?.monthly;
});

// Provider para el paquete anual
final annualPackageProvider = Provider<Package?>((ref) {
  final offerings = ref.watch(offeringsProvider);
  return offerings?.current?.annual;
});
