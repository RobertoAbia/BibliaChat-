import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class OnboardingPlanPreviewPage extends StatelessWidget {
  final String? motive;
  final String? motiveDetail;
  final VoidCallback onStart;

  const OnboardingPlanPreviewPage({
    super.key,
    required this.motive,
    required this.motiveDetail,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final preview = _getPlanPreview(motive, motiveDetail);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),

                // App logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/splash_logo.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Plan title
                Text(
                  preview.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Plan description
                Text(
                  preview.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Info bar: 7 Sessions | < 5 min/day
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.surfaceLight.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.checklist_outlined,
                        color: AppTheme.textSecondary,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '7 Sesiones',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: 1,
                          height: 20,
                          color: AppTheme.surfaceLight.withOpacity(0.5),
                        ),
                      ),
                      Icon(
                        Icons.schedule_outlined,
                        color: AppTheme.textSecondary,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '< 5 min/día',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Timeline
                _buildTimeline(context, preview.days),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Bottom button
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: AppTheme.textOnPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 8,
              shadowColor: AppTheme.primaryColor.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Comenzar mi viaje',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(BuildContext context, List<_DayPreview> days) {
    final widgets = <Widget>[];

    for (int i = 0; i < days.length; i++) {
      final isEven = i % 2 == 0;

      // Day card
      widgets.add(_buildDayCard(context, days[i], iconOnLeft: isEven));

      // Connector between cards (not after last)
      if (i < days.length - 1) {
        widgets.add(
          SizedBox(
            height: 50,
            child: CustomPaint(
              size: const Size(double.infinity, 50),
              painter: _DashedConnectorPainter(curveRight: isEven),
            ),
          ),
        );
      }
    }

    return Column(children: widgets);
  }

  Widget _buildDayCard(
    BuildContext context,
    _DayPreview day, {
    required bool iconOnLeft,
  }) {
    final iconWidget = Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.20),
            AppTheme.primaryLight.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        day.icon,
        color: AppTheme.primaryColor,
        size: 24,
      ),
    );

    final textWidget = Expanded(
      child: Column(
        crossAxisAlignment:
            iconOnLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            'DÍA ${day.dayNumber}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            day.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: iconOnLeft ? TextAlign.start : TextAlign.end,
          ),
          const SizedBox(height: 4),
          Text(
            day.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.3,
                ),
            textAlign: iconOnLeft ? TextAlign.start : TextAlign.end,
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.surfaceLight.withOpacity(0.4),
        ),
      ),
      child: Row(
        children: iconOnLeft
            ? [iconWidget, const SizedBox(width: 14), textWidget]
            : [textWidget, const SizedBox(width: 14), iconWidget],
      ),
    );
  }

  // --- Preview data ---

  static _PlanPreview _getPlanPreview(String? motive, String? detail) {
    final key = '${motive ?? ''}:${detail ?? ''}';
    return _previewData[key] ?? _defaultPreview;
  }

  static const _defaultIcons = [
    Icons.explore_outlined,
    Icons.menu_book_outlined,
    Icons.self_improvement,
    Icons.lightbulb_outline,
    Icons.favorite_outline,
    Icons.spa_outlined,
    Icons.wb_sunny_outlined,
  ];

  static final _defaultPreview = _PlanPreview(
    title: 'Tu plan personalizado',
    description:
        'Un viaje de 7 días diseñado para acompañarte en tu camino de fe.',
    icon: Icons.auto_awesome,
    days: List.generate(
      7,
      (i) => _DayPreview(
        dayNumber: i + 1,
        title: 'Día ${i + 1}',
        description: 'Contenido personalizado para ti.',
        icon: _defaultIcons[i],
      ),
    ),
  );

  static final Map<String, _PlanPreview> _previewData = {
    // --- DIFFICULT MOMENT ---
    'difficult_moment:family_issues': _PlanPreview(
      title: 'Sanando relaciones familiares',
      description:
          'Un viaje de 7 días para encontrar paz y sanación en tus relaciones más cercanas, guiado por la Palabra de Dios.',
      icon: Icons.family_restroom,
      days: [
        _DayPreview(
            dayNumber: 1,
            title: 'Reconociendo tu dolor',
            description: 'Identifica y lleva ante Dios lo que sientes.',
            icon: Icons.favorite_outline),
        _DayPreview(
            dayNumber: 2,
            title: 'El perdón que libera',
            description:
                'Descubre el poder transformador del perdón.',
            icon: Icons.menu_book_outlined),
        _DayPreview(
            dayNumber: 3,
            title: 'Comunicación con amor',
            description:
                'Aprende a expresarte con gracia y verdad.',
            icon: Icons.chat_outlined),
        _DayPreview(
            dayNumber: 4,
            title: 'Límites saludables',
            description:
                'Establece límites que honren a Dios.',
            icon: Icons.shield_outlined),
        _DayPreview(
            dayNumber: 5,
            title: 'Paciencia en el proceso',
            description:
                'Confía en el tiempo de Dios para la restauración.',
            icon: Icons.schedule_outlined),
        _DayPreview(
            dayNumber: 6,
            title: 'Oración por tu familia',
            description: 'Intercede con fe por quienes amas.',
            icon: Icons.self_improvement),
        _DayPreview(
            dayNumber: 7,
            title: 'Un nuevo comienzo',
            description:
                'Da un paso adelante con esperanza y fe.',
            icon: Icons.wb_sunny_outlined),
      ],
    ),
    'difficult_moment:health_issues': _PlanPreview(
      title: 'Fe en medio de la enfermedad',
      description:
          'Un viaje de 7 días para encontrar fortaleza y esperanza cuando tu salud te preocupa.',
      icon: Icons.healing,
      days: [
        _DayPreview(
            dayNumber: 1,
            title: 'Dios conoce tu dolor',
            description:
                'Entrégale tu preocupación al que todo lo puede.',
            icon: Icons.favorite_outline),
        _DayPreview(
            dayNumber: 2,
            title: 'Paz en la incertidumbre',
            description:
                'Encuentra calma cuando no tienes respuestas.',
            icon: Icons.spa_outlined),
        _DayPreview(
            dayNumber: 3,
            title: 'Tu cuerpo, templo de Dios',
            description:
                'Redescubre tu valor a los ojos del Creador.',
            icon: Icons.self_improvement),
        _DayPreview(
            dayNumber: 4,
            title: 'Compañía en la soledad',
            description:
                'Dios está contigo en los momentos más difíciles.',
            icon: Icons.people_outline),
        _DayPreview(
            dayNumber: 5,
            title: 'Testimonios de sanación',
            description:
                'Historias bíblicas de fe y restauración.',
            icon: Icons.menu_book_outlined),
        _DayPreview(
            dayNumber: 6,
            title: 'Gratitud en la prueba',
            description:
                'Descubre razones para dar gracias hoy.',
            icon: Icons.volunteer_activism_outlined),
        _DayPreview(
            dayNumber: 7,
            title: 'Esperanza inquebrantable',
            description:
                'Mira hacia adelante con la fuerza que Dios te da.',
            icon: Icons.wb_sunny_outlined),
      ],
    ),
    'difficult_moment:financial_issues': _PlanPreview(
      title: 'Confianza en la provisión de Dios',
      description:
          'Un viaje de 7 días para encontrar paz financiera y confianza en la provisión divina.',
      icon: Icons.account_balance_wallet_outlined,
      days: [
        _DayPreview(
            dayNumber: 1,
            title: 'Dios ve tu necesidad',
            description:
                'Él conoce tu situación antes de que se la cuentes.',
            icon: Icons.visibility_outlined),
        _DayPreview(
            dayNumber: 2,
            title: 'Libertad de la ansiedad',
            description:
                'Deja de cargar solo lo que Dios quiere llevar contigo.',
            icon: Icons.spa_outlined),
        _DayPreview(
            dayNumber: 3,
            title: 'Mayordomía fiel',
            description:
                'Administra con sabiduría lo poco o mucho que tengas.',
            icon: Icons.lightbulb_outline),
        _DayPreview(
            dayNumber: 4,
            title: 'Generosidad en la escasez',
            description: 'El poder de dar aun cuando te falta.',
            icon: Icons.volunteer_activism_outlined),
        _DayPreview(
            dayNumber: 5,
            title: 'Trabajo con propósito',
            description:
                'Honra a Dios con tu esfuerzo diario.',
            icon: Icons.work_outline),
        _DayPreview(
            dayNumber: 6,
            title: 'Contentamiento verdadero',
            description:
                'La paz que no depende de tu cuenta bancaria.',
            icon: Icons.favorite_outline),
        _DayPreview(
            dayNumber: 7,
            title: 'Futuro con esperanza',
            description:
                'Confía en las promesas de provisión de Dios.',
            icon: Icons.wb_sunny_outlined),
      ],
    ),

    // --- SPIRITUAL GROWTH ---
    'spiritual_growth:prayer_life': _PlanPreview(
      title: 'Fortaleciendo tu vida de oración',
      description:
          'Un viaje de 7 días para profundizar tu conexión con Dios a través de la oración.',
      icon: Icons.self_improvement,
      days: [
        _DayPreview(
            dayNumber: 1,
            title: '¿Por qué orar?',
            description:
                'Redescubre el propósito de hablar con Dios.',
            icon: Icons.explore_outlined),
        _DayPreview(
            dayNumber: 2,
            title: 'Modelos de oración',
            description:
                'Aprende del Padrenuestro y otras oraciones bíblicas.',
            icon: Icons.menu_book_outlined),
        _DayPreview(
            dayNumber: 3,
            title: 'Escuchar a Dios',
            description:
                'La oración no es solo hablar, también es escuchar.',
            icon: Icons.hearing_outlined),
        _DayPreview(
            dayNumber: 4,
            title: 'Oración persistente',
            description:
                'La fe que no se rinde cuando no ve resultados.',
            icon: Icons.shield_outlined),
        _DayPreview(
            dayNumber: 5,
            title: 'Orando por otros',
            description:
                'El poder de la intercesión en tu vida diaria.',
            icon: Icons.people_outline),
        _DayPreview(
            dayNumber: 6,
            title: 'Obstáculos en la oración',
            description:
                'Identifica y supera lo que frena tu conexión.',
            icon: Icons.lightbulb_outline),
        _DayPreview(
            dayNumber: 7,
            title: 'Una vida de oración',
            description:
                'Construye un hábito que transforme tu día a día.',
            icon: Icons.wb_sunny_outlined),
      ],
    ),
    'spiritual_growth:bible_knowledge': _PlanPreview(
      title: 'Conociendo la Palabra de Dios',
      description:
          'Un viaje de 7 días para descubrir la riqueza de la Biblia y aprender a leerla con profundidad.',
      icon: Icons.menu_book_outlined,
      days: [
        _DayPreview(
            dayNumber: 1,
            title: '¿Qué es la Biblia?',
            description: 'Una carta de amor escrita para ti.',
            icon: Icons.favorite_outline),
        _DayPreview(
            dayNumber: 2,
            title: 'Antiguo Testamento',
            description:
                'Las raíces de nuestra fe y sus lecciones eternas.',
            icon: Icons.history_edu_outlined),
        _DayPreview(
            dayNumber: 3,
            title: 'Nuevo Testamento',
            description:
                'Jesús, sus enseñanzas y la iglesia primitiva.',
            icon: Icons.auto_stories_outlined),
        _DayPreview(
            dayNumber: 4,
            title: 'Cómo leer la Biblia',
            description:
                'Herramientas prácticas para entender lo que lees.',
            icon: Icons.lightbulb_outline),
        _DayPreview(
            dayNumber: 5,
            title: 'Versículos que cambian vidas',
            description:
                'Pasajes fundamentales que debes conocer.',
            icon: Icons.bookmark_outline),
        _DayPreview(
            dayNumber: 6,
            title: 'Aplicando la Palabra',
            description:
                'De la lectura a la acción en tu vida real.',
            icon: Icons.check_circle_outline),
        _DayPreview(
            dayNumber: 7,
            title: 'Un hábito para siempre',
            description:
                'Construye una disciplina de lectura diaria.',
            icon: Icons.wb_sunny_outlined),
      ],
    ),
    'spiritual_growth:daily_faith': _PlanPreview(
      title: 'Fe en lo cotidiano',
      description:
          'Un viaje de 7 días para descubrir la presencia de Dios en tu rutina diaria.',
      icon: Icons.wb_sunny_outlined,
      days: [
        _DayPreview(
            dayNumber: 1,
            title: 'Fe en lo ordinario',
            description:
                'Descubre a Dios en tu rutina diaria.',
            icon: Icons.explore_outlined),
        _DayPreview(
            dayNumber: 2,
            title: 'Amor al prójimo',
            description:
                'Refleja a Cristo en tus relaciones del día a día.',
            icon: Icons.people_outline),
        _DayPreview(
            dayNumber: 3,
            title: 'Trabajo como adoración',
            description:
                'Tu esfuerzo diario puede glorificar a Dios.',
            icon: Icons.work_outline),
        _DayPreview(
            dayNumber: 4,
            title: 'Tentaciones cotidianas',
            description:
                'Herramientas para las batallas pequeñas de cada día.',
            icon: Icons.shield_outlined),
        _DayPreview(
            dayNumber: 5,
            title: 'Gratitud como estilo de vida',
            description:
                'Transforma tu perspectiva con un corazón agradecido.',
            icon: Icons.favorite_outline),
        _DayPreview(
            dayNumber: 6,
            title: 'Influencia positiva',
            description:
                'Sé luz en tu entorno sin ser perfecto.',
            icon: Icons.lightbulb_outline),
        _DayPreview(
            dayNumber: 7,
            title: 'Crecimiento continuo',
            description:
                'La fe es un camino, no un destino.',
            icon: Icons.wb_sunny_outlined),
      ],
    ),

    // --- FEELING DISTANT ---
    'feeling_distant:stopped_practicing': _PlanPreview(
      title: 'Retomando tu camino de fe',
      description:
          'Un viaje de 7 días para volver a conectar con Dios, sin juicio ni culpa.',
      icon: Icons.directions_walk,
      days: [
        _DayPreview(
            dayNumber: 1,
            title: 'Sin juicio, sin culpa',
            description:
                'Dios te recibe con los brazos abiertos.',
            icon: Icons.favorite_outline),
        _DayPreview(
            dayNumber: 2,
            title: '¿Qué te alejó?',
            description:
                'Reflexiona sin culpa sobre lo que pasó.',
            icon: Icons.search_outlined),
        _DayPreview(
            dayNumber: 3,
            title: 'El hijo pródigo',
            description:
                'Una historia de regreso y celebración.',
            icon: Icons.menu_book_outlined),
        _DayPreview(
            dayNumber: 4,
            title: 'Primeros pasos de vuelta',
            description:
                'Pequeñas acciones para reconectar con Dios.',
            icon: Icons.directions_walk),
        _DayPreview(
            dayNumber: 5,
            title: 'Una nueva comunidad',
            description:
                'No tienes que caminar solo en este regreso.',
            icon: Icons.people_outline),
        _DayPreview(
            dayNumber: 6,
            title: 'Hábitos de fe simples',
            description:
                'Rutinas espirituales que puedes mantener.',
            icon: Icons.schedule_outlined),
        _DayPreview(
            dayNumber: 7,
            title: 'Tu nuevo comienzo',
            description:
                'Hoy es el primer día del resto de tu vida de fe.',
            icon: Icons.wb_sunny_outlined),
      ],
    ),
    'feeling_distant:faith_doubts': _PlanPreview(
      title: 'Respondiendo tus dudas de fe',
      description:
          'Un viaje de 7 días para explorar tus preguntas sobre la fe con honestidad y paz.',
      icon: Icons.help_outline,
      days: [
        _DayPreview(
            dayNumber: 1,
            title: 'Dudar no es pecado',
            description:
                'Los más grandes hombres de fe también dudaron.',
            icon: Icons.explore_outlined),
        _DayPreview(
            dayNumber: 2,
            title: 'Tomás, el apóstol',
            description:
                'Cómo Jesús respondió a las dudas honestas.',
            icon: Icons.menu_book_outlined),
        _DayPreview(
            dayNumber: 3,
            title: 'Preguntas difíciles',
            description:
                '¿Por qué existe el sufrimiento? Fe y razón.',
            icon: Icons.lightbulb_outline),
        _DayPreview(
            dayNumber: 4,
            title: 'Fe y ciencia',
            description:
                'No son enemigos, sino compañeros de viaje.',
            icon: Icons.science_outlined),
        _DayPreview(
            dayNumber: 5,
            title: 'Testimonios de fe',
            description:
                'Historias de personas que superaron sus dudas.',
            icon: Icons.people_outline),
        _DayPreview(
            dayNumber: 6,
            title: 'Fe como confianza',
            description:
                'Creer no es entender todo, es confiar.',
            icon: Icons.favorite_outline),
        _DayPreview(
            dayNumber: 7,
            title: 'Avanzar con preguntas',
            description:
                'Una fe madura abraza la incertidumbre con paz.',
            icon: Icons.wb_sunny_outlined),
      ],
    ),
    'feeling_distant:painful_experience': _PlanPreview(
      title: 'Sanando heridas del alma',
      description:
          'Un viaje de 7 días para procesar tu dolor y encontrar consuelo en la presencia de Dios.',
      icon: Icons.healing,
      days: [
        _DayPreview(
            dayNumber: 1,
            title: 'Tu dolor es válido',
            description:
                'Dios no minimiza lo que sientes.',
            icon: Icons.favorite_outline),
        _DayPreview(
            dayNumber: 2,
            title: 'Job y el sufrimiento',
            description:
                'Cuando la vida no tiene sentido.',
            icon: Icons.menu_book_outlined),
        _DayPreview(
            dayNumber: 3,
            title: 'Lamento sagrado',
            description:
                'Expresar tu dolor ante Dios es una forma de oración.',
            icon: Icons.self_improvement),
        _DayPreview(
            dayNumber: 4,
            title: 'El Dios que llora contigo',
            description:
                'Jesús lloró. Tu dolor le importa.',
            icon: Icons.people_outline),
        _DayPreview(
            dayNumber: 5,
            title: 'Soltar el por qué',
            description:
                'De buscar explicaciones a buscar consuelo.',
            icon: Icons.spa_outlined),
        _DayPreview(
            dayNumber: 6,
            title: 'Cicatrices que cuentan historias',
            description:
                'Tu herida puede convertirse en testimonio.',
            icon: Icons.lightbulb_outline),
        _DayPreview(
            dayNumber: 7,
            title: 'Esperanza después del dolor',
            description:
                'El amanecer siempre llega después de la noche.',
            icon: Icons.wb_sunny_outlined),
      ],
    ),

    // --- UNDERSTAND BIBLE ---
    'understand_bible:apply_teachings': _PlanPreview(
      title: 'La Biblia en tu vida diaria',
      description:
          'Un viaje de 7 días para aprender a aplicar las enseñanzas bíblicas a tu realidad.',
      icon: Icons.auto_stories_outlined,
      days: [
        _DayPreview(
            dayNumber: 1,
            title: 'Más que un libro antiguo',
            description:
                'La Biblia habla directamente a tu vida hoy.',
            icon: Icons.menu_book_outlined),
        _DayPreview(
            dayNumber: 2,
            title: 'Principios eternos',
            description:
                'Verdades que trascienden el tiempo y la cultura.',
            icon: Icons.lightbulb_outline),
        _DayPreview(
            dayNumber: 3,
            title: 'Relaciones bíblicas',
            description:
                'Qué dice la Biblia sobre el amor y la familia.',
            icon: Icons.people_outline),
        _DayPreview(
            dayNumber: 4,
            title: 'Decisiones con sabiduría',
            description:
                'Usa las Escrituras como guía práctica.',
            icon: Icons.explore_outlined),
        _DayPreview(
            dayNumber: 5,
            title: 'Emociones y la Biblia',
            description:
                'Los Salmos como espejo de tu mundo interior.',
            icon: Icons.favorite_outline),
        _DayPreview(
            dayNumber: 6,
            title: 'Fe en el trabajo',
            description:
                'Principios bíblicos para tu vida profesional.',
            icon: Icons.work_outline),
        _DayPreview(
            dayNumber: 7,
            title: 'Una brújula para la vida',
            description:
                'Integra la Palabra en cada decisión.',
            icon: Icons.wb_sunny_outlined),
      ],
    ),
    'understand_bible:historical_context': _PlanPreview(
      title: 'Viajando por la historia bíblica',
      description:
          'Un viaje de 7 días para entender el contexto histórico que da vida a las Escrituras.',
      icon: Icons.public,
      days: [
        _DayPreview(
            dayNumber: 1,
            title: 'El mundo de la Biblia',
            description:
                'Conoce el contexto que dio origen a las Escrituras.',
            icon: Icons.explore_outlined),
        _DayPreview(
            dayNumber: 2,
            title: 'De Adán a Abraham',
            description:
                'Los comienzos de la historia de salvación.',
            icon: Icons.menu_book_outlined),
        _DayPreview(
            dayNumber: 3,
            title: 'El pueblo de Israel',
            description:
                'Éxodo, reyes y profetas en contexto.',
            icon: Icons.history_edu_outlined),
        _DayPreview(
            dayNumber: 4,
            title: 'Entre los Testamentos',
            description:
                '400 años de silencio que prepararon todo.',
            icon: Icons.schedule_outlined),
        _DayPreview(
            dayNumber: 5,
            title: 'El mundo de Jesús',
            description:
                'Palestina, Roma y la cultura del siglo I.',
            icon: Icons.public),
        _DayPreview(
            dayNumber: 6,
            title: 'La iglesia primitiva',
            description:
                'Cómo se expandió el mensaje por el mundo.',
            icon: Icons.people_outline),
        _DayPreview(
            dayNumber: 7,
            title: 'De entonces a hoy',
            description:
                'Cómo el contexto ilumina tu lectura actual.',
            icon: Icons.wb_sunny_outlined),
      ],
    ),
    'understand_bible:denomination_differences': _PlanPreview(
      title: 'Entendiendo las tradiciones cristianas',
      description:
          'Un viaje de 7 días para comprender las diferentes expresiones de la fe cristiana.',
      icon: Icons.church_outlined,
      days: [
        _DayPreview(
            dayNumber: 1,
            title: 'Una fe, muchas expresiones',
            description:
                'Por qué hay tantas iglesias diferentes.',
            icon: Icons.explore_outlined),
        _DayPreview(
            dayNumber: 2,
            title: 'Católicos y protestantes',
            description:
                'Historia y puntos en común.',
            icon: Icons.menu_book_outlined),
        _DayPreview(
            dayNumber: 3,
            title: 'Evangélicos y pentecostales',
            description:
                'Raíces y características principales.',
            icon: Icons.people_outline),
        _DayPreview(
            dayNumber: 4,
            title: 'Lo que nos une',
            description:
                'El credo común que compartimos todos.',
            icon: Icons.favorite_outline),
        _DayPreview(
            dayNumber: 5,
            title: 'Tradiciones y Escritura',
            description:
                'Cómo cada tradición lee la Biblia.',
            icon: Icons.auto_stories_outlined),
        _DayPreview(
            dayNumber: 6,
            title: 'Respeto en la diversidad',
            description:
                'Aprender de otros sin perder tu identidad.',
            icon: Icons.handshake_outlined),
        _DayPreview(
            dayNumber: 7,
            title: 'Tu fe personal',
            description:
                'Construye una fe informada y propia.',
            icon: Icons.wb_sunny_outlined),
      ],
    ),
  };
}

// --- Data classes ---

class _PlanPreview {
  final String title;
  final String description;
  final IconData icon;
  final List<_DayPreview> days;

  const _PlanPreview({
    required this.title,
    required this.description,
    required this.icon,
    required this.days,
  });
}

class _DayPreview {
  final int dayNumber;
  final String title;
  final String description;
  final IconData icon;

  const _DayPreview({
    required this.dayNumber,
    required this.title,
    required this.description,
    required this.icon,
  });
}

// --- Custom painter for dashed connector ---

class _DashedConnectorPainter extends CustomPainter {
  final bool curveRight;

  _DashedConnectorPainter({required this.curveRight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // Start and end points
    final startX = curveRight ? size.width * 0.35 : size.width * 0.65;
    final endX = curveRight ? size.width * 0.65 : size.width * 0.35;
    const startY = 0.0;
    final endY = size.height;

    // Control point for the curve
    final cpX = curveRight ? size.width * 0.75 : size.width * 0.25;
    final cpY = size.height * 0.5;

    // Build bezier path
    final path = Path()
      ..moveTo(startX, startY)
      ..quadraticBezierTo(cpX, cpY, endX, endY);

    // Draw dashed path
    final dashedPath = _createDashedPath(path);
    canvas.drawPath(dashedPath, paint);

    // Draw dots at endpoints
    canvas.drawCircle(Offset(startX, startY), 3.5, dotPaint);
    canvas.drawCircle(Offset(endX, endY), 3.5, dotPaint);
  }

  Path _createDashedPath(Path source,
      {double dashWidth = 6.0, double dashSpace = 4.0}) {
    final Path dashedPath = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = min(distance + dashWidth, metric.length);
        dashedPath.addPath(
          metric.extractPath(distance, nextDistance),
          Offset.zero,
        );
        distance = nextDistance + dashSpace;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant _DashedConnectorPainter oldDelegate) =>
      curveRight != oldDelegate.curveRight;
}
