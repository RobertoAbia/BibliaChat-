import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

/// Implementación del repositorio de perfiles de usuario
class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDatasource _remoteDatasource;

  UserProfileRepositoryImpl({UserProfileRemoteDatasource? remoteDatasource})
      : _remoteDatasource =
            remoteDatasource ?? UserProfileRemoteDatasource();

  @override
  Future<UserProfile?> getCurrentUserProfile() async {
    return await _remoteDatasource.getCurrentUserProfile();
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    final model = UserProfileModel.fromEntity(profile);
    return await _remoteDatasource.updateProfile(
      profile.userId,
      model.toJson(),
    );
  }

  @override
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
    String? motiveDetail,
    bool? reminderEnabled,
    DateTime? reminderTime,
    bool? persistenceSelfReport,
    String? timezone,
    bool consentGiven = false,
  }) async {
    final updateData = UserProfileModel.toUpdateJson(
      name: name,
      gender: gender,
      origin: origin,
      countryCode: countryCode,
      ageGroup: ageGroup,
      denomination: denomination,
      bibleVersionCode: bibleVersionCode,
      features: features,
      motive: motive,
      motiveDetail: motiveDetail,
      reminderEnabled: reminderEnabled,
      reminderTime: reminderTime,
      persistenceSelfReport: persistenceSelfReport,
      timezone: timezone,
      onboardingCompleted: true,
    );

    // Timestamps de consentimiento GDPR:
    // - consent_terms_at (términos + privacidad): siempre. Lo respalda el
    //   texto de la Welcome ("Al continuar, aceptas nuestros Términos...")
    //   que todo usuario ve al empezar el onboarding.
    // - consent_data_at (Art. 9, datos religiosos): SOLO si la página de
    //   consentimiento se mostró y se aceptó. El Art. 9 exige consentimiento
    //   EXPLÍCITO (checkbox); con el paso oculto por Remote Config se estaba
    //   registrando un consentimiento explícito que el usuario nunca dio.
    updateData['consent_terms_at'] = DateTime.now().toUtc().toIso8601String();
    if (consentGiven) {
      updateData['consent_data_at'] = DateTime.now().toUtc().toIso8601String();
    }

    return await _remoteDatasource.updateProfile(userId, updateData);
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    final profile = await _remoteDatasource.getCurrentUserProfile();
    return profile?.onboardingCompleted ?? false;
  }

  @override
  Stream<UserProfile?> watchCurrentUserProfile() {
    return _remoteDatasource.watchCurrentUserProfile();
  }

  /// Obtiene el ID del usuario actual o lanza excepción
  String getCurrentUserId() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('No authenticated user');
    }
    return userId;
  }
}
