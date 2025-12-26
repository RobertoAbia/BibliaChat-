import '../../domain/entities/daily_gospel.dart';

/// Modelo para serialización/deserialización del Evangelio del día
class DailyGospelModel extends DailyGospel {
  const DailyGospelModel({
    required super.date,
    required super.reference,
    required super.text,
    super.summary,
    super.keyConcept,
    super.practicalExercise,
    required super.bibleVersion,
    super.contextNotes,
  });

  /// Crea modelo desde respuesta de Supabase (join de daily_verses + daily_verse_texts)
  factory DailyGospelModel.fromSupabase(Map<String, dynamic> json) {
    return DailyGospelModel(
      date: DateTime.parse(json['verse_date'] as String),
      reference: json['reference'] as String? ?? '',
      text: json['verse_text'] as String? ?? '',
      summary: json['verse_summary'] as String?,
      keyConcept: json['key_concept'] as String?,
      practicalExercise: json['practical_exercise'] as String?,
      bibleVersion: json['bible_version_code'] as String? ?? 'RVR1960',
      contextNotes: json['context_notes'] as String?,
    );
  }

  /// Crea modelo desde dos registros separados (daily_verses y daily_verse_texts)
  factory DailyGospelModel.fromSeparateRecords({
    required Map<String, dynamic> verse,
    required Map<String, dynamic> text,
  }) {
    return DailyGospelModel(
      date: DateTime.parse(verse['verse_date'] as String),
      reference: verse['reference'] as String? ?? '',
      text: text['verse_text'] as String? ?? '',
      summary: text['verse_summary'] as String?,
      keyConcept: text['key_concept'] as String?,
      practicalExercise: text['practical_exercise'] as String?,
      bibleVersion: text['bible_version_code'] as String? ?? 'RVR1960',
      contextNotes: verse['context_notes'] as String?,
    );
  }

  /// Convierte a entity
  DailyGospel toEntity() {
    return DailyGospel(
      date: date,
      reference: reference,
      text: text,
      summary: summary,
      keyConcept: keyConcept,
      practicalExercise: practicalExercise,
      bibleVersion: bibleVersion,
      contextNotes: contextNotes,
    );
  }
}
