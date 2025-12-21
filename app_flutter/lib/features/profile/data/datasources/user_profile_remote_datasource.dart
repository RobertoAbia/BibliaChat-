import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile_model.dart';

/// Datasource remoto para perfiles de usuario (Supabase)
class UserProfileRemoteDatasource {
  final SupabaseClient _client;

  UserProfileRemoteDatasource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Obtiene el perfil del usuario actual
  Future<UserProfileModel?> getCurrentUserProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from('user_profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserProfileModel.fromJson(response);
  }

  /// Obtiene un perfil por user_id
  Future<UserProfileModel?> getProfileByUserId(String userId) async {
    final response = await _client
        .from('user_profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserProfileModel.fromJson(response);
  }

  /// Actualiza el perfil del usuario
  Future<UserProfileModel> updateProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final response = await _client
        .from('user_profiles')
        .update(data)
        .eq('user_id', userId)
        .select()
        .single();

    return UserProfileModel.fromJson(response);
  }

  /// Stream de cambios en el perfil del usuario actual
  Stream<UserProfileModel?> watchCurrentUserProfile() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return Stream.value(null);

    return _client
        .from('user_profiles')
        .stream(primaryKey: ['user_id'])
        .eq('user_id', userId)
        .map((data) {
          if (data.isEmpty) return null;
          return UserProfileModel.fromJson(data.first);
        });
  }

  /// Verifica si existe un perfil para el usuario
  Future<bool> profileExists(String userId) async {
    final response = await _client
        .from('user_profiles')
        .select('user_id')
        .eq('user_id', userId)
        .maybeSingle();

    return response != null;
  }

  /// Crea un perfil inicial (normalmente lo hace el trigger)
  Future<UserProfileModel> createProfile(String userId) async {
    final response = await _client
        .from('user_profiles')
        .insert({'user_id': userId})
        .select()
        .single();

    return UserProfileModel.fromJson(response);
  }
}
