import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/revenue_cat_service.dart';
import '../../../daily_gospel/presentation/providers/daily_gospel_provider.dart';
import '../../../home/presentation/providers/daily_progress_provider.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../../../study/presentation/providers/study_provider.dart';

/// Splash screen — check auth local + navegar rápido.
/// Servicios de red se lanzan en background DESPUÉS de navegar.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    if (!mounted) return;

    // 1. Check local session — instantáneo, sin red
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      // Usuario nuevo — crear sesión anónima (única llamada de red obligatoria)
      try {
        final response = await Supabase.instance.client.auth
            .signInAnonymously()
            .timeout(const Duration(seconds: 5));
        if (mounted) {
          context.go(RouteConstants.onboarding);
          FlutterNativeSplash.remove();
          if (response.user != null) {
            _initializeAllServices(response.user!.id);
          }
        }
      } catch (e) {
        debugPrint('Splash signIn error: $e');
        if (mounted) {
          context.go(RouteConstants.onboarding);
          FlutterNativeSplash.remove();
        }
      }
      return;
    }

    // 2. Hay sesión — verificar email pendiente (check local, sin red)
    final user = session.user;
    if (user.email != null &&
        user.email!.isNotEmpty &&
        user.emailConfirmedAt == null) {
      context.go('${RouteConstants.verifyEmail}?email=${user.email}');
      FlutterNativeSplash.remove();
      _initializeAllServices(user.id);
      return;
    }

    // 3. Verificar onboarding (única query de red, con timeout corto)
    try {
      final repository = ref.read(userProfileRepositoryProvider);
      final hasCompletedOnboarding = await repository
          .hasCompletedOnboarding()
          .timeout(const Duration(seconds: 3), onTimeout: () => false);

      if (!mounted) return;

      if (hasCompletedOnboarding) {
        // Precargar datos de Home (con timeout, splash nativa cubre la espera)
        await _preloadHomeData();
        if (!mounted) return;
        context.go(RouteConstants.home);
        FlutterNativeSplash.remove();
      } else {
        context.go(RouteConstants.onboarding);
        FlutterNativeSplash.remove();
      }
    } catch (e) {
      debugPrint('Splash onboarding check error: $e');
      if (mounted) {
        context.go(RouteConstants.onboarding);
        FlutterNativeSplash.remove();
      }
    }

    // 4. Servicios en background — DESPUÉS de navegar, nunca bloquea
    _initializeAllServices(user.id);
  }

  /// Inicializa TODOS los servicios sin bloquear — fire and forget
  void _initializeAllServices(String userId) {
    AnalyticsService().setUserId(userId);

    final router = ref.read(appRouterProvider);
    NotificationService().init(userId, router).catchError((e) {
      debugPrint('Notification init error: $e');
    });

    RevenueCatService.instance.init(userId).catchError((e) {
      debugPrint('RevenueCat init error: $e');
    });
  }

  /// Precarga datos de Home. Timeout de 1.5s como safety net.
  Future<void> _preloadHomeData() async {
    await Future.wait([
      ref.read(currentUserProfileProvider.future).catchError((_) => null),
      ref.read(dailyGospelProvider.future).catchError((_) => null),
      ref.read(weekCompletionProvider.future).catchError((_) => <String>{}),
      ref.read(activePlanDataProvider.future).catchError((_) => null),
    ]).timeout(
      const Duration(milliseconds: 1500),
      onTimeout: () => [null, null, <String>{}, null],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Image.asset(
          'assets/images/splash_icon.png',
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}
