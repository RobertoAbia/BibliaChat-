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

  final localSlides = await service.getViewedSlides(userId, gospel.date);
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

/// Provider family to mark a specific slide as viewed.
/// Usage: ref.read(markSlideViewedProvider(slideIndex))
final markSlideViewedProvider = FutureProvider.family<void, int>((ref, slideIndex) async {
  final userId = ref.watch(currentUserIdProvider);
  final gospelAsync = ref.watch(dailyGospelProvider);
  final service = ref.watch(storyViewedServiceProvider);

  if (userId == null) return;

  final gospel = gospelAsync.valueOrNull;
  if (gospel == null) return;

  await service.markSlideAsViewed(userId, gospel.date, slideIndex);
});
