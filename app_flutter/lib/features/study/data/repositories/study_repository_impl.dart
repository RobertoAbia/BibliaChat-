import '../../domain/entities/plan.dart';
import '../../domain/entities/plan_day.dart';
import '../../domain/entities/user_plan.dart';
import '../../domain/entities/user_plan_day.dart';
import '../../domain/repositories/study_repository.dart';
import '../datasources/study_remote_datasource.dart';

/// Implementation of StudyRepository
class StudyRepositoryImpl implements StudyRepository {
  final StudyRemoteDatasource _datasource;

  StudyRepositoryImpl(this._datasource);

  @override
  Future<List<Plan>> getAllPlans() async {
    return await _datasource.getAllPlans();
  }

  @override
  Future<Plan?> getPlanById(String planId) async {
    return await _datasource.getPlanById(planId);
  }

  @override
  Future<List<PlanDay>> getPlanDays(String planId) async {
    return await _datasource.getPlanDays(planId);
  }

  @override
  Future<PlanDay?> getPlanDay(String planDayId) async {
    return await _datasource.getPlanDay(planDayId);
  }

  @override
  Future<UserPlan?> getActiveUserPlan(String userId) async {
    return await _datasource.getActiveUserPlan(userId);
  }

  @override
  Future<List<UserPlan>> getUserPlans(String userId) async {
    return await _datasource.getUserPlans(userId);
  }

  @override
  Future<UserPlan> startPlan(String userId, String planId) async {
    return await _datasource.startPlan(userId, planId);
  }

  @override
  Future<void> completePlanDay(String userPlanId, int dayNumber, {String? userAnswer}) async {
    await _datasource.completePlanDay(userPlanId, dayNumber, userAnswer: userAnswer);
  }

  @override
  Future<void> advanceToNextDay(String userPlanId, int nextDay, bool isLastDay) async {
    await _datasource.advanceToNextDay(userPlanId, nextDay, isLastDay);
  }

  @override
  Future<List<UserPlanDay>> getCompletedDays(String userPlanId) async {
    return await _datasource.getCompletedDays(userPlanId);
  }

  @override
  Future<bool> isDayCompleted(String userPlanId, int dayNumber) async {
    return await _datasource.isDayCompleted(userPlanId, dayNumber);
  }

  @override
  Future<void> abandonPlan(String userPlanId) async {
    await _datasource.abandonPlan(userPlanId);
  }
}
