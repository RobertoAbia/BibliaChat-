import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/analytics_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../domain/entities/daily_gospel.dart';
import 'share_image_screen.dart';

/// Pantalla de Stories para el Evangelio del día
/// Muestra 3 slides: Resumen, Concepto clave, Ejercicio práctico
class GospelStoriesScreen extends StatefulWidget {
  final DailyGospel gospel;
  final int initialSlideIndex;
  final void Function(int slideIndex)? onSlideViewed;
  final String? topicKey; // Para navegar directo al chat

  const GospelStoriesScreen({
    super.key,
    required this.gospel,
    this.initialSlideIndex = 0,
    this.onSlideViewed,
    this.topicKey,
  });

  @override
  State<GospelStoriesScreen> createState() => _GospelStoriesScreenState();
}

class _GospelStoriesScreenState extends State<GospelStoriesScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late AnimationController _progressController;

  // Para el campo de texto expandible
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  bool _isTextFieldFocused = false;

  // Para diferenciar entre tap y long press
  bool _isLongPressing = false;
  double? _tapX;

  // Duración de cada slide (en segundos)
  static const int _slideDuration = 8;

  // Total de slides
  int get _totalSlides {
    int count = 0;
    if (widget.gospel.hasSummary) count++;
    if (widget.gospel.keyConcept != null &&
        widget.gospel.keyConcept!.isNotEmpty) count++;
    if (widget.gospel.practicalExercise != null &&
        widget.gospel.practicalExercise!.isNotEmpty) count++;
    return count > 0 ? count : 1; // Mínimo 1 slide
  }

  List<_StorySlide> get _slides {
    final slides = <_StorySlide>[];

    // Slide 1: Resumen
    if (widget.gospel.hasSummary) {
      slides.add(_StorySlide(
        type: _SlideType.summary,
        title: 'Reflexión del día',
        content: widget.gospel.summary!,
        icon: Icons.format_quote_rounded,
      ));
    }

    // Slide 2: Concepto clave
    if (widget.gospel.keyConcept != null &&
        widget.gospel.keyConcept!.isNotEmpty) {
      slides.add(_StorySlide(
        type: _SlideType.keyConcept,
        title: 'Concepto clave',
        content: widget.gospel.keyConcept!,
        icon: Icons.lightbulb_outline_rounded,
      ));
    }

    // Slide 3: Ejercicio práctico
    if (widget.gospel.practicalExercise != null &&
        widget.gospel.practicalExercise!.isNotEmpty) {
      slides.add(_StorySlide(
        type: _SlideType.exercise,
        title: 'Para hoy...',
        content: widget.gospel.practicalExercise!,
        icon: Icons.favorite_outline_rounded,
      ));
    }

    // Fallback si no hay contenido
    if (slides.isEmpty) {
      slides.add(_StorySlide(
        type: _SlideType.summary,
        title: widget.gospel.reference,
        content: widget.gospel.text.isNotEmpty
            ? widget.gospel.text
            : 'No hay contenido disponible para hoy.',
        icon: Icons.menu_book_rounded,
      ));
    }

    return slides;
  }

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialSlideIndex;
    _pageController = PageController(initialPage: widget.initialSlideIndex);
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _slideDuration),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextSlide();
      }
    });

    // Listener para el focus del campo de texto
    _messageFocusNode.addListener(() {
      setState(() {
        _isTextFieldFocused = _messageFocusNode.hasFocus;
      });
      // Pausar el timer cuando tiene focus
      if (_messageFocusNode.hasFocus) {
        _progressController.stop();
      }
      // NO reanudar automáticamente cuando pierde focus
      // Se reanudará manualmente si es necesario
    });

    // Listener para cambios en el texto
    _messageController.addListener(() {
      setState(() {});
    });

    // Mark initial slide as viewed
    widget.onSlideViewed?.call(widget.initialSlideIndex);
    // Log analytics for initial slide
    AnalyticsService().logStoryViewed(slideNumber: widget.initialSlideIndex);

    _startProgress();
  }

  void _startProgress() {
    _progressController.forward(from: 0);
  }

  void _nextSlide() {
    if (_currentPage < _totalSlides - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      // Mark new slide as viewed
      widget.onSlideViewed?.call(_currentPage);
      // Log analytics
      AnalyticsService().logStoryViewed(slideNumber: _currentPage);
      _startProgress();
    } else {
      // Último slide - log completion and close
      AnalyticsService().logStoryCompleted();
      context.pop();
    }
  }

  void _previousSlide() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      // Mark slide as viewed (in case user goes back)
      widget.onSlideViewed?.call(_currentPage);
      _startProgress();
    }
  }

  void _onTapDown(TapDownDetails details) {
    // Guardar posición para usar en _onTapUp
    _tapX = details.globalPosition.dx;
    // Pausar mientras está presionado
    _progressController.stop();
  }

  void _onTapUp(TapUpDetails details) {
    // Solo navegar si fue un tap rápido (no long press)
    if (!_isLongPressing && _tapX != null) {
      final screenWidth = MediaQuery.of(context).size.width;
      if (_tapX! < screenWidth / 3) {
        // Tap izquierdo - anterior
        _previousSlide();
        return; // _previousSlide ya reinicia el progreso
      } else if (_tapX! > screenWidth * 2 / 3) {
        // Tap derecho - siguiente
        _nextSlide();
        return; // _nextSlide ya reinicia el progreso
      }
    }
    // Tap central o release después de long press - reanudar
    _progressController.forward();
    _tapX = null;
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _isLongPressing = true;
    _progressController.stop();
    HapticFeedback.lightImpact();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _isLongPressing = false;
    _progressController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Main content con gesture detector para navegación de slides
              Expanded(
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  onLongPressStart: _onLongPressStart,
                  onLongPressEnd: _onLongPressEnd,
                  child: Stack(
                    children: [
                      // Background decoration
                      _buildBackgroundDecoration(),

                      // Page content
                      PageView.builder(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _totalSlides,
                        itemBuilder: (context, index) {
                          return _buildSlideContent(_slides[index]);
                        },
                      ),

                      // Top bar with progress and close
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: _buildTopBar(),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom bar Instagram-style (fuera del GestureDetector de navegación)
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          // Text input field
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppTheme.textTertiary.withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _messageFocusNode,
                      cursorColor: AppTheme.textPrimary,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                      decoration: InputDecoration(
                        hintText: 'Enviar mensaje',
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textTertiary,
                            ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        fillColor: Colors.transparent,
                        filled: false,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  // Botón "Enviar" cuando está focused O hay texto
                  if (_isTextFieldFocused || _messageController.text.isNotEmpty)
                    Listener(
                      onPointerDown: (_) => _sendMessage(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Enviar',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Icono compartir solo cuando NO está focused Y no hay texto
          if (!_isTextFieldFocused && _messageController.text.isEmpty) ...[
            const SizedBox(width: 16),

            // Share button
            GestureDetector(
              onTap: _shareContent,
              child: Icon(
                Icons.ios_share,
                color: AppTheme.textPrimary,
                size: 26,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Cerrar teclado
    _messageFocusNode.unfocus();

    // Pausar el timer
    _progressController.stop();

    // Obtener el contenido del slide actual
    final currentSlide = _slides[_currentPage];

    // Crear el texto para el chat basado en el slide actual (sin el mensaje del usuario)
    String chatText = '''${currentSlide.title}

"${currentSlide.content}"

📖 ${widget.gospel.reference}''';

    // Navegar al chat usando GoRouter (go reemplaza la ubicación completamente)
    context.go('/chat/new', extra: {
      'topicKey': widget.topicKey,
      'initialGospelText': chatText,
      'initialGospelReference': widget.gospel.reference,
      'initialUserMessage': message,
    });
  }

  void _shareContent() {
    // Pausar mientras comparte
    _progressController.stop();

    final currentSlide = _slides[_currentPage];

    // Abrir pantalla de edición de imagen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShareImageScreen(
          title: currentSlide.title,
          content: currentSlide.content,
          reference: widget.gospel.reference,
        ),
      ),
    ).then((_) {
      // Reanudar después de volver
      if (mounted) {
        _progressController.forward();
      }
    });
  }

  Widget _buildBackgroundDecoration() {
    return Stack(
      children: [
        // Glow superior dorado
        Positioned(
          top: -100,
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.15),
                  AppTheme.primaryColor.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        // Glow inferior
        Positioned(
          bottom: -150,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.accentPurple.withOpacity(0.1),
                  AppTheme.accentPurple.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          // Progress bars
          Row(
            children: List.generate(_totalSlides, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 3,
                    right: index == _totalSlides - 1 ? 0 : 3,
                  ),
                  height: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Stack(
                      children: [
                        // Background
                        Container(
                          color: AppTheme.surfaceLight.withOpacity(0.4),
                        ),
                        // Progress
                        if (index < _currentPage)
                          Container(
                            color: AppTheme.primaryColor,
                          )
                        else if (index == _currentPage)
                          AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, child) {
                              return FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _progressController.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.goldGradient,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          // Header row
          Row(
            children: [
              // Reference badge
              GlassContainer(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                borderRadius: 20,
                blur: 8,
                backgroundOpacity: 0.4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.gospel.reference,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Close button
              GlassContainer(
                padding: const EdgeInsets.all(10),
                borderRadius: 24,
                blur: 8,
                backgroundOpacity: 0.4,
                onTap: () => context.pop(),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppTheme.textPrimary,
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSlideContent(_StorySlide slide) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
      child: Column(
        children: [
          // Icon with glow
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Icon(
                slide.icon,
                color: AppTheme.textOnPrimary,
                size: 28,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Title
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  AppTheme.goldGradient.createShader(bounds),
              child: Text(
                slide.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Content text - clean, no box, Stories style
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                      Colors.white.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.85, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    slide.content,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.textPrimary,
                          height: 1.5,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// HELPER CLASSES
// ============================================

enum _SlideType { summary, keyConcept, exercise }

class _StorySlide {
  final _SlideType type;
  final String title;
  final String content;
  final IconData icon;

  const _StorySlide({
    required this.type,
    required this.title,
    required this.content,
    required this.icon,
  });
}
