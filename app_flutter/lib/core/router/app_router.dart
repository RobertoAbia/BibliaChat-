import 'package:flutter/material.dart';
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

/// Shell widget for bottom navigation
class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.go(RouteConstants.home);
        break;
      case 1:
        context.go(RouteConstants.chatList);
        break;
      case 2:
        context.go(RouteConstants.study);
        break;
      case 3:
        context.go(RouteConstants.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(index, context),
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
    );
  }
}
