import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Widget con efecto glassmorphism (cristal esmerilado)
/// Usa BackdropFilter para crear un efecto de blur de fondo
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final Color? backgroundColor;
  final double backgroundOpacity;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final Gradient? borderGradient;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.blur = 10,
    this.backgroundColor,
    this.backgroundOpacity = 0.3,
    this.showBorder = true,
    this.borderColor,
    this.borderWidth = 1,
    this.borderGradient,
    this.boxShadow,
    this.onTap,
  });

  /// Variante con borde dorado sutil
  factory GlassContainer.gold({
    Key? key,
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = 20,
    double blur = 10,
    VoidCallback? onTap,
  }) {
    return GlassContainer(
      key: key,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      blur: blur,
      showBorder: true,
      borderColor: AppTheme.primaryColor.withOpacity(0.3),
      boxShadow: [
        BoxShadow(
          color: AppTheme.primaryColor.withOpacity(0.1),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ],
      onTap: onTap,
      child: child,
    );
  }

  /// Variante para cards de contenido
  factory GlassContainer.card({
    Key? key,
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = 24,
    VoidCallback? onTap,
  }) {
    return GlassContainer(
      key: key,
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      margin: margin,
      borderRadius: borderRadius,
      blur: 15,
      backgroundOpacity: 0.4,
      showBorder: true,
      borderColor: AppTheme.surfaceLight.withOpacity(0.3),
      onTap: onTap,
      child: child,
    );
  }

  /// Variante para inputs
  factory GlassContainer.input({
    Key? key,
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    double borderRadius = 16,
  }) {
    return GlassContainer(
      key: key,
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: borderRadius,
      blur: 8,
      backgroundOpacity: 0.35,
      showBorder: true,
      borderColor: AppTheme.surfaceLight.withOpacity(0.4),
      child: child,
    );
  }

  /// Variante para selección (tiles)
  factory GlassContainer.selection({
    Key? key,
    required Widget child,
    required bool isSelected,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = 16,
    VoidCallback? onTap,
  }) {
    return GlassContainer(
      key: key,
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      borderRadius: borderRadius,
      blur: isSelected ? 12 : 8,
      backgroundOpacity: isSelected ? 0.45 : 0.25,
      showBorder: true,
      borderColor: isSelected
          ? AppTheme.primaryColor.withOpacity(0.6)
          : AppTheme.surfaceLight.withOpacity(0.3),
      borderWidth: isSelected ? 1.5 : 1,
      boxShadow: isSelected
          ? [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ]
          : null,
      onTap: onTap,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppTheme.surfaceDark;

    Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: bgColor.withOpacity(backgroundOpacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: showBorder
                ? Border.all(
                    color: borderColor ?? AppTheme.surfaceLight.withOpacity(0.2),
                    width: borderWidth,
                  )
                : null,
            boxShadow: boxShadow,
          ),
          child: child,
        ),
      ),
    );

    // Wrap con borde gradiente si se especifica
    if (borderGradient != null) {
      content = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: borderGradient,
        ),
        padding: EdgeInsets.all(borderWidth),
        child: content,
      );
    }

    // Wrap con margin
    if (margin != null) {
      content = Padding(
        padding: margin!,
        child: content,
      );
    }

    // Wrap con tap handler
    if (onTap != null) {
      content = GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}

/// Widget para borde con gradiente (más avanzado)
class GlassContainerGradientBorder extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double borderWidth;
  final Gradient gradient;
  final double blur;
  final double backgroundOpacity;

  const GlassContainerGradientBorder({
    super.key,
    required this.child,
    required this.gradient,
    this.borderRadius = 20,
    this.borderWidth = 1.5,
    this.blur = 10,
    this.backgroundOpacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient,
      ),
      padding: EdgeInsets.all(borderWidth),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - borderWidth),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark.withOpacity(backgroundOpacity),
              borderRadius: BorderRadius.circular(borderRadius - borderWidth),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
