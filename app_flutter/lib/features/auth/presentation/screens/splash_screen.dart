import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/lottie_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _gradientController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _gradientShift;

  @override
  void initState() {
    super.initState();

    // Main fade/scale animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Pulse animation for the glow
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Gradient shift animation
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _gradientShift = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _gradientController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeController.forward();
    _pulseController.repeat(reverse: true);
    _gradientController.repeat(reverse: true);
    _checkAuthAndNavigate();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      context.go(RouteConstants.home);
    } else {
      try {
        await Supabase.instance.client.auth.signInAnonymously();
        if (mounted) {
          context.go(RouteConstants.onboarding);
        }
      } catch (e) {
        if (mounted) {
          context.go(RouteConstants.onboarding);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    AppTheme.backgroundDark,
                    const Color(0xFF1E1E35),
                    _gradientShift.value * 0.3,
                  )!,
                  Color.lerp(
                    AppTheme.backgroundDeep,
                    const Color(0xFF151528),
                    _gradientShift.value * 0.3,
                  )!,
                ],
              ),
            ),
            child: child,
          );
        },
        child: Stack(
          children: [
            // Floating particles
            ...List.generate(6, (index) => _FloatingParticle(index: index)),

            // Main content
            Center(
              child: AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo with Lottie animation and glow
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: _buildLogo(),
                              );
                            },
                          ),
                          const SizedBox(height: 40),

                          // App name with shimmer effect
                          _buildAppName(context),
                          const SizedBox(height: 12),

                          // Tagline
                          Text(
                            'Tu fe, tu idioma, tu cultura',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppTheme.textSecondary,
                                      letterSpacing: 0.5,
                                    ),
                          ),
                          const SizedBox(height: 60),

                          // Loading indicator with Lottie
                          _buildLoadingIndicator(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
                blurRadius: 60,
                spreadRadius: 20,
              ),
            ],
          ),
        ),

        // Glass container with blur effect
        ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: AppTheme.primaryLight.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.5),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                // Try Lottie first, fallback to icon
                child: Lottie.asset(
                  LottieAssets.crossGlow,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.add_rounded,
                      size: 70,
                      color: AppTheme.backgroundDark.withOpacity(0.9),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppName(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          AppTheme.primaryLight,
          AppTheme.primaryColor,
          AppTheme.primaryLight,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(bounds),
      child: Text(
        'Biblia Chat',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Lottie.asset(
      LottieAssets.loadingDots,
      width: 60,
      height: 40,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.primaryColor.withOpacity(0.8),
            ),
          ),
        );
      },
    );
  }
}

/// Floating particle animation
class _FloatingParticle extends StatefulWidget {
  final int index;

  const _FloatingParticle({required this.index});

  @override
  State<_FloatingParticle> createState() => _FloatingParticleState();
}

class _FloatingParticleState extends State<_FloatingParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    final duration = Duration(seconds: 4 + widget.index);

    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );

    // Different starting positions based on index
    final startX = (widget.index % 3 - 1) * 0.3;
    final startY = 0.8 + (widget.index * 0.1);
    final endY = -0.2 - (widget.index * 0.1);

    _positionAnimation = Tween<Offset>(
      begin: Offset(startX, startY),
      end: Offset(startX + (widget.index.isEven ? 0.1 : -0.1), endY),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 0.6),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.6, end: 0.6),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.6, end: 0),
        weight: 20,
      ),
    ]).animate(_controller);

    Future.delayed(Duration(milliseconds: widget.index * 400), () {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final particleSize = 4.0 + (widget.index % 3) * 2;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: size.width * (0.5 + _positionAnimation.value.dx),
          top: size.height * (0.5 + _positionAnimation.value.dy),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: particleSize,
              height: particleSize,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
