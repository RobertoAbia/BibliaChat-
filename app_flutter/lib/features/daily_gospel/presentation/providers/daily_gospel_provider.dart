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
/// Usa ref.read (no watch) para el perfil: evita re-fetch cuando el perfil
/// pasa de loading→data (causaba parpadeo del gospel card).
final dailyGospelProvider = FutureProvider<DailyGospel?>((ref) async {
  final repository = ref.watch(dailyGospelRepositoryProvider);

  // Esperar perfil sin observarlo (la versión de biblia no cambia mid-session)
  String bibleVersion = 'RVR1960';
  try {
    final profile = await ref.read(currentUserProfileProvider.future);
    bibleVersion = profile?.bibleVersionCode ?? 'RVR1960';
  } catch (_) {}

  return await repository.getTodaysGospel(bibleVersion);
});

/// Provider para evangelio de una fecha específica
final gospelForDateProvider =
    FutureProvider.family<DailyGospel?, DateTime>((ref, date) async {
  final repository = ref.watch(dailyGospelRepositoryProvider);

  String bibleVersion = 'RVR1960';
  try {
    final profile = await ref.read(currentUserProfileProvider.future);
    bibleVersion = profile?.bibleVersionCode ?? 'RVR1960';
  } catch (_) {}

  return await repository.getGospelForDate(date, bibleVersion);
});
