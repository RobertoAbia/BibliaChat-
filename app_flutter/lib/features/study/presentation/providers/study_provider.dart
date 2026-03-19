import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/analytics_service.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../../data/datasources/study_remote_datasource.dart';
import '../../data/repositories/study_repository_impl.dart';
import '../../domain/entities/plan.dart';
import '../../domain/entities/plan_day.dart';
import '../../domain/entities/user_plan.dart';
import '../../domain/entities/user_plan_day.dart';
import '../../domain/repositories/study_repository.dart';

// ============================================================================
// Datasource & Repository Providers
// ============================================================================

final studyDatasourceProvider = Provider<StudyRemoteDatasource>((ref) {
  return StudyRemoteDatasource(Supabase.instance.client);
});

final studyRepositoryProvider = Provider<StudyRepository>((ref) {
  return StudyRepositoryImpl(ref.watch(studyDatasourceProvider));
});

// ============================================================================
// All Plans Provider
// ============================================================================

final allPlansProvider = FutureProvider<List<Plan>>((ref) async {
  final repository = ref.watch(studyRepositoryProvider);
  return await repository.getAllPlans();
});

// ============================================================================
// All User Plans Provider (for checking completed status)
// ============================================================================

/// Refresh trigger for user plans
final userPlansRefreshProvider = StateProvider<int>((ref) => 0);

/// Get all user plans (to check completed/abandoned status)
final allUserPlansProvider = FutureProvider<List<UserPlan>>((ref) async {
  ref.watch(userPlansRefreshProvider);
  ref.watch(currentUserIdProvider); // Invalidar al cambiar usuario

  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return [];

  final datasource = ref.watch(studyDatasourceProvider);
  return await datasource.getUserPlans(user.id);
});

// ============================================================================
// Active User Plan Provider
// ============================================================================

/// Refresh trigger for active plan
final activePlanRefreshProvider = StateProvider<int>((ref) => 0);

final activeUserPlanProvider = FutureProvider<UserPlan?>((ref) async {
  ref.watch(activePlanRefreshProvider);
  ref.watch(currentUserIdProvider); // Invalidar al cambiar usuario

  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return null;

  final repository = ref.watch(studyRepositoryProvider);
  return await repository.getActiveUserPlan(user.id);
});

// ============================================================================
// Active Plan Details Provider (combines UserPlan + Plan info)
// ============================================================================

/// Combined data for the active plan with full plan details
class ActivePlanData {
  final UserPlan userPlan;
  final Plan plan;
  final PlanDay currentPlanDay;
  final int completedDays;
  final bool isLockedForToday;

  ActivePlanData({
    required this.userPlan,
    required this.plan,
    required this.currentPlanDay,
    required this.completedDays,
    this.isLockedForToday = false,
  });

  double get progressPercent {
    if (plan.daysTotal == 0) return 0;
    return completedDays / plan.daysTotal;
  }
}

final activePlanDataProvider = FutureProvider<ActivePlanData?>((ref) async {
  final userPlan = await ref.watch(activeUserPlanProvider.future);
  if (userPlan == null) return null;

  final repository = ref.watch(studyRepositoryProvider);
  final datasource = ref.watch(studyDatasourceProvider);

  // Ejecutar las 4 queries en paralelo (son independientes entre sí)
  final results = await Future.wait([
    repository.getPlanById(userPlan.planId),
    datasource.getPlanDayByNumber(userPlan.planId, userPlan.currentDay),
    repository.getCompletedDays(userPlan.id),
    datasource.getLastCompletedDate(userPlan.id),
  ]);

  final plan = results[0] as Plan?;
  final currentDay = results[1] as PlanDay?;
  final completedDays = results[2] as List<UserPlanDay>;
  final lastCompleted = results[3] as DateTime?;

  if (plan == null || currentDay == null) return null;

  // Lock if last completed day was today (and not day 1 of a fresh plan)
  bool isLocked = false;
  if (lastCompleted != null && userPlan.currentDay > 1) {
    final now = DateTime.now();
    isLocked = lastCompleted.year == now.year &&
        lastCompleted.month == now.month &&
        lastCompleted.day == now.day;
  }

  return ActivePlanData(
    userPlan: userPlan,
    plan: plan,
    currentPlanDay: currentDay,
    completedDays: completedDays.length,
    isLockedForToday: isLocked,
  );
});

// ============================================================================
// Plan Days Provider (family by planId)
// ============================================================================

final planDaysProvider = FutureProvider.family<List<PlanDay>, String>((ref, planId) async {
  final repository = ref.watch(studyRepositoryProvider);
  return await repository.getPlanDays(planId);
});

// ============================================================================
// Plan Detail Provider (family by planId)
// ============================================================================

final planDetailProvider = FutureProvider.family<Plan?, String>((ref, planId) async {
  final repository = ref.watch(studyRepositoryProvider);
  return await repository.getPlanById(planId);
});

// ============================================================================
// Study Actions Notifier
// ============================================================================

class StudyActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final StudyRepository _repository;
  final StudyRemoteDatasource _datasource;
  final Ref _ref;

  StudyActionsNotifier(this._repository, this._datasource, this._ref)
      : super(const AsyncValue.data(null));

  /// Start a new plan - returns the UserPlan if successful, null if failed
  Future<UserPlan?> startPlan(String planId, {String? planName}) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;

    state = const AsyncValue.loading();

    try {
      // Check if user already has an active plan
      final existingPlan = await _repository.getActiveUserPlan(user.id);
      if (existingPlan != null) {
        state = AsyncValue.error('Ya tienes un plan activo', StackTrace.current);
        return null;
      }

      final userPlan = await _repository.startPlan(user.id, planId);
      _ref.read(activePlanRefreshProvider.notifier).state++;
      state = const AsyncValue.data(null);

      // Log analytics event
      AnalyticsService().logPlanStarted(
        planId: planId,
        planName: planName ?? planId,
      );

      return userPlan;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Complete current day and advance
  Future<bool> completeDay(String userPlanId, int currentDay, int totalDays, {String? planId}) async {
    state = const AsyncValue.loading();

    try {
      // Mark day as completed
      await _repository.completePlanDay(userPlanId, currentDay);

      // Advance to next day or complete plan
      final isLastDay = currentDay >= totalDays;
      await _datasource.advanceToNextDay(userPlanId, currentDay + 1, isLastDay);

      _ref.read(activePlanRefreshProvider.notifier).state++;
      _ref.read(userPlansRefreshProvider.notifier).state++;
      state = const AsyncValue.data(null);

      // Log analytics events
      AnalyticsService().logPlanDayCompleted(
        planId: planId ?? userPlanId,
        dayNumber: currentDay,
      );
      if (isLastDay) {
        AnalyticsService().logPlanCompleted(planId: planId ?? userPlanId);
      }

      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Abandon current plan
  Future<bool> abandonPlan(String userPlanId, {String? planId, int? dayNumber}) async {
    state = const AsyncValue.loading();

    try {
      await _repository.abandonPlan(userPlanId);
      _ref.read(activePlanRefreshProvider.notifier).state++;
      state = const AsyncValue.data(null);

      // Log analytics event
      AnalyticsService().logPlanAbandoned(
        planId: planId ?? userPlanId,
        dayNumber: dayNumber ?? 0,
      );

      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final studyActionsProvider = StateNotifierProvider<StudyActionsNotifier, AsyncValue<void>>((ref) {
  return StudyActionsNotifier(
    ref.watch(studyRepositoryProvider),
    ref.watch(studyDatasourceProvider),
    ref,
  );
});
