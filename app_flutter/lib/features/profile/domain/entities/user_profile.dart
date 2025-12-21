/// Entidad UserProfile - representa el perfil del usuario
class UserProfile {
  final String userId;
  final String? name;
  final GenderType? gender;
  final Denomination? denomination;
  final OriginGroup? origin;
  final AgeGroup? ageGroup;
  final MotiveType? motive;
  final bool reminderEnabled;
  final DateTime? reminderTime;
  final bool? persistenceSelfReport;
  final String? firstMessage;
  final String bibleVersionCode;
  final Map<String, dynamic>? aiMemory;
  final String timezone;
  final bool onboardingCompleted;
  final String theme;
  final String? rcAppUserId; // RevenueCat ID para restaurar compras + datos
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.userId,
    this.name,
    this.gender,
    this.denomination,
    this.origin,
    this.ageGroup,
    this.motive,
    this.reminderEnabled = false,
    this.reminderTime,
    this.persistenceSelfReport,
    this.firstMessage,
    this.bibleVersionCode = 'RVR1960',
    this.aiMemory,
    this.timezone = 'America/New_York',
    this.onboardingCompleted = false,
    this.theme = 'auto',
    this.rcAppUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  UserProfile copyWith({
    String? userId,
    String? name,
    GenderType? gender,
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      denomination: denomination ?? this.denomination,
      origin: origin ?? this.origin,
      ageGroup: ageGroup ?? this.ageGroup,
      motive: motive ?? this.motive,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      persistenceSelfReport: persistenceSelfReport ?? this.persistenceSelfReport,
      firstMessage: firstMessage ?? this.firstMessage,
      bibleVersionCode: bibleVersionCode ?? this.bibleVersionCode,
      aiMemory: aiMemory ?? this.aiMemory,
      timezone: timezone ?? this.timezone,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      theme: theme ?? this.theme,
      rcAppUserId: rcAppUserId ?? this.rcAppUserId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Género del usuario
enum GenderType {
  male,
  female;

  String get displayName {
    switch (this) {
      case GenderType.male:
        return 'Hombre';
      case GenderType.female:
        return 'Mujer';
    }
  }

  String get dbValue => name;

  static GenderType? fromString(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'male':
        return GenderType.male;
      case 'female':
        return GenderType.female;
      default:
        return null;
    }
  }
}

/// Denominación cristiana
enum Denomination {
  catolica,
  evangelica,
  pentecostal,
  bautista,
  metodista,
  luterana,
  adventista,
  ortodoxa,
  sinDenominacion,
  otra;

  String get displayName {
    switch (this) {
      case Denomination.catolica:
        return 'Católica';
      case Denomination.evangelica:
        return 'Evangélica';
      case Denomination.pentecostal:
        return 'Pentecostal';
      case Denomination.bautista:
        return 'Bautista';
      case Denomination.metodista:
        return 'Metodista';
      case Denomination.luterana:
        return 'Luterana';
      case Denomination.adventista:
        return 'Adventista';
      case Denomination.ortodoxa:
        return 'Ortodoxa';
      case Denomination.sinDenominacion:
        return 'Sin denominación';
      case Denomination.otra:
        return 'Otra';
    }
  }

  String get dbValue {
    switch (this) {
      case Denomination.sinDenominacion:
        return 'sin_denominacion';
      default:
        return name;
    }
  }

  static Denomination? fromString(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'catolica':
        return Denomination.catolica;
      case 'evangelica':
        return Denomination.evangelica;
      case 'pentecostal':
        return Denomination.pentecostal;
      case 'bautista':
        return Denomination.bautista;
      case 'metodista':
        return Denomination.metodista;
      case 'luterana':
        return Denomination.luterana;
      case 'adventista':
        return Denomination.adventista;
      case 'ortodoxa':
        return Denomination.ortodoxa;
      case 'sin_denominacion':
        return Denomination.sinDenominacion;
      case 'otra':
        return Denomination.otra;
      default:
        return null;
    }
  }
}

/// Grupo de origen cultural
enum OriginGroup {
  mexicoCentroamerica,
  caribe,
  sudamerica,
  espana,
  usaHispano;

  String get displayName {
    switch (this) {
      case OriginGroup.mexicoCentroamerica:
        return 'México / Centroamérica';
      case OriginGroup.caribe:
        return 'Caribe';
      case OriginGroup.sudamerica:
        return 'Sudamérica';
      case OriginGroup.espana:
        return 'España';
      case OriginGroup.usaHispano:
        return 'USA (Hispano)';
    }
  }

  String get dbValue {
    switch (this) {
      case OriginGroup.mexicoCentroamerica:
        return 'mexico_centroamerica';
      case OriginGroup.usaHispano:
        return 'usa_hispano';
      default:
        return name;
    }
  }

  static OriginGroup? fromString(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'mexico_centroamerica':
        return OriginGroup.mexicoCentroamerica;
      case 'caribe':
        return OriginGroup.caribe;
      case 'sudamerica':
        return OriginGroup.sudamerica;
      case 'espana':
        return OriginGroup.espana;
      case 'usa_hispano':
        return OriginGroup.usaHispano;
      default:
        return null;
    }
  }
}

/// Grupo de edad
enum AgeGroup {
  age18to24,
  age25to34,
  age35to44,
  age45to54,
  age55plus;

  String get displayName {
    switch (this) {
      case AgeGroup.age18to24:
        return '18-24';
      case AgeGroup.age25to34:
        return '25-34';
      case AgeGroup.age35to44:
        return '35-44';
      case AgeGroup.age45to54:
        return '45-54';
      case AgeGroup.age55plus:
        return '55+';
    }
  }

  String get dbValue {
    switch (this) {
      case AgeGroup.age18to24:
        return '18-24';
      case AgeGroup.age25to34:
        return '25-34';
      case AgeGroup.age35to44:
        return '35-44';
      case AgeGroup.age45to54:
        return '45-54';
      case AgeGroup.age55plus:
        return '55+';
    }
  }

  static AgeGroup? fromString(String? value) {
    if (value == null) return null;
    switch (value) {
      case '18-24':
        return AgeGroup.age18to24;
      case '25-34':
        return AgeGroup.age25to34;
      case '35-44':
        return AgeGroup.age35to44;
      case '45-54':
        return AgeGroup.age45to54;
      case '55+':
        return AgeGroup.age55plus;
      default:
        return null;
    }
  }
}

/// Motivo principal de uso
enum MotiveType {
  estudio,
  sufrimiento,
  crecimiento,
  comunidad,
  habito,
  otro;

  String get displayName {
    switch (this) {
      case MotiveType.estudio:
        return 'Estudiar la Biblia';
      case MotiveType.sufrimiento:
        return 'Superar sufrimientos';
      case MotiveType.crecimiento:
        return 'Crecimiento espiritual';
      case MotiveType.comunidad:
        return 'Comunidad';
      case MotiveType.habito:
        return 'Crear hábito';
      case MotiveType.otro:
        return 'Otro';
    }
  }

  String get dbValue => name;

  static MotiveType? fromString(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'estudio':
        return MotiveType.estudio;
      case 'sufrimiento':
        return MotiveType.sufrimiento;
      case 'crecimiento':
        return MotiveType.crecimiento;
      case 'comunidad':
        return MotiveType.comunidad;
      case 'habito':
        return MotiveType.habito;
      case 'otro':
        return MotiveType.otro;
      default:
        return null;
    }
  }
}
