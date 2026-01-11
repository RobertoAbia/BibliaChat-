/// Entity representing a day within a study plan
class PlanDay {
  final String id;
  final String planId;
  final int dayNumber;
  final String? title;
  final List<String> verseReferences;
  final String? reflection;
  final String? practicalExercise;
  final String? question;

  const PlanDay({
    required this.id,
    required this.planId,
    required this.dayNumber,
    this.title,
    required this.verseReferences,
    this.reflection,
    this.practicalExercise,
    this.question,
  });

  /// Display title for the day
  String get displayTitle => title ?? 'Día $dayNumber';
}
