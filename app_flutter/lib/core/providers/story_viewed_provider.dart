import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/daily_gospel/presentation/providers/daily_gospel_provider.dart';
import '../../features/profile/presentation/providers/user_profile_provider.dart';
import '../services/story_viewed_service.dart';

/// Provider for the StoryViewedService instance
final storyViewedServiceProvider = Provider<StoryViewedService>(
  (ref) => StoryViewedService(),
);

/// Provider that returns the set of viewed slide indices for today's gospel.
/// Returns an empty set if gospel is not available, no user, or on error.
/// Each user has their own viewed slides (keyed by user ID + date).
final viewedSlidesProvider = FutureProvider<Set<int>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final gospelAsync = ref.watch(dailyGospelProvider);
  final service = ref.watch(storyViewedServiceProvider);

  if (userId == null) return <int>{};

  final gospel = gospelAsync.valueOrNull;
  if (gospel == null) {
    return <int>{};
  }

  return await service.getViewedSlides(userId, gospel.date);
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
