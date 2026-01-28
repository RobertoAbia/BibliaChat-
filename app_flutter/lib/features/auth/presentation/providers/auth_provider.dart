import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/analytics_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

/// Provider del repositorio de autenticación
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

/// Stream provider para escuchar cambios en el estado de auth
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.onAuthStateChange;
});

/// Provider que indica si el usuario actual es anónimo
/// Se actualiza automáticamente cuando cambia el estado de auth
final isAnonymousProvider = Provider<bool>((ref) {
  // Escuchar cambios de auth para re-evaluar
  ref.watch(authStateChangesProvider);
  final repo = ref.watch(authRepositoryProvider);
  return repo.isAnonymous;
});

/// Provider que indica si el email está verificado
/// Se actualiza automáticamente cuando cambia el estado de auth
final isEmailVerifiedProvider = Provider<bool>((ref) {
  // Escuchar cambios de auth para re-evaluar
  ref.watch(authStateChangesProvider);
  final repo = ref.watch(authRepositoryProvider);
  return repo.isEmailVerified;
});

/// Provider del email actual (null si es anónimo)
/// Se actualiza automáticamente cuando cambia el estado de auth
final currentEmailProvider = Provider<String?>((ref) {
  // Escuchar cambios de auth para re-evaluar
  ref.watch(authStateChangesProvider);
  final repo = ref.watch(authRepositoryProvider);
  return repo.currentEmail;
});

/// Provider del estado de autenticación actual
/// Se actualiza automáticamente cuando cambia el estado de auth
final authStatusProvider = Provider<AuthStatus>((ref) {
  // Escuchar cambios de auth para re-evaluar
  ref.watch(authStateChangesProvider);
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStatus;
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
      // Log analytics event
      AnalyticsService().logEmailLinked();
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
      // Log analytics event
      AnalyticsService().logLogin(method: 'email');
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
  /// NO cambia el estado a success para evitar navegación automática en LoginScreen
  Future<bool> sendPasswordResetEmail(String email) async {
    final result = await _repository.sendPasswordResetEmail(email.trim());

    if (result.success) {
      // NO establecer state.success - solo retornar true
      // Esto evita que el listener en LoginScreen navegue a Home
      return true;
    } else {
      state = AuthNotifierState.error(
        result.errorMessage ?? 'Error al enviar email',
        result.errorCode,
      );
      return false;
    }
  }

  /// Actualiza la contraseña del usuario (usado después de password recovery)
  Future<bool> updatePassword(String newPassword) async {
    state = AuthNotifierState.loading();

    final result = await _repository.updatePassword(newPassword);

    if (result.success) {
      state = AuthNotifierState.success();
      return true;
    } else {
      state = AuthNotifierState.error(
        result.errorMessage ?? 'Error al cambiar contraseña',
        result.errorCode,
      );
      return false;
    }
  }

  /// Refresca la sesión para obtener datos actualizados
  Future<bool> refreshSession() async {
    state = AuthNotifierState.loading();

    final result = await _repository.refreshSession();

    if (result.success) {
      state = AuthNotifierState.success();
      return true;
    } else {
      state = AuthNotifierState.error(
        result.errorMessage ?? 'Error al refrescar sesión',
        result.errorCode,
      );
      return false;
    }
  }

  /// Elimina la cuenta del usuario y todos sus datos
  Future<bool> deleteAccount() async {
    state = AuthNotifierState.loading();

    // Log analytics event BEFORE deleting (after delete, user won't exist)
    AnalyticsService().logAccountDeleted();

    final result = await _repository.deleteAccount();

    if (result.success) {
      // El listener de auth detectará que el usuario ya no existe
      // y redirigirá automáticamente a Splash
      state = AuthNotifierState.success();
      return true;
    } else {
      state = AuthNotifierState.error(
        result.errorMessage ?? 'Error al borrar cuenta',
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
