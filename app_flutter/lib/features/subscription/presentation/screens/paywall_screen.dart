import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/services/revenue_cat_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../legal/presentation/screens/privacy_policy_screen.dart';
import '../../../legal/presentation/screens/terms_conditions_screen.dart';
import '../providers/subscription_provider.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  /// Si true, el paywall actúa de puerta (hard paywall): sin botón de cerrar.
  /// Las aperturas contextuales (Ajustes, etc.) lo dejan en false y son cerrables.
  final bool gate;

  /// Origen desde el que se abrió el paywall (para analytics): onboarding,
  /// settings, home, message_limit...
  final String source;

  const PaywallScreen({super.key, this.gate = false, this.source = 'onboarding'});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _trialEnabled = true; // true = mensual con trial, false = anual
  bool _canClose = false;
  bool _isEligibleForTrial = true; // optimista; se actualiza tras consultar RC
  bool _eligibilityChecked = false;

  @override
  void initState() {
    super.initState();
    // Aplicar la elegibilidad cacheada (prewarm en pre-paywall) o sembrada
    // (splash, cold start) DESDE EL PRIMER FRAME, sin esperar a que carguen los
    // precios. Es lo que evita el parpadeo del toggle. Si no hay valor todavía,
    // se mantiene optimista y se resuelve async cuando carguen los offerings.
    final cachedEligible = RevenueCatService.instance.trialEligible;
    if (cachedEligible != null) {
      _isEligibleForTrial = cachedEligible;
      _eligibilityChecked = true;
    }
    AnalyticsService().logPaywallViewed(source: widget.source);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _canClose = true);
    });
    // Forzar recarga de offerings si no están disponibles
    final offerings = ref.read(subscriptionProvider).offerings;
    if (offerings == null) {
      ref.read(subscriptionProvider.notifier).refresh();
    }
  }

  Future<void> _checkEligibility(String productId) async {
    final eligible =
        await RevenueCatService.instance.isEligibleForTrial(productId);
    if (mounted) setState(() => _isEligibleForTrial = eligible);
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionProvider);
    final monthlyPackage = ref.watch(monthlyPackageProvider);
    final annualPackage = ref.watch(annualPackageProvider);

    final monthlyPrice = monthlyPackage?.storeProduct.priceString ?? '\$14.99';
    final annualPrice = annualPackage?.storeProduct.priceString ?? '\$39.99';
    final isPurchasing = subscriptionState.isPurchasing;

    // Resolver elegibilidad de trial cuando el paquete mensual esté cargado.
    if (monthlyPackage != null && !_eligibilityChecked) {
      _eligibilityChecked = true;
      final cached = RevenueCatService.instance.trialEligible;
      if (cached != null) {
        // Precargada (pre-paywall) o persistida (cold start) → se aplica en este
        // mismo frame, sin parpadeo.
        _isEligibleForTrial = cached;
      } else {
        // Desconocida (p.ej. abierto desde Ajustes/Home sin caché previa) →
        // comprobación asíncrona, suavizada por el AnimatedSize del toggle.
        final productId = monthlyPackage.storeProduct.identifier;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkEligibility(productId);
        });
      }
    }

    final showTrialCopy = _isEligibleForTrial && _trialEnabled;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Contenido scrollable centrado verticalmente: logo, título y
              // features (evita el hueco muerto entre features y planes).
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),

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

                            const SizedBox(height: 32),

                            // Features enriquecidas
                            _buildFeatureItem(
                              Icons.chat_bubble_outline_rounded,
                              'Chat ilimitado con IA',
                              'Habla de tu fe siempre que lo necesites',
                            ),
                            const SizedBox(height: 18),
                            _buildFeatureItem(
                              Icons.menu_book_rounded,
                              'Planes de estudio personalizados',
                              'Crece a tu ritmo, paso a paso',
                            ),
                            const SizedBox(height: 18),
                            _buildFeatureItem(
                              Icons.wb_sunny_rounded,
                              'Reflexiones y devocionales diarios',
                              'Tu momento de paz cada mañana',
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bloque inferior fijo: planes + microcopy + CTA + footer
              // (pegado al botón para evitar el hueco)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Toggle trial — solo si es elegible. Colapso suave para que
                    // no "parpadee" cuando RC confirma que no es elegible.
                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      child: _isEligibleForTrial
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildTrialToggle(),
                                const SizedBox(height: 12),
                              ],
                            )
                          : const SizedBox(width: double.infinity),
                    ),

                    // Plan mensual (mock data si RevenueCat no carga)
                    _buildMonthlyCard(monthlyPrice),

                    const SizedBox(height: 10),

                    // Plan anual
                    _buildAnnualCard(annualPrice),

                    const SizedBox(height: 14),

                    // Microcopy JUSTO encima del botón
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showTrialCopy) ...[
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          child: Text(
                            showTrialCopy
                                ? 'Hoy no pagas nada. Cancela en cualquier momento.'
                                : 'Cancela en cualquier momento, sin compromiso.',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Error
                    if (subscriptionState.error != null) ...[
                      Text(
                        subscriptionState.error!,
                        style: const TextStyle(
                          color: AppTheme.errorColor,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                    ],

                    // CTA grande
                    SizedBox(
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
                                onPressed: () =>
                                    _handleCTA(monthlyPackage, annualPackage),
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
                                      showTrialCopy
                                          ? 'Pruebalo gratis'
                                          : 'Suscribete',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.chevron_right,
                                        size: 22, color: Colors.white),
                                  ],
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
                            MaterialPageRoute(
                                builder: (_) => const TermsConditionsScreen()),
                          ),
                          child: const Text(
                            'Terminos y condiciones',
                            style: TextStyle(
                                fontSize: 11, color: AppTheme.textTertiary),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '·',
                            style: TextStyle(
                                fontSize: 11, color: AppTheme.textTertiary),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const PrivacyPolicyScreen()),
                          ),
                          child: const Text(
                            'Politica de privacidad',
                            style: TextStyle(
                                fontSize: 11, color: AppTheme.textTertiary),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '·',
                            style: TextStyle(
                                fontSize: 11, color: AppTheme.textTertiary),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _handleRestore(),
                          child: const Text(
                            'Restaurar',
                            style: TextStyle(
                                fontSize: 11, color: AppTheme.textTertiary),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Boton X flotante — oculto en modo gate (hard paywall: no se puede cerrar)
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: widget.gate
          ? null
          : Padding(
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
                    AnalyticsService()
                        .logPaywallDismissed(source: widget.source);
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

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrialToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
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
        padding: EdgeInsets.all(isSelected ? 14.5 : 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
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
            Text(
              _isEligibleForTrial ? 'Prueba gratuita de 3 dias' : 'Acceso Mensual',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _isEligibleForTrial
                  ? 'Despues, $price cada mes. Sin cobros ahora'
                  : '$price cada mes',
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
        padding: EdgeInsets.all(isSelected ? 14.5 : 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
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
    } else {
      // RevenueCat no cargó productos
      if (widget.gate) {
        // Hard paywall: no dejar pasar. Reintentar cargar productos.
        ref.read(subscriptionProvider.notifier).refresh();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cargando planes, inténtalo de nuevo en un momento'),
            backgroundColor: Color(0xFF1A2740),
          ),
        );
      } else if (context.canPop()) {
        context.pop();
      } else {
        context.go(RouteConstants.home);
      }
    }
  }

  Future<void> _handlePurchase(Package package) async {
    // ¿Esta compra inicia un trial real? Solo si el usuario es elegible y tiene
    // el plan con trial (mensual) seleccionado. Se captura ANTES de comprar
    // porque después de comprar la elegibilidad siempre da false.
    final wasTrialStart = _isEligibleForTrial && _trialEnabled;
    final success = await ref.read(subscriptionProvider.notifier).purchasePackage(package);
    if (success && mounted) {
      context.go('${RouteConstants.purchaseSuccess}?trial=$wasTrialStart');
    }
  }

  Future<void> _handleRestore() async {
    await ref.read(subscriptionProvider.notifier).restorePurchases();
    if (!mounted) return;
    final isPremium = ref.read(subscriptionProvider).isPremium;
    if (isPremium) {
      context.go(RouteConstants.purchaseSuccess);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontraron compras anteriores'),
          backgroundColor: Color(0xFF1A2740),
        ),
      );
    }
  }
}
