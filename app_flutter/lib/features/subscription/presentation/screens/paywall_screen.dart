import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../core/services/analytics_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';
import '../providers/subscription_provider.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _trialEnabled = true; // Toggle para prueba gratis en plan mensual

  @override
  void initState() {
    super.initState();
    // Log analytics event when paywall is viewed
    AnalyticsService().logPaywallViewed(source: 'onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionProvider);
    final monthlyPackage = ref.watch(monthlyPackageProvider);
    final annualPackage = ref.watch(annualPackageProvider);

    final showMockData = kIsWeb && monthlyPackage == null && annualPackage == null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Contenido principal
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 48), // Espacio para el botón X

                    // Header
                    _buildHeader(),

                    const SizedBox(height: 24),

                    // Features
                    _buildFeatures(),

                    const SizedBox(height: 24),

                    // Planes
                    if (subscriptionState.isLoading && !kIsWeb)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (showMockData)
                      Expanded(child: _buildMockPlans(context))
                    else if (annualPackage != null || monthlyPackage != null)
                      Expanded(
                        child: _buildRealPlans(
                          context,
                          monthlyPackage,
                          annualPackage,
                          subscriptionState,
                        ),
                      )
                    else
                      _buildErrorState(),
                  ],
                ),
              ),

              // Botón X discreto (esquina superior izquierda)
              Positioned(
                top: 8,
                left: 8,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: AppTheme.textTertiary.withOpacity(0.5),
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Icono premium
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.goldGradient,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 36,
            color: AppTheme.backgroundDark,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Biblia Chat Premium',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tu companero espiritual sin limites',
          style: TextStyle(
            fontSize: 15,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatures() {
    final features = [
      'Chat ilimitado con IA',
      'Devocionales personalizados',
      'Planes de estudio',
      'Sin anuncios',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: features.map((feature) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                size: 14,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                feature,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRealPlans(
    BuildContext context,
    Package? monthlyPackage,
    Package? annualPackage,
    SubscriptionState subscriptionState,
  ) {
    return SingleChildScrollView(
      child: Column(
      children: [
        // Plan mensual con toggle de trial
        if (monthlyPackage != null)
          _MonthlyPlanCard(
            package: monthlyPackage,
            trialEnabled: _trialEnabled,
            onTrialToggled: (value) => setState(() => _trialEnabled = value),
            isPurchasing: subscriptionState.isPurchasing,
            onTap: () => _handlePurchase(monthlyPackage),
          ),

        const SizedBox(height: 12),

        // Plan anual (sin trial)
        if (annualPackage != null)
          _AnnualPlanCard(
            package: annualPackage,
            isPurchasing: subscriptionState.isPurchasing,
            onTap: () => _handlePurchase(annualPackage),
          ),

        const SizedBox(height: 24),

        // Error
        if (subscriptionState.error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              subscriptionState.error!,
              style: const TextStyle(color: AppTheme.errorColor, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),

        // Restaurar compras
        TextButton(
          onPressed: () => _handleRestore(),
          child: const Text(
            'Restaurar compras',
            style: TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 13,
            ),
          ),
        ),

        const SizedBox(height: 4),

        // Terminos
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _trialEnabled
                ? 'Al activar la prueba gratis, se te cobrara \$14.99/mes despues de 3 dias. Puedes cancelar en cualquier momento.'
                : 'La suscripcion se renueva automaticamente. Puedes cancelar en cualquier momento.',
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 16),
      ],
      ),
    );
  }

  Widget _buildMockPlans(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
      children: [
        // Banner web
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.infoColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.visibility, size: 14, color: AppTheme.infoColor),
              SizedBox(width: 6),
              Text(
                'Vista previa (Web)',
                style: TextStyle(fontSize: 11, color: AppTheme.infoColor),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Plan mensual mock con toggle
        _MockMonthlyPlanCard(
          trialEnabled: _trialEnabled,
          onTrialToggled: (value) => setState(() => _trialEnabled = value),
        ),

        const SizedBox(height: 12),

        // Plan anual mock
        _MockAnnualPlanCard(),

        const SizedBox(height: 24),

        // Restaurar
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Compras solo disponibles en iOS/Android'),
                backgroundColor: AppTheme.warningColor,
              ),
            );
          },
          child: const Text(
            'Restaurar compras',
            style: TextStyle(color: AppTheme.textTertiary, fontSize: 13),
          ),
        ),

        const SizedBox(height: 4),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _trialEnabled
                ? 'Al activar la prueba gratis, se te cobrara \$14.99/mes despues de 3 dias.'
                : 'La suscripcion se renueva automaticamente.',
            style: const TextStyle(fontSize: 10, color: AppTheme.textTertiary),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 16),
      ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 40, color: AppTheme.textTertiary),
          const SizedBox(height: 12),
          const Text(
            'No se pudieron cargar los planes',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => ref.read(subscriptionProvider.notifier).refresh(),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePurchase(Package package) async {
    final success = await ref.read(subscriptionProvider.notifier).purchasePackage(package);
    if (success && mounted) {
      context.pop();
    }
  }

  Future<void> _handleRestore() async {
    final success = await ref.read(subscriptionProvider.notifier).restorePurchases();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compras restauradas'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }
}

/// Card del plan mensual con toggle de trial
class _MonthlyPlanCard extends StatelessWidget {
  final Package package;
  final bool trialEnabled;
  final ValueChanged<bool> onTrialToggled;
  final bool isPurchasing;
  final VoidCallback onTap;

  const _MonthlyPlanCard({
    required this.package,
    required this.trialEnabled,
    required this.onTrialToggled,
    required this.isPurchasing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer.selection(
      isSelected: trialEnabled,
      padding: const EdgeInsets.all(16),
      onTap: isPurchasing ? null : onTap,
      child: Column(
        children: [
          // Toggle de trial
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Plan Mensual',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      package.storeProduct.priceString + '/mes',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Toggle
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: trialEnabled,
                  onChanged: onTrialToggled,
                  activeColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Texto del trial
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: trialEnabled
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : AppTheme.surfaceLight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              trialEnabled
                  ? '3 dias gratis, luego ${package.storeProduct.priceString}/mes'
                  : 'Sin prueba gratis',
              style: TextStyle(
                fontSize: 13,
                color: trialEnabled ? AppTheme.primaryColor : AppTheme.textTertiary,
                fontWeight: trialEnabled ? FontWeight.w500 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 12),

          // Boton
          SizedBox(
            width: double.infinity,
            child: isPurchasing
                ? const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: trialEnabled ? AppTheme.goldGradient : null,
                      color: trialEnabled ? null : AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      trialEnabled ? 'Comenzar prueba gratis' : 'Suscribirse',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: trialEnabled
                            ? AppTheme.backgroundDark
                            : AppTheme.textPrimary,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Card del plan anual (sin trial)
class _AnnualPlanCard extends StatelessWidget {
  final Package package;
  final bool isPurchasing;
  final VoidCallback onTap;

  const _AnnualPlanCard({
    required this.package,
    required this.isPurchasing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      onTap: isPurchasing ? null : onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Plan Anual',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Ahorra 50%',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.successColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  package.storeProduct.priceString + '/ano',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          isPurchasing
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Elegir',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

/// Mock mensual para web
class _MockMonthlyPlanCard extends StatelessWidget {
  final bool trialEnabled;
  final ValueChanged<bool> onTrialToggled;

  const _MockMonthlyPlanCard({
    required this.trialEnabled,
    required this.onTrialToggled,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer.selection(
      isSelected: trialEnabled,
      padding: const EdgeInsets.all(16),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compras solo disponibles en iOS/Android'),
            backgroundColor: AppTheme.warningColor,
          ),
        );
      },
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan Mensual',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '\$14.99/mes',
                      style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: trialEnabled,
                  onChanged: onTrialToggled,
                  activeColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: trialEnabled
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : AppTheme.surfaceLight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              trialEnabled ? '3 dias gratis, luego \$14.99/mes' : 'Sin prueba gratis',
              style: TextStyle(
                fontSize: 13,
                color: trialEnabled ? AppTheme.primaryColor : AppTheme.textTertiary,
                fontWeight: trialEnabled ? FontWeight.w500 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: trialEnabled ? AppTheme.goldGradient : null,
              color: trialEnabled ? null : AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              trialEnabled ? 'Comenzar prueba gratis' : 'Suscribirse',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: trialEnabled ? AppTheme.backgroundDark : AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock anual para web
class _MockAnnualPlanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compras solo disponibles en iOS/Android'),
            backgroundColor: AppTheme.warningColor,
          ),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Plan Anual',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Ahorra 50%',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.successColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  '\$39.99/ano',
                  style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Elegir',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
