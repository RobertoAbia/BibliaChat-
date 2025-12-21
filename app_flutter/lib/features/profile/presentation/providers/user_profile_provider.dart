import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/user_profile_remote_datasource.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';

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
  final repository = ref.watch(userProfileRepositoryProvider);
  return await repository.getCurrentUserProfile();
});

/// Provider que escucha cambios en el perfil en tiempo real
final userProfileStreamProvider = StreamProvider<UserProfile?>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return repository.watchCurrentUserProfile();
});

/// Provider para verificar si el onboarding está completado
final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(userProfileRepositoryProvider);
  return await repository.hasCompletedOnboarding();
});

/// Estado para el proceso de onboarding
class OnboardingState {
  final String? name;
  final String? ageGroup;
  final String? gender;
  final String? denomination;
  final String? bibleVersionCode;
  final String? supportType;
  final String? heartMessage;
  final bool isLoading;
  final String? error;

  const OnboardingState({
    this.name,
    this.ageGroup,
    this.gender,
    this.denomination,
    this.bibleVersionCode,
    this.supportType,
    this.heartMessage,
    this.isLoading = false,
    this.error,
  });

  OnboardingState copyWith({
    String? name,
    String? ageGroup,
    String? gender,
    String? denomination,
    String? bibleVersionCode,
    String? supportType,
    String? heartMessage,
    bool? isLoading,
    String? error,
  }) {
    return OnboardingState(
      name: name ?? this.name,
      ageGroup: ageGroup ?? this.ageGroup,
      gender: gender ?? this.gender,
      denomination: denomination ?? this.denomination,
      bibleVersionCode: bibleVersionCode ?? this.bibleVersionCode,
      supportType: supportType ?? this.supportType,
      heartMessage: heartMessage ?? this.heartMessage,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Convierte supportType a MotiveType
  MotiveType? get motive {
    switch (supportType) {
      case 'study':
        return MotiveType.estudio;
      case 'overcome':
        return MotiveType.sufrimiento;
      default:
        return null;
    }
  }

  /// Convierte ageGroup string a AgeGroup enum
  AgeGroup? get ageGroupEnum => AgeGroup.fromString(ageGroup);

  /// Convierte denomination string a Denomination enum
  Denomination? get denominationEnum => Denomination.fromString(denomination);

  /// Convierte gender string a GenderType enum
  GenderType? get genderEnum => GenderType.fromString(gender);
}

/// Notifier para manejar el estado del onboarding
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final UserProfileRepository _repository;

  OnboardingNotifier(this._repository) : super(const OnboardingState());

  void setAgeGroup(String value) {
    state = state.copyWith(ageGroup: value);
  }

  void setGender(String value) {
    state = state.copyWith(gender: value);
  }

  void setDenomination(String value) {
    state = state.copyWith(denomination: value);
  }

  void setBibleVersion(String value) {
    state = state.copyWith(bibleVersionCode: value);
  }

  void setSupportType(String value) {
    state = state.copyWith(supportType: value);
  }

  void setHeartMessage(String value) {
    state = state.copyWith(heartMessage: value);
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

      await _repository.completeOnboarding(
        userId: userId,
        gender: state.genderEnum,
        ageGroup: state.ageGroupEnum,
        denomination: state.denominationEnum,
        bibleVersionCode: state.bibleVersionCode,
        motive: state.motive,
        firstMessage: state.heartMessage,
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
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return OnboardingNotifier(repository);
});
