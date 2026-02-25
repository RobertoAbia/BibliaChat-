import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_theme.dart';

class PrePaywallScreen extends StatefulWidget {
  const PrePaywallScreen({super.key});

  @override
  State<PrePaywallScreen> createState() => _PrePaywallScreenState();
}

class _PrePaywallScreenState extends State<PrePaywallScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage == 0) {
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
      setState(() => _currentPage = 1);
    } else {
      context.go(RouteConstants.paywall);
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
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildPage([
                      const TextSpan(
                        text: 'Ofrecemos\n',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textPrimary,
                          height: 1.4,
                        ),
                      ),
                      TextSpan(
                        text: '3 dias gratis\n',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                          height: 1.4,
                        ),
                      ),
                      const TextSpan(
                        text: 'para que todos puedan\nacercarse a Dios',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ]),
                    _buildPage([
                      const TextSpan(
                        text: 'Recibiras un\nrecordatorio ',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textPrimary,
                          height: 1.4,
                        ),
                      ),
                      TextSpan(
                        text: '2 dias',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                          height: 1.4,
                        ),
                      ),
                      const TextSpan(
                        text: '\nantes de que termine\ntu prueba',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ]),
                  ],
                ),
              ),

              // Botón Continuar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                      onPressed: _next,
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
                            'Continuar',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.backgroundDark,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.chevron_right, size: 22, color: AppTheme.backgroundDark),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(List<TextSpan> spans) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text.rich(
          TextSpan(children: spans),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
