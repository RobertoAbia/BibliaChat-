import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

/// Service that manages Bible verse widgets on Lock Screen (iOS) and Home Screen (Android).
///
/// Uses `home_widget` package to sync data between Flutter and native widgets.
/// Verses rotate every hour based on the current hour of the day.
class WidgetService {
  static const String _appGroupId = 'group.ee.bikain.bibliachat';
  static const String _iOSWidgetName = 'BibleVerseWidget';
  static const String _androidWidgetName = 'BibleVerseWidget';

  static const String _keyVerseText = 'verse_text';
  static const String _keyVerseRef = 'verse_ref';

  List<Map<String, String>>? _verses;

  /// Initialize the widget service. Call once at app startup.
  Future<void> init() async {
    HomeWidget.setAppGroupId(_appGroupId);
    await _loadVerses();
    await _syncVersesToAppGroup();
    await updateWidget();

    // Register callback for when widget is tapped
    HomeWidget.registerInteractivityCallback(widgetBackgroundCallback);
  }

  /// Sync the full verses JSON to App Group so the iOS widget can
  /// calculate verses independently without the app running.
  Future<void> _syncVersesToAppGroup() async {
    if (_verses == null) return;
    final jsonString = json.encode(_verses);
    await HomeWidget.saveWidgetData<String>('verses_json', jsonString);
  }

  /// Load verses from the bundled JSON asset.
  Future<void> _loadVerses() async {
    if (_verses != null) return;
    final jsonString =
        await rootBundle.loadString('assets/data/widget_verses.json');
    final List<dynamic> decoded = json.decode(jsonString);
    _verses = decoded
        .map((v) => {
              'ref': v['ref'] as String,
              'text': v['text'] as String,
            })
        .toList();
  }

  /// Get the verse for the current hour.
  ///
  /// Uses a deterministic shuffle (LCG) so the order is consistent
  /// within the same day (same hour = same verse).
  /// This algorithm is replicated in BibleVerseWidget.swift so the
  /// iOS widget can calculate verses independently without the app.
  Map<String, String> _getVerseForCurrentHour() {
    if (_verses == null || _verses!.isEmpty) {
      return {'ref': 'Salmos 23:1', 'text': 'El Señor es mi pastor; nada me falta.'};
    }

    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final hour = now.hour;

    final seed = dayOfYear * 1000 + now.year;
    final indices = _seededShuffle(_verses!.length, seed);

    // Pick verse based on hour (cycles through shuffled list)
    final index = indices[hour % indices.length];
    return _verses![index];
  }

  /// Deterministic Fisher-Yates shuffle using LCG.
  /// Must match the algorithm in BibleVerseWidget.swift exactly.
  static List<int> _seededShuffle(int count, int seed) {
    final indices = List<int>.generate(count, (i) => i);
    int state = seed.abs();

    for (int i = count - 1; i >= 1; i--) {
      // LCG: same constants as Swift version
      state = ((state * 6364136223846793005) + 1442695040888963407) & 0xFFFFFFFFFFFFFFFF;
      final j = (state >> 33) % (i + 1);
      final temp = indices[i];
      indices[i] = indices[j];
      indices[j] = temp;
    }

    return indices;
  }

  /// Update the widget with the current verse.
  Future<void> updateWidget() async {
    await _loadVerses();
    final verse = _getVerseForCurrentHour();

    await HomeWidget.saveWidgetData<String>(_keyVerseText, verse['text']);
    await HomeWidget.saveWidgetData<String>(_keyVerseRef, verse['ref']);

    // Request native widget update
    await HomeWidget.updateWidget(
      iOSName: _iOSWidgetName,
      androidName: _androidWidgetName,
    );
  }

  /// Get the current verse (for display in Flutter UI if needed).
  Future<Map<String, String>> getCurrentVerse() async {
    await _loadVerses();
    return _getVerseForCurrentHour();
  }
}

/// Background callback when widget is tapped (opens the app).
@pragma('vm:entry-point')
Future<void> widgetBackgroundCallback(Uri? uri) async {
  // When user taps the widget, the app opens.
  // No special handling needed — the app just opens to Home.
}
