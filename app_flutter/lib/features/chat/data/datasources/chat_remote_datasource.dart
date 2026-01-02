import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_message_model.dart';

abstract class ChatRemoteDatasource {
  Future<Map<String, dynamic>> sendMessage({
    String? topicKey,
    required String userMessage,
    String? chatId,
    String? systemContext,  // Contexto para la IA (no se guarda en BD)
  });

  Future<List<ChatMessageModel>> getMessages(String chatId);

  Future<ChatModel?> getChatById(String chatId);

  Future<ChatModel?> getChatByTopic(String topicKey);

  Future<List<ChatModel>> getUserChats();

  Future<void> updateChatTitle(String chatId, String newTitle);

  Future<void> deleteChat(String chatId);
}

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final SupabaseClient _supabase;

  ChatRemoteDatasourceImpl(this._supabase);

  @override
  Future<Map<String, dynamic>> sendMessage({
    String? topicKey,
    required String userMessage,
    String? chatId,
    String? systemContext,
  }) async {
    final body = <String, dynamic>{
      'user_message': userMessage,
    };

    // Solo incluir topic_key si no es null
    if (topicKey != null) {
      body['topic_key'] = topicKey;
    }

    // Solo incluir chat_id si no es null
    if (chatId != null) {
      body['chat_id'] = chatId;
    }

    // Solo incluir system_context si no es null (contexto para la IA, no se guarda)
    if (systemContext != null && systemContext.isNotEmpty) {
      body['system_context'] = systemContext;
    }

    final response = await _supabase.functions.invoke(
      'chat-send-message',
      body: body,
    );

    if (response.status != 200) {
      throw Exception('Failed to send message: ${response.data}');
    }

    return response.data as Map<String, dynamic>;
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String chatId) async {
    final response = await _supabase
        .from('chat_messages')
        .select()
        .eq('chat_id', chatId)
        .order('created_at', ascending: true);

    return (response as List)
        .map((json) => ChatMessageModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ChatModel?> getChatById(String chatId) async {
    final response = await _supabase
        .from('chats')
        .select()
        .eq('id', chatId)
        .maybeSingle();

    if (response == null) return null;

    return ChatModel.fromJson(response);
  }

  @override
  Future<ChatModel?> getChatByTopic(String topicKey) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _supabase
        .from('chats')
        .select()
        .eq('user_id', userId)
        .eq('topic_key', topicKey)
        .order('last_message_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;

    return ChatModel.fromJson(response);
  }

  @override
  Future<List<ChatModel>> getUserChats() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('chats')
        .select()
        .eq('user_id', userId)
        .order('last_message_at', ascending: false);

    return (response as List)
        .map((json) => ChatModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> updateChatTitle(String chatId, String newTitle) async {
    await _supabase.from('chats').update({'title': newTitle}).eq('id', chatId);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    // Primero eliminar los mensajes del chat
    await _supabase.from('chat_messages').delete().eq('chat_id', chatId);
    // Luego eliminar el chat
    await _supabase.from('chats').delete().eq('id', chatId);
  }
}
