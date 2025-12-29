import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/daily_gospel/presentation/providers/daily_gospel_provider.dart';
import '../services/story_viewed_service.dart';

/// Provider for the StoryViewedService instance
final storyViewedServiceProvider = Provider<StoryViewedService>(
  (ref) => StoryViewedService(),
);

/// Provider that returns the set of viewed slide indices for today's gospel.
/// Returns an empty set if gospel is not available or on error.
final viewedSlidesProvider = FutureProvider<Set<int>>((ref) async {
  final gospelAsync = ref.watch(dailyGospelProvider);
  final service = ref.watch(storyViewedServiceProvider);

  final gospel = gospelAsync.valueOrNull;
  if (gospel == null) {
    return <int>{};
  }

  return await service.getViewedSlides(gospel.date);
});

/// Provider family to mark a specific slide as viewed.
/// Usage: ref.read(markSlideViewedProvider(slideIndex))
final markSlideViewedProvider = FutureProvider.family<void, int>((ref, slideIndex) async {
  final gospelAsync = ref.watch(dailyGospelProvider);
  final service = ref.watch(storyViewedServiceProvider);

  final gospel = gospelAsync.valueOrNull;
  if (gospel == null) return;

  await service.markSlideAsViewed(gospel.date, slideIndex);
});
