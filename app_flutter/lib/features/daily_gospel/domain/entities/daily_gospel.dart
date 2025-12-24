/// Entidad que representa el Evangelio del día
class DailyGospel {
  /// Fecha del evangelio (YYYY-MM-DD)
  final DateTime date;

  /// Referencia bíblica (ej: "Lucas 1:57-66")
  final String reference;

  /// Texto del evangelio en la versión de biblia del usuario
  final String text;

  /// Resumen del evangelio en lenguaje coloquial
  final String? summary;

  /// Versión de la biblia (ej: "RVR1960")
  final String bibleVersion;

  /// Notas de contexto (ej: "Adviento")
  final String? contextNotes;

  const DailyGospel({
    required this.date,
    required this.reference,
    required this.text,
    this.summary,
    required this.bibleVersion,
    this.contextNotes,
  });

  /// Evangelio vacío/placeholder cuando no hay datos
  factory DailyGospel.empty() {
    return DailyGospel(
      date: DateTime.now(),
      reference: '',
      text: '',
      summary: null,
      bibleVersion: 'RVR1960',
      contextNotes: null,
    );
  }

  /// Verifica si el evangelio tiene contenido válido
  bool get isValid => reference.isNotEmpty && text.isNotEmpty;

  /// Verifica si tiene resumen disponible
  bool get hasSummary => summary != null && summary!.isNotEmpty;

  @override
  String toString() {
    return 'DailyGospel(date: $date, reference: $reference, bibleVersion: $bibleVersion)';
  }
}
