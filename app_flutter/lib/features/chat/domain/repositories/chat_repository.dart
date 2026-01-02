import '../entities/chat_message.dart';
import '../../data/repositories/chat_repository_impl.dart';

abstract class ChatRepository {
  /// Envía un mensaje y obtiene la respuesta de la IA
  /// [topicKey] es opcional: null para chat libre
  /// [systemContext] es contexto para la IA que NO se guarda en BD
  Future<ChatMessage> sendMessage({
    String? topicKey,
    required String userMessage,
    String? chatId,
    String? systemContext,
  });

  /// Envía un mensaje y obtiene tanto la respuesta como el título (si se generó)
  /// [systemContext] es contexto para la IA que NO se guarda en BD
  Future<SendMessageResult> sendMessageWithTitle({
    String? topicKey,
    required String userMessage,
    String? chatId,
    String? systemContext,
  });

  /// Obtiene el historial de mensajes de un chat
  Future<List<ChatMessage>> getMessages(String chatId);

  /// Obtiene un chat por su ID
  Future<Chat?> getChatById(String chatId);

  /// Obtiene o crea un chat para un tema específico
  Future<Chat?> getChatByTopic(String topicKey);

  /// Obtiene todos los chats del usuario
  Future<List<Chat>> getUserChats();

  /// Actualiza el título de un chat
  Future<void> updateChatTitle(String chatId, String newTitle);

  /// Elimina un chat y todos sus mensajes
  Future<void> deleteChat(String chatId);
}
