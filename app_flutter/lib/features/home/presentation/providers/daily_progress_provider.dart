import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers/story_viewed_provider.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../../data/datasources/daily_activity_remote_datasource.dart';

/// Provider para el datasource de actividad diaria.
final dailyActivityDatasourceProvider = Provider<DailyActivityRemoteDatasource>(
  (ref) => DailyActivityRemoteDatasource(Supabase.instance.client),
);

/// Provider del progreso de hoy (0-100) basado en slides vistos.
/// 0 slides = 0%, 1 slide = 33%, 2 slides = 67%, 3 slides = 100%
final todayProgressProvider = Provider<int>((ref) {
  final viewedSlidesAsync = ref.watch(viewedSlidesProvider);
  final viewedSlides = viewedSlidesAsync.valueOrNull ?? <int>{};
  return (viewedSlides.length / 3 * 100).round();
});

/// Provider de la racha actual (días consecutivos completados) desde Supabase.
final streakDaysProvider = FutureProvider<int>((ref) async {
  ref.watch(currentUserIdProvider); // Invalidar al cambiar usuario
  final datasource = ref.watch(dailyActivityDatasourceProvider);
  return await datasource.getStreakDays();
});

/// Provider de estado mutable para la racha (permite updates optimistas).
/// Cuando es null, se usa el valor de Supabase.
final streakDaysStateProvider = StateProvider<int?>((ref) => null);

/// Provider combinado: usa el estado optimista si existe, sino el de Supabase.
/// Este es el que debe usar la UI para mostrar la racha.
final streakDaysDisplayProvider = Provider<int>((ref) {
  final optimisticStreak = ref.watch(streakDaysStateProvider);
  if (optimisticStreak != null) return optimisticStreak;

  final asyncStreak = ref.watch(streakDaysProvider);
  return asyncStreak.valueOrNull ?? 0;
});

/// Provider para verificar si hoy ya está completado.
final isTodayCompletedProvider = FutureProvider<bool>((ref) async {
  ref.watch(currentUserIdProvider); // Invalidar al cambiar usuario
  final datasource = ref.watch(dailyActivityDatasourceProvider);
  return await datasource.isTodayCompleted();
});

/// Función para marcar el día como completado cuando progreso = 100%.
/// Retorna true si se marcó exitosamente (primera vez), false si ya estaba completado.
/// Usa Optimistic UI para actualizar la racha instantáneamente.
Future<bool> markDayAsCompleted(WidgetRef ref) async {
  // Verificar primero si ya está completado
  final isAlreadyCompleted = await ref.read(isTodayCompletedProvider.future);
  if (isAlreadyCompleted) return false;

  // OPTIMISTIC UPDATE: Incrementar racha inmediatamente en la UI
  final currentStreak = ref.read(streakDaysDisplayProvider);
  ref.read(streakDaysStateProvider.notifier).state = currentStreak + 1;

  // Marcar como completado en Supabase (en background)
  final datasource = ref.read(dailyActivityDatasourceProvider);
  await datasource.markDayCompleted('stories');

  // Refrescar desde Supabase
  ref.invalidate(streakDaysProvider);
  ref.invalidate(isTodayCompletedProvider);

  // Esperar a que streakDaysProvider termine de cargar antes de limpiar estado optimista
  // Esto evita la race condition donde el timeout fijo de 500ms no era suficiente
  final newStreak = await ref.read(streakDaysProvider.future);
  ref.read(streakDaysStateProvider.notifier).state = null;

  // Enviar notificación especial al completar primera semana
  if (newStreak == 7) {
    _sendWeekCompletedNotification();
  }

  return true;
}

/// Envía notificación push celebrando la primera semana completada
Future<void> _sendWeekCompletedNotification() async {
  try {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase.functions.invoke('send-notification', body: {
      'user_id': userId,
      'title': '🎉 ¡Una semana seguida!',
      'body': 'Felicidades, has mantenido tu racha durante 7 días',
      'data': {'screen': 'home'},
    });

    debugPrint('Week completed notification sent');
  } catch (e) {
    debugPrint('Error sending week completed notification: $e');
  }
}
