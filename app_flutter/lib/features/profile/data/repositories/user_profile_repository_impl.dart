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
    AgeGroup? ageGroup,
    Denomination? denomination,
    String? bibleVersionCode,
    MotiveType? motive,
    String? firstMessage,
  }) async {
    final updateData = UserProfileModel.toUpdateJson(
      name: name,
      ageGroup: ageGroup,
      denomination: denomination,
      bibleVersionCode: bibleVersionCode,
      motive: motive,
      firstMessage: firstMessage,
      onboardingCompleted: true,
    );

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
