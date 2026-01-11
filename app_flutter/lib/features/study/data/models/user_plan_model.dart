import '../../domain/entities/user_plan.dart';

/// Data model for UserPlan with JSON serialization
class UserPlanModel extends UserPlan {
  const UserPlanModel({
    required super.id,
    required super.userId,
    required super.planId,
    required super.status,
    required super.currentDay,
    required super.startedAt,
    super.completedAt,
  });

  factory UserPlanModel.fromJson(Map<String, dynamic> json) {
    return UserPlanModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      planId: json['plan_id'] as String,
      status: _parseStatus(json['status'] as String),
      currentDay: json['current_day'] as int,
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  static PlanStatus _parseStatus(String status) {
    switch (status) {
      case 'not_started':
        return PlanStatus.notStarted;
      case 'in_progress':
        return PlanStatus.inProgress;
      case 'completed':
        return PlanStatus.completed;
      case 'abandoned':
        return PlanStatus.abandoned;
      default:
        return PlanStatus.inProgress;
    }
  }

  static String _statusToString(PlanStatus status) {
    switch (status) {
      case PlanStatus.notStarted:
        return 'not_started';
      case PlanStatus.inProgress:
        return 'in_progress';
      case PlanStatus.completed:
        return 'completed';
      case PlanStatus.abandoned:
        return 'abandoned';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plan_id': planId,
      'status': _statusToString(status),
      'current_day': currentDay,
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
