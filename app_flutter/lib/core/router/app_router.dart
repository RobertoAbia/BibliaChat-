import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/link_email_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/study/presentation/screens/study_screen.dart';
import '../../features/study/presentation/screens/plan_detail_screen.dart';
import '../../features/study/presentation/screens/plan_day_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/subscription/presentation/screens/paywall_screen.dart';
import '../../features/profile/presentation/screens/profile_edit_screen.dart';
import '../../features/saved_messages/presentation/screens/saved_messages_screen.dart';
import '../constants/route_constants.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteConstants.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen
      GoRoute(
        path: RouteConstants.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: RouteConstants.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteConstants.linkEmail,
        name: 'linkEmail',
        builder: (context, state) => const LinkEmailScreen(),
      ),
      GoRoute(
        path: RouteConstants.verifyEmail,
        name: 'verifyEmail',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'];
          return VerifyEmailScreen(email: email);
        },
      ),
      GoRoute(
        path: RouteConstants.resetPassword,
        name: 'resetPassword',
        builder: (context, state) => const ResetPasswordScreen(),
      ),

      // Paywall (sin bottom navigation)
      GoRoute(
        path: RouteConstants.paywall,
        name: 'paywall',
        builder: (context, state) => const PaywallScreen(),
      ),

      // Saved Messages / Mis Reflexiones (sin bottom navigation)
      GoRoute(
        path: RouteConstants.savedMessages,
        name: 'savedMessages',
        builder: (context, state) => const SavedMessagesScreen(),
      ),

      // Main App with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: RouteConstants.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RouteConstants.chatList,
            name: 'chatList',
            builder: (context, state) => const ChatListScreen(),
            routes: [
              // Nueva conversación (chat libre)
              GoRoute(
                path: 'new',
                name: 'chatNew',
                builder: (context, state) => const ChatScreen(),
              ),
              // Chat existente por ID
              GoRoute(
                path: 'id/:chatId',
                name: 'chatById',
                builder: (context, state) {
                  final chatId = state.pathParameters['chatId']!;
                  return ChatScreen(chatId: chatId);
                },
              ),
              // Chat por topic (desde Stories o temas guiados)
              GoRoute(
                path: 'topic/:topicKey',
                name: 'chatByTopic',
                builder: (context, state) {
                  final topicKey = state.pathParameters['topicKey']!;
                  return ChatScreen(topicKey: topicKey);
                },
              ),
            ],
          ),
          GoRoute(
            path: RouteConstants.study,
            name: 'study',
            builder: (context, state) => const StudyScreen(),
            routes: [
              // Plan detail
              GoRoute(
                path: 'plan/:planId',
                name: 'planDetail',
                builder: (context, state) {
                  final planId = state.pathParameters['planId']!;
                  return PlanDetailScreen(planId: planId);
                },
              ),
              // Plan day (current day of active plan, or any day in readOnly mode)
              GoRoute(
                path: 'day/:userPlanId',
                name: 'planDay',
                builder: (context, state) {
                  final userPlanId = state.pathParameters['userPlanId']!;
                  // Query params for readOnly mode
                  final readOnly = state.uri.queryParameters['readOnly'] == 'true';
                  final dayParam = state.uri.queryParameters['day'];
                  final day = dayParam != null ? int.tryParse(dayParam) : null;
                  return PlanDayScreen(
                    userPlanId: userPlanId,
                    readOnly: readOnly,
                    day: day,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: RouteConstants.settings,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'profileEdit',
                builder: (context, state) => const ProfileEditScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// Shell widget for bottom navigation with swipe support
class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  PageController? _pageController;
  String? _lastLocation;

  // Rutas principales (tabs)
  static const _mainRoutes = [
    RouteConstants.home,
    RouteConstants.chatList,
    RouteConstants.study,
    RouteConstants.settings,
  ];

  // Las pantallas principales (se mantienen en memoria para swipe)
  final List<Widget> _screens = const [
    HomeScreen(),
    ChatListScreen(),
    StudyScreen(),
    SettingsScreen(),
  ];

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  // Detectar si estamos en una ruta principal (tab) o anidada
  bool _isMainRoute(String location) {
    return _mainRoutes.contains(location);
  }

  // Obtener el índice de la tab según la ruta
  int _getTabIndex(String location) {
    if (location.startsWith('/settings')) return 3;
    if (location.startsWith('/study')) return 2;
    if (location.startsWith('/chat')) return 1;
    return 0; // /home por defecto
  }

  void _onItemTapped(int index, String currentLocation) {
    // Si estamos en ruta anidada, navegar a la tab
    if (!_isMainRoute(currentLocation)) {
      context.go(_mainRoutes[index]);
      return;
    }

    // Si estamos en tabs, animar el PageView y sincronizar
    _pageController?.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    context.go(_mainRoutes[index]);
  }

  void _onPageChanged(int index) {
    context.go(_mainRoutes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isMainRoute = _isMainRoute(location);
    final selectedIndex = _getTabIndex(location);

    // Detectar si venimos de una ruta anidada
    final wasOnNestedRoute = _lastLocation != null && !_isMainRoute(_lastLocation!);

    // Crear PageController o recrearlo si volvemos de ruta anidada
    if (isMainRoute) {
      if (_pageController == null || wasOnNestedRoute) {
        _pageController?.dispose();
        _pageController = PageController(initialPage: selectedIndex);
      }
    }
    _lastLocation = location;

    return BackButtonListener(
      onBackButtonPressed: () async {
        final router = GoRouter.of(context);
        if (router.canPop()) {
          router.pop();
          return true;
        } else if (isMainRoute) {
          await SystemNavigator.pop();
          return true;
        }
        return false;
      },
      child: Scaffold(
        // Si es ruta principal → PageView (swipe), si es anidada → child
        body: isMainRoute
            ? PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: _screens,
              )
            : widget.child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) => _onItemTapped(index, location),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Hoy',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'Estudiar',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
