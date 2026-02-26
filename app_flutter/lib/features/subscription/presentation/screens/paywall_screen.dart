import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../legal/presentation/screens/privacy_policy_screen.dart';
import '../../../legal/presentation/screens/terms_conditions_screen.dart';
import '../providers/subscription_provider.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _trialEnabled = true; // true = mensual con trial, false = anual
  bool _canClose = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logPaywallViewed(source: 'onboarding');
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _canClose = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionProvider);
    final monthlyPackage = ref.watch(monthlyPackageProvider);
    final annualPackage = ref.watch(annualPackageProvider);

    final showMockData =
        monthlyPackage == null && annualPackage == null && !subscriptionState.isLoading;

    final monthlyPrice = monthlyPackage?.storeProduct.priceString ?? '\$14.99';
    final annualPrice = annualPackage?.storeProduct.priceString ?? '\$39.99';
    final isPurchasing = subscriptionState.isPurchasing;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Contenido scrollable
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 64),

                      // Logo centrado
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/splash_logo.png',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Titulo grande
                      const Text(
                        'No pierdas ni un\nsolo momento de fe',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          height: 1.15,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Features - lista vertical
                      _buildFeatureItem('Chat ilimitado con IA'),
                      const SizedBox(height: 12),
                      _buildFeatureItem('Planes de estudio personalizados'),
                      const SizedBox(height: 12),
                      _buildFeatureItem('Reflexiones y devocionales diarios'),

                      const SizedBox(height: 24),

                      // Toggle trial (siempre visible)
                      _buildTrialToggle(),

                      const SizedBox(height: 12),

                      // Loading
                      if (subscriptionState.isLoading && !kIsWeb && !showMockData)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else ...[
                        // Plan mensual
                        _buildMonthlyCard(monthlyPrice),

                        const SizedBox(height: 10),

                        // Plan anual
                        _buildAnnualCard(annualPrice),
                      ],

                      const SizedBox(height: 16),

                      // Texto legal
                      const Center(
                        child: Text(
                          'Cancela en cualquier momento, sin compromiso.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              // Error
              if (subscriptionState.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 24, right: 24),
                  child: Text(
                    subscriptionState.error!,
                    style: const TextStyle(color: AppTheme.errorColor, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),

              // CTA grande
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: isPurchasing
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : Container(
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
                            onPressed: () => _handleCTA(monthlyPackage, annualPackage),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _trialEnabled
                                      ? 'Pruebalo gratis'
                                      : 'Continuar',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.backgroundDark,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.chevron_right, size: 22, color: AppTheme.backgroundDark),
                              ],
                            ),
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 12),

              // Footer: Terminos · Privacidad · Restaurar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TermsConditionsScreen()),
                    ),
                    child: const Text(
                      'Terminos y condiciones',
                      style: TextStyle(fontSize: 11, color: AppTheme.textTertiary),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '\u00b7',
                      style: TextStyle(fontSize: 11, color: AppTheme.textTertiary),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                    ),
                    child: const Text(
                      'Politica de privacidad',
                      style: TextStyle(fontSize: 11, color: AppTheme.textTertiary),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '\u00b7',
                      style: TextStyle(fontSize: 11, color: AppTheme.textTertiary),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _handleRestore(),
                    child: const Text(
                      'Restaurar',
                      style: TextStyle(fontSize: 11, color: AppTheme.textTertiary),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      // Boton X flotante
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _canClose
              ? IconButton(
                  key: const ValueKey('close'),
                  icon: Icon(
                    Icons.close,
                    size: 22,
                    color: AppTheme.textTertiary.withOpacity(0.6),
                  ),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(RouteConstants.home);
                    }
                  },
                )
              : SizedBox(
                  key: const ValueKey('loading'),
                  width: 48,
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(seconds: 3),
                      builder: (context, value, _) {
                        return CircularProgressIndicator(
                          value: value,
                          strokeWidth: 2,
                          color: AppTheme.textTertiary.withOpacity(0.6),
                          backgroundColor: AppTheme.textTertiary.withOpacity(0.15),
                        );
                      },
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 22,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrialToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.textPrimary.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Quiero probar la aplicacion gratis',
              style: TextStyle(
                fontSize: 15,
                color: _trialEnabled ? AppTheme.textPrimary : AppTheme.textSecondary,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: _trialEnabled,
              onChanged: (value) => setState(() => _trialEnabled = value),
              activeColor: Colors.white,
              activeTrackColor: AppTheme.primaryColor,
              inactiveThumbColor: Colors.white.withOpacity(0.7),
              inactiveTrackColor: AppTheme.textPrimary.withOpacity(0.12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyCard(String price) {
    final isSelected = _trialEnabled;

    return GestureDetector(
      onTap: () => setState(() => _trialEnabled = true),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark.withOpacity(0.4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor.withOpacity(0.9)
                : AppTheme.textPrimary.withOpacity(0.12),
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prueba gratuita de 3 dias',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Despues, $price cada mes. Sin cobros ahora',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnualCard(String price) {
    final isSelected = !_trialEnabled;

    return GestureDetector(
      onTap: () => setState(() => _trialEnabled = false),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark.withOpacity(0.4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor.withOpacity(0.9)
                : AppTheme.textPrimary.withOpacity(0.12),
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Acceso Anualmente',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'pagaras $price anualmente',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.errorColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'AHORRA 78%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCTA(Package? monthlyPackage, Package? annualPackage) {
    if (_trialEnabled && monthlyPackage != null) {
      _handlePurchase(monthlyPackage);
    } else if (!_trialEnabled && annualPackage != null) {
      _handlePurchase(annualPackage);
    }
    // Si es mock data (packages null), no hace nada
  }

  Future<void> _handlePurchase(Package package) async {
    final success = await ref.read(subscriptionProvider.notifier).purchasePackage(package);
    if (success && mounted) {
      context.go(RouteConstants.purchaseSuccess);
    }
  }

  Future<void> _handleRestore() async {
    final success = await ref.read(subscriptionProvider.notifier).restorePurchases();
    if (success && mounted) {
      context.go(RouteConstants.purchaseSuccess);
    }
  }
}
