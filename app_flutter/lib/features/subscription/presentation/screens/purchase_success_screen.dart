import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_theme.dart';

class PurchaseSuccessScreen extends StatefulWidget {
  const PurchaseSuccessScreen({super.key});

  @override
  State<PurchaseSuccessScreen> createState() => _PurchaseSuccessScreenState();
}

class _PurchaseSuccessScreenState extends State<PurchaseSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Emoji celebración animado
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: const Text(
                            '🎉',
                            style: TextStyle(fontSize: 64),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Logo
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/images/splash_logo.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Título
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: '¡Bienvenido a\n',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w400,
                                    color: AppTheme.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Premium',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryColor,
                                    height: 1.4,
                                  ),
                                ),
                                const TextSpan(
                                  text: '!',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w400,
                                    color: AppTheme.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Subtítulo motivador
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'Tu camino de fe sin límites comienza ahora',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textSecondary,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Features desbloqueadas
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.primaryColor.withOpacity(0.15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.08),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: const Column(
                              children: [
                                _FeatureItem(
                                  icon: Icons.chat_bubble_outline,
                                  text: 'Chat ilimitado con tu consejero',
                                ),
                                SizedBox(height: 16),
                                _FeatureItem(
                                  icon: Icons.menu_book_outlined,
                                  text: 'Todos los planes de estudio',
                                ),
                                SizedBox(height: 16),
                                _FeatureItem(
                                  icon: Icons.wb_sunny_outlined,
                                  text: 'Reflexiones diarias completas',
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

              // Botón Comenzar
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => context.go(RouteConstants.home),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Comenzar',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.chevron_right, size: 22, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: AppTheme.goldGradient,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Icon(
          Icons.check_circle,
          size: 20,
          color: AppTheme.primaryColor,
        ),
      ],
    );
  }
}
