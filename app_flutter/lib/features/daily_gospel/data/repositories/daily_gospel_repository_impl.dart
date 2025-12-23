import '../../domain/entities/daily_gospel.dart';
import '../../domain/repositories/daily_gospel_repository.dart';
import '../datasources/daily_gospel_remote_datasource.dart';

/// Implementación del repositorio del Evangelio del día
class DailyGospelRepositoryImpl implements DailyGospelRepository {
  final DailyGospelRemoteDatasource _remoteDatasource;

  DailyGospelRepositoryImpl({DailyGospelRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? DailyGospelRemoteDatasource();

  @override
  Future<DailyGospel?> getTodaysGospel(String bibleVersionCode) async {
    final model = await _remoteDatasource.getTodaysGospel(bibleVersionCode);
    return model?.toEntity();
  }

  @override
  Future<DailyGospel?> getGospelForDate(
    DateTime date,
    String bibleVersionCode,
  ) async {
    final model = await _remoteDatasource.getGospelForDate(date, bibleVersionCode);
    return model?.toEntity();
  }
}
