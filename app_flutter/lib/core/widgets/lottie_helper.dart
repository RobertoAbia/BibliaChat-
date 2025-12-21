import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../theme/app_theme.dart';

/// Rutas de animaciones Lottie disponibles
class LottieAssets {
  static const String _basePath = 'assets/animations/';

  /// Cruz con brillo/luz divina (splash, logo)
  static const String crossGlow = '${_basePath}cross_glow.json';

  /// Indicador de carga elegante
  static const String loadingDots = '${_basePath}loading_dots.json';

  /// Check de éxito/completado
  static const String successCheck = '${_basePath}success_check.json';

  /// Indicador de escritura (typing)
  static const String typingIndicator = '${_basePath}typing_indicator.json';

  /// Manos orando
  static const String prayingHands = '${_basePath}praying_hands.json';

  /// Celebración/confetti
  static const String celebration = '${_basePath}celebration.json';

  /// Meditación/paz
  static const String meditation = '${_basePath}meditation.json';

  /// Corazón latiendo
  static const String heartbeat = '${_basePath}heartbeat.json';
}

/// Helper para cargar y mostrar animaciones Lottie
class LottieAnimation extends StatelessWidget {
  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool repeat;
  final bool reverse;
  final AnimationController? controller;
  final void Function(LottieComposition)? onLoaded;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? colorFilter;

  const LottieAnimation({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.repeat = true,
    this.reverse = false,
    this.controller,
    this.onLoaded,
    this.placeholder,
    this.errorWidget,
    this.colorFilter,
  });

  /// Animación de cruz brillante para splash/logo
  factory LottieAnimation.crossGlow({
    double? width,
    double? height,
    bool repeat = true,
  }) {
    return LottieAnimation(
      asset: LottieAssets.crossGlow,
      width: width ?? 140,
      height: height ?? 140,
      repeat: repeat,
    );
  }

  /// Indicador de carga
  factory LottieAnimation.loading({
    double? width,
    double? height,
  }) {
    return LottieAnimation(
      asset: LottieAssets.loadingDots,
      width: width ?? 60,
      height: height ?? 60,
      repeat: true,
    );
  }

  /// Check de éxito (reproduce una vez)
  factory LottieAnimation.success({
    double? width,
    double? height,
    AnimationController? controller,
  }) {
    return LottieAnimation(
      asset: LottieAssets.successCheck,
      width: width ?? 80,
      height: height ?? 80,
      repeat: false,
      controller: controller,
    );
  }

  /// Indicador de typing para chat
  factory LottieAnimation.typing({
    double? width,
    double? height,
  }) {
    return LottieAnimation(
      asset: LottieAssets.typingIndicator,
      width: width ?? 50,
      height: height ?? 30,
      repeat: true,
    );
  }

  /// Manos orando
  factory LottieAnimation.praying({
    double? width,
    double? height,
    bool repeat = true,
  }) {
    return LottieAnimation(
      asset: LottieAssets.prayingHands,
      width: width ?? 100,
      height: height ?? 100,
      repeat: repeat,
    );
  }

  /// Celebración (reproduce una vez)
  factory LottieAnimation.celebration({
    double? width,
    double? height,
    AnimationController? controller,
  }) {
    return LottieAnimation(
      asset: LottieAssets.celebration,
      width: width ?? 200,
      height: height ?? 200,
      repeat: false,
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      repeat: repeat,
      reverse: reverse,
      controller: controller,
      onLoaded: onLoaded,
      frameBuilder: (context, child, composition) {
        if (composition == null) {
          return placeholder ?? _defaultPlaceholder();
        }
        return child;
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _defaultError();
      },
      delegates: colorFilter != null
          ? LottieDelegates(
              values: [
                ValueDelegate.color(
                  const ['**'],
                  value: colorFilter,
                ),
              ],
            )
          : null,
    );
  }

  Widget _defaultPlaceholder() {
    return SizedBox(
      width: width ?? 100,
      height: height ?? 100,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.primaryColor.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _defaultError() {
    return SizedBox(
      width: width ?? 100,
      height: height ?? 100,
      child: Center(
        child: Icon(
          Icons.error_outline,
          color: AppTheme.textTertiary,
          size: (width ?? 100) * 0.4,
        ),
      ),
    );
  }
}

/// Widget para animar un ícono con Lottie
class LottieIcon extends StatefulWidget {
  final String asset;
  final double size;
  final bool animate;
  final Color? color;

  const LottieIcon({
    super.key,
    required this.asset,
    this.size = 24,
    this.animate = true,
    this.color,
  });

  @override
  State<LottieIcon> createState() => _LottieIconState();
}

class _LottieIconState extends State<LottieIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(LottieIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LottieAnimation(
      asset: widget.asset,
      width: widget.size,
      height: widget.size,
      controller: _controller,
      colorFilter: widget.color,
    );
  }
}

/// Botón con animación Lottie integrada
class LottieButton extends StatefulWidget {
  final String asset;
  final VoidCallback? onPressed;
  final String? label;
  final double iconSize;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;

  const LottieButton({
    super.key,
    required this.asset,
    this.onPressed,
    this.label,
    this.iconSize = 32,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
  });

  @override
  State<LottieButton> createState() => _LottieButtonState();
}

class _LottieButtonState extends State<LottieButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool hovering) {
    setState(() {
      _isHovered = hovering;
    });
    if (hovering) {
      _controller.repeat();
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LottieAnimation(
                    asset: widget.asset,
                    width: widget.iconSize,
                    height: widget.iconSize,
                    controller: _controller,
                  ),
                  if (widget.label != null) ...[
                    const SizedBox(width: 12),
                    Text(
                      widget.label!,
                      style: TextStyle(
                        color: widget.foregroundColor ?? AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget para animación de entrada con Lottie (una sola vez)
class LottieEntrance extends StatefulWidget {
  final String asset;
  final Widget child;
  final double? width;
  final double? height;
  final Duration delay;

  const LottieEntrance({
    super.key,
    required this.asset,
    required this.child,
    this.width,
    this.height,
    this.delay = Duration.zero,
  });

  @override
  State<LottieEntrance> createState() => _LottieEntranceState();
}

class _LottieEntranceState extends State<LottieEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showChild = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  void _onAnimationComplete(LottieComposition composition) {
    _controller.duration = composition.duration;
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showChild = true;
        });
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
    if (_showChild) {
      return widget.child;
    }

    return LottieAnimation(
      asset: widget.asset,
      width: widget.width,
      height: widget.height,
      controller: _controller,
      repeat: false,
      onLoaded: _onAnimationComplete,
    );
  }
}
