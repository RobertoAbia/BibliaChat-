import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/daily_gospel/presentation/providers/daily_gospel_provider.dart';
import '../../features/home/presentation/providers/daily_progress_provider.dart';
import '../../features/profile/presentation/providers/user_profile_provider.dart';
import '../services/story_viewed_service.dart';

/// Provider for the StoryViewedService instance
final storyViewedServiceProvider = Provider<StoryViewedService>(
  (ref) => StoryViewedService(),
);

/// All 3 slides viewed (used as fallback when Supabase says completed but local data is missing).
const Set<int> _allSlidesViewed = {0, 1, 2};

/// Provider that returns the set of viewed slide indices for today's gospel.
/// Returns an empty set if gospel is not available, no user, or on error.
/// Each user has their own viewed slides (keyed by user ID + date).
/// If SharedPreferences is empty but Supabase says today is completed, returns {0,1,2}.
final viewedSlidesProvider = FutureProvider<Set<int>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final gospelAsync = ref.watch(dailyGospelProvider);
  final service = ref.watch(storyViewedServiceProvider);

  if (userId == null) return <int>{};

  final gospel = gospelAsync.valueOrNull;
  if (gospel == null) {
    return <int>{};
  }

  // Clave = fecha de HOY, no gospel.date: si el cron falló y se sirve el
  // evangelio de ayer como fallback, gospel.date apuntaría al progreso de
  // ayer (100% instantáneo y completación de hoy con un solo slide).
  final today = DateTime.now();
  final localSlides = await service.getViewedSlides(userId, today);
  if (localSlides.isNotEmpty) return localSlides;

  // Fallback: if local is empty, check Supabase
  final isCompleted = await ref.read(isTodayCompletedProvider.future);
  return isCompleted ? _allSlidesViewed : localSlides;
});

/// Provider that returns viewed slides for a specific date (past days).
/// If SharedPreferences is empty but Supabase says the date is completed, returns {0,1,2}.
final viewedSlidesForDateProvider = FutureProvider.family<Set<int>, DateTime>((ref, date) async {
  final userId = ref.watch(currentUserIdProvider);
  final service = ref.watch(storyViewedServiceProvider);

  if (userId == null) return <int>{};

  final localSlides = await service.getViewedSlides(userId, date);
  if (localSlides.isNotEmpty) return localSlides;

  // Fallback: if local is empty, check Supabase
  final completedDates = await ref.read(weekCompletionProvider.future);
  final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  return completedDates.contains(dateStr) ? _allSlidesViewed : localSlides;
});

// NOTA: el marcado de slides vistos se hace directamente vía
// StoryViewedService desde home_screen (callback onSlideViewed), con la
// fecha del flujo como clave. No hay provider de escritura: tener la regla
// de la clave duplicada en dos sitios reintrodujo en su día el desajuste
// gospel.date vs hoy.
