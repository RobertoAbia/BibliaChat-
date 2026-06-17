import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Momento "WOW" del onboarding: revela un versículo elegido según el motivo
/// del usuario. Tras un breve instante dispara `onReveal` (para pedir la review
/// en el pico emocional) y el CTA avanza con `onContinue`.
class OnboardingVersePage extends StatefulWidget {
  final String? name;
  final String? motive;

  /// Se llama una vez, tras la animación de revelado, para pedir la review.
  final VoidCallback onReveal;

  /// CTA inferior para continuar al plan preview.
  final VoidCallback onContinue;

  const OnboardingVersePage({
    super.key,
    required this.name,
    required this.motive,
    required this.onReveal,
    required this.onContinue,
  });

  @override
  State<OnboardingVersePage> createState() => _OnboardingVersePageState();
}

class _OnboardingVersePageState extends State<OnboardingVersePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final _Verse _verse;
  bool _reviewRequested = false;

  @override
  void initState() {
    super.initState();
    _verse = _pickVerse(widget.motive, widget.name);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  /// El usuario ha visto el versículo y decide avanzar: pico emocional para
  /// pedir la review (una sola vez) y, a continuación, ir al plan preview.
  void _onContinue() {
    if (!_reviewRequested) {
      _reviewRequested = true;
      widget.onReveal();
    }
    widget.onContinue();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.name?.trim();
    final hasName = name != null && name.isNotEmpty;
    final motivePhrase = _motivePhrase(widget.motive);
    const blue = TextStyle(
      color: AppTheme.primaryColor,
      fontWeight: FontWeight.w700,
    );

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Lead conversacional con el nombre y el motivo resaltados
                    // en azul para que no quede plano.
                    Text.rich(
                      TextSpan(
                        children: [
                          if (hasName) ...[
                            TextSpan(text: name, style: blue),
                            const TextSpan(
                                text: ', antes de mostrarte tu plan'),
                          ] else
                            const TextSpan(text: 'Antes de mostrarte tu plan'),
                          if (motivePhrase != null) ...[
                            const TextSpan(
                                text: ', como nos has dicho que '),
                            TextSpan(text: motivePhrase, style: blue),
                          ],
                          const TextSpan(
                              text:
                                  ', queremos inspirarte con esta enseñanza de la Biblia.'),
                        ],
                      ),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    // Verse card
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.primaryColor.withOpacity(0.18),
                            AppTheme.primaryLight.withOpacity(0.06),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.35),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.15),
                            blurRadius: 24,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.format_quote_rounded,
                            color: AppTheme.primaryColor,
                            size: 32,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _verse.text,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontStyle: FontStyle.italic,
                                  height: 1.4,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _verse.reference,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),

        // Bottom button (mismo estilo que el resto del onboarding)
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ver mi plan',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right, size: 22, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Selecciona un versículo según el motivo del onboarding. Determinista por
/// nombre (mismo usuario → mismo versículo) para que se sienta personal y estable.
_Verse _pickVerse(String? motive, String? name) {
  final verses = _versesByMotive[motive] ?? _defaultVerses;
  final index = (name?.hashCode ?? 0).abs() % verses.length;
  return verses[index];
}

class _Verse {
  final String reference;
  final String text;
  const _Verse(this.reference, this.text);
}

// Textos literales de versiculos_widget_review.txt (verificados).
const Map<String, List<_Verse>> _versesByMotive = {
  'difficult_moment': [
    _Verse('Salmos 34:18',
        'El Señor está cerca de los que tienen el corazón roto.'),
    _Verse('Isaías 43:2', 'Cuando cruces las aguas, yo estaré contigo.'),
    _Verse('Salmos 23:4',
        'Aunque camine por el valle más oscuro, no temeré peligro alguno.'),
    _Verse('Mateo 11:28',
        'Vengan a mí los que están cansados y agobiados y yo les daré descanso.'),
    _Verse('Salmos 30:5',
        'El llanto puede durar toda la noche, pero la alegría llega con la mañana.'),
  ],
  'spiritual_growth': [
    _Verse('Filipenses 1:6',
        'El que comenzó la buena obra la completará hasta el fin de sus días.'),
    _Verse('Jeremías 29:13',
        'Me buscarán y me encontrarán cuando me busquen de todo corazón.'),
    _Verse('Santiago 1:5',
        'Si a alguno de ustedes le falta sabiduría, pídala a Dios.'),
    _Verse('2 Corintios 5:17',
        'Si alguno está en Cristo, es una nueva creación.'),
    _Verse('Proverbios 2:6', 'El Señor da la sabiduría.'),
  ],
  'feeling_distant': [
    _Verse('Santiago 4:8', 'Acérquense a Dios y Él se acercará a ustedes.'),
    _Verse('Salmos 42:1',
        'Como el ciervo anhela los ríos, así te anhela mi alma, oh Dios.'),
    _Verse('Salmos 145:18',
        'El Señor está cerca de todos los que lo invocan.'),
    _Verse('Isaías 41:10',
        'No temas, porque yo estoy contigo. No te desanimes, porque yo soy tu Dios.'),
    _Verse('Salmos 63:1',
        'Oh Dios, tú eres mi Dios; yo te busco intensamente. Mi alma tiene sed de ti.'),
  ],
  'understand_bible': [
    _Verse('Salmos 119:105',
        'Tu palabra es un calzado para mis pies y una luz en mi camino.'),
    _Verse('2 Timoteo 3:16-17',
        'Toda la Escritura es inspirada por Dios y útil para enseñar.'),
    _Verse('Juan 8:32', 'Conocerán la verdad, y la verdad los hará libres.'),
    _Verse('Romanos 10:17',
        'Así que la fe viene como resultado de escuchar la palabra de Dios.'),
    _Verse('Hebreos 4:12', 'La palabra de Dios está viva.'),
  ],
};

const List<_Verse> _defaultVerses = [
  _Verse('Jeremías 29:11',
      'Porque yo sé los planes que tengo para ustedes.'),
  _Verse('Filipenses 4:13', 'Todo lo puedo en Cristo que me fortalece.'),
  _Verse('Salmos 23:1', 'El Señor es mi pastor; nada me falta.'),
];

/// Frase del motivo (lo que el usuario nos dijo) para resaltarla en azul dentro
/// del lead. Devuelve null si no hay motivo → el lead omite esa parte.
String? _motivePhrase(String? motive) {
  switch (motive) {
    case 'difficult_moment':
      return 'estás pasando por un momento difícil';
    case 'spiritual_growth':
      return 'quieres crecer espiritualmente';
    case 'feeling_distant':
      return 'a veces te sientes lejos de Dios';
    case 'understand_bible':
      return 'quieres entender mejor la Biblia';
    default:
      return null;
  }
}
