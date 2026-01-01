/// Route path constants for navigation
class RouteConstants {
  RouteConstants._();

  // Auth & Onboarding
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // Main App
  static const String home = '/home';
  static const String chatList = '/chat';
  static const String chatNew = '/chat/new';
  static const String chatById = '/chat/id/:chatId';
  static const String chatByTopic = '/chat/topic/:topicKey';
  static const String study = '/study';
  static const String settings = '/settings';

  // Study Plans
  static const String planDetail = '/study/plan/:planId';
  static const String planDay = '/study/plan/:planId/day/:dayNumber';
}
