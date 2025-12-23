import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../../data/datasources/daily_gospel_remote_datasource.dart';
import '../../data/repositories/daily_gospel_repository_impl.dart';
import '../../domain/entities/daily_gospel.dart';
import '../../domain/repositories/daily_gospel_repository.dart';

/// Provider para el datasource remoto
final dailyGospelDatasourceProvider = Provider<DailyGospelRemoteDatasource>(
  (ref) => DailyGospelRemoteDatasource(),
);

/// Provider para el repositorio
final dailyGospelRepositoryProvider = Provider<DailyGospelRepository>(
  (ref) => DailyGospelRepositoryImpl(
    remoteDatasource: ref.watch(dailyGospelDatasourceProvider),
  ),
);

/// Provider para el Evangelio del día
/// Automáticamente usa la versión de biblia preferida del usuario
final dailyGospelProvider = FutureProvider<DailyGospel?>((ref) async {
  final repository = ref.watch(dailyGospelRepositoryProvider);

  // Obtener la versión de biblia del perfil del usuario
  final profileAsync = ref.watch(currentUserProfileProvider);

  final bibleVersion = profileAsync.when(
    data: (profile) => profile?.bibleVersionCode ?? 'RVR1960',
    loading: () => 'RVR1960',
    error: (_, __) => 'RVR1960',
  );

  return await repository.getTodaysGospel(bibleVersion);
});

/// Provider para evangelio de una fecha específica
final gospelForDateProvider =
    FutureProvider.family<DailyGospel?, DateTime>((ref, date) async {
  final repository = ref.watch(dailyGospelRepositoryProvider);

  final profileAsync = ref.watch(currentUserProfileProvider);
  final bibleVersion = profileAsync.when(
    data: (profile) => profile?.bibleVersionCode ?? 'RVR1960',
    loading: () => 'RVR1960',
    error: (_, __) => 'RVR1960',
  );

  return await repository.getGospelForDate(date, bibleVersion);
});
