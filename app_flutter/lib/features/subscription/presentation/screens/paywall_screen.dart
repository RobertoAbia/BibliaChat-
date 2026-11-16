import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/services/remote_config_service.dart';
import '../../../../core/services/revenue_cat_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../legal/presentation/screens/privacy_policy_screen.dart';
import '../../../legal/presentation/screens/terms_conditions_screen.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../providers/subscription_provider.dart';
import '../utils/paywall_pricing.dart';

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

enum _Plan { annual, monthly }

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  /// Cita de prueba social. Debe ser una reseña real de la App Store.
  static const String _socialProofQuote = 'Me ayuda a orar cada día';

  _Plan _selected = _Plan.annual;
  bool _selectionInitialized = false;
  bool _canClose = false;
  bool _isEligibleForTrial = true; // optimista; se actualiza tras consultar RC
  bool _eligibilityChecked = false;

  /// Los planes no han cargado tras el timeout (sin red, RevenueCat caído o
  /// plataforma sin API key). Muestra error + reintento en vez de precios
  /// inventados, y abre la válvula de escape del gate.
  bool _plansTimedOut = false;
  Timer? _plansTimer;

  void _startPlansTimer() {
    _plansTimer?.cancel();
    _plansTimer = Timer(const Duration(seconds: 12), () {
      if (mounted) setState(() => _plansTimedOut = true);
    });
  }

  void _retryLoadPlans() {
    setState(() => _plansTimedOut = false);
    _startPlansTimer();
    ref.read(subscriptionProvider.notifier).refresh();
  }

  void _closePaywall() {
    AnalyticsService().logPaywallDismissed(source: widget.source);
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouteConstants.home);
    }
  }

  /// Pantalla mientras cargan los planes (o si no cargan). Nunca precios mock.
  Widget _buildPlansLoadingScaffold(BuildContext context) {
    final showEscape = (!widget.gate || _plansTimedOut) && _canClose;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: _plansTimedOut
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wifi_off_rounded,
                            size: 44, color: AppTheme.textTertiary),
                        const SizedBox(height: 16),
                        Text(
                          'No se pudieron cargar los planes',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Comprueba tu conexión e inténtalo de nuevo.',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 48,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppTheme.goldGradient,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: ElevatedButton(
                              onPressed: _retryLoadPlans,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                minimumSize: Size.zero,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 28),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text(
                                'Reintentar',
                                style: TextStyle(
                                  color: Color(0xFF1A1A2E),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Cargando planes…',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      // Válvula de escape: cerrable siempre fuera del gate; en el gate, solo
      // cuando los planes no cargan (mejor dejar pasar que bloquear la app)
      floatingActionButton: showEscape
          ? Padding(
              padding: const EdgeInsets.only(top: 4),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 22,
                  color: AppTheme.textTertiary.withOpacity(0.6),
                ),
                onPressed: _closePaywall,
              ),
            )
          : null,
    );
  }

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
      // NO marcar _eligibilityChecked: la caché puede estar obsoleta (p.ej.
      // trial consumido y expirado) — se re-verifica contra RC cuando carguen
      // los paquetes, sin parpadeo porque se parte del valor cacheado.
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
    _startPlansTimer();
  }

  @override
  void dispose() {
    _plansTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkEligibility(List<String> productIds) async {
    final eligible =
        await RevenueCatService.instance.isEligibleForTrial(productIds);
    if (!mounted) return;
    setState(() {
      _isEligibleForTrial = eligible;
      // Sin trial, la mejor oferta es el anual (salvo que Remote Config fije
      // un plan concreto).
      if (!eligible && RemoteConfigService().paywallDefaultPlan == 'auto') {
        _selected = _Plan.annual;
      }
    });
  }

  /// Selección inicial. Remote Config `paywall_default_plan` manda si vale
  /// `annual` o `monthly`; en `auto`: el plan con trial si el usuario es
  /// elegible (anual preferido), si no el anual.
  void _initSelection(Package? monthly, Package? annual) {
    if (_selectionInitialized || (monthly == null && annual == null)) return;
    _selectionInitialized = true;
    switch (RemoteConfigService().paywallDefaultPlan) {
      case 'annual':
        _selected = _Plan.annual;
        return;
      case 'monthly':
        _selected = _Plan.monthly;
        return;
    }
    if (_isEligibleForTrial) {
      if (PaywallPricing.hasFreeTrial(annual)) {
        _selected = _Plan.annual;
        return;
      }
      if (PaywallPricing.hasFreeTrial(monthly)) {
        _selected = _Plan.monthly;
        return;
      }
    }
    _selected = _Plan.annual;
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionProvider);
    final monthlyPackage = ref.watch(monthlyPackageProvider);
    final annualPackage = ref.watch(annualPackageProvider);
    final profile = ref.watch(currentUserProfileProvider).valueOrNull;

    // Sin paquetes cargados NO se pintan precios inventados (los mocks
    // $14.99/$39.99 en USD podían no corresponder al storefront real):
    // pantalla de carga, y tras el timeout error + reintento con válvula de
    // escape incluso en modo gate (si no, con RevenueCat caído o sin API key
    // —Android hoy— la app quedaba bloqueada para siempre).
    if (monthlyPackage == null && annualPackage == null) {
      return _buildPlansLoadingScaffold(context);
    }

    final monthlyPrice = monthlyPackage?.storeProduct.priceString ?? '—';
    final annualPrice = annualPackage?.storeProduct.priceString ?? '—';
    final isPurchasing = subscriptionState.isPurchasing;

    // Resolver elegibilidad de trial cuando los paquetes estén cargados.
    if ((monthlyPackage != null || annualPackage != null) &&
        !_eligibilityChecked) {
      _eligibilityChecked = true;
      final cached = RevenueCatService.instance.trialEligible;
      if (cached != null) {
        // Precargada (pre-paywall) o persistida (cold start) → se aplica en este
        // mismo frame, sin parpadeo.
        _isEligibleForTrial = cached;
      }
      // Verificar SIEMPRE contra RC aunque haya caché: un trial consumido en
      // una suscripción ya expirada dejaría caché true y Apple cobraría al
      // instante pese al copy "3 días gratis". Con caché, el cambio solo se
      // pinta si el valor real difiere.
      final ids = [monthlyPackage, annualPackage]
          .whereType<Package>()
          .map((p) => p.storeProduct.identifier)
          .toList();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkEligibility(ids);
      });
    }
    _initSelection(monthlyPackage, annualPackage);

    // Trial por plan (dato real del producto × elegibilidad del usuario).
    final annualTrialDays = _isEligibleForTrial
        ? PaywallPricing.freeTrialDays(annualPackage)
        : null;
    final monthlyTrialDays = _isEligibleForTrial
        ? PaywallPricing.freeTrialDays(monthlyPackage)
        : null;
    final selectedTrialDays =
        _selected == _Plan.annual ? annualTrialDays : monthlyTrialDays;
    final selectedPrice =
        _selected == _Plan.annual ? annualPrice : monthlyPrice;
    final selectedPeriod = _selected == _Plan.annual ? 'año' : 'mes';
    final showTrialCopy = selectedTrialDays != null;

    // El toggle "probar gratis" solo tiene sentido si exactamente uno de los
    // dos planes tiene trial.
    final _Plan? trialPlan = (annualTrialDays != null) != (monthlyTrialDays != null)
        ? (annualTrialDays != null ? _Plan.annual : _Plan.monthly)
        : null;

    final savingsPct =
        PaywallPricing.annualSavingsPercent(monthlyPackage, annualPackage);
    final monthlyEquivalent = PaywallPricing.monthlyEquivalent(annualPackage);

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

                            // Título personalizado con nombre + motivo
                            ..._buildTitle(profile?.name, profile?.motive),

                            const SizedBox(height: 28),

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

                            const SizedBox(height: 22),

                            // Prueba social
                            _buildSocialProof(),

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
                    // Toggle trial — solo si hay un plan con trial. Colapso
                    // suave para que no "parpadee" cuando RC confirma que no
                    // es elegible.
                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      child: trialPlan != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildTrialToggle(trialPlan),
                                const SizedBox(height: 12),
                              ],
                            )
                          : const SizedBox(width: double.infinity),
                    ),

                    // Tarjetas de planes. Orden según Remote Config
                    // `paywall_annual_first` (default: anual arriba).
                    ..._orderCards(
                      annualFirst: RemoteConfigService().paywallAnnualFirst,
                      annual: _buildPlanCard(
                        plan: _Plan.annual,
                        title: annualTrialDays != null
                            ? 'Prueba gratuita de $annualTrialDays días'
                            : 'Acceso Anual',
                        subtitle: annualTrialDays != null
                            ? 'Después, $annualPrice al año. Sin cobros ahora'
                            : monthlyEquivalent != null
                                ? '$annualPrice al año, solo $monthlyEquivalent al mes'
                                : '$annualPrice al año',
                        badge:
                            savingsPct != null ? 'AHORRA $savingsPct%' : null,
                      ),
                      monthly: _buildPlanCard(
                        plan: _Plan.monthly,
                        title: monthlyTrialDays != null
                            ? 'Prueba gratuita de $monthlyTrialDays días'
                            : 'Acceso Mensual',
                        subtitle: monthlyTrialDays != null
                            ? 'Después, $monthlyPrice al mes. Sin cobros ahora'
                            : '$monthlyPrice al mes',
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Microcopy JUSTO encima del botón
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showTrialCopy) ...[
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          child: Text(
                            showTrialCopy
                                ? 'Hoy no pagas nada. Después, $selectedPrice/$selectedPeriod. Cancela cuando quieras.'
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
                                onPressed: () => _handleCTA(
                                  monthlyPackage,
                                  annualPackage,
                                  isTrialStart: showTrialCopy,
                                ),
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
                                          ? 'Empezar $selectedTrialDays días gratis'
                                          : 'Suscríbete',
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

                    // Footer: Términos · Privacidad · Restaurar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const TermsConditionsScreen()),
                          ),
                          child: const Text(
                            'Términos y condiciones',
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
                            'Política de privacidad',
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
      // Botón X flotante — oculto en modo gate (hard paywall: no se puede cerrar)
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
                  onPressed: _closePaywall,
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

  /// Título personalizado: "{Nombre}, tu plan de fe está listo" + objetivo.
  /// Si no hay nombre, cae en el título genérico.
  List<Widget> _buildTitle(String? name, String? motive) {
    const titleStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: AppTheme.textPrimary,
      height: 1.15,
    );
    final cleanName = name?.trim();
    if (cleanName == null || cleanName.isEmpty) {
      return const [
        Text('No pierdas ni un\nsolo momento de fe', style: titleStyle),
      ];
    }
    return [
      Text('$cleanName, tu plan\nde fe está listo', style: titleStyle),
      const SizedBox(height: 10),
      Text(
        'Todo lo que necesitas para ${PaywallPricing.objectivePhrase(motive)}.',
        style: const TextStyle(
          fontSize: 15,
          color: AppTheme.textSecondary,
          height: 1.3,
        ),
      ),
    ];
  }

  List<Widget> _orderCards({
    required bool annualFirst,
    required Widget annual,
    required Widget monthly,
  }) {
    final first = annualFirst ? annual : monthly;
    final second = annualFirst ? monthly : annual;
    return [first, const SizedBox(height: 10), second];
  }

  Widget _buildSocialProof() {
    return Row(
      children: [
        ...List.generate(
          5,
          (_) => const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF5B301)),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            '«$_socialProofQuote»',
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: AppTheme.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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

  /// Toggle "probar gratis": ON selecciona el plan con trial, OFF el otro.
  Widget _buildTrialToggle(_Plan trialPlan) {
    final trialOn = _selected == trialPlan;
    final otherPlan = trialPlan == _Plan.annual ? _Plan.monthly : _Plan.annual;
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
              'Quiero probar la aplicación gratis',
              style: TextStyle(
                fontSize: 15,
                color: trialOn ? AppTheme.textPrimary : AppTheme.textSecondary,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: trialOn,
              onChanged: (value) => setState(
                () => _selected = value ? trialPlan : otherPlan,
              ),
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

  Widget _buildPlanCard({
    required _Plan plan,
    required String title,
    required String subtitle,
    String? badge,
  }) {
    final isSelected = _selected == plan;

    return GestureDetector(
      onTap: () => setState(() => _selected = plan),
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
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
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
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleCTA(
    Package? monthlyPackage,
    Package? annualPackage, {
    required bool isTrialStart,
  }) {
    final package =
        _selected == _Plan.annual ? annualPackage : monthlyPackage;
    if (package != null) {
      _handlePurchase(package, isTrialStart: isTrialStart);
      return;
    }
    // El paquete del plan seleccionado no cargó (caso raro: offerings a
    // medias). Reintentar e informar — NUNCA cerrar en silencio: el usuario
    // acaba de pulsar "Suscríbete" con máxima intención de compra.
    ref.read(subscriptionProvider.notifier).refresh();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cargando planes, inténtalo de nuevo en un momento'),
        backgroundColor: Color(0xFF1A2740),
      ),
    );
  }

  Future<void> _handlePurchase(Package package,
      {required bool isTrialStart}) async {
    // ¿Esta compra inicia un trial real? Solo si el usuario es elegible y el
    // plan seleccionado tiene trial. Se captura ANTES de comprar porque después
    // de comprar la elegibilidad siempre da false.
    final success = await ref.read(subscriptionProvider.notifier).purchasePackage(package);
    if (success && mounted) {
      context.go('${RouteConstants.purchaseSuccess}?trial=$isTrialStart');
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
