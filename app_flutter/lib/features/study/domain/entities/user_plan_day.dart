/// Entity representing a user's completion of a specific plan day
class UserPlanDay {
  final String id;
  final String userPlanId;
  final int dayNumber;
  final String? userAnswer;
  final String? completedVia;
  final DateTime completedAt;

  const UserPlanDay({
    required this.id,
    required this.userPlanId,
    required this.dayNumber,
    this.userAnswer,
    this.completedVia,
    required this.completedAt,
  });
}
