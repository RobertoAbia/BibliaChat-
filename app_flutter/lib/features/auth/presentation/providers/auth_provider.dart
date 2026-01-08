import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

/// Provider del repositorio de autenticación
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

/// Provider que indica si el usuario actual es anónimo
final isAnonymousProvider = Provider<bool>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.isAnonymous;
});

/// Provider que indica si el email está verificado
final isEmailVerifiedProvider = Provider<bool>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.isEmailVerified;
});

/// Provider del email actual (null si es anónimo)
final currentEmailProvider = Provider<String?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.currentEmail;
});

/// Provider del estado de autenticación actual
final authStatusProvider = Provider<AuthStatus>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStatus;
});

/// Stream provider para escuchar cambios en el estado de auth
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.onAuthStateChange;
});

/// Estado para el notifier de auth
class AuthNotifierState {
  final bool isLoading;
  final String? errorMessage;
  final String? errorCode;
  final bool success;

  const AuthNotifierState({
    this.isLoading = false,
    this.errorMessage,
    this.errorCode,
    this.success = false,
  });

  AuthNotifierState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? errorCode,
    bool? success,
  }) {
    return AuthNotifierState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      errorCode: errorCode,
      success: success ?? this.success,
    );
  }

  factory AuthNotifierState.initial() => const AuthNotifierState();
  factory AuthNotifierState.loading() =>
      const AuthNotifierState(isLoading: true);
  factory AuthNotifierState.success() =>
      const AuthNotifierState(success: true);
  factory AuthNotifierState.error(String message, [String? code]) =>
      AuthNotifierState(errorMessage: message, errorCode: code);
}

/// Notifier para operaciones de autenticación
class AuthNotifier extends StateNotifier<AuthNotifierState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthNotifierState.initial());

  /// Resetea el estado a inicial
  void reset() {
    state = AuthNotifierState.initial();
  }

  /// Vincula email/password a cuenta anónima
  Future<bool> linkEmail(String email, String password) async {
    state = AuthNotifierState.loading();

    final result = await _repository.linkEmail(
      email: email.trim(),
      password: password,
    );

    if (result.success) {
      state = AuthNotifierState.success();
      return true;
    } else {
      state = AuthNotifierState.error(
        result.errorMessage ?? 'Error desconocido',
        result.errorCode,
      );
      return false;
    }
  }

  /// Inicia sesión con email/password
  Future<bool> signInWithEmail(String email, String password) async {
    state = AuthNotifierState.loading();

    final result = await _repository.signInWithEmail(
      email: email.trim(),
      password: password,
    );

    if (result.success) {
      state = AuthNotifierState.success();
      return true;
    } else {
      state = AuthNotifierState.error(
        result.errorMessage ?? 'Error desconocido',
        result.errorCode,
      );
      return false;
    }
  }

  /// Cierra sesión
  Future<bool> signOut() async {
    state = AuthNotifierState.loading();

    final result = await _repository.signOut();

    if (result.success) {
      state = AuthNotifierState.success();
      return true;
    } else {
      state = AuthNotifierState.error(
        result.errorMessage ?? 'Error al cerrar sesión',
        result.errorCode,
      );
      return false;
    }
  }

  /// Crea sesión anónima
  Future<bool> signInAnonymously() async {
    state = AuthNotifierState.loading();

    final result = await _repository.signInAnonymously();

    if (result.success) {
      state = AuthNotifierState.success();
      return true;
    } else {
      state = AuthNotifierState.error(
        result.errorMessage ?? 'Error al crear sesión',
        result.errorCode,
      );
      return false;
    }
  }

  /// Reenvía email de verificación
  Future<bool> resendVerificationEmail() async {
    state = AuthNotifierState.loading();

    final result = await _repository.resendVerificationEmail();

    if (result.success) {
      state = AuthNotifierState.success();
      return true;
    } else {
      state = AuthNotifierState.error(
        result.errorMessage ?? 'Error al reenviar email',
        result.errorCode,
      );
      return false;
    }
  }

  /// Envía email para recuperar contraseña
  Future<bool> sendPasswordResetEmail(String email) async {
    state = AuthNotifierState.loading();

    final result = await _repository.sendPasswordResetEmail(email.trim());

    if (result.success) {
      state = AuthNotifierState.success();
      return true;
    } else {
      state = AuthNotifierState.error(
        result.errorMessage ?? 'Error al enviar email',
        result.errorCode,
      );
      return false;
    }
  }
}

/// Provider del notifier de auth
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthNotifierState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
