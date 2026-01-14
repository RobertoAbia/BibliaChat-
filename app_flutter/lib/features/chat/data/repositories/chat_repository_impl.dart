import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/chat_message_model.dart';

/// Resultado de enviar un mensaje, incluye el mensaje del asistente y el título (si se generó)
class SendMessageResult {
  final ChatMessage message;
  final String? title;

  SendMessageResult({required this.message, this.title});
}

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource _remoteDatasource;

  ChatRepositoryImpl(this._remoteDatasource);

  @override
  Future<ChatMessage> sendMessage({
    String? topicKey,
    required String userMessage,
    String? chatId,
    String? systemMessage,
  }) async {
    final result = await sendMessageWithTitle(
      topicKey: topicKey,
      userMessage: userMessage,
      chatId: chatId,
      systemMessage: systemMessage,
    );
    return result.message;
  }

  /// Envía un mensaje y devuelve tanto el mensaje como el título (si se generó)
  @override
  Future<SendMessageResult> sendMessageWithTitle({
    String? topicKey,
    required String userMessage,
    String? chatId,
    String? systemMessage,
  }) async {
    final response = await _remoteDatasource.sendMessage(
      topicKey: topicKey,
      userMessage: userMessage,
      chatId: chatId,
      systemMessage: systemMessage,
    );

    // La Edge Function devuelve el mensaje del asistente y opcionalmente el título
    final message = ChatMessageModel(
      id: response['message_id'] as String,
      chatId: response['chat_id'] as String,
      role: MessageRole.assistant,
      content: response['assistant_message'] as String,
      createdAt: DateTime.parse(response['created_at'] as String),
    );

    final title = response['title'] as String?;

    return SendMessageResult(message: message, title: title);
  }

  @override
  Future<List<ChatMessage>> getMessages(String chatId) async {
    return await _remoteDatasource.getMessages(chatId);
  }

  @override
  Future<Chat?> getChatById(String chatId) async {
    return await _remoteDatasource.getChatById(chatId);
  }

  @override
  Future<Chat?> getChatByTopic(String topicKey) async {
    return await _remoteDatasource.getChatByTopic(topicKey);
  }

  @override
  Future<List<Chat>> getUserChats() async {
    return await _remoteDatasource.getUserChats();
  }

  @override
  Future<void> updateChatTitle(String chatId, String newTitle) async {
    await _remoteDatasource.updateChatTitle(chatId, newTitle);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await _remoteDatasource.deleteChat(chatId);
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    await _remoteDatasource.deleteMessage(messageId);
  }
}
