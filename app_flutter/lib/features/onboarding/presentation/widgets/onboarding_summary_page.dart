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

                // Header
                Center(
                  child: Column(
                    children: [
                      Text(
                        name != null ? '$name, tu plan está listo' : 'Tu plan está listo',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hemos preparado esto para ti',
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

                const SizedBox(height: 16),

                // Card: Lo que haremos juntos
                if (supportTypes.isNotEmpty) ...[
                  _buildPlanCard(context),
                  const SizedBox(height: 16),
                ],

                // Social proof
                _buildSocialProof(context),

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
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gold side bar
          Container(
            width: 4,
            height: detailText != null ? 90 : 60,
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    situationText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  if (detailText != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      detailText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    );
  }

  Widget _buildPlanCard(BuildContext context) {
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
            'Lo que haremos juntos',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 12),
          ...supportTypes.map((type) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _getSupportTypeText(type),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

  Widget _buildSocialProof(BuildContext context) {
    final stats = _getSocialProofStats();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            'No estás solo en esto',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 16),
          ...stats.map((stat) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Text(
                      stat.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: stat.highlight,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            TextSpan(
                              text: ' ${stat.text}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                            ),
                          ],
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

  String _getSupportTypeText(String type) {
    switch (type) {
      case 'talk_faith':
        return 'Conversaciones sobre tu fe';
      case 'daily_reflection':
        return 'Reflexión bíblica cada día';
      case 'guided_plans':
        return 'Planes de estudio guiados';
      default:
        return type;
    }
  }

  List<_SocialProofStat> _getSocialProofStats() {
    final stats = <_SocialProofStat>[];

    // Stat based on motive
    switch (motive) {
      case 'difficult_moment':
        stats.add(const _SocialProofStat(
          emoji: '\u{1F64F}', // praying hands
          highlight: '+12,000 personas',
          text: 'han encontrado paz en momentos difíciles',
        ));
        break;
      case 'spiritual_growth':
        stats.add(const _SocialProofStat(
          emoji: '\u{2728}', // sparkles
          highlight: '+9,200 personas',
          text: 'han crecido espiritualmente con la app',
        ));
        break;
      case 'feeling_distant':
        stats.add(const _SocialProofStat(
          emoji: '\u{1F49B}', // yellow heart
          highlight: '+7,500 personas',
          text: 'han reconectado con su fe',
        ));
        break;
      case 'understand_bible':
        stats.add(const _SocialProofStat(
          emoji: '\u{1F4D6}', // open book
          highlight: '+10,300 personas',
          text: 'entienden mejor la Biblia hoy',
        ));
        break;
      default:
        stats.add(const _SocialProofStat(
          emoji: '\u{1F64F}', // praying hands
          highlight: '+15,000 personas',
          text: 'usan Biblia Chat cada día',
        ));
    }

    // Stat based on supportTypes
    if (supportTypes.contains('daily_reflection')) {
      stats.add(const _SocialProofStat(
        emoji: '\u{1F525}', // fire
        highlight: '87%',
        text: 'mantienen su racha más de 7 días',
      ));
    } else if (supportTypes.contains('guided_plans')) {
      stats.add(const _SocialProofStat(
        emoji: '\u{1F4DA}', // books
        highlight: '+5,800 planes',
        text: 'completados por nuestra comunidad',
      ));
    } else {
      stats.add(const _SocialProofStat(
        emoji: '\u{1F4AC}', // speech bubble
        highlight: '+50,000 mensajes',
        text: 'de apoyo enviados cada mes',
      ));
    }

    return stats;
  }
}

class _SocialProofStat {
  final String emoji;
  final String highlight;
  final String text;

  const _SocialProofStat({
    required this.emoji,
    required this.highlight,
    required this.text,
  });
}
