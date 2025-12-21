import '../../domain/entities/user_profile.dart';

/// Modelo de datos para UserProfile - maneja serialización JSON
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.userId,
    super.name,
    super.denomination,
    super.origin,
    super.ageGroup,
    super.motive,
    super.reminderEnabled,
    super.reminderTime,
    super.persistenceSelfReport,
    super.firstMessage,
    super.bibleVersionCode,
    super.aiMemory,
    super.timezone,
    super.onboardingCompleted,
    super.theme,
    super.rcAppUserId,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Crea un modelo desde un Map de Supabase
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['user_id'] as String,
      name: json['name'] as String?,
      denomination: Denomination.fromString(json['denomination'] as String?),
      origin: OriginGroup.fromString(json['origin'] as String?),
      ageGroup: AgeGroup.fromString(json['age_group'] as String?),
      motive: MotiveType.fromString(json['motive'] as String?),
      reminderEnabled: json['reminder_enabled'] as bool? ?? false,
      reminderTime: json['reminder_time'] != null
          ? _parseTime(json['reminder_time'] as String)
          : null,
      persistenceSelfReport: json['persistence_self_report'] as bool?,
      firstMessage: json['first_message'] as String?,
      bibleVersionCode: json['bible_version_code'] as String? ?? 'RVR1960',
      aiMemory: json['ai_memory'] as Map<String, dynamic>?,
      timezone: json['timezone'] as String? ?? 'America/New_York',
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      theme: json['theme'] as String? ?? 'auto',
      rcAppUserId: json['rc_app_user_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convierte el modelo a Map para Supabase
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      if (name != null) 'name': name,
      if (denomination != null) 'denomination': denomination!.dbValue,
      if (origin != null) 'origin': origin!.dbValue,
      if (ageGroup != null) 'age_group': ageGroup!.dbValue,
      if (motive != null) 'motive': motive!.dbValue,
      'reminder_enabled': reminderEnabled,
      if (reminderTime != null) 'reminder_time': _formatTime(reminderTime!),
      if (persistenceSelfReport != null)
        'persistence_self_report': persistenceSelfReport,
      if (firstMessage != null) 'first_message': firstMessage,
      'bible_version_code': bibleVersionCode,
      if (aiMemory != null) 'ai_memory': aiMemory,
      'timezone': timezone,
      'onboarding_completed': onboardingCompleted,
      'theme': theme,
      if (rcAppUserId != null) 'rc_app_user_id': rcAppUserId,
    };
  }

  /// Convierte un Map de actualización parcial (solo campos modificados)
  static Map<String, dynamic> toUpdateJson({
    String? name,
    Denomination? denomination,
    OriginGroup? origin,
    AgeGroup? ageGroup,
    MotiveType? motive,
    bool? reminderEnabled,
    DateTime? reminderTime,
    bool? persistenceSelfReport,
    String? firstMessage,
    String? bibleVersionCode,
    Map<String, dynamic>? aiMemory,
    String? timezone,
    bool? onboardingCompleted,
    String? theme,
    String? rcAppUserId,
  }) {
    final map = <String, dynamic>{};

    if (name != null) map['name'] = name;
    if (denomination != null) map['denomination'] = denomination.dbValue;
    if (origin != null) map['origin'] = origin.dbValue;
    if (ageGroup != null) map['age_group'] = ageGroup.dbValue;
    if (motive != null) map['motive'] = motive.dbValue;
    if (reminderEnabled != null) map['reminder_enabled'] = reminderEnabled;
    if (reminderTime != null) map['reminder_time'] = _formatTime(reminderTime);
    if (persistenceSelfReport != null) {
      map['persistence_self_report'] = persistenceSelfReport;
    }
    if (firstMessage != null) map['first_message'] = firstMessage;
    if (bibleVersionCode != null) map['bible_version_code'] = bibleVersionCode;
    if (aiMemory != null) map['ai_memory'] = aiMemory;
    if (timezone != null) map['timezone'] = timezone;
    if (onboardingCompleted != null) {
      map['onboarding_completed'] = onboardingCompleted;
    }
    if (theme != null) map['theme'] = theme;
    if (rcAppUserId != null) map['rc_app_user_id'] = rcAppUserId;

    return map;
  }

  /// Crea un modelo desde una entidad
  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      userId: entity.userId,
      name: entity.name,
      denomination: entity.denomination,
      origin: entity.origin,
      ageGroup: entity.ageGroup,
      motive: entity.motive,
      reminderEnabled: entity.reminderEnabled,
      reminderTime: entity.reminderTime,
      persistenceSelfReport: entity.persistenceSelfReport,
      firstMessage: entity.firstMessage,
      bibleVersionCode: entity.bibleVersionCode,
      aiMemory: entity.aiMemory,
      timezone: entity.timezone,
      onboardingCompleted: entity.onboardingCompleted,
      theme: entity.theme,
      rcAppUserId: entity.rcAppUserId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Parsea una hora en formato HH:MM:SS desde la BD
  static DateTime? _parseTime(String timeString) {
    final parts = timeString.split(':');
    if (parts.length >= 2) {
      final now = DateTime.now();
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    }
    return null;
  }

  /// Formatea una DateTime a HH:MM:SS para la BD
  static String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:00';
  }
}
