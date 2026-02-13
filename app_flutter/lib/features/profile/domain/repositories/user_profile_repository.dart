import '../entities/user_profile.dart';

/// Interface para el repositorio de perfiles de usuario
abstract class UserProfileRepository {
  /// Obtiene el perfil del usuario actual
  Future<UserProfile?> getCurrentUserProfile();

  /// Actualiza el perfil del usuario
  Future<UserProfile> updateProfile(UserProfile profile);

  /// Completa el onboarding con los datos recopilados
  Future<UserProfile> completeOnboarding({
    required String userId,
    String? name,
    GenderType? gender,
    OriginGroup? origin,
    String? countryCode,
    AgeGroup? ageGroup,
    Denomination? denomination,
    String? bibleVersionCode,
    String? features,
    String? motive,
    bool? reminderEnabled,
    DateTime? reminderTime,
    bool? persistenceSelfReport,
    String? timezone,
  });

  /// Verifica si el usuario ha completado el onboarding
  Future<bool> hasCompletedOnboarding();

  /// Escucha cambios en el perfil del usuario
  Stream<UserProfile?> watchCurrentUserProfile();
}
