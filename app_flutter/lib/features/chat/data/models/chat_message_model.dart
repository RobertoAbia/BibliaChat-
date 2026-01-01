import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.chatId,
    required super.role,
    required super.content,
    required super.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      chatId: json['chat_id'] as String,
      role: _parseRole(json['role'] as String),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static MessageRole _parseRole(String role) {
    switch (role) {
      case 'user':
        return MessageRole.user;
      case 'assistant':
        return MessageRole.assistant;
      case 'system':
        return MessageRole.system;
      default:
        return MessageRole.user;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'role': role.name,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Crea un mensaje temporal (antes de que se guarde en el servidor)
  factory ChatMessageModel.temporary({
    required String chatId,
    required MessageRole role,
    required String content,
  }) {
    return ChatMessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      chatId: chatId,
      role: role,
      content: content,
      createdAt: DateTime.now(),
    );
  }
}

class ChatModel extends Chat {
  const ChatModel({
    required super.id,
    super.topicKey,
    super.title,
    super.contextSummary,
    super.lastMessageAt,
    super.lastMessagePreview,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      topicKey: json['topic_key'] as String?,
      title: json['title'] as String?,
      contextSummary: json['context_summary'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      lastMessagePreview: json['last_message_preview'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic_key': topicKey,
      'title': title,
      'context_summary': contextSummary,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'last_message_preview': lastMessagePreview,
    };
  }
}
