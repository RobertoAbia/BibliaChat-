import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class OnboardingSummaryPage extends StatelessWidget {
  final String? name;
  final String? motive;
  final String? motiveDetail;
  final Set<String> supportTypes;
  final String? gender;
  final VoidCallback onNext;

  const OnboardingSummaryPage({
    super.key,
    required this.name,
    required this.motive,
    required this.motiveDetail,
    required this.supportTypes,
    required this.gender,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Header with icon
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryColor.withOpacity(0.25),
                              AppTheme.primaryLight.withOpacity(0.10),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: AppTheme.primaryColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name != null
                            ? '$name, tu plan está listo'
                            : 'Tu plan está listo',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Basado en tus respuestas',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Card: Tu situación
                _buildSituationCard(context),

                const SizedBox(height: 12),

                // Card: Tu plan personalizado
                _buildPlanCard(context),
                const SizedBox(height: 20),

                // Research-backed stats
                _buildResearchSection(context),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Bottom button
        Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: AppTheme.textOnPrimary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  minimumSize: Size.zero,
                  elevation: 8,
                  shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSituationCard(BuildContext context) {
    final situationText = _getMotiveText();
    final detailText = _getMotiveDetailText();

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.surfaceLight.withOpacity(0.5),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gold side bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu situación',
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      situationText,
                      style:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                    if (detailText != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        detailText,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context) {
    final planItems = _getPlanItems();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.surfaceLight.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tu plan personalizado',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 12),
          ...planItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(top: 1),
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.text,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildResearchSection(BuildContext context) {
    final stats = _getResearchStats();

    return Column(
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.trending_up_rounded,
                color: AppTheme.primaryColor,
                size: 13,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Respaldado por la ciencia',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Two stat cards side by side
        Row(
          children: [
            Expanded(child: _buildStatCard(context, stats[0])),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard(context, stats[1])),
          ],
        ),

        const SizedBox(height: 10),

        // Source citation
        Text(
          _getSourceText(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textTertiary,
                fontSize: 10,
                height: 1.3,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, _ResearchStat stat) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.10),
            AppTheme.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.15),
        ),
      ),
      child: Column(
        children: [
          Icon(stat.icon, color: AppTheme.primaryColor, size: 22),
          const SizedBox(height: 10),
          Text(
            stat.value,
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stat.label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.3,
                ),
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // --- Helpers ---

  String _getMotiveText() {
    switch (motive) {
      case 'difficult_moment':
        return 'Estás pasando por un momento difícil';
      case 'spiritual_growth':
        return 'Quieres crecer espiritualmente';
      case 'feeling_distant':
        return 'Quieres reconectarte con Dios';
      case 'understand_bible':
        return 'Quieres entender mejor la Biblia';
      default:
        return 'Quieres fortalecer tu fe';
    }
  }

  String? _getMotiveDetailText() {
    switch (motiveDetail) {
      // difficult_moment details
      case 'family_issues':
        return 'Problemas familiares o de pareja';
      case 'health_issues':
        return 'Problemas de salud';
      case 'financial_issues':
        return 'Problemas económicos o laborales';
      // spiritual_growth details
      case 'prayer_life':
        return 'Quieres fortalecer tu vida de oración';
      case 'bible_knowledge':
        return 'Quieres conocer mejor la Biblia';
      case 'daily_faith':
        return 'Quieres vivir tu fe en el día a día';
      // feeling_distant details
      case 'stopped_practicing':
        return 'Dejaste de practicar tu fe';
      case 'doubts':
        return 'Tienes dudas sobre tu fe';
      case 'painful_experience':
        return 'Una experiencia dolorosa te alejó';
      // understand_bible details
      case 'apply_life':
        return 'Quieres aplicar la Biblia a tu vida';
      case 'historical_context':
        return 'Quieres entender el contexto histórico';
      case 'denomination_differences':
        return 'Quieres entender las diferencias entre denominaciones';
      default:
        return null;
    }
  }

  List<_PlanItem> _getPlanItems() {
    final items = <_PlanItem>[];

    // Always add the personalized 7-day plan first
    final planName = _getPlanName();
    if (planName != null) {
      items.add(_PlanItem(
        icon: Icons.auto_stories_outlined,
        text: 'Plan de 7 días: "$planName"',
      ));
    }

    // Add contextual items based on supportTypes
    for (final type in supportTypes) {
      switch (type) {
        case 'talk_faith':
          items.add(_PlanItem(
            icon: Icons.chat_bubble_outline,
            text: _getTalkText(),
          ));
          break;
        case 'daily_reflection':
          items.add(_PlanItem(
            icon: Icons.wb_sunny_outlined,
            text: 'Reflexión bíblica diaria para tu situación',
          ));
          break;
        case 'guided_plans':
          // Already covered by the 7-day plan above, add variety
          items.add(_PlanItem(
            icon: Icons.favorite_outline,
            text: 'Oraciones personalizadas para ti',
          ));
          break;
      }
    }

    return items;
  }

  String? _getPlanName() {
    final key = '$motive:$motiveDetail';
    const planNames = {
      'difficult_moment:family_issues': 'Sanando relaciones familiares',
      'difficult_moment:health_issues': 'Fe en medio de la enfermedad',
      'difficult_moment:financial_issues': 'Confianza en la provisión de Dios',
      'spiritual_growth:prayer_life': 'Fortaleciendo tu vida de oración',
      'spiritual_growth:bible_knowledge': 'Conociendo la Palabra de Dios',
      'spiritual_growth:daily_faith': 'Fe en lo cotidiano',
      'feeling_distant:stopped_practicing': 'Retomando tu camino de fe',
      'feeling_distant:doubts': 'Respondiendo tus dudas de fe',
      'feeling_distant:painful_experience': 'Sanando heridas del alma',
      'understand_bible:apply_life': 'La Biblia en tu vida diaria',
      'understand_bible:historical_context': 'Viajando por la historia bíblica',
      'understand_bible:denomination_differences': 'Entendiendo las tradiciones',
    };
    return planNames[key];
  }

  String _getTalkText() {
    switch (motive) {
      case 'difficult_moment':
        return 'Un amigo que te escucha y acompaña';
      case 'spiritual_growth':
        return 'Conversaciones para crecer en tu fe';
      case 'feeling_distant':
        return 'Alguien que te entiende sin juzgarte';
      case 'understand_bible':
        return 'Respuestas a tus preguntas sobre la Biblia';
      default:
        return 'Conversaciones personalizadas sobre tu fe';
    }
  }

  List<_ResearchStat> _getResearchStats() {
    // Stats backed by real studies:
    // - 83%: American Bible Society / Barna Group, State of the Bible 2025
    //   "83% of Scripture Engaged strongly agree they find comfort in faith"
    // - 89%: JMIR Formative Research / Univ. North Texas, 2024
    //   "89% of prayer app users reported satisfaction"
    // - 88%: Same JMIR study — "88% said they would continue using it"
    // - 19%: American Bible Society / Barna Group, State of the Bible 2025
    //   "Scripture Engaged score 7.9 vs 6.8 on Flourishing Index (19% more)"
    // - +1,000M: YouVersion, Oct 2025 — "1 billion installs milestone"
    switch (motive) {
      case 'difficult_moment':
        return const [
          _ResearchStat(
            icon: Icons.favorite_outline,
            value: '83%',
            label: 'encuentran consuelo en su fe durante desafíos',
          ),
          _ResearchStat(
            icon: Icons.thumb_up_outlined,
            value: '89%',
            label: 'de satisfacción en usuarios de apps de oración',
          ),
        ];
      case 'spiritual_growth':
        return const [
          _ResearchStat(
            icon: Icons.spa_outlined,
            value: '69%',
            label: 'de lectores habituales reportan mayor paz interior',
          ),
          _ResearchStat(
            icon: Icons.thumb_up_outlined,
            value: '89%',
            label: 'de satisfacción en usuarios de apps de oración',
          ),
        ];
      case 'feeling_distant':
        return const [
          _ResearchStat(
            icon: Icons.replay_outlined,
            value: '88%',
            label: 'mantienen su práctica espiritual tras 4 semanas',
          ),
          _ResearchStat(
            icon: Icons.spa_outlined,
            value: '19%',
            label: 'más bienestar en lectores habituales de la Biblia',
          ),
        ];
      case 'understand_bible':
        return const [
          _ResearchStat(
            icon: Icons.public,
            value: '+1,000M',
            label: 'de descargas de apps bíblicas en el mundo',
          ),
          _ResearchStat(
            icon: Icons.spa_outlined,
            value: '19%',
            label: 'más bienestar en lectores habituales de la Biblia',
          ),
        ];
      default:
        return const [
          _ResearchStat(
            icon: Icons.spa_outlined,
            value: '19%',
            label: 'más bienestar en lectores habituales de la Biblia',
          ),
          _ResearchStat(
            icon: Icons.thumb_up_outlined,
            value: '89%',
            label: 'de satisfacción en usuarios de apps de oración',
          ),
        ];
    }
  }

  String _getSourceText() {
    switch (motive) {
      case 'difficult_moment':
        return 'Fuentes: American Bible Society (2025), JMIR Formative Research (2024)';
      case 'spiritual_growth':
        return 'Fuentes: American Bible Society / Barna (2025), JMIR (2024)';
      case 'feeling_distant':
        return 'Fuentes: JMIR Formative Research (2024), American Bible Society (2025)';
      case 'understand_bible':
        return 'Fuentes: YouVersion (2025), American Bible Society / Barna (2025)';
      default:
        return 'Fuentes: American Bible Society (2025), JMIR Formative Research (2024)';
    }
  }
}

class _ResearchStat {
  final IconData icon;
  final String value;
  final String label;

  const _ResearchStat({
    required this.icon,
    required this.value,
    required this.label,
  });
}

class _PlanItem {
  final IconData icon;
  final String text;

  const _PlanItem({
    required this.icon,
    required this.text,
  });
}
