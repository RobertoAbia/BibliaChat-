import 'dart:async';

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

/// Splash screen simplificada - la UI viene de la splash nativa
/// Este widget solo hace el auth check y navega
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _listenToAuthChanges();
    _checkAuthAndNavigate();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  /// Escuchar cambios de auth para detectar password recovery
  void _listenToAuthChanges() {
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      // Detectar password recovery (cuando el usuario hace clic en el enlace del email)
      if (event == AuthChangeEvent.passwordRecovery) {
        if (mounted) {
          FlutterNativeSplash.remove();
          context.go(RouteConstants.resetPassword);
        }
      }
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      final user = session.user;

      // Verificar si tiene email pendiente de verificación
      if (user.email != null && user.email!.isNotEmpty && user.emailConfirmedAt == null) {
        await _initializeServices(user.id);
        if (mounted) {
          FlutterNativeSplash.remove();
          context.go('${RouteConstants.verifyEmail}?email=${user.email}');
        }
        return;
      }

      // Inicializar servicios y verificar onboarding EN PARALELO
      try {
        final repository = ref.read(userProfileRepositoryProvider);
        final servicesFuture = _initializeServices(user.id);
        final onboardingFuture = repository.hasCompletedOnboarding();

        // Esperar ambos resultados
        await servicesFuture;
        final hasCompletedOnboarding = await onboardingFuture;

        if (!mounted) return;

        if (hasCompletedOnboarding) {
          FlutterNativeSplash.remove();
          context.go(RouteConstants.home);
          _initializeBackgroundServices(user.id);
        } else {
          FlutterNativeSplash.remove();
          context.go(RouteConstants.onboarding);
          _initializeBackgroundServices(user.id);
        }
      } catch (e) {
        if (mounted) {
          FlutterNativeSplash.remove();
          context.go(RouteConstants.home);
        }
      }
    } else {
      // Usuario nuevo - crear sesión anónima
      try {
        final response = await Supabase.instance.client.auth.signInAnonymously();

        if (response.user != null) {
          await _initializeServices(response.user!.id);
          if (mounted) {
            FlutterNativeSplash.remove();
            context.go(RouteConstants.onboarding);
            _initializeBackgroundServices(response.user!.id);
          }
        } else if (mounted) {
          FlutterNativeSplash.remove();
          context.go(RouteConstants.onboarding);
        }
      } catch (e) {
        if (mounted) {
          FlutterNativeSplash.remove();
          context.go(RouteConstants.onboarding);
        }
      }
    }
  }

  Future<void> _initializeServices(String userId) async {
    // Set user ID for Firebase Analytics (instantáneo, no necesita await)
    AnalyticsService().setUserId(userId);

    // Solo notificaciones (rápido: ~50-200ms sin permiso dialog)
    final router = ref.read(appRouterProvider);
    await NotificationService().init(userId, router).catchError((e) {
      debugPrint('Notification init error: $e');
    });
  }

  /// Lanza servicios no críticos en background después de navegar.
  /// RevenueCat + preload de datos: estarán listos antes de que el usuario los necesite.
  void _initializeBackgroundServices(String userId) {
    // RevenueCat: estará listo antes de que el usuario llegue al paywall
    RevenueCatService.instance.init(userId).catchError((e) {
      debugPrint('RevenueCat init error: $e');
    });
    // Preload Home data: el placeholder glass cubre mientras cargan
    ref.read(dailyGospelProvider.future).catchError((_) => null);
    ref.read(weekCompletionProvider.future).catchError((_) => <String>{});
  }

  @override
  Widget build(BuildContext context) {
    // Mismo color que la splash nativa para transición invisible
    return const Scaffold(
      backgroundColor: Color(0xFF141A2E),
      body: SizedBox.shrink(),
    );
  }
}
