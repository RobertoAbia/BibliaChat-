import 'dart:convert';
import 'dart:math';

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
    await updateWidget();

    // Register callback for when widget is tapped
    HomeWidget.registerInteractivityCallback(widgetBackgroundCallback);
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
  /// Uses a daily shuffle so the order feels random but is consistent
  /// within the same day (same hour = same verse).
  Map<String, String> _getVerseForCurrentHour() {
    if (_verses == null || _verses!.isEmpty) {
      return {'ref': 'Salmos 23:1', 'text': 'El Señor es mi pastor; nada me falta.'};
    }

    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final hour = now.hour;

    // Use day as seed for consistent daily shuffle
    final random = Random(dayOfYear * 1000 + now.year);
    final indices = List<int>.generate(_verses!.length, (i) => i);
    indices.shuffle(random);

    // Pick verse based on hour (cycles through shuffled list)
    final index = indices[hour % indices.length];
    return _verses![index];
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
