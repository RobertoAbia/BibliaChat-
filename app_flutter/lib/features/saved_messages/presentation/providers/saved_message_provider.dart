import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/analytics_service.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../../data/datasources/saved_message_remote_datasource.dart';
import '../../data/repositories/saved_message_repository_impl.dart';
import '../../domain/entities/saved_message.dart';
import '../../domain/repositories/saved_message_repository.dart';

// Datasource provider
final savedMessageDatasourceProvider = Provider<SavedMessageRemoteDatasource>((ref) {
  return SavedMessageRemoteDatasourceImpl(Supabase.instance.client);
});

// Repository provider
final savedMessageRepositoryProvider = Provider<SavedMessageRepository>((ref) {
  return SavedMessageRepositoryImpl(ref.watch(savedMessageDatasourceProvider));
});

// Refresh trigger for saved messages list
final savedMessagesRefreshProvider = StateProvider<int>((ref) => 0);

// List of saved messages (for SavedMessagesScreen)
final savedMessagesProvider = FutureProvider<List<SavedMessage>>((ref) async {
  // Watch refresh trigger to reload when needed
  ref.watch(savedMessagesRefreshProvider);
  ref.watch(currentUserIdProvider); // Invalidar al cambiar usuario
  final repo = ref.watch(savedMessageRepositoryProvider);
  return repo.getSavedMessages();
});

// Set of saved message IDs (for showing filled hearts in chat)
final savedMessageIdsProvider = FutureProvider<Set<String>>((ref) async {
  // Watch refresh trigger to reload when needed
  ref.watch(savedMessagesRefreshProvider);
  ref.watch(currentUserIdProvider); // Invalidar al cambiar usuario
  final repo = ref.watch(savedMessageRepositoryProvider);
  return repo.getSavedMessageIds();
});

// State for saved message operations
class SavedMessageState {
  final bool isLoading;
  final String? error;

  const SavedMessageState({
    this.isLoading = false,
    this.error,
  });

  SavedMessageState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return SavedMessageState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier for save/unsave operations
class SavedMessageNotifier extends StateNotifier<SavedMessageState> {
  final SavedMessageRepository _repository;
  final Ref _ref;

  SavedMessageNotifier(this._repository, this._ref) : super(const SavedMessageState());

  /// Toggle save/unsave for a message
  Future<bool> toggleSave(String chatMessageId) async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Check current state
      final savedIds = await _ref.read(savedMessageIdsProvider.future);
      final isSaved = savedIds.contains(chatMessageId);

      if (isSaved) {
        await _repository.unsaveMessage(chatMessageId);
        // Log analytics event
        AnalyticsService().logMessageUnsaved();
      } else {
        await _repository.saveMessage(chatMessageId);
        // Log analytics event
        AnalyticsService().logMessageSaved();
      }

      // Refresh the saved messages list
      _ref.read(savedMessagesRefreshProvider.notifier).state++;

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error: $e',
      );
      return false;
    }
  }

  /// Unsave a message (for use in SavedMessagesScreen)
  Future<bool> unsave(String chatMessageId) async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.unsaveMessage(chatMessageId);

      // Refresh the saved messages list
      _ref.read(savedMessagesRefreshProvider.notifier).state++;

      // Log analytics event
      AnalyticsService().logMessageUnsaved();

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error: $e',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Notifier provider
final savedMessageNotifierProvider =
    StateNotifierProvider<SavedMessageNotifier, SavedMessageState>((ref) {
  return SavedMessageNotifier(
    ref.watch(savedMessageRepositoryProvider),
    ref,
  );
});
