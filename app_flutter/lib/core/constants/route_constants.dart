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
  static const String study = '/study';

  // Chat conversations (fuera del ShellRoute - sin bottom nav)
  static const String chatConversationNew = '/chat-conversation/new';
  static const String chatConversationById = '/chat-conversation'; // + /:chatId
  static const String chatConversationByTopic = '/chat-conversation/topic'; // + /:topicKey
  static const String settings = '/settings';
  static const String profileEdit = '/settings/edit';
  static const String savedMessages = '/saved-messages';

  // Study Plans
  static const String planDetail = '/study/plan/:planId';
  static const String planDay = '/study/day/:userPlanId';

  // Subscription
  static const String paywall = '/paywall';
}
