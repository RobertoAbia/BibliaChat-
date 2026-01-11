import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/study_remote_datasource.dart';
import '../../data/repositories/study_repository_impl.dart';
import '../../domain/entities/plan.dart';
import '../../domain/entities/plan_day.dart';
import '../../domain/entities/user_plan.dart';
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
// Active User Plan Provider
// ============================================================================

/// Refresh trigger for active plan
final activePlanRefreshProvider = StateProvider<int>((ref) => 0);

final activeUserPlanProvider = FutureProvider<UserPlan?>((ref) async {
  ref.watch(activePlanRefreshProvider);

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

  ActivePlanData({
    required this.userPlan,
    required this.plan,
    required this.currentPlanDay,
    required this.completedDays,
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

  final plan = await repository.getPlanById(userPlan.planId);
  if (plan == null) return null;

  final currentDay = await datasource.getPlanDayByNumber(
    userPlan.planId,
    userPlan.currentDay,
  );
  if (currentDay == null) return null;

  final completedDays = await repository.getCompletedDays(userPlan.id);

  return ActivePlanData(
    userPlan: userPlan,
    plan: plan,
    currentPlanDay: currentDay,
    completedDays: completedDays.length,
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

  /// Start a new plan
  Future<bool> startPlan(String planId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return false;

    state = const AsyncValue.loading();

    try {
      // Check if user already has an active plan
      final existingPlan = await _repository.getActiveUserPlan(user.id);
      if (existingPlan != null) {
        state = AsyncValue.error('Ya tienes un plan activo', StackTrace.current);
        return false;
      }

      await _repository.startPlan(user.id, planId);
      _ref.read(activePlanRefreshProvider.notifier).state++;
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Complete current day and advance
  Future<bool> completeDay(String userPlanId, int currentDay, int totalDays) async {
    state = const AsyncValue.loading();

    try {
      // Mark day as completed
      await _repository.completePlanDay(userPlanId, currentDay);

      // Advance to next day or complete plan
      final isLastDay = currentDay >= totalDays;
      await _datasource.advanceToNextDay(userPlanId, currentDay + 1, isLastDay);

      _ref.read(activePlanRefreshProvider.notifier).state++;
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Abandon current plan
  Future<bool> abandonPlan(String userPlanId) async {
    state = const AsyncValue.loading();

    try {
      await _repository.abandonPlan(userPlanId);
      _ref.read(activePlanRefreshProvider.notifier).state++;
      state = const AsyncValue.data(null);
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
