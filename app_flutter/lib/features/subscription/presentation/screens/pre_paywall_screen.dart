import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/services/revenue_cat_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../providers/subscription_provider.dart';
import '../utils/paywall_pricing.dart';

/// Pantalla "trial preview" antes del paywall: título personalizado
/// (nombre + 3 días gratis + objetivo del onboarding) + timeline de 3 días +
/// microcopy + CTA. También precalienta RevenueCat para que el paywall sea instantáneo.
class PrePaywallScreen extends ConsumerStatefulWidget {
  const PrePaywallScreen({super.key});

  @override
  ConsumerState<PrePaywallScreen> createState() => _PrePaywallScreenState();
}

class _PrePaywallScreenState extends ConsumerState<PrePaywallScreen> {
  @override
  void initState() {
    super.initState();
    // Prewarm: instanciar el provider de suscripción para que RevenueCat empiece
    // a cargar los offerings mientras el usuario lee esta pantalla. Así el paywall
    // aparece con los precios reales al instante, no con placeholders.
    ref.read(subscriptionProvider);
    // Toda esta pantalla es una promesa de "3 días gratis": si ya se sabe que
    // el usuario NO es elegible (trial consumido), mostrarla sería mentirle
    // (Apple cobraría al instante) — saltar directo al paywall, que ya pinta
    // el copy sin trial.
    if (RevenueCatService.instance.trialEligible == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _continue();
      });
      return;
    }
    // Prewarm también la elegibilidad del trial para que el paywall sepa desde el
    // primer frame si mostrar el toggle (evita el parpadeo del toggle).
    _prewarmTrialEligibility();
  }

  /// Carga offerings y cachea la elegibilidad del trial (mensual y anual), para
  /// que el paywall la lea de forma síncrona y no parpadee. No-crítico.
  Future<void> _prewarmTrialEligibility() async {
    try {
      final offerings = await RevenueCatService.instance.getOfferings();
      final current = offerings?.current;
      final productIds = [current?.monthly, current?.annual]
          .whereType<Package>()
          .map((p) => p.storeProduct.identifier)
          .toList();
      if (productIds.isNotEmpty) {
        final eligible =
            await RevenueCatService.instance.isEligibleForTrial(productIds);
        // Resultado fresco: sin elegibilidad, el timeline de 3 días que el
        // usuario tiene delante es falso — pasar al paywall.
        if (!eligible && mounted) _continue();
      }
    } catch (_) {
      // No-crítico: si falla, el paywall hace la comprobación asíncrona.
    }
  }

  void _continue() {
    context.go('${RouteConstants.paywall}?gate=true');
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentUserProfileProvider).valueOrNull;
    final name = profile?.name;
    final objective = PaywallPricing.objectivePhrase(profile?.motive);
    final namePrefix = (name != null && name.trim().isNotEmpty)
        ? '${name.trim()}, aquí tienes '
        : 'Aquí tienes ';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Contenido scrollable
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),

                      // Título personalizado
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: namePrefix),
                            const TextSpan(
                              text: '3 días gratis',
                              style: TextStyle(color: AppTheme.primaryColor),
                            ),
                            TextSpan(text: ' para $objective'),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 44),

                      // Timeline de 3 días
                      _buildTimelineItem(
                        title: 'Hoy',
                        subtitle: 'Acceso completo a Biblia Chat',
                        isLast: false,
                      ),
                      _buildTimelineItem(
                        title: 'Día 2',
                        subtitle: 'Te avisaremos antes de cualquier cobro',
                        isLast: false,
                      ),
                      _buildTimelineItem(
                        title: 'Día 3',
                        subtitle: 'Termina tu prueba — cancela cuando quieras',
                        isLast: true,
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Microcopy: hoy no pagas nada
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Hoy no pagas nada. Cancela cuando quieras.',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // CTA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _continue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                      ),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Empezar mis 3 días gratis',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.chevron_right, size: 22, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Círculo + conector vertical
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 20, color: Colors.white),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppTheme.primaryColor.withOpacity(0.25),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Texto
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
