import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';

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
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isSending;
  final String? error;
  final bool showStarterSuggestions;

  const ChatState({
    this.chatId,
    this.topicKey,
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.error,
    this.showStarterSuggestions = false,
  });

  ChatState copyWith({
    String? chatId,
    String? topicKey,
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isSending,
    String? error,
    bool? showStarterSuggestions,
  }) {
    return ChatState(
      chatId: chatId ?? this.chatId,
      topicKey: topicKey ?? this.topicKey,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
      showStarterSuggestions: showStarterSuggestions ?? this.showStarterSuggestions,
    );
  }

  bool get isEmpty => messages.isEmpty;
  bool get isNewFreeChat => chatId == null && topicKey == null;
}

// StateNotifier para manejar el estado del chat
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;
  final ChatIdentifier _identifier;

  ChatNotifier(this._repository, this._identifier)
      : super(ChatState(
          topicKey: _identifier.topicKey,
          chatId: _identifier.chatId,
          showStarterSuggestions: _identifier.isNewChat,
        ));

  // Resetea el estado para empezar un chat completamente nuevo
  // Esto es necesario porque Riverpod cachea el provider por identifier
  void resetForNewChat() {
    state = ChatState(
      topicKey: _identifier.topicKey,
      chatId: null,
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
  // Si systemContext se proporciona, se incluye como contexto para la IA (no se muestra al usuario)
  Future<void> sendMessage(String content, {String? topicKey, String? systemContext}) async {
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
      // Preparar el mensaje para la Edge Function
      // Si hay contexto del sistema (ej: contenido de Story), incluirlo
      String messageForApi = content;
      if (systemContext != null && systemContext.isNotEmpty) {
        messageForApi = '[Contexto de la lectura bíblica que el usuario está viendo:]\n$systemContext\n\n[Mensaje del usuario:]\n$content';
      }

      // Enviar mensaje a la Edge Function
      // Usar topicKey proporcionado o el del state
      final assistantMessage = await _repository.sendMessage(
        topicKey: topicKey ?? state.topicKey,
        userMessage: messageForApi,
        chatId: state.chatId,
      );

      // Actualizar chat_id si es la primera vez
      final newChatId = state.chatId ??
          (assistantMessage as ChatMessageModel).chatId;

      // Actualizar el mensaje del usuario con el ID real del chat
      final updatedUserMessage = ChatMessageModel(
        id: tempUserMessage.id,
        chatId: newChatId,
        role: MessageRole.user,
        content: content,
        createdAt: tempUserMessage.createdAt,
      );

      // Reemplazar mensaje temporal y añadir respuesta
      final updatedMessages = [
        ...state.messages.where((m) => m.id != tempUserMessage.id),
        updatedUserMessage,
        assistantMessage,
      ];

      state = state.copyWith(
        chatId: newChatId,
        messages: updatedMessages,
        isSending: false,
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
      messages: [initialMessage, ...state.messages],
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
      messages: [...messages, ...state.messages],
      showStarterSuggestions: false,
    );
  }

  // Limpia el error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider family usando ChatIdentifier como key
final chatNotifierProvider = StateNotifierProvider.family<ChatNotifier, ChatState, ChatIdentifier>(
  (ref, identifier) {
    final repository = ref.watch(chatRepositoryProvider);
    return ChatNotifier(repository, identifier);
  },
);

// Provider para obtener los chats del usuario
final userChatsProvider = FutureProvider<List<Chat>>((ref) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getUserChats();
});

// Provider para refrescar la lista de chats
final userChatsRefreshProvider = StateProvider<int>((ref) => 0);

// Provider que refresca cuando cambia el contador
final refreshableUserChatsProvider = FutureProvider<List<Chat>>((ref) async {
  ref.watch(userChatsRefreshProvider);
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
