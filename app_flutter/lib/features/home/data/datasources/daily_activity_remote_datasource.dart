import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Datasource para interactuar con la tabla daily_activity en Supabase.
/// Maneja el registro de actividad diaria y el cálculo de racha.
class DailyActivityRemoteDatasource {
  final SupabaseClient _client;

  DailyActivityRemoteDatasource(this._client);

  /// Marcar el día actual como completado.
  /// Usa upsert para evitar duplicados si el usuario ya completó hoy.
  Future<void> markDayCompleted(String source) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      debugPrint('markDayCompleted: No user logged in');
      return;
    }

    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    debugPrint('markDayCompleted: userId=$userId, date=$todayStr, source=$source');

    try {
      await _client.from('daily_activity').upsert({
        'user_id': userId,
        'activity_date': todayStr,
        'completed': true,
        'source': source,
      });
      debugPrint('markDayCompleted: Success!');
    } catch (e) {
      debugPrint('markDayCompleted: Error - $e');
      rethrow;
    }
  }

  /// Obtener racha actual (días consecutivos completados).
  /// Cuenta hacia atrás desde hoy/ayer buscando días consecutivos.
  Future<int> getStreakDays() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      debugPrint('getStreakDays: No user logged in');
      return 0;
    }

    try {
      // Obtener los últimos 100 días de actividad completada, ordenados DESC
      final response = await _client
          .from('daily_activity')
          .select('activity_date')
          .eq('user_id', userId)
          .eq('completed', true)
          .order('activity_date', ascending: false)
          .limit(100);

      debugPrint('getStreakDays: Found ${response.length} completed days');

      if (response.isEmpty) return 0;

      // Convertir a Set de strings de fecha para búsqueda O(1)
      final completedDates = <String>{};
      for (final row in response) {
        completedDates.add(row['activity_date'] as String);
      }
      debugPrint('getStreakDays: Completed dates = $completedDates');

      // Obtener fecha de hoy en formato string
      final now = DateTime.now();
      final todayStr = _dateToString(now);

      // Verificar si hoy está completado
      final hasTodayCompleted = completedDates.contains(todayStr);
      debugPrint('getStreakDays: Today ($todayStr) completed = $hasTodayCompleted');

      // Empezar a contar desde hoy si está completado, o desde ayer si no
      DateTime checkDate;
      int streak = 0;

      if (hasTodayCompleted) {
        streak = 1;
        checkDate = now.subtract(const Duration(days: 1));
      } else {
        checkDate = now.subtract(const Duration(days: 1));
      }

      // Contar días consecutivos hacia atrás
      while (completedDates.contains(_dateToString(checkDate))) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }

      debugPrint('getStreakDays: Final streak = $streak');
      return streak;
    } catch (e) {
      debugPrint('getStreakDays: Error - $e');
      return 0;
    }
  }

  /// Verificar si hoy ya está marcado como completado.
  Future<bool> isTodayCompleted() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    final todayStr = DateTime.now().toIso8601String().split('T')[0];

    final response = await _client
        .from('daily_activity')
        .select('completed')
        .eq('user_id', userId)
        .eq('activity_date', todayStr)
        .maybeSingle();

    return response?['completed'] == true;
  }

  /// Obtener fechas completadas en un rango (para calendario semanal).
  /// Retorna Set<String> de fechas YYYY-MM-DD que tienen completed=true.
  Future<Set<String>> getCompletedDatesInRange(DateTime start, DateTime end) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return <String>{};

    final startStr = _dateToString(start);
    final endStr = _dateToString(end);

    try {
      final response = await _client
          .from('daily_activity')
          .select('activity_date')
          .eq('user_id', userId)
          .eq('completed', true)
          .gte('activity_date', startStr)
          .lte('activity_date', endStr);

      return response
          .map<String>((row) => row['activity_date'] as String)
          .toSet();
    } catch (e) {
      debugPrint('getCompletedDatesInRange: Error - $e');
      return <String>{};
    }
  }

  /// Marcar una fecha específica como completada (para días pasados).
  /// Usa upsert para evitar duplicados.
  Future<void> markDateCompleted(DateTime date, String source) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    final dateStr = _dateToString(date);

    try {
      await _client.from('daily_activity').upsert({
        'user_id': userId,
        'activity_date': dateStr,
        'completed': true,
        'source': source,
      });
      debugPrint('markDateCompleted: $dateStr marked as completed');
    } catch (e) {
      debugPrint('markDateCompleted: Error - $e');
      rethrow;
    }
  }

  /// Convierte DateTime a string formato YYYY-MM-DD.
  String _dateToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
