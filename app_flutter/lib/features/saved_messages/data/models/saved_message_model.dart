import '../../domain/entities/saved_message.dart';

/// Model for saved messages with JSON serialization
/// Parses the nested JOIN response from Supabase:
/// saved_messages -> chat_messages -> chats
class SavedMessageModel extends SavedMessage {
  const SavedMessageModel({
    required super.id,
    required super.chatMessageId,
    required super.content,
    super.chatTitle,
    required super.savedAt,
    required super.messageCreatedAt,
  });

  /// Parse from Supabase JOIN response:
  /// {
  ///   "id": "...",
  ///   "chat_message_id": "...",
  ///   "saved_at": "...",
  ///   "chat_messages": {
  ///     "content": "...",
  ///     "created_at": "...",
  ///     "chats": {
  ///       "title": "..."
  ///     }
  ///   }
  /// }
  factory SavedMessageModel.fromJson(Map<String, dynamic> json) {
    final chatMessage = json['chat_messages'] as Map<String, dynamic>;
    final chat = chatMessage['chats'] as Map<String, dynamic>?;

    return SavedMessageModel(
      id: json['id'] as String,
      chatMessageId: json['chat_message_id'] as String,
      savedAt: DateTime.parse(json['saved_at'] as String),
      content: chatMessage['content'] as String,
      messageCreatedAt: DateTime.parse(chatMessage['created_at'] as String),
      chatTitle: chat?['title'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_message_id': chatMessageId,
      'saved_at': savedAt.toIso8601String(),
      'content': content,
      'message_created_at': messageCreatedAt.toIso8601String(),
      'chat_title': chatTitle,
    };
  }
}
