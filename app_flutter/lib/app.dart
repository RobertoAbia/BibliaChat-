import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/route_constants.dart';

/// Provider global para trackear el índice de la tab actual
final currentTabIndexProvider = StateProvider<int>((ref) => 0);

/// Provider global para trackear la ruta REAL (incluyendo rutas anidadas)
/// Necesario porque BackButtonInterceptor está fuera del contexto del router
/// y GoRouter solo reporta la ruta del ShellRoute padre
final currentLocationProvider = StateProvider<String>((ref) => '/');

/// Provider para guardar el contexto del diálogo abierto
/// Cuando hay un diálogo, el botón atrás de Android debe cerrarlo
final dialogContextProvider = StateProvider<BuildContext?>((ref) => null);

class BibliaChatApp extends ConsumerStatefulWidget {
  const BibliaChatApp({super.key});

  @override
  ConsumerState<BibliaChatApp> createState() => _BibliaChatAppState();
}

class _BibliaChatAppState extends ConsumerState<BibliaChatApp> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(_handleBackButton, name: 'main');
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_handleBackButton);
    super.dispose();
  }

  bool _handleBackButton(bool stopDefaultButtonEvent, RouteInfo info) {
    final dialogContext = ref.read(dialogContextProvider);

    // Si hay un diálogo abierto, cerrarlo manualmente
    if (dialogContext != null) {
      Navigator.of(dialogContext).pop();
      ref.read(dialogContextProvider.notifier).state = null;
      return true;
    }

    final router = ref.read(appRouterProvider);
    final currentTabIndex = ref.read(currentTabIndexProvider);

    // 1. Si hay historial → pop (volver a ruta anterior)
    if (router.canPop()) {
      router.pop();
      return true;
    }

    // 2. En Home sin historial → minimizar app (como WhatsApp/Instagram)
    if (currentTabIndex == 0) {
      const MethodChannel('ee.bikain.bibliachat/app').invokeMethod('moveToBack');
      return true;
    }

    // 3. En otro tab sin historial → ir a Home
    ref.read(currentTabIndexProvider.notifier).state = 0;
    router.go(RouteConstants.home);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Biblia Chat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
