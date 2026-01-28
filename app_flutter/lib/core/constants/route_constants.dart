/// Route path constants for navigation
class RouteConstants {
  RouteConstants._();

  // Auth & Onboarding
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/auth/login';
  static const String linkEmail = '/auth/link-email';
  static const String verifyEmail = '/auth/verify-email';
  static const String resetPassword = '/auth/reset-password';

  // Main App
  static const String home = '/home';
  static const String chatList = '/chat';
  static const String chatNew = '/chat/new';
  static const String chatById = '/chat/id/:chatId';
  static const String chatByTopic = '/chat/topic/:topicKey';
  static const String study = '/study';
  static const String settings = '/settings';
  static const String profileEdit = '/settings/edit';
  static const String savedMessages = '/settings/saved-messages';
  static const String privacyPolicy = '/settings/privacy-policy';
  static const String termsConditions = '/settings/terms-conditions';

  // Study Plans
  static const String planDetail = '/study/plan/:planId';
  static const String planDay = '/study/day/:userPlanId';

  // Subscription
  static const String paywall = '/paywall';
}
