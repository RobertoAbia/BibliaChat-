import 'package:supabase_flutter/supabase_flutter.dart';

/// Estados de autenticación posibles
enum AuthStatus {
  /// Usuario anónimo (sin email vinculado)
  anonymous,

  /// Email vinculado pero no verificado
  emailUnverified,

  /// Email vinculado y verificado
  emailVerified,
}

/// Resultado de operaciones de auth
class AuthResult {
  final bool success;
  final String? errorMessage;
  final String? errorCode;

  const AuthResult({
    required this.success,
    this.errorMessage,
    this.errorCode,
  });

  factory AuthResult.success() => const AuthResult(success: true);

  factory AuthResult.error(String message, [String? code]) => AuthResult(
        success: false,
        errorMessage: message,
        errorCode: code,
      );
}

/// Interface del repositorio de autenticación
abstract class AuthRepository {
  /// Usuario actual de Supabase
  User? get currentUser;

  /// Sesión actual
  Session? get currentSession;

  /// Verifica si el usuario actual es anónimo
  bool get isAnonymous;

  /// Verifica si el email está verificado
  bool get isEmailVerified;

  /// Email del usuario actual (null si es anónimo)
  String? get currentEmail;

  /// Obtiene el estado de autenticación actual
  AuthStatus get authStatus;

  /// Stream de cambios en el estado de auth
  Stream<AuthState> get onAuthStateChange;

  /// Crea una sesión anónima
  Future<AuthResult> signInAnonymously();

  /// Vincula email/password a cuenta anónima (upgrade)
  /// Preserva el mismo user_id y todos los datos
  Future<AuthResult> linkEmail({
    required String email,
    required String password,
  });

  /// Inicia sesión con email/password
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  });

  /// Cierra sesión
  Future<AuthResult> signOut();

  /// Reenvía el email de verificación
  Future<AuthResult> resendVerificationEmail();

  /// Envía email para recuperar contraseña
  Future<AuthResult> sendPasswordResetEmail(String email);

  /// Refresca la sesión actual para obtener datos actualizados del usuario
  Future<AuthResult> refreshSession();

  /// Actualiza la contraseña del usuario (usado después de password recovery)
  Future<AuthResult> updatePassword(String newPassword);
}
