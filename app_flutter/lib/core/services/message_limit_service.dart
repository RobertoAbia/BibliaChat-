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

  // NOTA: el contador lo incrementa el SERVIDOR (Edge Function
  // chat-send-message vía RPC atómica increment_daily_messages). El antiguo
  // incremento cliente hacía un read-modify-write de `completed` con una
  // carrera que podía revertir días de racha (ver migración 00026/00035).
  // Este servicio ahora es solo de lectura.

  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
