import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../../../study/presentation/providers/study_provider.dart';
import '../widgets/onboarding_welcome_page.dart';
import '../widgets/onboarding_name_page.dart';
import '../widgets/onboarding_selection_page.dart';
import '../widgets/onboarding_country_page.dart';
import '../widgets/onboarding_reminder_page.dart';
import '../widgets/onboarding_analyzing_page.dart';
import '../widgets/onboarding_intro_page.dart';
import '../widgets/onboarding_consent_page.dart';
import '../widgets/onboarding_plan_preview_page.dart';
import '../widgets/onboarding_summary_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 16; // Welcome + Consent + Intro + Nombre + 9 preguntas + Analyzing + Summary + Ready

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      FocusScope.of(context).unfocus();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      FocusScope.of(context).unfocus();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final notifier = ref.read(onboardingProvider.notifier);
    final state = ref.read(onboardingProvider);
    final success = await notifier.completeOnboarding();

    if (success && mounted) {
      // Log analytics event
      AnalyticsService().logOnboardingComplete(
        denomination: state.denomination ?? 'unknown',
        origin: state.origin ?? 'unknown',
        ageGroup: state.ageGroup ?? 'unknown',
        gender: state.gender,
      );
      // Set user properties for segmentation
      AnalyticsService().setUserProperties(
        denomination: state.denomination,
        origin: state.origin,
        ageGroup: state.ageGroup,
        gender: state.gender,
        motive: state.motive,
        motiveDetail: state.motiveDetail,
      );
      // Invalidar el provider de perfil para que se recargue con los nuevos datos
      ref.invalidate(currentUserProfileProvider);
      // Auto-assign recommended plan based on motive+detail
      final planId = _getRecommendedPlanId(state.motive, state.motiveDetail);
      if (planId != null) {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId != null) {
          try {
            await ref.read(studyDatasourceProvider).startPlan(userId, planId);
          } catch (_) {
            // Non-critical: plan assignment can fail silently
          }
        }
      }
      // Mostrar paywall después del onboarding
      context.go(RouteConstants.paywall);
    } else if (mounted) {
      // Mostrar error
      final state = ref.read(onboardingProvider);
      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  static const _motiveDetailPlanMap = {
    'difficult_moment:family_issues': 'b1000000-0000-0000-0000-000000000001',
    'difficult_moment:health_issues': 'b1000000-0000-0000-0000-000000000002',
    'difficult_moment:financial_issues': 'b1000000-0000-0000-0000-000000000003',
    'spiritual_growth:prayer_life': 'b1000000-0000-0000-0000-000000000004',
    'spiritual_growth:bible_knowledge': 'b1000000-0000-0000-0000-000000000005',
    'spiritual_growth:daily_faith': 'b1000000-0000-0000-0000-000000000006',
    'feeling_distant:stopped_practicing': 'b1000000-0000-0000-0000-000000000007',
    'feeling_distant:doubts': 'b1000000-0000-0000-0000-000000000008',
    'feeling_distant:painful_experience': 'b1000000-0000-0000-0000-000000000009',
    'understand_bible:apply_life': 'b1000000-0000-0000-0000-000000000010',
    'understand_bible:historical_context': 'b1000000-0000-0000-0000-000000000011',
    'understand_bible:denomination_differences': 'b1000000-0000-0000-0000-000000000012',
  };

  String? _getRecommendedPlanId(String? motive, String? motiveDetail) {
    if (motive == null || motiveDetail == null) return null;
    return _motiveDetailPlanMap['$motive:$motiveDetail'];
  }

  bool _canProceed() {
    final state = ref.watch(onboardingProvider);
    switch (_currentPage) {
      case 3: // Name - required
        return state.name != null;
      case 4: // Age
        return state.ageGroup != null;
      case 5: // Gender
        return state.gender != null;
      case 6: // Country
        return state.origin != null;
      case 7: // Denomination
        return state.denomination != null;
      case 8: // Faith motivation - requires selection
        return state.motive != null;
      case 9: // Motive detail - requires selection
        return state.motiveDetail != null;
      case 10: // Support type (multi-select)
        return state.supportTypes.isNotEmpty;
      case 11: // Commitment - requires selection
        return state.commitmentLevel != null;
      case 12: // Reminder - optional, always can proceed
        return true;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator with back button (show only on question pages)
              if (_currentPage > 2 && _currentPage < _totalPages - 3)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 24, 0),
                  child: Row(
                    children: [
                      // Back button
                      IconButton(
                        onPressed: _previousPage,
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.surfaceDark.withOpacity(0.5),
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Progress bar
                      Expanded(child: _buildProgressBar()),
                    ],
                  ),
                ),

              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    // Page 0: Welcome
                    OnboardingWelcomePage(
                      onGetStarted: _nextPage,
                      onLogin: () => context.push(RouteConstants.login),
                    ),

                    // Page 1: Privacy consent
                    OnboardingConsentPage(
                      onNext: _nextPage,
                      onPrivacyPolicy: () => context.push(RouteConstants.privacyPolicy),
                      onTermsConditions: () => context.push(RouteConstants.termsConditions),
                    ),

                    // Page 2: Intro
                    OnboardingIntroPage(
                      onNext: _nextPage,
                    ),

                    // Page 3: Name
                    Builder(
                      builder: (context) {
                        final state = ref.watch(onboardingProvider);
                        final notifier = ref.read(onboardingProvider.notifier);
                        return OnboardingNamePage(
                          currentName: state.name,
                          onNameChanged: (name) => notifier.setName(name),
                          onNext: _canProceed() ? _nextPage : null,
                        );
                      },
                    ),

                    // Page 4: Age selection
                    Builder(
                      builder: (context) {
                        final state = ref.watch(onboardingProvider);
                        final notifier = ref.read(onboardingProvider.notifier);
                        final name = state.name;
                        return OnboardingSelectionPage(
                          verseReference: 'Salmo 90:12',
                          title: 'Enséñanos a contar bien nuestros días.',
                          subtitle: name != null
                              ? '$name, ¿cuál es tu grupo de edad?'
                              : '¿Cuál es tu grupo de edad?',
                          options: const [
                            SelectionOption(key: '18-24', label: '18-24'),
                            SelectionOption(key: '25-34', label: '25-34'),
                            SelectionOption(key: '35-44', label: '35-44'),
                            SelectionOption(key: '45-54', label: '45-54'),
                            SelectionOption(key: '55+', label: '55+'),
                          ],
                          selectedKey: state.ageGroup,
                          onSelect: (key) => notifier.setAgeGroup(key),
                          onNext: _canProceed() ? _nextPage : null,
                        );
                      },
                    ),

                    // Page 5: Gender selection
                    Builder(
                      builder: (context) {
                        final state = ref.watch(onboardingProvider);
                        final notifier = ref.read(onboardingProvider.notifier);
                        return OnboardingSelectionPage(
                          verseReference: 'Salmo 139:14',
                          title: 'Dios nos creó única y maravillosamente.',
                          subtitle: '¿Cuál es tu género?',
                          options: const [
                            SelectionOption(key: 'male', label: 'Hombre'),
                            SelectionOption(key: 'female', label: 'Mujer'),
                          ],
                          selectedKey: state.gender,
                          onSelect: (key) => notifier.setGender(key),
                          onNext: _canProceed() ? _nextPage : null,
                        );
                      },
                    ),

                    // Page 6: Country selection
                    Builder(
                      builder: (context) {
                        final notifier = ref.read(onboardingProvider.notifier);
                        return OnboardingCountryPage(
                          onSelect: (originGroup) => notifier.setOrigin(originGroup),
                          onCountryCodeSelect: (code) => notifier.setCountryCode(code),
                          onNext: _canProceed() ? _nextPage : null,
                        );
                      },
                    ),

                    // Page 7: Denomination selection
                    Builder(
                      builder: (context) {
                        final state = ref.watch(onboardingProvider);
                        final notifier = ref.read(onboardingProvider.notifier);
                        return OnboardingSelectionPage(
                          verseReference: 'Efesios 4:5',
                          title: 'Un solo Señor, una sola fe, un solo bautismo.',
                          subtitle: '¿Cuál es tu tradición cristiana?',
                          options: const [
                            SelectionOption(
                              key: 'catolica',
                              label: 'Católica',
                              icon: Icons.church,
                            ),
                            SelectionOption(
                              key: 'evangelica',
                              label: 'Evangélica',
                              icon: Icons.menu_book,
                            ),
                            SelectionOption(
                              key: 'pentecostal',
                              label: 'Pentecostal',
                              icon: Icons.local_fire_department,
                            ),
                            SelectionOption(
                              key: 'bautista',
                              label: 'Bautista',
                              icon: Icons.water_drop,
                            ),
                            SelectionOption(
                              key: 'otra',
                              label: 'Otra / Sin denominación',
                              icon: Icons.diversity_3,
                            ),
                          ],
                          selectedKey: state.denomination,
                          onSelect: (key) => notifier.setDenomination(key),
                          onNext: _canProceed() ? _nextPage : null,
                        );
                      },
                    ),

                    // Page 8: Faith motivation
                    Builder(
                      builder: (context) {
                        final state = ref.watch(onboardingProvider);
                        final notifier = ref.read(onboardingProvider.notifier);
                        final name = state.name;
                        final isFemale = state.gender == 'female';
                        return OnboardingSelectionPage(
                          verseReference: 'Filipenses 1:6',
                          title: 'El que comenzó en vosotros la buena obra, la perfeccionará.',
                          subtitle: name != null
                              ? '$name, ¿por qué es importante para ti trabajar en tu Fe ahora?'
                              : '¿Por qué es importante para ti trabajar en tu Fe ahora?',
                          options: [
                            const SelectionOption(
                              key: 'difficult_moment',
                              label: 'Estoy pasando por un momento difícil',
                              icon: Icons.favorite,
                            ),
                            const SelectionOption(
                              key: 'spiritual_growth',
                              label: 'Quiero crecer espiritualmente',
                              icon: Icons.auto_awesome,
                            ),
                            SelectionOption(
                              key: 'feeling_distant',
                              label: isFemale
                                  ? 'Me siento alejada de Dios'
                                  : 'Me siento alejado de Dios',
                              icon: Icons.explore,
                            ),
                            const SelectionOption(
                              key: 'understand_bible',
                              label: 'Quiero entender mejor la Biblia',
                              icon: Icons.menu_book,
                            ),
                          ],
                          selectedKey: state.motive,
                          onSelect: (key) => notifier.setMotive(key),
                          onNext: _canProceed() ? _nextPage : null,
                        );
                      },
                    ),

                    // Page 9: Motive detail (follow-up to Faith motivation)
                    Builder(
                      builder: (context) {
                        final state = ref.watch(onboardingProvider);
                        final notifier = ref.read(onboardingProvider.notifier);
                        final config = _getMotiveDetailConfig(state.motive);
                        return OnboardingSelectionPage(
                          verseReference: config.verseReference,
                          title: config.verseText,
                          subtitle: config.question,
                          options: config.options,
                          selectedKey: state.motiveDetail,
                          onSelect: (key) => notifier.setMotiveDetail(key),
                          onNext: _canProceed() ? _nextPage : null,
                        );
                      },
                    ),

                    // Page 10: Support type
                    Builder(
                      builder: (context) {
                        final state = ref.watch(onboardingProvider);
                        final notifier = ref.read(onboardingProvider.notifier);
                        return OnboardingSelectionPage(
                          verseReference: 'Isaías 41:10',
                          title: 'No temas, porque yo estoy contigo.',
                          subtitle: '¿Cómo quieres que te ayudemos en Biblia Chat?',
                          hint: 'Puedes seleccionar más de una opción',
                          options: const [
                            SelectionOption(
                              key: 'talk_faith',
                              label: 'Quiero hablar sobre mi fe con alguien que me entienda',
                              icon: Icons.forum,
                            ),
                            SelectionOption(
                              key: 'daily_reflection',
                              label: 'Me gustaría recibir una reflexión bíblica cada mañana',
                              icon: Icons.wb_sunny,
                            ),
                            SelectionOption(
                              key: 'guided_plans',
                              label: 'Quiero aprender de la Biblia con planes guiados',
                              icon: Icons.menu_book,
                            ),
                          ],
                          selectedKeys: state.supportTypes,
                          onSelect: (key) => notifier.toggleSupportType(key),
                          onNext: _canProceed() ? _nextPage : null,
                        );
                      },
                    ),

                    // Page 11: Commitment
                    Builder(
                      builder: (context) {
                        final state = ref.watch(onboardingProvider);
                        final notifier = ref.read(onboardingProvider.notifier);
                        final isFemale = state.gender == 'female';
                        return OnboardingSelectionPage(
                          verseReference: 'Josué 1:9',
                          title: 'Sé fuerte y valiente, porque el Señor tu Dios estará contigo.',
                          subtitle: '¿Qué nivel de compromiso tienes con cumplir tus objetivos?',
                          options: [
                            SelectionOption(
                              key: 'high',
                              label: isFemale
                                  ? 'Estoy totalmente comprometida'
                                  : 'Estoy totalmente comprometido',
                              icon: Icons.local_fire_department,
                            ),
                            SelectionOption(
                              key: 'low',
                              label: isFemale
                                  ? 'No estoy muy comprometida, mis objetivos no son tan importantes para mí'
                                  : 'No estoy muy comprometido, mis objetivos no son tan importantes para mí',
                              icon: Icons.sentiment_neutral,
                            ),
                          ],
                          selectedKey: state.commitmentLevel,
                          onSelect: (key) => notifier.setCommitmentLevel(key),
                          onNext: _canProceed() ? _nextPage : null,
                        );
                      },
                    ),

                    // Page 12: Reminder
                    Builder(
                      builder: (context) {
                        final state = ref.watch(onboardingProvider);
                        final notifier = ref.read(onboardingProvider.notifier);
                        return OnboardingReminderPage(
                          reminderEnabled: state.reminderEnabled,
                          reminderTime: state.reminderTime,
                          onToggle: (value) => notifier.setReminderEnabled(value),
                          onTimeChanged: (value) => notifier.setReminderTime(value),
                          onNext: _nextPage,
                        );
                      },
                    ),

                    // Page 13: Analyzing
                    OnboardingAnalyzingPage(
                      onComplete: _nextPage,
                    ),

                    // Page 14: Motivational summary
                    Builder(
                      builder: (context) {
                        final state = ref.watch(onboardingProvider);
                        return OnboardingSummaryPage(
                          name: state.name,
                          motive: state.motive,
                          motiveDetail: state.motiveDetail,
                          supportTypes: state.supportTypes,
                          gender: state.gender,
                          onNext: _nextPage,
                        );
                      },
                    ),

                    // Page 15: Plan preview (replaces Ready page)
                    Builder(
                      builder: (context) {
                        final state = ref.watch(onboardingProvider);
                        return OnboardingPlanPreviewPage(
                          motive: state.motive,
                          motiveDetail: state.motiveDetail,
                          onStart: _completeOnboarding,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _MotiveDetailConfig _getMotiveDetailConfig(String? motive) {
    switch (motive) {
      case 'difficult_moment':
        return _MotiveDetailConfig(
          question: '¿Qué tipo de situación estás viviendo?',
          verseReference: 'Salmo 34:18',
          verseText: 'Cercano está el Señor a los quebrantados de corazón.',
          options: const [
            SelectionOption(
              key: 'family_issues',
              label: 'Problemas familiares o de pareja',
              icon: Icons.people,
            ),
            SelectionOption(
              key: 'health_issues',
              label: 'Problemas de salud',
              icon: Icons.healing,
            ),
            SelectionOption(
              key: 'financial_issues',
              label: 'Problemas económicos o laborales',
              icon: Icons.work,
            ),
          ],
        );
      case 'spiritual_growth':
        return _MotiveDetailConfig(
          question: '¿En qué área quieres crecer?',
          verseReference: '2 Pedro 3:18',
          verseText: 'Creced en la gracia y el conocimiento de nuestro Señor.',
          options: const [
            SelectionOption(
              key: 'prayer_life',
              label: 'Fortalecer mi vida de oración',
              icon: Icons.self_improvement,
            ),
            SelectionOption(
              key: 'bible_knowledge',
              label: 'Conocer mejor la Biblia',
              icon: Icons.menu_book,
            ),
            SelectionOption(
              key: 'daily_faith',
              label: 'Vivir mi fe en el día a día',
              icon: Icons.wb_sunny,
            ),
          ],
        );
      case 'feeling_distant':
        return _MotiveDetailConfig(
          question: '¿Qué te ha llevado a sentirte así?',
          verseReference: 'Santiago 4:8',
          verseText: 'Acercaos a Dios, y Él se acercará a vosotros.',
          options: const [
            SelectionOption(
              key: 'stopped_practicing',
              label: 'He dejado de practicar mi fe',
              icon: Icons.pause_circle,
            ),
            SelectionOption(
              key: 'faith_doubts',
              label: 'Tengo dudas sobre lo que creo',
              icon: Icons.help_outline,
            ),
            SelectionOption(
              key: 'painful_experience',
              label: 'He pasado por algo que me alejó',
              icon: Icons.heart_broken,
            ),
          ],
        );
      case 'understand_bible':
        return _MotiveDetailConfig(
          question: '¿Qué te gustaría entender mejor?',
          verseReference: 'Salmo 119:105',
          verseText: 'Lámpara es a mis pies tu palabra, y lumbrera a mi camino.',
          options: const [
            SelectionOption(
              key: 'apply_teachings',
              label: 'Cómo aplicar las enseñanzas a mi vida',
              icon: Icons.lightbulb,
            ),
            SelectionOption(
              key: 'historical_context',
              label: 'El contexto histórico y los libros',
              icon: Icons.history_edu,
            ),
            SelectionOption(
              key: 'denomination_differences',
              label: 'Las diferencias entre denominaciones',
              icon: Icons.diversity_3,
            ),
          ],
        );
      default:
        return _MotiveDetailConfig(
          question: '¿Qué te gustaría profundizar?',
          verseReference: 'Proverbios 2:6',
          verseText: 'Porque el Señor da la sabiduría.',
          options: const [
            SelectionOption(
              key: 'general',
              label: 'Explorar mi fe',
              icon: Icons.explore,
            ),
          ],
        );
    }
  }

  Widget _buildProgressBar() {
    // Progress from page 1 to page 5 (actual question pages)
    final progress = (_currentPage - 1) / (_totalPages - 4);

    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                height: 4,
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MotiveDetailConfig {
  final String question;
  final String verseReference;
  final String verseText;
  final List<SelectionOption> options;

  const _MotiveDetailConfig({
    required this.question,
    required this.verseReference,
    required this.verseText,
    required this.options,
  });
}
