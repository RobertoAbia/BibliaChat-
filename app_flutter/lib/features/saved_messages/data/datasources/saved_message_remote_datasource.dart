import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/saved_message_model.dart';

abstract class SavedMessageRemoteDatasource {
  Future<List<SavedMessageModel>> getSavedMessages();
  Future<void> saveMessage(String chatMessageId);
  Future<void> unsaveMessage(String chatMessageId);
  Future<Set<String>> getSavedMessageIds();
  Future<bool> isMessageSaved(String chatMessageId);
}

class SavedMessageRemoteDatasourceImpl implements SavedMessageRemoteDatasource {
  final SupabaseClient _supabase;

  SavedMessageRemoteDatasourceImpl(this._supabase);

  @override
  Future<List<SavedMessageModel>> getSavedMessages() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('saved_messages')
        .select('''
          id,
          chat_message_id,
          saved_at,
          chat_messages!inner(
            content,
            created_at,
            chats!inner(title)
          )
        ''')
        .eq('user_id', userId)
        .order('saved_at', ascending: false);

    return (response as List)
        .map((json) => SavedMessageModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveMessage(String chatMessageId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabase.from('saved_messages').insert({
      'user_id': userId,
      'chat_message_id': chatMessageId,
    });
  }

  @override
  Future<void> unsaveMessage(String chatMessageId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabase
        .from('saved_messages')
        .delete()
        .eq('user_id', userId)
        .eq('chat_message_id', chatMessageId);
  }

  @override
  Future<Set<String>> getSavedMessageIds() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return {};

    final response = await _supabase
        .from('saved_messages')
        .select('chat_message_id')
        .eq('user_id', userId);

    return (response as List)
        .map((json) => json['chat_message_id'] as String)
        .toSet();
  }

  @override
  Future<bool> isMessageSaved(String chatMessageId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    final response = await _supabase
        .from('saved_messages')
        .select('id')
        .eq('user_id', userId)
        .eq('chat_message_id', chatMessageId)
        .maybeSingle();

    return response != null;
  }
}
