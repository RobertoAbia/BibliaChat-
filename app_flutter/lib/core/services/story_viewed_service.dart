import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// Service to track which story slides the user has viewed.
/// The state is tied to the gospel date, so it resets when new content is available.
class StoryViewedService {
  static const _keyPrefix = 'story_viewed_';

  // Lock para evitar race conditions cuando múltiples slides se marcan rápidamente
  Completer<void>? _lock;

  /// Get the set of slide indices that have been viewed for the given gospel date.
  Future<Set<int>> getViewedSlides(DateTime gospelDate) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _buildKey(gospelDate);
    final stored = prefs.getString(key);

    if (stored == null || stored.isEmpty) {
      return <int>{};
    }

    return stored
        .split(',')
        .map((s) => int.tryParse(s))
        .whereType<int>()
        .toSet();
  }

  /// Mark a slide as viewed for the given gospel date.
  /// Uses a lock to prevent race conditions when multiple slides are marked quickly.
  Future<void> markSlideAsViewed(DateTime gospelDate, int slideIndex) async {
    // Esperar si hay otra escritura en progreso
    while (_lock != null) {
      await _lock!.future;
    }

    // Crear lock
    _lock = Completer<void>();

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _buildKey(gospelDate);

      final viewedSlides = await getViewedSlides(gospelDate);
      viewedSlides.add(slideIndex);

      await prefs.setString(key, viewedSlides.join(','));
    } finally {
      // Liberar lock
      final currentLock = _lock;
      _lock = null;
      currentLock?.complete();
    }
  }

  /// Mark multiple slides as viewed at once.
  Future<void> markSlidesAsViewed(DateTime gospelDate, Set<int> slideIndices) async {
    // Esperar si hay otra escritura en progreso
    while (_lock != null) {
      await _lock!.future;
    }

    _lock = Completer<void>();

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _buildKey(gospelDate);

      final viewedSlides = await getViewedSlides(gospelDate);
      viewedSlides.addAll(slideIndices);

      await prefs.setString(key, viewedSlides.join(','));
    } finally {
      final currentLock = _lock;
      _lock = null;
      currentLock?.complete();
    }
  }

  /// Build the SharedPreferences key from the gospel date.
  /// Format: "story_viewed_2025-12-29"
  String _buildKey(DateTime date) {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '$_keyPrefix$dateStr';
  }
}
