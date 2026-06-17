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
  late final AnimationController _controller; // progreso 0→1
  late final AnimationController _glowController; // glow pulsante
  bool _completed = false;
  int _currentStep = 0;

  static const List<String> _labels = [
    'Analizando tus respuestas',
    'Personalizando tu experiencia',
    'Preparando tu viaje espiritual',
  ];

  // Umbrales de progreso para cambiar de etiqueta (duraciones 1500/1200/1000).
  static const double _step0End = 0.405;
  static const double _step1End = 0.73;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3700),
    )..addListener(_onTick);

    _controller.forward().whenComplete(() async {
      await Future.delayed(const Duration(milliseconds: 450));
      if (mounted && !_completed) {
        _completed = true;
        widget.onComplete();
      }
    });
  }

  void _onTick() {
    final v = _controller.value;
    final step = v < _step0End ? 0 : (v < _step1End ? 1 : 2);
    if (step != _currentStep) {
      setState(() => _currentStep = step);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Anillo de progreso con glow pulsante y % en el centro
          SizedBox(
            width: 200,
            height: 200,
            child: AnimatedBuilder(
              animation: Listenable.merge([_controller, _glowController]),
              builder: (context, _) {
                final progress = _controller.value;
                final glowOpacity = 0.22 + (_glowController.value * 0.22);
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(glowOpacity),
                            blurRadius: 44,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    // Anillo
                    SizedBox(
                      width: 172,
                      height: 172,
                      child: CustomPaint(
                        painter: _RingPainter(progress),
                      ),
                    ),
                    // Porcentaje
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 48),

          // Línea de estado que cambia con fade + slide
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.25),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              _labels[_currentStep],
              key: ValueKey(_currentStep),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Esto solo tomará un momento',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 36),

          // Puntos de avance
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_labels.length, (i) {
              final active = i <= _currentStep;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  gradient: active ? AppTheme.goldGradient : null,
                  color: active ? null : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Anillo de progreso con gradiente y extremos redondeados.
class _RingPainter extends CustomPainter {
  final double progress;

  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - 6;
    const stroke = 10.0;

    final bgPaint = Paint()
      ..color = AppTheme.surfaceLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    if (progress <= 0) return;

    final rect = Rect.fromCircle(center: center, radius: radius);
    final fgPaint = Paint()
      ..shader = const SweepGradient(
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
        colors: [AppTheme.primaryLight, AppTheme.primaryColor],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
