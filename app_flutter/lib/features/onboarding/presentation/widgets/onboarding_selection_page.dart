import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';

class SelectionOption {
  final String key;
  final String label;
  final String? subtitle;
  final IconData? icon;

  const SelectionOption({
    required this.key,
    required this.label,
    this.subtitle,
    this.icon,
  });
}

class OnboardingSelectionPage extends StatelessWidget {
  final String? verseReference;
  final String title;
  final String subtitle;
  final List<SelectionOption> options;
  final String? selectedKey;
  final ValueChanged<String> onSelect;
  final VoidCallback? onNext;

  const OnboardingSelectionPage({
    super.key,
    this.verseReference,
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selectedKey,
    required this.onSelect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Verse reference badge with glass effect
                if (verseReference != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.menu_book_outlined,
                              color: AppTheme.primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              verseReference!,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Bible verse (decorative, subtle)
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textTertiary,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                      ),
                ),

                const SizedBox(height: 24),

                // Subtitle (question) with glass effect
                GlassContainer(
                  blur: 8,
                  backgroundOpacity: 0.35,
                  borderRadius: 14,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: AppTheme.goldGradient,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          subtitle,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Options with glass effect
                ...options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400 + (index * 80)),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 25 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SelectionTile(
                        option: option,
                        isSelected: selectedKey == option.key,
                        onTap: () => onSelect(option.key),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),
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
            child: _AnimatedButton(
              onPressed: onNext,
              isEnabled: onNext != null,
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectionTile extends StatefulWidget {
  final SelectionOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SelectionTile> createState() => _SelectionTileState();
}

class _SelectionTileState extends State<_SelectionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_SelectionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget.isSelected ? 12 : 8,
              sigmaY: widget.isSelected ? 12 : 8,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: widget.isSelected
                    ? LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.2),
                          AppTheme.primaryColor.withOpacity(0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: widget.isSelected
                    ? null
                    : AppTheme.surfaceDark.withOpacity(0.4),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: widget.isSelected
                      ? AppTheme.primaryColor.withOpacity(0.6)
                      : AppTheme.surfaceLight.withOpacity(0.3),
                  width: widget.isSelected ? 1.5 : 1,
                ),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  // Icon container
                  if (widget.option.icon != null) ...[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: widget.isSelected ? AppTheme.goldGradient : null,
                        color: widget.isSelected
                            ? null
                            : AppTheme.surfaceLight.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: widget.isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        widget.option.icon,
                        color: widget.isSelected
                            ? AppTheme.textOnPrimary
                            : AppTheme.textSecondary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.option.label,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: widget.isSelected
                                    ? AppTheme.textPrimary
                                    : AppTheme.textSecondary,
                                fontWeight: widget.isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                        ),
                        if (widget.option.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.option.subtitle!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textTertiary,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Check indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: widget.isSelected ? AppTheme.goldGradient : null,
                      color: widget.isSelected
                          ? null
                          : AppTheme.surfaceLight.withOpacity(0.4),
                      shape: BoxShape.circle,
                      border: !widget.isSelected
                          ? Border.all(
                              color: AppTheme.textTertiary.withOpacity(0.3),
                              width: 2,
                            )
                          : null,
                      boxShadow: widget.isSelected
                          ? [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                    child: widget.isSelected
                        ? const Icon(
                            Icons.check,
                            color: AppTheme.textOnPrimary,
                            size: 16,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;

  const _AnimatedButton({
    required this.onPressed,
    required this.isEnabled,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    if (widget.isEnabled) {
      _shimmerController.repeat();
    }
  }

  @override
  void didUpdateWidget(_AnimatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEnabled && !oldWidget.isEnabled) {
      _shimmerController.repeat();
    } else if (!widget.isEnabled && oldWidget.isEnabled) {
      _shimmerController.stop();
      _shimmerController.reset();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isEnabled ? AppTheme.primaryColor : AppTheme.surfaceDark,
            foregroundColor: widget.isEnabled ? AppTheme.textOnPrimary : AppTheme.textTertiary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            minimumSize: Size.zero,
            elevation: widget.isEnabled ? 8 : 0,
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
              if (widget.isEnabled) ...[
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
