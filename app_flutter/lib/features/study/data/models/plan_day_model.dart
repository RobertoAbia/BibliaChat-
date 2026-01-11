import '../../domain/entities/plan_day.dart';

/// Data model for PlanDay with JSON serialization
class PlanDayModel extends PlanDay {
  const PlanDayModel({
    required super.id,
    required super.planId,
    required super.dayNumber,
    super.title,
    required super.verseReferences,
    super.reflection,
    super.practicalExercise,
    super.question,
  });

  factory PlanDayModel.fromJson(Map<String, dynamic> json) {
    // verse_references comes as a Postgres array, Supabase returns it as List
    final verseRefs = json['verse_references'];
    List<String> verses = [];
    if (verseRefs is List) {
      verses = verseRefs.map((e) => e.toString()).toList();
    }

    return PlanDayModel(
      id: json['id'] as String,
      planId: json['plan_id'] as String,
      dayNumber: json['day_number'] as int,
      title: json['title'] as String?,
      verseReferences: verses,
      reflection: json['reflection'] as String?,
      practicalExercise: json['practical_exercise'] as String?,
      question: json['question'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'day_number': dayNumber,
      'title': title,
      'verse_references': verseReferences,
      'reflection': reflection,
      'practical_exercise': practicalExercise,
      'question': question,
    };
  }
}
