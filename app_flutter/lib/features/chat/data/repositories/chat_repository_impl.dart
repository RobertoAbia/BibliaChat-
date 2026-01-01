import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource _remoteDatasource;

  ChatRepositoryImpl(this._remoteDatasource);

  @override
  Future<ChatMessage> sendMessage({
    String? topicKey,
    required String userMessage,
    String? chatId,
  }) async {
    final response = await _remoteDatasource.sendMessage(
      topicKey: topicKey,
      userMessage: userMessage,
      chatId: chatId,
    );

    // La Edge Function devuelve el mensaje del asistente
    return ChatMessageModel(
      id: response['message_id'] as String,
      chatId: response['chat_id'] as String,
      role: MessageRole.assistant,
      content: response['assistant_message'] as String,
      createdAt: DateTime.parse(response['created_at'] as String),
    );
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
}
