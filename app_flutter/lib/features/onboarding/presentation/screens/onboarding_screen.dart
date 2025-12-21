import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/onboarding_welcome_page.dart';
import '../widgets/onboarding_selection_page.dart';
import '../widgets/onboarding_text_input_page.dart';
import '../widgets/onboarding_analyzing_page.dart';
import '../widgets/onboarding_ready_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 9;

  // Onboarding data
  String? _selectedAgeGroup;
  String? _selectedGender;
  String? _selectedDenomination;
  String? _selectedBibleVersion;
  String? _selectedSupportType;
  String? _heartMessage;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    // TODO: Save onboarding data to Supabase user_profiles
    context.go(RouteConstants.home);
  }

  bool _canProceed() {
    switch (_currentPage) {
      case 1:
        return _selectedAgeGroup != null;
      case 2:
        return _selectedGender != null;
      case 3:
        return _selectedDenomination != null;
      case 4:
        return _selectedBibleVersion != null;
      case 5:
        return _selectedSupportType != null;
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
              // Progress indicator (show only on question pages)
              if (_currentPage > 0 && _currentPage < _totalPages - 2)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: _buildProgressBar(),
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
                    ),

                    // Page 1: Age selection
                    OnboardingSelectionPage(
                      verseReference: 'Salmo 90:12',
                      title: 'Enséñanos a contar\nbien nuestros días.',
                      subtitle: '¿Cuál es tu grupo de edad?',
                      options: const [
                        SelectionOption(key: '18-24', label: '18-24'),
                        SelectionOption(key: '25-34', label: '25-34'),
                        SelectionOption(key: '35-44', label: '35-44'),
                        SelectionOption(key: '45-54', label: '45-54'),
                        SelectionOption(key: '55+', label: '55+'),
                      ],
                      selectedKey: _selectedAgeGroup,
                      onSelect: (key) {
                        setState(() => _selectedAgeGroup = key);
                      },
                      onNext: _canProceed() ? _nextPage : null,
                    ),

                    // Page 2: Gender selection
                    OnboardingSelectionPage(
                      verseReference: 'Salmo 139:14',
                      title: 'Dios nos creó única y\nmaravillosamente.',
                      subtitle: '¿Cuál es tu género?',
                      options: const [
                        SelectionOption(key: 'male', label: 'Hombre'),
                        SelectionOption(key: 'female', label: 'Mujer'),
                      ],
                      selectedKey: _selectedGender,
                      onSelect: (key) {
                        setState(() => _selectedGender = key);
                      },
                      onNext: _canProceed() ? _nextPage : null,
                    ),

                    // Page 3: Denomination selection
                    OnboardingSelectionPage(
                      verseReference: 'Efesios 4:5',
                      title: 'Un solo Señor, una sola fe,\nun solo bautismo.',
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
                      selectedKey: _selectedDenomination,
                      onSelect: (key) {
                        setState(() => _selectedDenomination = key);
                      },
                      onNext: _canProceed() ? _nextPage : null,
                    ),

                    // Page 4: Bible version
                    OnboardingSelectionPage(
                      verseReference: '2 Timoteo 3:16',
                      title: 'Toda la Escritura es\ninspirada por Dios.',
                      subtitle: '¿Qué versión de la Biblia prefieres?',
                      options: const [
                        SelectionOption(
                          key: 'RVR1960',
                          label: 'Reina-Valera 1960',
                          subtitle: 'Tradicional y ampliamente usada',
                        ),
                        SelectionOption(
                          key: 'NVI',
                          label: 'Nueva Versión Internacional',
                          subtitle: 'Lenguaje contemporáneo',
                        ),
                        SelectionOption(
                          key: 'NTV',
                          label: 'Nueva Traducción Viviente',
                          subtitle: 'Fácil de entender',
                        ),
                        SelectionOption(
                          key: 'LBLA',
                          label: 'La Biblia de las Américas',
                          subtitle: 'Traducción literal',
                        ),
                      ],
                      selectedKey: _selectedBibleVersion,
                      onSelect: (key) {
                        setState(() => _selectedBibleVersion = key);
                      },
                      onNext: _canProceed() ? _nextPage : null,
                    ),

                    // Page 5: Support type
                    OnboardingSelectionPage(
                      verseReference: 'Isaías 41:10',
                      title: 'La Biblia tiene respuestas\npara superar cualquier prueba.',
                      subtitle: '¿Cómo te puede ayudar Biblia Chat?',
                      options: const [
                        SelectionOption(
                          key: 'study',
                          label: 'Solo estudiar la Biblia',
                          icon: Icons.menu_book,
                        ),
                        SelectionOption(
                          key: 'overcome',
                          label: 'Superar sufrimientos y desafíos',
                          icon: Icons.favorite,
                        ),
                      ],
                      selectedKey: _selectedSupportType,
                      onSelect: (key) {
                        setState(() => _selectedSupportType = key);
                      },
                      onNext: _canProceed() ? _nextPage : null,
                    ),

                    // Page 6: Heart input
                    OnboardingTextInputPage(
                      title:
                          '¿Qué hay en tu corazón?\nCreemos que la Biblia tiene\nconsuelo y paz para ti.',
                      hint: 'Escribe lo que sientes...',
                      initialValue: _heartMessage,
                      onChanged: (value) {
                        _heartMessage = value;
                      },
                      onNext: _nextPage,
                    ),

                    // Page 7: Analyzing
                    OnboardingAnalyzingPage(
                      onComplete: _nextPage,
                    ),

                    // Page 8: Ready
                    OnboardingReadyPage(
                      onStart: _completeOnboarding,
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

  Widget _buildProgressBar() {
    // Progress from page 1 to page 5 (actual question pages)
    final progress = (_currentPage) / (_totalPages - 3);

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
