import '../entities/saved_message.dart';

/// Repository interface for saved messages (reflections)
abstract class SavedMessageRepository {
  /// Get all saved messages for the current user, ordered by saved_at desc
  Future<List<SavedMessage>> getSavedMessages();

  /// Save a message by its chat_message_id
  Future<void> saveMessage(String chatMessageId);

  /// Unsave (delete) a message by its chat_message_id
  Future<void> unsaveMessage(String chatMessageId);

  /// Get a set of saved chat_message_ids for the current user
  /// Used to show filled heart icon in chat
  Future<Set<String>> getSavedMessageIds();

  /// Check if a specific message is saved
  Future<bool> isMessageSaved(String chatMessageId);
}
