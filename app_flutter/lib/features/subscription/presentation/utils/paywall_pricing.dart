import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Helpers de precios y copys del paywall derivados de los datos reales del
/// producto (RevenueCat / App Store). Así cualquier offering marcado como
/// "Current" en RevenueCat se pinta correctamente sin tocar código.
class PaywallPricing {
  PaywallPricing._();

  /// Días de prueba gratuita del paquete, o null si el producto no tiene
  /// trial gratuito (intro price con precio 0).
  static int? freeTrialDays(Package? package) {
    final intro = package?.storeProduct.introductoryPrice;
    if (intro == null || intro.price > 0) return null;
    final units = intro.periodNumberOfUnits;
    switch (intro.periodUnit) {
      case PeriodUnit.day:
        return units;
      case PeriodUnit.week:
        return units * 7;
      case PeriodUnit.month:
        return units * 30;
      case PeriodUnit.year:
        return units * 365;
      case PeriodUnit.unknown:
        return null;
    }
  }

  static bool hasFreeTrial(Package? package) => freeTrialDays(package) != null;

  /// Precio formateado con la moneda del producto (ej. "$3.33").
  static String formatPrice(double amount, String currencyCode) {
    try {
      return NumberFormat.simpleCurrency(name: currencyCode).format(amount);
    } catch (_) {
      return amount.toStringAsFixed(2);
    }
  }

  /// Equivalente mensual del plan anual (precio / 12), formateado.
  static String? monthlyEquivalent(Package? annual) {
    final product = annual?.storeProduct;
    if (product == null || product.price <= 0) return null;
    return formatPrice(product.price / 12, product.currencyCode);
  }

  /// Porcentaje de ahorro del anual frente a 12 mensualidades. Null si no se
  /// puede calcular o si no hay ahorro real.
  static int? annualSavingsPercent(Package? monthly, Package? annual) {
    final m = monthly?.storeProduct.price;
    final a = annual?.storeProduct.price;
    if (m == null || a == null || m <= 0 || a <= 0) return null;
    final pct = ((1 - a / (m * 12)) * 100).round();
    return pct > 0 ? pct : null;
  }

  /// Objetivo legible según el motivo elegido en el onboarding.
  static String objectivePhrase(String? motive) {
    switch (motive) {
      case 'difficult_moment':
        return 'atravesar este momento difícil con fe';
      case 'spiritual_growth':
        return 'crecer en tu fe';
      case 'feeling_distant':
        return 'reconectar con Dios';
      case 'understand_bible':
        return 'entender mejor la Palabra';
      default:
        return 'fortalecer tu fe';
    }
  }
}
