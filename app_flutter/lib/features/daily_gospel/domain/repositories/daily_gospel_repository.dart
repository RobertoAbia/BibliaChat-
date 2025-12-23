import '../entities/daily_gospel.dart';

/// Interface del repositorio del Evangelio del día
abstract class DailyGospelRepository {
  /// Obtiene el evangelio de hoy para la versión de biblia especificada
  Future<DailyGospel?> getTodaysGospel(String bibleVersionCode);

  /// Obtiene el evangelio para una fecha específica
  Future<DailyGospel?> getGospelForDate(DateTime date, String bibleVersionCode);
}
