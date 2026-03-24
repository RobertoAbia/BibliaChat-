import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'user_profile_provider.dart';

/// Estado del formulario de edición de perfil
class ProfileEditState {
  final String? name;
  final GenderType? gender;
  final Denomination? denomination;
  final OriginGroup? origin;
  final String? countryCode;
  final AgeGroup? ageGroup;
  final String bibleVersionCode;
  final bool reminderEnabled;
  final DateTime? reminderTime;
  final bool isLoading;
  final bool isSaved;
  final String? error;

  const ProfileEditState({
    this.name,
    this.gender,
    this.denomination,
    this.origin,
    this.countryCode,
    this.ageGroup,
    this.bibleVersionCode = 'RVR1960',
    this.reminderEnabled = false,
    this.reminderTime,
    this.isLoading = false,
    this.isSaved = false,
    this.error,
  });

  ProfileEditState copyWith({
    String? name,
    GenderType? gender,
    Denomination? denomination,
    OriginGroup? origin,
    String? countryCode,
    AgeGroup? ageGroup,
    String? bibleVersionCode,
    bool? reminderEnabled,
    DateTime? reminderTime,
    bool? isLoading,
    bool? isSaved,
    String? error,
  }) {
    return ProfileEditState(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      denomination: denomination ?? this.denomination,
      origin: origin ?? this.origin,
      countryCode: countryCode ?? this.countryCode,
      ageGroup: ageGroup ?? this.ageGroup,
      bibleVersionCode: bibleVersionCode ?? this.bibleVersionCode,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      error: error,
    );
  }

  factory ProfileEditState.fromProfile(UserProfile profile) {
    return ProfileEditState(
      name: profile.name,
      gender: profile.gender,
      denomination: profile.denomination,
      origin: profile.origin,
      countryCode: profile.countryCode,
      ageGroup: profile.ageGroup,
      bibleVersionCode: profile.bibleVersionCode,
      reminderEnabled: profile.reminderEnabled,
      reminderTime: profile.reminderTime,
    );
  }
}

/// Notifier para manejar la edición del perfil
class ProfileEditNotifier extends StateNotifier<ProfileEditState> {
  final UserProfileRepository _repository;
  UserProfile? _originalProfile;

  ProfileEditNotifier(this._repository) : super(const ProfileEditState());

  /// Carga el perfil actual en el estado
  void loadProfile(UserProfile profile) {
    _originalProfile = profile;
    state = ProfileEditState.fromProfile(profile);
  }

  /// Actualiza el nombre
  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  /// Actualiza el género
  void updateGender(GenderType value) {
    state = state.copyWith(gender: value);
  }

  /// Actualiza la denominación
  void updateDenomination(Denomination value) {
    state = state.copyWith(denomination: value);
  }

  /// Actualiza el origen/región
  void updateOrigin(OriginGroup value) {
    state = state.copyWith(origin: value);
  }

  /// Actualiza el código de país
  void updateCountryCode(String value) {
    state = state.copyWith(countryCode: value);
  }

  /// Actualiza el grupo de edad
  void updateAgeGroup(AgeGroup value) {
    state = state.copyWith(ageGroup: value);
  }

  /// Actualiza la versión de la Biblia
  void updateBibleVersion(String value) {
    state = state.copyWith(bibleVersionCode: value);
  }

  /// Actualiza si el recordatorio está activo
  void updateReminderEnabled(bool value) {
    state = state.copyWith(reminderEnabled: value);
    // Si activa el recordatorio y no tiene hora, poner 08:00 por defecto
    if (value && state.reminderTime == null) {
      final now = DateTime.now();
      state = state.copyWith(reminderTime: DateTime(now.year, now.month, now.day, 8, 0));
    }
  }

  /// Actualiza el valor original de reminderEnabled (para sincronizar la baseline
  /// cuando el sistema fuerza un cambio, ej: permisos revocados)
  void updateOriginalReminderEnabled(bool value) {
    if (_originalProfile != null) {
      _originalProfile = _originalProfile!.copyWith(reminderEnabled: value);
    }
  }

  /// Actualiza la hora del recordatorio
  void updateReminderTime(DateTime? value) {
    state = state.copyWith(reminderTime: value);
  }

  /// Verifica si hay cambios sin guardar
  bool get hasChanges {
    if (_originalProfile == null) return false;
    return state.name != _originalProfile!.name ||
        state.gender != _originalProfile!.gender ||
        state.denomination != _originalProfile!.denomination ||
        state.origin != _originalProfile!.origin ||
        state.countryCode != _originalProfile!.countryCode ||
        state.ageGroup != _originalProfile!.ageGroup ||
        state.bibleVersionCode != _originalProfile!.bibleVersionCode ||
        state.reminderEnabled != _originalProfile!.reminderEnabled ||
        state.reminderTime != _originalProfile!.reminderTime;
  }

  /// Guarda los cambios en Supabase
  Future<bool> saveChanges() async {
    if (_originalProfile == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final updated = _originalProfile!.copyWith(
        name: state.name,
        gender: state.gender,
        denomination: state.denomination,
        origin: state.origin,
        countryCode: state.countryCode,
        ageGroup: state.ageGroup,
        bibleVersionCode: state.bibleVersionCode,
        reminderEnabled: state.reminderEnabled,
        reminderTime: state.reminderTime,
      );

      await _repository.updateProfile(updated);
      _originalProfile = updated;
      state = state.copyWith(isLoading: false, isSaved: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Resetea el flag de guardado
  void resetSavedFlag() {
    state = state.copyWith(isSaved: false);
  }
}

/// Provider del notifier de edición de perfil
final profileEditProvider =
    StateNotifierProvider.autoDispose<ProfileEditNotifier, ProfileEditState>(
        (ref) {
  final repo = ref.watch(userProfileRepositoryProvider);
  return ProfileEditNotifier(repo);
});
