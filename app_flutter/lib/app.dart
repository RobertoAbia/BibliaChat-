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

class BibliaChatApp extends ConsumerStatefulWidget {
  const BibliaChatApp({super.key});

  @override
  ConsumerState<BibliaChatApp> createState() => _BibliaChatAppState();
}

class _BibliaChatAppState extends ConsumerState<BibliaChatApp> {
  static const _mainRoutes = [
    RouteConstants.home,
    RouteConstants.chatList,
    RouteConstants.study,
    RouteConstants.settings,
  ];

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

  bool _isMainRoute(String location) => _mainRoutes.contains(location);

  // Helper para obtener la ruta padre de una ruta anidada
  String _getParentRoute(String location) {
    // Chat conversations (fuera del ShellRoute) → volver a lista de chats
    if (location.startsWith('/chat-conversation')) return RouteConstants.chatList;
    // Rutas anidadas dentro del ShellRoute
    if (location.startsWith('/chat/')) return RouteConstants.chatList;
    if (location.startsWith('/study/')) return RouteConstants.study;
    if (location.startsWith('/settings/')) return RouteConstants.settings;
    if (location.startsWith('/home/')) return RouteConstants.home;
    return RouteConstants.home;
  }

  bool _handleBackButton(bool stopDefaultButtonEvent, RouteInfo info) {
    final router = ref.read(appRouterProvider);
    final location = ref.read(currentLocationProvider);
    final isMainRoute = _isMainRoute(location);
    final currentTabIndex = ref.read(currentTabIndexProvider);

    debugPrint('BackButtonInterceptor: location=$location, isMainRoute=$isMainRoute, tabIndex=$currentTabIndex');

    // Si NO estamos en una ruta principal, es una ruta GoRouter anidada → ir a la ruta padre
    if (!isMainRoute) {
      debugPrint('BackButtonInterceptor: Nested GoRouter route, going to parent');
      final parentRoute = _getParentRoute(location);
      router.go(parentRoute);
      return true;
    }

    // Si estamos en tab principal
    if (currentTabIndex == 0) {
      // En Home -> cerrar la app
      debugPrint('BackButtonInterceptor: On Home, closing app');
      SystemNavigator.pop();
      return true;
    }

    // En otra tab -> ir a Home
    debugPrint('BackButtonInterceptor: Going to Home from tab $currentTabIndex');
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
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
