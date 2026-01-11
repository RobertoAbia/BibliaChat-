/// Status of a study plan
enum PlanStatus {
  notStarted,
  inProgress,
  completed,
  abandoned,
}

/// Entity representing a user's enrollment in a study plan
class UserPlan {
  final String id;
  final String userId;
  final String planId;
  final PlanStatus status;
  final int currentDay;
  final DateTime startedAt;
  final DateTime? completedAt;

  const UserPlan({
    required this.id,
    required this.userId,
    required this.planId,
    required this.status,
    required this.currentDay,
    required this.startedAt,
    this.completedAt,
  });

  bool get isCompleted => status == PlanStatus.completed;
  bool get isInProgress => status == PlanStatus.inProgress;

  /// Progress percentage (0.0 to 1.0)
  double progressPercent(int totalDays) {
    if (totalDays == 0) return 0;
    return (currentDay - 1) / totalDays;
  }
}
