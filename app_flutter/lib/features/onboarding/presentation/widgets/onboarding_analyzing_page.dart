import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class OnboardingAnalyzingPage extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingAnalyzingPage({
    super.key,
    required this.onComplete,
  });

  @override
  State<OnboardingAnalyzingPage> createState() =>
      _OnboardingAnalyzingPageState();
}

class _OnboardingAnalyzingPageState extends State<OnboardingAnalyzingPage>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  int _currentStep = 0;

  final List<_AnalyzingStep> _steps = [
    _AnalyzingStep(
      label: 'Analizando tus respuestas',
      duration: const Duration(milliseconds: 1500),
    ),
    _AnalyzingStep(
      label: 'Personalizando tu experiencia',
      duration: const Duration(milliseconds: 1200),
    ),
    _AnalyzingStep(
      label: 'Preparando tu viaje espiritual',
      duration: const Duration(milliseconds: 1000),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _startAnimation();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _startAnimation() async {
    for (int i = 0; i < _steps.length; i++) {
      if (!mounted) return;

      setState(() {
        _currentStep = i;
      });

      _progressController.forward(from: 0);
      await Future.delayed(_steps[i].duration);
    }

    // Small delay before completing
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.add_rounded,
                size: 50,
                color: AppTheme.backgroundDark.withOpacity(0.9),
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Title
          Text(
            'Tu viaje espiritual',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.textPrimary,
                ),
          ),

          const SizedBox(height: 48),

          // Progress steps
          ...List.generate(_steps.length, (index) {
            final isActive = index == _currentStep;
            final isCompleted = index < _currentStep;

            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _steps[index].label,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isActive || isCompleted
                                      ? AppTheme.textPrimary
                                      : AppTheme.textTertiary,
                                ),
                      ),
                      if (isCompleted)
                        const Icon(
                          Icons.check_circle,
                          color: AppTheme.successColor,
                          size: 20,
                        )
                      else if (isActive)
                        Text(
                          '${((_progressController.value) * 100).toInt()}%',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.primaryColor,
                                  ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: isCompleted
                              ? 1.0
                              : (isActive ? _progressController.value : 0.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: isCompleted
                                  ? null
                                  : AppTheme.goldGradient,
                              color: isCompleted
                                  ? AppTheme.successColor
                                  : null,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AnalyzingStep {
  final String label;
  final Duration duration;

  _AnalyzingStep({
    required this.label,
    required this.duration,
  });
}
