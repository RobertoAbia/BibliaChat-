import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/plan_model.dart';
import '../models/plan_day_model.dart';
import '../models/user_plan_model.dart';
import '../models/user_plan_day_model.dart';

/// Remote datasource for study plans using Supabase
class StudyRemoteDatasource {
  final SupabaseClient _supabase;

  StudyRemoteDatasource(this._supabase);

  /// Get all available plans
  Future<List<PlanModel>> getAllPlans() async {
    final response = await _supabase
        .from('plans')
        .select()
        .eq('is_active', true)
        .order('sort_order', ascending: true);

    return (response as List)
        .map((json) => PlanModel.fromJson(json))
        .toList();
  }

  /// Get a specific plan by ID
  Future<PlanModel?> getPlanById(String planId) async {
    final response = await _supabase
        .from('plans')
        .select()
        .eq('id', planId)
        .maybeSingle();

    if (response == null) return null;
    return PlanModel.fromJson(response);
  }

  /// Get all days for a plan, ordered by day number
  Future<List<PlanDayModel>> getPlanDays(String planId) async {
    final response = await _supabase
        .from('plan_days')
        .select()
        .eq('plan_id', planId)
        .order('day_number', ascending: true);

    return (response as List)
        .map((json) => PlanDayModel.fromJson(json))
        .toList();
  }

  /// Get a specific plan day
  Future<PlanDayModel?> getPlanDay(String planDayId) async {
    final response = await _supabase
        .from('plan_days')
        .select()
        .eq('id', planDayId)
        .maybeSingle();

    if (response == null) return null;
    return PlanDayModel.fromJson(response);
  }

  /// Get user's active (in_progress) plan
  Future<UserPlanModel?> getActiveUserPlan(String userId) async {
    final response = await _supabase
        .from('user_plans')
        .select()
        .eq('user_id', userId)
        .eq('status', 'in_progress')
        .order('started_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return UserPlanModel.fromJson(response);
  }

  /// Get all user plans
  Future<List<UserPlanModel>> getUserPlans(String userId) async {
    final response = await _supabase
        .from('user_plans')
        .select()
        .eq('user_id', userId)
        .order('started_at', ascending: false);

    return (response as List)
        .map((json) => UserPlanModel.fromJson(json))
        .toList();
  }

  /// Start a new plan for the user (or restart an abandoned/completed one)
  Future<UserPlanModel> startPlan(String userId, String planId) async {
    // Check if user already has a record for this plan (abandoned or completed)
    final existing = await _supabase
        .from('user_plans')
        .select()
        .eq('user_id', userId)
        .eq('plan_id', planId)
        .maybeSingle();

    if (existing != null) {
      // Reactivate existing plan - reset to day 1
      final response = await _supabase
          .from('user_plans')
          .update({
            'status': 'in_progress',
            'current_day': 1,
            'started_at': DateTime.now().toIso8601String(),
            'completed_at': null,
          })
          .eq('id', existing['id'])
          .select()
          .single();

      return UserPlanModel.fromJson(response);
    } else {
      // Create new plan record
      final response = await _supabase
          .from('user_plans')
          .insert({
            'user_id': userId,
            'plan_id': planId,
            'status': 'in_progress',
            'current_day': 1,
          })
          .select()
          .single();

      return UserPlanModel.fromJson(response);
    }
  }

  /// Mark a day as completed (insert into user_plan_days)
  Future<void> completePlanDay(String userPlanId, int dayNumber, {String? userAnswer}) async {
    // Check if already exists
    final existing = await _supabase
        .from('user_plan_days')
        .select()
        .eq('user_plan_id', userPlanId)
        .eq('day_number', dayNumber)
        .maybeSingle();

    if (existing != null) {
      // Update existing
      await _supabase
          .from('user_plan_days')
          .update({
            'user_answer': userAnswer,
            'completed_via': 'answer',
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', existing['id']);
    } else {
      // Insert new
      await _supabase.from('user_plan_days').insert({
        'user_plan_id': userPlanId,
        'day_number': dayNumber,
        'user_answer': userAnswer,
        'completed_via': 'answer',
      });
    }
  }

  /// Advance to next day in the plan
  Future<void> advanceToNextDay(String userPlanId, int nextDay, bool isLastDay) async {
    if (isLastDay) {
      // Mark plan as completed
      await _supabase
          .from('user_plans')
          .update({
            'status': 'completed',
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userPlanId);
    } else {
      // Just advance to next day
      await _supabase
          .from('user_plans')
          .update({'current_day': nextDay})
          .eq('id', userPlanId);
    }
  }

  /// Get completed days for a user plan
  Future<List<UserPlanDayModel>> getCompletedDays(String userPlanId) async {
    final response = await _supabase
        .from('user_plan_days')
        .select()
        .eq('user_plan_id', userPlanId);

    return (response as List)
        .map((json) => UserPlanDayModel.fromJson(json))
        .toList();
  }

  /// Check if a specific day is completed
  Future<bool> isDayCompleted(String userPlanId, int dayNumber) async {
    final response = await _supabase
        .from('user_plan_days')
        .select()
        .eq('user_plan_id', userPlanId)
        .eq('day_number', dayNumber)
        .maybeSingle();

    return response != null;
  }

  /// Abandon a user plan
  Future<void> abandonPlan(String userPlanId) async {
    await _supabase
        .from('user_plans')
        .update({'status': 'abandoned'})
        .eq('id', userPlanId);
  }

  /// Get plan day by plan_id and day_number
  Future<PlanDayModel?> getPlanDayByNumber(String planId, int dayNumber) async {
    final response = await _supabase
        .from('plan_days')
        .select()
        .eq('plan_id', planId)
        .eq('day_number', dayNumber)
        .maybeSingle();

    if (response == null) return null;
    return PlanDayModel.fromJson(response);
  }
}
