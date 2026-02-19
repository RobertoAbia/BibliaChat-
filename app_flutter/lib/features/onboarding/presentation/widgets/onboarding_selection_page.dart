import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

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
  final String? hint;
  final List<SelectionOption> options;
  final String? selectedKey;
  final Set<String>? selectedKeys; // For multi-select
  final ValueChanged<String> onSelect;
  final VoidCallback? onNext;

  const OnboardingSelectionPage({
    super.key,
    this.verseReference,
    required this.title,
    required this.subtitle,
    this.hint,
    required this.options,
    this.selectedKey,
    this.selectedKeys,
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

                // Question (main heading — clean, bold)
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),

                // Optional hint (e.g. for multi-select)
                if (hint != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app_outlined,
                          color: AppTheme.primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          hint!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],

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
                        isSelected: selectedKeys != null
                            ? selectedKeys!.contains(option.key)
                            : selectedKey == option.key,
                        onTap: () => onSelect(option.key),
                      ),
                    ),
                  );
                }),

                // Bible verse (subtle decorative quote)
                if (verseReference != null) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      '«$title» — $verseReference',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textTertiary,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
                ],

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
    // If deselected while animation is in progress, reset immediately
    if (!widget.isSelected && _controller.isAnimating) {
      _controller.reset();
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? AppTheme.primaryColor.withOpacity(0.25)
                    : Colors.transparent,
                blurRadius: widget.isSelected ? 20 : 0,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? AppTheme.primaryColor.withOpacity(0.15)
                      : AppTheme.surfaceDark.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: widget.isSelected
                        ? AppTheme.primaryColor.withOpacity(0.6)
                        : AppTheme.surfaceLight.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              child: Row(
                children: [
                  // Icon container
                  if (widget.option.icon != null) ...[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.surfaceLight.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: widget.isSelected
                                ? AppTheme.primaryColor.withOpacity(0.3)
                                : Colors.transparent,
                            blurRadius: widget.isSelected ? 10 : 0,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 350),
                        style: TextStyle(
                          color: widget.isSelected
                              ? AppTheme.textOnPrimary
                              : AppTheme.textSecondary,
                        ),
                        child: Icon(
                          widget.option.icon,
                          color: widget.isSelected
                              ? AppTheme.textOnPrimary
                              : AppTheme.textSecondary,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: widget.isSelected
                                    ? AppTheme.textPrimary
                                    : AppTheme.textSecondary,
                                fontWeight: widget.isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                          child: Text(widget.option.label),
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
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.surfaceLight.withOpacity(0.4),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.textTertiary.withOpacity(0.3),
                        width: widget.isSelected ? 0 : 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.isSelected
                              ? AppTheme.primaryColor.withOpacity(0.3)
                              : Colors.transparent,
                          blurRadius: widget.isSelected ? 8 : 0,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: widget.isSelected ? 1.0 : 0.0,
                      child: const Icon(
                        Icons.check,
                        color: AppTheme.textOnPrimary,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
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
