import '../entities/chat_message.dart';

abstract class ChatRepository {
  /// Envía un mensaje y obtiene la respuesta de la IA
  /// [topicKey] es opcional: null para chat libre
  Future<ChatMessage> sendMessage({
    String? topicKey,
    required String userMessage,
    String? chatId,
  });

  /// Obtiene el historial de mensajes de un chat
  Future<List<ChatMessage>> getMessages(String chatId);

  /// Obtiene un chat por su ID
  Future<Chat?> getChatById(String chatId);

  /// Obtiene o crea un chat para un tema específico
  Future<Chat?> getChatByTopic(String topicKey);

  /// Obtiene todos los chats del usuario
  Future<List<Chat>> getUserChats();
}
