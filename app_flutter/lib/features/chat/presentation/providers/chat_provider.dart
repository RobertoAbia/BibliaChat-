import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/analytics_service.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';

/// Provider para pasar contenido del día del plan al chat
/// Se usa porque GoRouter extra no funciona bien con ShellRoute
final pendingPlanContentProvider = StateProvider<String?>((ref) => null);

// Datasource provider
final chatRemoteDatasourceProvider = Provider<ChatRemoteDatasource>((ref) {
  return ChatRemoteDatasourceImpl(Supabase.instance.client);
});

// Repository provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(ref.watch(chatRemoteDatasourceProvider));
});

/// Identificador de chat que puede ser:
/// - chatId: para abrir un chat existente por su ID
/// - topicKey: para abrir/crear un chat de un topic específico (desde Stories)
/// - null/vacío: para crear un nuevo chat libre
class ChatIdentifier {
  final String? chatId;
  final String? topicKey;

  const ChatIdentifier({this.chatId, this.topicKey});

  /// Chat nuevo (libre, sin topic)
  const ChatIdentifier.newChat() : chatId = null, topicKey = null;

  /// Chat existente por ID
  const ChatIdentifier.existing(String id) : chatId = id, topicKey = null;

  /// Chat por topic (desde Stories o temas guiados)
  const ChatIdentifier.topic(String key) : chatId = null, topicKey = key;

  bool get isNewChat => chatId == null && topicKey == null;
  bool get isExistingChat => chatId != null;
  bool get isTopicChat => topicKey != null && chatId == null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatIdentifier &&
        other.chatId == chatId &&
        other.topicKey == topicKey;
  }

  @override
  int get hashCode => chatId.hashCode ^ topicKey.hashCode;

  @override
  String toString() => 'ChatIdentifier(chatId: $chatId, topicKey: $topicKey)';
}

// Estado del chat
class ChatState {
  final String? chatId;
  final String? topicKey;
  final String? title;  // Título del chat (generado por IA o editado manualmente)
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isSending;
  final String? error;
  final bool showStarterSuggestions;

  const ChatState({
    this.chatId,
    this.topicKey,
    this.title,
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.error,
    this.showStarterSuggestions = false,
  });

  ChatState copyWith({
    String? chatId,
    String? topicKey,
    String? title,
    bool clearTitle = false,  // Para poder establecer title = null
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isSending,
    String? error,
    bool? showStarterSuggestions,
  }) {
    return ChatState(
      chatId: chatId ?? this.chatId,
      topicKey: topicKey ?? this.topicKey,
      title: clearTitle ? null : (title ?? this.title),
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
      showStarterSuggestions: showStarterSuggestions ?? this.showStarterSuggestions,
    );
  }

  bool get isEmpty => messages.isEmpty;
  bool get isNewFreeChat => chatId == null && topicKey == null;

  /// Título para mostrar: título personalizado > título del topic > "Nueva conversación"
  String get displayTitle {
    if (title != null && title!.isNotEmpty) return title!;
    if (topicKey != null) return _getTopicTitle(topicKey!);
    return 'Nueva conversación';
  }

  String _getTopicTitle(String key) {
    const titles = {
      'familia_separada': 'Familia separada',
      'desempleo': 'Desempleo',
      'solteria': 'Soltería',
      'ansiedad_miedo': 'Ansiedad y miedo',
      'identidad_bicultural': 'Identidad bicultural',
      'reconciliacion': 'Reconciliación',
      'sacramentos': 'Sacramentos',
      'oracion': 'Oración',
      'preguntas_biblia': 'Preguntas bíblicas',
      'evangelio_del_dia': 'Evangelio del día',
      'lectura_del_dia': 'Lectura del día',
      'otro': 'Otro tema',
    };
    return titles[key] ?? 'Nueva conversación';
  }
}

// StateNotifier para manejar el estado del chat
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;
  final ChatIdentifier _identifier;
  final Ref _ref;

  ChatNotifier(this._repository, this._identifier, this._ref)
      : super(ChatState(
          topicKey: _identifier.topicKey,
          chatId: _identifier.chatId,
          showStarterSuggestions: _identifier.isNewChat,
        ));

  /// Notifica a la lista de chats que debe refrescarse
  void _notifyChatListRefresh() {
    _ref.read(userChatsRefreshProvider.notifier).state++;
  }

  // Resetea el estado para empezar un chat completamente nuevo
  // Esto es necesario porque Riverpod cachea el provider por identifier
  void resetForNewChat() {
    state = ChatState(
      topicKey: _identifier.topicKey,
      chatId: null,
      title: null,
      messages: [],
      isLoading: false,
      isSending: false,
      error: null,
      showStarterSuggestions: _identifier.isNewChat,
    );
  }

  // Inicializa el chat cargando el historial existente
  Future<void> initialize() async {
    // Para chats nuevos, no hay nada que cargar - mostrar sugerencias directamente
    if (_identifier.isNewChat) {
      state = state.copyWith(
        isLoading: false,
        showStarterSuggestions: true,
      );
      return;
    }

    // Para chats existentes o por topic, cargar datos
    state = state.copyWith(isLoading: true, error: null);

    try {
      Chat? existingChat;

      if (_identifier.isExistingChat) {
        // Abrir chat existente por ID
        existingChat = await _repository.getChatById(_identifier.chatId!);
      } else if (_identifier.isTopicChat) {
        // Buscar chat existente para este topic
        existingChat = await _repository.getChatByTopic(_identifier.topicKey!);
      }

      if (existingChat != null) {
        // Cargar mensajes existentes
        final messages = await _repository.getMessages(existingChat.id);
        state = state.copyWith(
          chatId: existingChat.id,
          topicKey: existingChat.topicKey,
          title: existingChat.title,  // Cargar título existente
          messages: messages,
          isLoading: false,
          showStarterSuggestions: false,
        );
      } else {
        // No hay chat existente para este topic, empezar vacío
        state = state.copyWith(
          isLoading: false,
          showStarterSuggestions: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar el chat: $e',
      );
    }
  }

  // Envía un mensaje y recibe la respuesta de la IA
  // Si topicKey se proporciona, se usa en lugar de state.topicKey (útil para crear chats nuevos con topic)
  // Si systemMessage se proporciona (contenido de Story), se guarda como mensaje 'system' en BD
  Future<void> sendMessage(String content, {String? topicKey, String? systemMessage}) async {
    if (content.trim().isEmpty) return;

    // Ocultar sugerencias al enviar primer mensaje
    if (state.showStarterSuggestions) {
      state = state.copyWith(showStarterSuggestions: false);
    }

    // Crear mensaje temporal del usuario para mostrar inmediatamente
    final tempUserMessage = ChatMessageModel.temporary(
      chatId: state.chatId ?? 'temp',
      role: MessageRole.user,
      content: content,
    );

    // Añadir mensaje del usuario y marcar como enviando
    state = state.copyWith(
      messages: [...state.messages, tempUserMessage],
      isSending: true,
      error: null,
    );

    try {
      // Enviar mensaje a la Edge Function y obtener respuesta + título
      // El systemMessage (contenido de Story) se guarda como mensaje 'system' en BD
      // Usar topicKey proporcionado o el del state
      final result = await _repository.sendMessageWithTitle(
        topicKey: topicKey ?? state.topicKey,
        userMessage: content,
        chatId: state.chatId,
        systemMessage: systemMessage,
      );

      final assistantMessage = result.message;
      final generatedTitle = result.title;

      // Actualizar chat_id si es la primera vez
      final newChatId = state.chatId ??
          (assistantMessage as ChatMessageModel).chatId;

      // Si había systemMessage (contenido de Story), recargar todos los mensajes
      // para incluir el mensaje 'system' guardado por la Edge Function
      if (systemMessage != null) {
        final allMessages = await _repository.getMessages(newChatId);
        state = state.copyWith(
          chatId: newChatId,
          title: generatedTitle ?? state.title,
          messages: allMessages,
          isSending: false,
        );
      } else {
        // Sin systemMessage, actualizar solo los mensajes locales
        final updatedUserMessage = ChatMessageModel(
          id: tempUserMessage.id,
          chatId: newChatId,
          role: MessageRole.user,
          content: content,
          createdAt: tempUserMessage.createdAt,
        );

        final updatedMessages = [
          ...state.messages.where((m) => m.id != tempUserMessage.id),
          updatedUserMessage,
          assistantMessage,
        ];

        state = state.copyWith(
          chatId: newChatId,
          title: generatedTitle ?? state.title,
          messages: updatedMessages,
          isSending: false,
        );
      }

      // Notificar a la lista de chats que debe refrescarse
      _notifyChatListRefresh();

      // Log analytics event
      final isPremium = _ref.read(isPremiumProvider);
      AnalyticsService().logChatMessageSent(
        topicKey: topicKey ?? state.topicKey,
        isPremium: isPremium,
      );
    } catch (e) {
      state = state.copyWith(
        isSending: false,
        error: 'Error al enviar mensaje: $e',
      );
    }
  }

  // Añade un mensaje inicial del asistente (para saludo o contexto)
  void addInitialAssistantMessage(String content) {
    final initialMessage = ChatMessageModel.temporary(
      chatId: state.chatId ?? 'temp',
      role: MessageRole.assistant,
      content: content,
    );

    state = state.copyWith(
      messages: [...state.messages, initialMessage],
      showStarterSuggestions: false,
    );
  }

  // Añade mensajes iniciales (para cuando viene de Stories)
  void addInitialMessages({
    required String assistantContent,
    String? userContent,
  }) {
    final messages = <ChatMessage>[];

    // Mensaje inicial del asistente
    messages.add(ChatMessageModel.temporary(
      chatId: state.chatId ?? 'temp',
      role: MessageRole.assistant,
      content: assistantContent,
    ));

    // Mensaje del usuario (si viene de Stories)
    if (userContent != null && userContent.isNotEmpty) {
      messages.add(ChatMessageModel.temporary(
        chatId: state.chatId ?? 'temp',
        role: MessageRole.user,
        content: userContent,
      ));
    }

    state = state.copyWith(
      messages: [...state.messages, ...messages],
      showStarterSuggestions: false,
    );
  }

  // Limpia el error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Actualiza el título del chat
  Future<bool> updateTitle(String newTitle) async {
    if (state.chatId == null) return false;

    try {
      await _repository.updateChatTitle(state.chatId!, newTitle);
      state = state.copyWith(title: newTitle);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al renombrar: $e');
      return false;
    }
  }

  // Elimina el chat actual
  Future<bool> deleteChat() async {
    if (state.chatId == null) return false;

    try {
      await _repository.deleteChat(state.chatId!);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar: $e');
      return false;
    }
  }

  /// Elimina un mensaje específico del chat
  Future<bool> deleteMessage(String messageId) async {
    if (state.chatId == null) return false;

    try {
      await _repository.deleteMessage(messageId);
      // Quitar el mensaje del estado local
      state = state.copyWith(
        messages: state.messages.where((m) => m.id != messageId).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar mensaje: $e');
      return false;
    }
  }
}

// Provider family usando ChatIdentifier como key
final chatNotifierProvider = StateNotifierProvider.family<ChatNotifier, ChatState, ChatIdentifier>(
  (ref, identifier) {
    final repository = ref.watch(chatRepositoryProvider);
    return ChatNotifier(repository, identifier, ref);
  },
);

// Provider para obtener los chats del usuario
final userChatsProvider = FutureProvider<List<Chat>>((ref) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getUserChats();
});

// Provider para refrescar la lista de chats
final userChatsRefreshProvider = StateProvider<int>((ref) => 0);

// Provider que refresca cuando cambia el contador o el usuario
final refreshableUserChatsProvider = FutureProvider<List<Chat>>((ref) async {
  ref.watch(userChatsRefreshProvider);
  ref.watch(currentUserIdProvider); // Invalidar al cambiar usuario
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getUserChats();
});

/// Sugerencias de inicio para chat libre
class StarterSuggestion {
  final String icon;
  final String text;
  final String? topicKey;

  const StarterSuggestion({
    required this.icon,
    required this.text,
    this.topicKey,
  });
}

const List<StarterSuggestion> starterSuggestions = [
  StarterSuggestion(
    icon: '🙏',
    text: 'Necesito una oración por...',
    topicKey: 'oracion',
  ),
  StarterSuggestion(
    icon: '📖',
    text: 'Tengo una pregunta sobre la Biblia',
    topicKey: 'preguntas_biblia',
  ),
  StarterSuggestion(
    icon: '😰',
    text: 'Me siento ansioso o preocupado',
    topicKey: 'ansiedad_miedo',
  ),
  StarterSuggestion(
    icon: '👨‍👩‍👧',
    text: 'Quiero hablar de mi familia',
    topicKey: 'familia_separada',
  ),
  StarterSuggestion(
    icon: '💬',
    text: 'Otra cosa...',
    topicKey: null,
  ),
];
