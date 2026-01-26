import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/message_limit_service.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';

/// Estado del límite de mensajes
class MessageLimitState {
  final int messagesSentToday;
  final int remainingMessages;
  final bool canSendMessage;
  final bool isLoading;

  const MessageLimitState({
    this.messagesSentToday = 0,
    this.remainingMessages = MessageLimitService.freeDailyLimit,
    this.canSendMessage = true,
    this.isLoading = true,
  });

  MessageLimitState copyWith({
    int? messagesSentToday,
    int? remainingMessages,
    bool? canSendMessage,
    bool? isLoading,
  }) {
    return MessageLimitState(
      messagesSentToday: messagesSentToday ?? this.messagesSentToday,
      remainingMessages: remainingMessages ?? this.remainingMessages,
      canSendMessage: canSendMessage ?? this.canSendMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier para el límite de mensajes
class MessageLimitNotifier extends StateNotifier<MessageLimitState> {
  final MessageLimitService _service;
  final Ref _ref;

  MessageLimitNotifier(this._service, this._ref)
      : super(const MessageLimitState()) {
    _init();
  }

  Future<void> _init() async {
    await refresh();
  }

  /// Refresca el estado del límite de mensajes
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);

    final sent = await _service.getMessagesSentToday();
    final remaining = (MessageLimitService.freeDailyLimit - sent)
        .clamp(0, MessageLimitService.freeDailyLimit);

    state = state.copyWith(
      messagesSentToday: sent,
      remainingMessages: remaining,
      canSendMessage: remaining > 0,
      isLoading: false,
    );
  }

  /// Incrementa el contador y actualiza el estado
  Future<void> incrementAndRefresh() async {
    await _service.incrementMessageCount();
    await refresh();
  }

  /// Verifica si el usuario puede enviar mensaje (considerando si es premium)
  bool canUserSendMessage() {
    final isPremium = _ref.read(isPremiumProvider);
    if (isPremium) return true;
    return state.canSendMessage;
  }
}

/// Provider del servicio
final messageLimitServiceProvider = Provider<MessageLimitService>((ref) {
  final client = Supabase.instance.client;
  return MessageLimitService(client);
});

/// Provider principal del límite de mensajes
final messageLimitProvider =
    StateNotifierProvider<MessageLimitNotifier, MessageLimitState>((ref) {
  ref.watch(currentUserIdProvider); // Invalidar al cambiar usuario
  final service = ref.watch(messageLimitServiceProvider);
  return MessageLimitNotifier(service, ref);
});

/// Provider simple para verificar si puede enviar mensaje (considera premium)
final canSendMessageProvider = Provider<bool>((ref) {
  final isPremium = ref.watch(isPremiumProvider);
  if (isPremium) return true;

  final limitState = ref.watch(messageLimitProvider);
  return limitState.canSendMessage;
});

/// Provider para mensajes restantes (solo relevante para usuarios free)
final remainingMessagesProvider = Provider<int>((ref) {
  final isPremium = ref.watch(isPremiumProvider);
  if (isPremium) return -1; // -1 indica ilimitado

  return ref.watch(messageLimitProvider).remainingMessages;
});
