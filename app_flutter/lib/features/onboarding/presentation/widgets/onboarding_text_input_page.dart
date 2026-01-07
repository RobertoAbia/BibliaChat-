import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class OnboardingTextInputPage extends StatefulWidget {
  final String title;
  final String hint;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final VoidCallback onNext;

  const OnboardingTextInputPage({
    super.key,
    required this.title,
    required this.hint,
    this.initialValue,
    required this.onChanged,
    required this.onNext,
  });

  @override
  State<OnboardingTextInputPage> createState() =>
      _OnboardingTextInputPageState();
}

class _OnboardingTextInputPageState extends State<OnboardingTextInputPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          // Title
          Text(
            widget.title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.textPrimary,
                  height: 1.3,
                ),
          ),

          const SizedBox(height: 32),

          // Text input
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.surfaceLight.withOpacity(0.5),
              ),
            ),
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              maxLines: 4,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(20),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Optional note
          Text(
            'Es opcional, pero nos ayuda a personalizar tu experiencia.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textTertiary,
                ),
          ),

          const Spacer(),

          // Continue button
          UnconstrainedBox(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: widget.onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textOnPrimary,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Skip option
          Center(
            child: TextButton(
              onPressed: widget.onNext,
              child: Text(
                'Omitir por ahora',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textTertiary,
                    ),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
