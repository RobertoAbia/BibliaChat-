import '../entities/plan.dart';
import '../entities/plan_day.dart';
import '../entities/user_plan.dart';
import '../entities/user_plan_day.dart';

/// Repository interface for study plans
abstract class StudyRepository {
  /// Get all available plans
  Future<List<Plan>> getAllPlans();

  /// Get a specific plan by ID
  Future<Plan?> getPlanById(String planId);

  /// Get all days for a plan
  Future<List<PlanDay>> getPlanDays(String planId);

  /// Get a specific plan day
  Future<PlanDay?> getPlanDay(String planDayId);

  /// Get user's active plan (if any)
  Future<UserPlan?> getActiveUserPlan(String userId);

  /// Get all user plans (active and completed)
  Future<List<UserPlan>> getUserPlans(String userId);

  /// Start a new plan for the user
  Future<UserPlan> startPlan(String userId, String planId);

  /// Mark a day as completed
  Future<void> completePlanDay(String userPlanId, int dayNumber, {String? userAnswer});

  /// Advance to next day in the plan
  Future<void> advanceToNextDay(String userPlanId, int nextDay, bool isLastDay);

  /// Get completed days for a user plan
  Future<List<UserPlanDay>> getCompletedDays(String userPlanId);

  /// Check if a specific day is completed
  Future<bool> isDayCompleted(String userPlanId, int dayNumber);

  /// Abandon a plan
  Future<void> abandonPlan(String userPlanId);
}
