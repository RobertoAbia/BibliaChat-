import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/daily_gospel_model.dart';

/// Datasource remoto para el Evangelio del día (Supabase)
class DailyGospelRemoteDatasource {
  final SupabaseClient _client;

  DailyGospelRemoteDatasource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Obtiene el evangelio para una fecha y versión específica
  Future<DailyGospelModel?> getGospelForDate(
    DateTime date,
    String bibleVersionCode,
  ) async {
    final dateStr = _formatDate(date);

    try {
      // Query con join implícito usando foreign key
      final response = await _client
          .from('daily_verse_texts')
          .select('''
            verse_date,
            bible_version_code,
            verse_text,
            daily_verses!inner (
              reference,
              context_notes
            )
          ''')
          .eq('verse_date', dateStr)
          .eq('bible_version_code', bibleVersionCode)
          .maybeSingle();

      if (response == null) {
        // Intentar con versión por defecto si no existe la solicitada
        if (bibleVersionCode != 'RVR1960') {
          return getGospelForDate(date, 'RVR1960');
        }
        return null;
      }

      // Extraer datos del join
      final dailyVerse = response['daily_verses'] as Map<String, dynamic>;

      return DailyGospelModel(
        date: date,
        reference: dailyVerse['reference'] as String? ?? '',
        text: response['verse_text'] as String? ?? '',
        bibleVersion: response['bible_version_code'] as String? ?? bibleVersionCode,
        contextNotes: dailyVerse['context_notes'] as String?,
      );
    } catch (e) {
      print('Error fetching daily gospel: $e');
      return null;
    }
  }

  /// Obtiene el evangelio de hoy
  Future<DailyGospelModel?> getTodaysGospel(String bibleVersionCode) {
    return getGospelForDate(DateTime.now(), bibleVersionCode);
  }

  /// Formatea fecha a YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
