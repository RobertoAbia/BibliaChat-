import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class OnboardingNamePage extends StatefulWidget {
  final ValueChanged<String> onNameChanged;
  final VoidCallback? onNext;
  final String? currentName;

  const OnboardingNamePage({
    super.key,
    required this.onNameChanged,
    required this.onNext,
    this.currentName,
  });

  @override
  State<OnboardingNamePage> createState() => _OnboardingNamePageState();
}

class _OnboardingNamePageState extends State<OnboardingNamePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Question
                  Text(
                    '¿Cómo te llamas?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  const SizedBox(height: 32),

                  // Name TextField with glass style
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: TextField(
                        controller: _controller,
                        onChanged: widget.onNameChanged,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                        decoration: InputDecoration(
                          hintText: 'Escribe tu nombre',
                          hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.textTertiary,
                              ),
                          filled: true,
                          fillColor: AppTheme.surfaceDark.withOpacity(0.4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppTheme.surfaceLight.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppTheme.surfaceLight.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppTheme.primaryColor.withOpacity(0.6),
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: AppTheme.primaryColor.withOpacity(0.6),
                          ),
                        ),
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          if (widget.onNext != null) widget.onNext!();
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bible verse (subtle)
                  Center(
                    child: Text(
                      '«Antes de formarte, ya te conocía.» — Jeremías 1:5',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textTertiary,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fixed bottom button
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.backgroundDark.withOpacity(0),
                  AppTheme.backgroundDark,
                ],
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: widget.onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.onNext != null
                          ? AppTheme.primaryColor
                          : AppTheme.surfaceDark,
                      foregroundColor: widget.onNext != null
                          ? AppTheme.textOnPrimary
                          : AppTheme.textTertiary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      minimumSize: Size.zero,
                      elevation: widget.onNext != null ? 8 : 0,
                      shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Continuar',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.onNext != null) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 20),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
