import '../../domain/entities/saved_message.dart';
import '../../domain/repositories/saved_message_repository.dart';
import '../datasources/saved_message_remote_datasource.dart';

class SavedMessageRepositoryImpl implements SavedMessageRepository {
  final SavedMessageRemoteDatasource _remoteDatasource;

  SavedMessageRepositoryImpl(this._remoteDatasource);

  @override
  Future<List<SavedMessage>> getSavedMessages() async {
    return await _remoteDatasource.getSavedMessages();
  }

  @override
  Future<void> saveMessage(String chatMessageId) async {
    await _remoteDatasource.saveMessage(chatMessageId);
  }

  @override
  Future<void> unsaveMessage(String chatMessageId) async {
    await _remoteDatasource.unsaveMessage(chatMessageId);
  }

  @override
  Future<Set<String>> getSavedMessageIds() async {
    return await _remoteDatasource.getSavedMessageIds();
  }

  @override
  Future<bool> isMessageSaved(String chatMessageId) async {
    return await _remoteDatasource.isMessageSaved(chatMessageId);
  }
}
