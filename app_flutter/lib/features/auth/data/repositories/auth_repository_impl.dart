import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:functions_client/functions_client.dart' show FunctionException, HttpMethod;

import '../../domain/repositories/auth_repository.dart';

/// Implementación del repositorio de autenticación con Supabase
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase;

  AuthRepositoryImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  @override
  User? get currentUser => _supabase.auth.currentUser;

  @override
  Session? get currentSession => _supabase.auth.currentSession;

  @override
  bool get isAnonymous {
    final user = currentUser;
    if (user == null) return true;
    // Usuario es anónimo si no tiene email ni email pendiente (newEmail)
    final hasEmail = user.email != null && user.email!.isNotEmpty;
    final hasPendingEmail = user.newEmail != null && user.newEmail!.isNotEmpty;
    return !hasEmail && !hasPendingEmail;
  }

  @override
  bool get isEmailVerified {
    final user = currentUser;
    if (user == null) return false;
    if (user.email == null) return false;
    return user.emailConfirmedAt != null;
  }

  @override
  String? get currentEmail {
    final user = currentUser;
    if (user == null) return null;
    // Priorizar email confirmado, sino el pendiente (newEmail)
    if (user.email != null && user.email!.isNotEmpty) return user.email;
    return user.newEmail;
  }

  @override
  AuthStatus get authStatus {
    final user = currentUser;
    if (user == null) return AuthStatus.anonymous;
    final hasEmail = user.email != null && user.email!.isNotEmpty;
    final hasPendingEmail = user.newEmail != null && user.newEmail!.isNotEmpty;
    if (!hasEmail && !hasPendingEmail) return AuthStatus.anonymous;
    if (hasPendingEmail || user.emailConfirmedAt == null) return AuthStatus.emailUnverified;
    return AuthStatus.emailVerified;
  }

  @override
  Stream<AuthState> get onAuthStateChange => _supabase.auth.onAuthStateChange;

  @override
  Future<AuthResult> signInAnonymously() async {
    try {
      final response = await _supabase.auth.signInAnonymously();
      if (response.user != null) {
        return AuthResult.success();
      }
      return AuthResult.error('No se pudo crear la sesión anónima');
    } on AuthException catch (e) {
      return _handleAuthException(e);
    } catch (e) {
      if (_isNetworkError(e)) {
        return AuthResult.error('No tienes conexión a internet', 'network_error');
      }
      return AuthResult.error('Error inesperado: $e');
    }
  }

  @override
  Future<AuthResult> linkEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Validaciones básicas
      if (email.isEmpty) {
        return AuthResult.error('El email es requerido', 'empty_email');
      }
      if (password.length < 6) {
        return AuthResult.error(
          'La contraseña debe tener mínimo 6 caracteres',
          'weak_password',
        );
      }

      // updateUser vincula el email preservando el mismo user_id
      final response = await _supabase.auth.updateUser(
        UserAttributes(
          email: email,
          password: password,
        ),
      );

      if (response.user != null) {
        // Supabase envía email de verificación automáticamente
        return AuthResult.success();
      }
      return AuthResult.error('No se pudo vincular el email');
    } on AuthException catch (e) {
      return _handleAuthException(e);
    } catch (e) {
      if (_isNetworkError(e)) {
        return AuthResult.error('No tienes conexión a internet', 'network_error');
      }
      return AuthResult.error('Error inesperado: $e');
    }
  }

  @override
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return AuthResult.success();
      }
      return AuthResult.error('Credenciales incorrectas', 'invalid_credentials');
    } on AuthException catch (e) {
      return _handleAuthException(e);
    } catch (e) {
      if (_isNetworkError(e)) {
        return AuthResult.error('No tienes conexión a internet', 'network_error');
      }
      return AuthResult.error('Error inesperado: $e');
    }
  }

  @override
  Future<AuthResult> signOut() async {
    try {
      await _supabase.auth.signOut();
      return AuthResult.success();
    } on AuthException catch (e) {
      return _handleAuthException(e);
    } catch (e) {
      if (_isNetworkError(e)) {
        return AuthResult.error('No tienes conexión a internet', 'network_error');
      }
      return AuthResult.error('Error al cerrar sesión: $e');
    }
  }

  @override
  Future<AuthResult> resendVerificationEmail() async {
    try {
      final email = currentEmail;
      if (email == null) {
        return AuthResult.error('No hay email para verificar');
      }

      await _supabase.auth.resend(
        type: OtpType.email,
        email: email,
      );
      return AuthResult.success();
    } on AuthException catch (e) {
      return _handleAuthException(e);
    } catch (e) {
      if (_isNetworkError(e)) {
        return AuthResult.error('No tienes conexión a internet', 'network_error');
      }
      return AuthResult.error('Error al reenviar email: $e');
    }
  }

  @override
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return AuthResult.success();
    } on AuthException catch (e) {
      return _handleAuthException(e);
    } catch (e) {
      if (_isNetworkError(e)) {
        return AuthResult.error('No tienes conexión a internet', 'network_error');
      }
      return AuthResult.error('Error al enviar email: $e');
    }
  }

  @override
  Future<AuthResult> refreshSession() async {
    try {
      final response = await _supabase.auth.refreshSession();
      if (response.session != null) {
        return AuthResult.success();
      }
      return AuthResult.error('No se pudo refrescar la sesión');
    } on AuthException catch (e) {
      return _handleAuthException(e);
    } catch (e) {
      if (_isNetworkError(e)) {
        return AuthResult.error('No tienes conexión a internet', 'network_error');
      }
      return AuthResult.error('Error al refrescar sesión: $e');
    }
  }

  @override
  Future<AuthResult> updatePassword(String newPassword) async {
    try {
      if (newPassword.length < 6) {
        return AuthResult.error(
          'La contraseña debe tener mínimo 6 caracteres',
          'weak_password',
        );
      }

      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return AuthResult.success();
    } on AuthException catch (e) {
      return _handleAuthException(e);
    } catch (e) {
      if (_isNetworkError(e)) {
        return AuthResult.error('No tienes conexión a internet', 'network_error');
      }
      return AuthResult.error('Error al cambiar contraseña: $e');
    }
  }

  @override
  Future<AuthResult> deleteAccount() async {
    try {
      final response = await _supabase.functions.invoke(
        'delete-account',
        method: HttpMethod.post,
      );

      final data = response.data as Map<String, dynamic>?;
      if (data?['success'] == true) {
        // Limpiar sesión local después de borrar cuenta en servidor
        await _supabase.auth.signOut();
        return AuthResult.success();
      } else {
        return AuthResult.error(
          data?['error'] ?? 'Error al borrar cuenta',
          'delete_failed',
        );
      }
    } on FunctionException catch (e) {
      return AuthResult.error(
        'Error del servidor: ${e.details}',
        'function_error',
      );
    } catch (e) {
      if (_isNetworkError(e)) {
        return AuthResult.error('No tienes conexión a internet', 'network_error');
      }
      return AuthResult.error('Error de conexión: $e', 'connection_error');
    }
  }

  /// Detecta si un error es de red (sin conexión a internet)
  bool _isNetworkError(Object e) {
    final msg = e.toString().toLowerCase();
    return msg.contains('socketexception') ||
        msg.contains('failed host lookup') ||
        msg.contains('no address associated') ||
        msg.contains('connection refused') ||
        msg.contains('network is unreachable') ||
        msg.contains('connection timed out') ||
        msg.contains('clientexception');
  }

  /// Maneja las excepciones de Supabase Auth y devuelve mensajes amigables
  AuthResult _handleAuthException(AuthException e) {
    final message = e.message.toLowerCase();

    // Sin conexión a internet (Supabase envuelve SocketException en AuthException)
    if (message.contains('socketexception') ||
        message.contains('failed host lookup') ||
        message.contains('no address associated') ||
        message.contains('clientexception') ||
        message.contains('connection refused') ||
        message.contains('network is unreachable')) {
      return AuthResult.error(
        'No tienes conexión a internet',
        'network_error',
      );
    }

    // Email ya existe
    if (message.contains('already registered') ||
        message.contains('already been registered') ||
        message.contains('user already registered')) {
      return AuthResult.error(
        'Este email ya está registrado. Intenta iniciar sesión.',
        'email_exists',
      );
    }

    // Email inválido
    if (message.contains('invalid email') ||
        message.contains('unable to validate email')) {
      return AuthResult.error(
        'Ingresa un email válido',
        'invalid_email',
      );
    }

    // Misma contraseña
    if (message.contains('new password should be different')) {
      return AuthResult.error(
        'La nueva contraseña debe ser diferente a la anterior',
        'same_password',
      );
    }

    // Contraseña débil
    if (message.contains('password') &&
        (message.contains('weak') ||
            message.contains('short') ||
            message.contains('at least'))) {
      return AuthResult.error(
        'La contraseña debe tener mínimo 6 caracteres',
        'weak_password',
      );
    }

    // Credenciales inválidas
    if (message.contains('invalid login credentials') ||
        message.contains('invalid credentials')) {
      return AuthResult.error(
        'Email o contraseña incorrectos',
        'invalid_credentials',
      );
    }

    // Email no confirmado
    if (message.contains('email not confirmed')) {
      return AuthResult.error(
        'Debes verificar tu email antes de iniciar sesión',
        'email_not_confirmed',
      );
    }

    // Rate limit
    if (message.contains('rate limit') ||
        message.contains('too many') ||
        message.contains('for security purposes') ||
        message.contains('you can only request this after')) {
      return AuthResult.error(
        'Demasiados intentos. Espera unos segundos.',
        'rate_limit',
      );
    }

    // Error genérico
    return AuthResult.error(
      'Error de autenticación: ${e.message}',
      'auth_error',
    );
  }
}
