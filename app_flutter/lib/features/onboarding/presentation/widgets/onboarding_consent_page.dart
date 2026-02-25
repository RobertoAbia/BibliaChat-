import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class OnboardingConsentPage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onPrivacyPolicy;
  final VoidCallback? onTermsConditions;

  const OnboardingConsentPage({
    super.key,
    required this.onNext,
    this.onPrivacyPolicy,
    this.onTermsConditions,
  });

  @override
  State<OnboardingConsentPage> createState() => _OnboardingConsentPageState();
}

class _OnboardingConsentPageState extends State<OnboardingConsentPage> {
  bool _acceptedTerms = false;
  bool _acceptedData = false;

  bool get _canContinue => _acceptedTerms && _acceptedData;

  void _acceptAll() {
    setState(() {
      _acceptedTerms = true;
      _acceptedData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 48),

                // Shield icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: AppTheme.primaryColor,
                    size: 40,
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  'Tu privacidad es lo primero',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'Para ofrecerte una experiencia personalizada, necesitamos tu consentimiento.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Checkbox 1: Terms & Privacy
                _buildCheckboxCard(
                  value: _acceptedTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptedTerms = value ?? false;
                    });
                  },
                  child: Text.rich(
                    TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            height: 1.4,
                          ),
                      children: [
                        const TextSpan(text: 'Acepto los '),
                        TextSpan(
                          text: 'Términos de Servicio',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                AppTheme.primaryColor.withOpacity(0.5),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onTermsConditions,
                        ),
                        const TextSpan(text: ' y la '),
                        TextSpan(
                          text: 'Política de Privacidad',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                AppTheme.primaryColor.withOpacity(0.5),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onPrivacyPolicy,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Checkbox 2: Sensitive data (GDPR Art. 9)
                _buildCheckboxCard(
                  value: _acceptedData,
                  onChanged: (value) {
                    setState(() {
                      _acceptedData = value ?? false;
                    });
                  },
                  child: Text(
                    'Consiento el tratamiento de mis datos de creencias religiosas para personalizar mi experiencia',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          height: 1.4,
                        ),
                  ),
                ),

                const SizedBox(height: 20),

                // "Accept all" button
                TextButton(
                  onPressed: _canContinue ? null : _acceptAll,
                  child: Text(
                    'Aceptar todo',
                    style: TextStyle(
                      color: _canContinue
                          ? AppTheme.textTertiary
                          : AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Bottom button
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Opacity(
            opacity: _canContinue ? 1.0 : 0.4,
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
                  onPressed: _canContinue ? widget.onNext : null,
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
        ),
      ],
    );
  }

  Widget _buildCheckboxCard({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: value
                ? AppTheme.primaryColor.withOpacity(0.5)
                : AppTheme.surfaceLight.withOpacity(0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: AppTheme.primaryColor,
                checkColor: AppTheme.textOnPrimary,
                side: BorderSide(
                  color: AppTheme.textTertiary,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
