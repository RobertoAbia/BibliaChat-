import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/user_profile_remote_datasource.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';

/// Provider que extrae solo el user ID del estado de auth
/// Solo emite cuando el user ID REALMENTE cambia (no en cada evento de auth)
final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.value?.session?.user.id;
});

/// Provider para el datasource remoto
final userProfileDatasourceProvider = Provider<UserProfileRemoteDatasource>(
  (ref) => UserProfileRemoteDatasource(),
);

/// Provider para el repositorio
final userProfileRepositoryProvider = Provider<UserProfileRepository>(
  (ref) => UserProfileRepositoryImpl(
    remoteDatasource: ref.watch(userProfileDatasourceProvider),
  ),
);

/// Provider para el perfil del usuario actual
final currentUserProfileProvider = FutureProvider<UserProfile?>((ref) async {
  // Solo invalidar cuando el user ID cambie, no en cada evento de auth
  ref.watch(currentUserIdProvider);

  final repository = ref.watch(userProfileRepositoryProvider);
  return await repository.getCurrentUserProfile();
});

/// Provider que escucha cambios en el perfil en tiempo real
final userProfileStreamProvider = StreamProvider<UserProfile?>((ref) {
  // Solo invalidar cuando el user ID cambie
  ref.watch(currentUserIdProvider);

  final repository = ref.watch(userProfileRepositoryProvider);
  return repository.watchCurrentUserProfile();
});

/// Provider para verificar si el onboarding está completado
final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) async {
  // Solo invalidar cuando el user ID cambie
  ref.watch(currentUserIdProvider);

  final repository = ref.watch(userProfileRepositoryProvider);
  return await repository.hasCompletedOnboarding();
});

/// Estado para el proceso de onboarding
class OnboardingState {
  final String? name;
  final String? ageGroup;
  final String? gender;
  final String? origin; // origin_group de la BD
  final String? countryCode; // ISO 3166-1 alpha-2 (e.g., MX, ES, CO)
  final String? denomination;
  final String? bibleVersionCode;
  final Set<String> supportTypes;
  final String? motive;
  final String? motiveDetail;
  final String? commitmentLevel; // high, medium, low
  final bool reminderEnabled;
  final TimeOfDay reminderTime;
  final bool isLoading;
  final String? error;

  const OnboardingState({
    this.name,
    this.ageGroup,
    this.gender,
    this.origin,
    this.countryCode,
    this.denomination,
    this.bibleVersionCode,
    this.supportTypes = const {},
    this.motive,
    this.motiveDetail,
    this.commitmentLevel,
    this.reminderEnabled = false,
    this.reminderTime = const TimeOfDay(hour: 8, minute: 0),
    this.isLoading = false,
    this.error,
  });

  OnboardingState copyWith({
    String? name,
    String? ageGroup,
    String? gender,
    String? origin,
    String? countryCode,
    String? denomination,
    String? bibleVersionCode,
    Set<String>? supportTypes,
    String? motive,
    String? motiveDetail,
    bool clearMotiveDetail = false,
    String? commitmentLevel,
    bool? reminderEnabled,
    TimeOfDay? reminderTime,
    bool? isLoading,
    String? error,
  }) {
    return OnboardingState(
      name: name ?? this.name,
      ageGroup: ageGroup ?? this.ageGroup,
      gender: gender ?? this.gender,
      origin: origin ?? this.origin,
      countryCode: countryCode ?? this.countryCode,
      denomination: denomination ?? this.denomination,
      bibleVersionCode: bibleVersionCode ?? this.bibleVersionCode,
      supportTypes: supportTypes ?? this.supportTypes,
      motive: motive ?? this.motive,
      motiveDetail: clearMotiveDetail ? null : (motiveDetail ?? this.motiveDetail),
      commitmentLevel: commitmentLevel ?? this.commitmentLevel,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Devuelve las keys de supportTypes como string separado por comas
  String? get features =>
      supportTypes.isNotEmpty ? supportTypes.join(',') : null;

  /// Convierte ageGroup string a AgeGroup enum
  AgeGroup? get ageGroupEnum => AgeGroup.fromString(ageGroup);

  /// Convierte denomination string a Denomination enum
  Denomination? get denominationEnum => Denomination.fromString(denomination);

  /// Convierte gender string a GenderType enum
  GenderType? get genderEnum => GenderType.fromString(gender);

  /// Convierte origin string a OriginGroup enum
  OriginGroup? get originEnum => OriginGroup.fromString(origin);
}

/// Notifier para manejar el estado del onboarding
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final UserProfileRepository _repository;

  OnboardingNotifier(this._repository) : super(const OnboardingState());

  void setName(String value) {
    state = state.copyWith(name: value.trim().isEmpty ? null : value.trim());
  }

  void setAgeGroup(String value) {
    state = state.copyWith(ageGroup: value);
  }

  void setGender(String value) {
    state = state.copyWith(gender: value);
  }

  void setOrigin(String value) {
    state = state.copyWith(origin: value);
  }

  void setCountryCode(String value) {
    state = state.copyWith(countryCode: value);
  }

  void setDenomination(String value) {
    state = state.copyWith(denomination: value);
  }

  void setBibleVersion(String value) {
    state = state.copyWith(bibleVersionCode: value);
  }

  void toggleSupportType(String key) {
    final current = Set<String>.from(state.supportTypes);
    if (current.contains(key)) {
      current.remove(key);
    } else {
      current.add(key);
    }
    state = state.copyWith(supportTypes: current);
  }

  void setMotive(String value) {
    state = state.copyWith(motive: value, clearMotiveDetail: true);
  }

  void setMotiveDetail(String value) {
    state = state.copyWith(motiveDetail: value);
  }

  void setCommitmentLevel(String value) {
    state = state.copyWith(commitmentLevel: value);
  }

  void setReminderEnabled(bool value) {
    state = state.copyWith(reminderEnabled: value);
  }

  void setReminderTime(TimeOfDay value) {
    state = state.copyWith(reminderTime: value);
  }

  /// Convierte TimeOfDay a DateTime para guardar en BD
  DateTime? _timeOfDayToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  /// Completa el onboarding guardando los datos en Supabase
  Future<bool> completeOnboarding() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'No hay usuario autenticado',
        );
        return false;
      }

      // Auto-detectar timezone
      String? timezone;
      try {
        timezone = await FlutterTimezone.getLocalTimezone();
      } catch (e) {
        // Si falla, usar default America/New_York
        timezone = 'America/New_York';
      }

      await _repository.completeOnboarding(
        userId: userId,
        name: state.name,
        gender: state.genderEnum,
        origin: state.originEnum,
        countryCode: state.countryCode,
        ageGroup: state.ageGroupEnum,
        denomination: state.denominationEnum,
        bibleVersionCode: state.bibleVersionCode,
        features: state.features,
        persistenceSelfReport: state.commitmentLevel != null
            ? state.commitmentLevel != 'low'
            : null,
        motive: state.motive,
        motiveDetail: state.motiveDetail,
        reminderEnabled: state.reminderEnabled,
        reminderTime: state.reminderEnabled
            ? _timeOfDayToDateTime(state.reminderTime)
            : null,
        timezone: timezone,
      );

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al guardar: $e',
      );
      return false;
    }
  }

  /// Resetea el estado del onboarding
  void reset() {
    state = const OnboardingState();
  }
}

/// Provider para el notifier del onboarding
/// Se resetea automáticamente cuando cambia el usuario (logout → nuevo anónimo)
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  // Escuchar cambios de user ID para resetear cuando cambia el usuario
  ref.listen(currentUserIdProvider, (previous, next) {
    if (previous != null && previous != next) {
      // El usuario cambió, resetear estado
      ref.invalidateSelf();
    }
  });

  final repository = ref.watch(userProfileRepositoryProvider);
  return OnboardingNotifier(repository);
});
