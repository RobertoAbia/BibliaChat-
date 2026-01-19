import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// Service to track which story slides the user has viewed.
/// The state is tied to both the user ID and gospel date, so each user has their own progress.
class StoryViewedService {
  static const _keyPrefix = 'story_viewed_';

  // Lock para evitar race conditions cuando múltiples slides se marcan rápidamente
  Completer<void>? _lock;

  /// Get the set of slide indices that have been viewed for the given user and gospel date.
  Future<Set<int>> getViewedSlides(String? userId, DateTime gospelDate) async {
    if (userId == null) return <int>{};

    final prefs = await SharedPreferences.getInstance();
    final key = _buildKey(userId, gospelDate);
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

  /// Mark a slide as viewed for the given user and gospel date.
  /// Uses a lock to prevent race conditions when multiple slides are marked quickly.
  Future<void> markSlideAsViewed(String? userId, DateTime gospelDate, int slideIndex) async {
    if (userId == null) return;

    // Esperar si hay otra escritura en progreso
    while (_lock != null) {
      await _lock!.future;
    }

    // Crear lock
    _lock = Completer<void>();

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _buildKey(userId, gospelDate);

      final viewedSlides = await getViewedSlides(userId, gospelDate);
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
  Future<void> markSlidesAsViewed(String? userId, DateTime gospelDate, Set<int> slideIndices) async {
    if (userId == null) return;

    // Esperar si hay otra escritura en progreso
    while (_lock != null) {
      await _lock!.future;
    }

    _lock = Completer<void>();

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _buildKey(userId, gospelDate);

      final viewedSlides = await getViewedSlides(userId, gospelDate);
      viewedSlides.addAll(slideIndices);

      await prefs.setString(key, viewedSlides.join(','));
    } finally {
      final currentLock = _lock;
      _lock = null;
      currentLock?.complete();
    }
  }

  /// Build the SharedPreferences key from user ID and gospel date.
  /// Format: "story_viewed_userId_2025-12-29"
  String _buildKey(String userId, DateTime date) {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '$_keyPrefix${userId}_$dateStr';
  }
}
