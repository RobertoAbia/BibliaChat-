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

      // Inicializar servicios
      await _initializeServices(user.id);

      // Verificar si tiene email pendiente de verificación
      if (user.email != null && user.email!.isNotEmpty && user.emailConfirmedAt == null) {
        if (mounted) {
          FlutterNativeSplash.remove();
          context.go('${RouteConstants.verifyEmail}?email=${user.email}');
        }
        return;
      }

      // Usuario autenticado - verificar si completó onboarding
      await _checkOnboardingAndNavigate();
    } else {
      // Usuario nuevo - crear sesión anónima
      try {
        final response = await Supabase.instance.client.auth.signInAnonymously();

        if (response.user != null) {
          await _initializeServices(response.user!.id);
        }

        if (mounted) {
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
    // Inicializar RevenueCat
    try {
      await RevenueCatService.instance.init(userId);
    } catch (e) {
      debugPrint('RevenueCat init error: $e');
    }

    // Set user ID for Firebase Analytics
    AnalyticsService().setUserId(userId);

    // Inicializar notificaciones push
    try {
      final router = ref.read(appRouterProvider);
      await NotificationService().init(userId, router);
    } catch (e) {
      debugPrint('Notification init error: $e');
    }
  }

  Future<void> _checkOnboardingAndNavigate() async {
    try {
      final repository = ref.read(userProfileRepositoryProvider);
      final hasCompletedOnboarding = await repository.hasCompletedOnboarding();

      if (!mounted) return;

      FlutterNativeSplash.remove();

      if (hasCompletedOnboarding) {
        context.go(RouteConstants.home);
      } else {
        context.go(RouteConstants.onboarding);
      }
    } catch (e) {
      if (mounted) {
        FlutterNativeSplash.remove();
        context.go(RouteConstants.home);
      }
    }
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
