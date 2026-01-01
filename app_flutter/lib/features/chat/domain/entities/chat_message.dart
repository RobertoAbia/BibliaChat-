import 'package:equatable/equatable.dart';

enum MessageRole { user, assistant, system }

class ChatMessage extends Equatable {
  final String id;
  final String chatId;
  final MessageRole role;
  final String content;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  bool get isUser => role == MessageRole.user;
  bool get isAssistant => role == MessageRole.assistant;

  @override
  List<Object?> get props => [id, chatId, role, content, createdAt];
}

class Chat extends Equatable {
  final String id;
  final String? topicKey; // Nullable: null = chat libre
  final String? title; // Título personalizado del chat
  final String? contextSummary;
  final DateTime? lastMessageAt;
  final String? lastMessagePreview;

  const Chat({
    required this.id,
    this.topicKey,
    this.title,
    this.contextSummary,
    this.lastMessageAt,
    this.lastMessagePreview,
  });

  /// Obtiene el título a mostrar (title personalizado o título del topic)
  String get displayTitle {
    if (title != null && title!.isNotEmpty) return title!;
    if (topicKey != null) return _getTopicTitle(topicKey!);
    return 'Nueva conversación';
  }

  static String _getTopicTitle(String key) {
    const topics = {
      'familia_separada': 'Familia separada',
      'desempleo': 'Fe en desempleo',
      'solteria': 'Soltería cristiana',
      'ansiedad_miedo': 'Ansiedad y miedo',
      'identidad_bicultural': 'Identidad bicultural',
      'reconciliacion': 'Reconciliación',
      'sacramentos': 'Sacramentos',
      'oracion': 'Oración',
      'preguntas_biblia': 'Preguntas bíblicas',
      'evangelio_del_dia': 'Evangelio del día',
      'lectura_del_dia': 'Lectura del día',
      'otro': 'Conversación',
    };
    return topics[key] ?? 'Conversación';
  }

  @override
  List<Object?> get props => [id, topicKey, title, contextSummary, lastMessageAt, lastMessagePreview];
}
