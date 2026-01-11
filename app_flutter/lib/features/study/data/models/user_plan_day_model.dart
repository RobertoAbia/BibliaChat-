import '../../domain/entities/user_plan_day.dart';

/// Data model for UserPlanDay with JSON serialization
class UserPlanDayModel extends UserPlanDay {
  const UserPlanDayModel({
    required super.id,
    required super.userPlanId,
    required super.dayNumber,
    super.userAnswer,
    super.completedVia,
    required super.completedAt,
  });

  factory UserPlanDayModel.fromJson(Map<String, dynamic> json) {
    return UserPlanDayModel(
      id: json['id'] as String,
      userPlanId: json['user_plan_id'] as String,
      dayNumber: json['day_number'] as int,
      userAnswer: json['user_answer'] as String?,
      completedVia: json['completed_via'] as String?,
      completedAt: DateTime.parse(json['completed_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_plan_id': userPlanId,
      'day_number': dayNumber,
      'user_answer': userAnswer,
      'completed_via': completedVia,
      'completed_at': completedAt.toIso8601String(),
    };
  }
}
