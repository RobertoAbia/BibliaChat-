/// Entity representing a saved message (reflection)
class SavedMessage {
  final String id;
  final String chatMessageId;
  final String content;
  final String? chatTitle;
  final DateTime savedAt;
  final DateTime messageCreatedAt;

  const SavedMessage({
    required this.id,
    required this.chatMessageId,
    required this.content,
    this.chatTitle,
    required this.savedAt,
    required this.messageCreatedAt,
  });
}
