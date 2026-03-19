import 'dart:math';

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
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  int _currentStep = 0;

  final List<_AnalyzingStep> _steps = [
    _AnalyzingStep(
      icon: Icons.psychology_outlined,
      label: 'Analizando tus respuestas',
      duration: const Duration(milliseconds: 1500),
    ),
    _AnalyzingStep(
      icon: Icons.auto_awesome_outlined,
      label: 'Personalizando tu experiencia',
      duration: const Duration(milliseconds: 1200),
    ),
    _AnalyzingStep(
      icon: Icons.route_outlined,
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
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: 1.0,
    );
    _startAnimation();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _startAnimation() async {
    for (int i = 0; i < _steps.length; i++) {
      if (!mounted) return;

      // Fade in new step
      _fadeController.forward(from: 0);

      setState(() {
        _currentStep = i;
      });

      _progressController.forward(from: 0);
      await Future.delayed(_steps[i].duration);
    }

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
          // Pulsing logo with glow
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final scale = 1.0 + (_pulseController.value * 0.05);
              final glowOpacity = 0.3 + (_pulseController.value * 0.2);
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(glowOpacity),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/splash_logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Animated current step label
          FadeTransition(
            opacity: _fadeController,
            child: Text(
              _steps[_currentStep].label,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 40),

          // Step indicators with icons
          ...List.generate(_steps.length, (index) {
            final isActive = index == _currentStep;
            final isCompleted = index < _currentStep;

            return AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                final progressValue = isActive ? _progressController.value : 0.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      // Step icon
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppTheme.successColor
                              : isActive
                                  ? AppTheme.primaryColor.withOpacity(0.15)
                                  : AppTheme.surfaceLight.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isCompleted ? Icons.check : _steps[index].icon,
                          color: isCompleted
                              ? Colors.white
                              : isActive
                                  ? AppTheme.primaryColor
                                  : AppTheme.textTertiary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Label + progress bar
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _steps[index].label,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isActive || isCompleted
                                        ? AppTheme.textPrimary
                                        : AppTheme.textTertiary,
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceLight,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: isCompleted ? 1.0 : progressValue,
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class _AnalyzingStep {
  final IconData icon;
  final String label;
  final Duration duration;

  _AnalyzingStep({
    required this.icon,
    required this.label,
    required this.duration,
  });
}
