import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio para gestionar el límite de mensajes diarios para usuarios free.
/// Los usuarios premium no tienen límite.
class MessageLimitService {
  static const int freeDailyLimit = 5;

  final SupabaseClient _client;

  MessageLimitService(this._client);

  /// Obtiene los mensajes enviados hoy por el usuario.
  Future<int> getMessagesSentToday() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      debugPrint('MessageLimitService: No user logged in');
      return 0;
    }

    final todayStr = _getTodayString();

    try {
      final response = await _client
          .from('daily_activity')
          .select('messages_sent')
          .eq('user_id', userId)
          .eq('activity_date', todayStr)
          .maybeSingle();

      final messagesSent = response?['messages_sent'] as int? ?? 0;
      debugPrint('MessageLimitService: Messages sent today = $messagesSent');
      return messagesSent;
    } catch (e) {
      debugPrint('MessageLimitService: Error getting messages - $e');
      return 0;
    }
  }

  /// Obtiene los mensajes restantes para hoy.
  Future<int> getRemainingMessages() async {
    final sent = await getMessagesSentToday();
    final remaining = (freeDailyLimit - sent).clamp(0, freeDailyLimit);
    debugPrint('MessageLimitService: Remaining messages = $remaining');
    return remaining;
  }

  /// Verifica si el usuario puede enviar un mensaje.
  Future<bool> canSendMessage() async {
    final remaining = await getRemainingMessages();
    return remaining > 0;
  }

  /// Incrementa el contador de mensajes enviados hoy.
  /// Usa upsert para crear el registro si no existe.
  Future<void> incrementMessageCount() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      debugPrint('MessageLimitService: No user logged in');
      return;
    }

    final todayStr = _getTodayString();

    try {
      // Primero obtenemos el valor actual
      final currentCount = await getMessagesSentToday();
      final newCount = currentCount + 1;

      // Upsert con el nuevo valor
      await _client.from('daily_activity').upsert({
        'user_id': userId,
        'activity_date': todayStr,
        'messages_sent': newCount,
        'completed': false, // No marca el día como completado solo por enviar mensaje
      });

      debugPrint('MessageLimitService: Incremented to $newCount messages');
    } catch (e) {
      debugPrint('MessageLimitService: Error incrementing - $e');
      rethrow;
    }
  }

  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
