import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';

class OnboardingWelcomePage extends StatefulWidget {
  final VoidCallback onGetStarted;
  final VoidCallback? onLogin;

  const OnboardingWelcomePage({
    super.key,
    required this.onGetStarted,
    this.onLogin,
  });

  @override
  State<OnboardingWelcomePage> createState() => _OnboardingWelcomePageState();
}

class _OnboardingWelcomePageState extends State<OnboardingWelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;
  late Animation<double> _scale;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideUp = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _pulse = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.06),

                      // Animated Logo with pulse
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scale.value * _pulse.value,
                            child: Opacity(
                              opacity: _fadeIn.value,
                              child: _buildLogo(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Title with animation
                      Transform.translate(
                        offset: Offset(0, _slideUp.value),
                        child: Opacity(
                          opacity: _fadeIn.value,
                          child: Column(
                            children: [
                              Text(
                                'Bienvenido a',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: AppTheme.textSecondary,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    AppTheme.primaryLight,
                                    AppTheme.primaryColor,
                                    AppTheme.primaryLight,
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'Biblia Chat',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Features card with glassmorphism
                      Transform.translate(
                        offset: Offset(0, _slideUp.value * 1.3),
                        child: Opacity(
                          opacity: _fadeIn.value,
                          child: GlassContainer.card(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Column(
                              children: [
                                _FeatureRow(
                                  icon: Icons.chat_bubble_outline,
                                  text: 'Un amigo que te escucha',
                                  delay: 0,
                                ),
                                const SizedBox(height: 14),
                                _FeatureRow(
                                  icon: Icons.favorite,
                                  text: 'Oraciones personalizadas',
                                  delay: 100,
                                ),
                                const SizedBox(height: 14),
                                _FeatureRow(
                                  icon: Icons.school,
                                  text: 'Planes de estudio bíblico',
                                  delay: 200,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                      // CTA Button with shimmer
                      Transform.translate(
                        offset: Offset(0, _slideUp.value * 1.6),
                        child: Opacity(
                          opacity: _fadeIn.value,
                          child: Column(
                            children: [
                              _ShimmerButton(
                                onPressed: widget.onGetStarted,
                                controller: _shimmerController,
                              ),

                              const SizedBox(height: 8),

                              // Ya tengo cuenta
                              if (widget.onLogin != null)
                                TextButton(
                                  onPressed: widget.onLogin,
                                  child: Text(
                                    '¿Ya tienes cuenta? Inicia sesión',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        );
      },
    );
  }

  Widget _buildLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 50,
                spreadRadius: 15,
              ),
            ],
          ),
        ),

        // Logo image
        ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: Image.asset(
            'assets/images/splash_logo.png',
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

class _FeatureRow extends StatefulWidget {
  final IconData icon;
  final String text;
  final int delay;

  const _FeatureRow({
    required this.icon,
    required this.text,
    this.delay = 0,
  });

  @override
  State<_FeatureRow> createState() => _FeatureRowState();
}

class _FeatureRowState extends State<_FeatureRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideIn = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 600 + widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideIn,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                ),
              ),
              child: Icon(
                widget.icon,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: AppTheme.successColor,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final AnimationController controller;

  const _ShimmerButton({
    required this.onPressed,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed,
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Comenzar mi viaje',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, size: 22),
            ],
          ),
        ),
      ],
    );
  }
}
