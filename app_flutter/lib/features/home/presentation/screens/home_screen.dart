import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/story_viewed_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/daily_progress_provider.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../chat/presentation/screens/chat_screen.dart';
import '../../../daily_gospel/presentation/providers/daily_gospel_provider.dart';
import '../../../daily_gospel/presentation/screens/gospel_stories_screen.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with glass effect
                  _buildHeader(context),

                  // Week Calendar with glass effect
                  _buildWeekCalendar(context),

                  const SizedBox(height: 24),

                  // Today's Progress
                  _buildProgressSection(context),

                  const SizedBox(height: 24),

                  // Content Cards
                  _buildContentCards(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          // Avatar with glow
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppTheme.goldGradient,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.primaryLight.withOpacity(0.5),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'B',
                      style: TextStyle(
                        color: AppTheme.textOnPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'El Viaje de Hoy',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  _getFormattedDate(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                ),
              ],
            ),
          ),

          // Streak with glass effect
          GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            borderRadius: 24,
            blur: 8,
            backgroundOpacity: 0.4,
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Consumer(
                  builder: (context, ref, child) {
                    final streak = ref.watch(streakDaysDisplayProvider);
                    return Text(
                      '$streak',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Calendar icon with glass effect
          GlassContainer(
            padding: const EdgeInsets.all(10),
            borderRadius: 14,
            blur: 5,
            backgroundOpacity: 0.3,
            onTap: () {
              // TODO: Show calendar/history
            },
            child: const Icon(
              Icons.calendar_today_outlined,
              color: AppTheme.textSecondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekCalendar(BuildContext context) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
        borderRadius: 20,
        blur: 10,
        backgroundOpacity: 0.35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            final day = weekStart.add(Duration(days: index));
            final isToday = day.day == now.day &&
                day.month == now.month &&
                day.year == now.year;
            final dayNames = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 400 + (index * 60)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  Text(
                    dayNames[index],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isToday
                              ? AppTheme.primaryColor
                              : AppTheme.textTertiary,
                          fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                        ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: isToday ? AppTheme.goldGradient : null,
                      color: isToday ? null : Colors.transparent,
                      shape: BoxShape.circle,
                      border: !isToday
                          ? Border.all(
                              color: AppTheme.surfaceLight.withOpacity(0.5),
                              width: 1,
                            )
                          : null,
                      boxShadow: isToday
                          ? [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isToday
                                  ? AppTheme.textOnPrimary
                                  : AppTheme.textSecondary,
                              fontWeight:
                                  isToday ? FontWeight.bold : FontWeight.normal,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final progress = ref.watch(todayProgressProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progreso de hoy',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
              ),
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.goldGradient.createShader(bounds),
                child: Text(
                  '$progress%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress bar with glass effect
          GlassContainer(
            height: 10,
            borderRadius: 5,
            blur: 3,
            backgroundOpacity: 0.4,
            showBorder: false,
            child: Stack(
              children: [
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${now.day} de ${months[now.month - 1]}';
  }

  /// Opens Stories at a specific slide index
  Future<void> _openStoriesAtIndex(int slideIndex) async {
    final gospelAsync = ref.read(dailyGospelProvider);
    final profileAsync = ref.read(currentUserProfileProvider);
    final service = ref.read(storyViewedServiceProvider);

    final gospel = gospelAsync.valueOrNull;
    if (gospel == null || !gospel.hasStoriesContent) {
      // No gospel content available
      return;
    }

    // Determine topic based on denomination
    final isCatholic = profileAsync.valueOrNull?.denomination == Denomination.catolica;
    final topicKey = isCatholic ? 'evangelio_del_dia' : 'lectura_del_dia';

    // Open Stories at the specified slide
    final result = await Navigator.of(context, rootNavigator: true).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => GospelStoriesScreen(
          gospel: gospel,
          initialSlideIndex: slideIndex,
          topicKey: topicKey,
          onSlideViewed: (index) async {
            // Mark slide as viewed
            await service.markSlideAsViewed(gospel.date, index);
          },
        ),
        fullscreenDialog: true,
      ),
    );

    // Refresh the viewed slides state for UI
    ref.invalidate(viewedSlidesProvider);

    // Read directly from SharedPreferences to check completion
    // This avoids race conditions with provider refresh
    final viewedSlides = await service.getViewedSlides(gospel.date);
    debugPrint('After Stories: viewedSlides = $viewedSlides (length=${viewedSlides.length})');

    if (viewedSlides.length >= 3) {
      final marked = await markDayAsCompleted(ref);
      if (marked) {
        debugPrint('Day marked as completed! Streak updated.');
        // Show celebration SnackBar
        if (context.mounted) {
          final newStreak = ref.read(streakDaysDisplayProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '¡Felicidades! 🔥 $newStreak ${newStreak == 1 ? 'día' : 'días'} seguidos',
                style: const TextStyle(
                  color: AppTheme.textOnPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: AppTheme.primaryColor,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      } else {
        debugPrint('Day was already completed.');
      }
    } else {
      debugPrint('Not all slides viewed yet: ${viewedSlides.length}/3');
    }

    // Handle chat action from Stories
    if (result != null && result['action'] == 'openChat' && context.mounted) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            topicKey: topicKey,
            initialGospelText: result['text'] ?? gospel.text,
            initialGospelReference: result['reference'] ?? gospel.reference,
            initialUserMessage: result['userMessage'],
          ),
          fullscreenDialog: true,
        ),
      );
    }
  }

  Widget _buildContentCards() {
    final viewedSlidesAsync = ref.watch(viewedSlidesProvider);
    final gospelAsync = ref.watch(dailyGospelProvider);

    // Get viewed slides (default to empty if loading/error)
    final viewedSlides = viewedSlidesAsync.valueOrNull ?? <int>{};
    final hasContent = gospelAsync.valueOrNull?.hasStoriesContent ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Gospel Card (Evangelio del Día)
          _buildGospelCard(),

          const SizedBox(height: 16),

          // Key Concept Card - Opens Stories at slide 1
          _ContentCard(
            label: 'CONCEPTO CLAVE',
            duration: '1 MIN',
            title: 'La idea que transforma',
            icon: Icons.lightbulb_outline,
            delay: 100,
            isNew: hasContent && !viewedSlides.contains(1),
            onTap: () => _openStoriesAtIndex(1),
          ),

          const SizedBox(height: 16),

          // Practical Exercise Card - Opens Stories at slide 2
          _ContentCard(
            label: 'PARA HOY',
            duration: '1 MIN',
            title: 'Tu acción del día',
            icon: Icons.favorite_outline,
            delay: 200,
            isNew: hasContent && !viewedSlides.contains(2),
            onTap: () => _openStoriesAtIndex(2),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildGospelCard() {
    final gospelAsync = ref.watch(dailyGospelProvider);
    final profileAsync = ref.watch(currentUserProfileProvider);
    final viewedSlidesAsync = ref.watch(viewedSlidesProvider);

    // Determine label and topic based on denomination
    final isCatholic = profileAsync.whenOrNull(
      data: (profile) => profile?.denomination == Denomination.catolica,
    ) ?? false;

    final label = isCatholic ? 'EVANGELIO DEL DÍA' : 'LECTURA DEL DÍA';
    final topicKey = isCatholic ? 'evangelio_del_dia' : 'lectura_del_dia';

    return gospelAsync.when(
      loading: () => const ShimmerVerseCard(),
      error: (error, stack) => _GospelErrorCard(
        onRetry: () => ref.invalidate(dailyGospelProvider),
      ),
      data: (gospel) {
        if (gospel == null) {
          return _GospelErrorCard(
            message: 'No hay contenido disponible',
            onRetry: () => ref.invalidate(dailyGospelProvider),
          );
        }
        // Check if slide 0 has been viewed
        final viewedSlides = viewedSlidesAsync.valueOrNull ?? <int>{};
        final isSlide0New = gospel.hasStoriesContent && !viewedSlides.contains(0);
        final service = ref.read(storyViewedServiceProvider);

        return _GospelCardCompact(
          label: label,
          reference: gospel.reference,
          hasStories: isSlide0New,
          onTap: () async {
            // Si tiene contenido de Stories, abrir Stories primero
            if (gospel.hasStoriesContent) {
              // Usar rootNavigator para que cubra toda la pantalla incluyendo bottom nav
              final result = await Navigator.of(context, rootNavigator: true).push<Map<String, dynamic>>(
                MaterialPageRoute(
                  builder: (context) => GospelStoriesScreen(
                    gospel: gospel,
                    initialSlideIndex: 0,
                    topicKey: topicKey,
                    onSlideViewed: (index) async {
                      await service.markSlideAsViewed(gospel.date, index);
                    },
                  ),
                  fullscreenDialog: true,
                ),
              );

              // Refresh the viewed slides state
              ref.invalidate(viewedSlidesProvider);

              // Check completion - read directly from SharedPreferences
              final viewedSlidesNow = await service.getViewedSlides(gospel.date);
              debugPrint('After Stories (Gospel Card): viewedSlides = $viewedSlidesNow (length=${viewedSlidesNow.length})');

              if (viewedSlidesNow.length >= 3) {
                final marked = await markDayAsCompleted(ref);
                if (marked) {
                  debugPrint('Day marked as completed! Streak updated.');
                  if (context.mounted) {
                    final newStreak = ref.read(streakDaysDisplayProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '¡Felicidades! 🔥 $newStreak ${newStreak == 1 ? 'día' : 'días'} seguidos',
                          style: const TextStyle(
                            color: AppTheme.textOnPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: AppTheme.primaryColor,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  }
                } else {
                  debugPrint('Day was already completed.');
                }
              } else {
                debugPrint('Not all slides viewed yet: ${viewedSlidesNow.length}/3');
              }

              // Si el usuario quiere abrir el chat desde Stories
              if (result != null && result['action'] == 'openChat' && context.mounted) {
                // Usar rootNavigator para ocultar el bottom nav
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      topicKey: topicKey,
                      initialGospelText: result['text'] ?? gospel.text,
                      initialGospelReference: result['reference'] ?? gospel.reference,
                      initialUserMessage: result['userMessage'],
                    ),
                    fullscreenDialog: true,
                  ),
                );
              }
            } else {
              // Si no, ir directo al chat
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    topicKey: topicKey,
                    initialGospelText: gospel.text,
                    initialGospelReference: gospel.reference,
                  ),
                ),
              );
            }
          },
          onChatTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  topicKey: topicKey,
                  initialGospelText: gospel.text,
                  initialGospelReference: gospel.reference,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ============================================
// WIDGETS
// ============================================

class _GospelCardCompact extends StatefulWidget {
  final String label;
  final String reference;
  final bool hasStories;
  final VoidCallback onTap;
  final VoidCallback? onChatTap;

  const _GospelCardCompact({
    required this.label,
    required this.reference,
    this.hasStories = false,
    required this.onTap,
    this.onChatTap,
  });

  @override
  State<_GospelCardCompact> createState() => _GospelCardCompactState();
}

class _GospelCardCompactState extends State<_GospelCardCompact>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTapDown: (_) => _scaleController.forward(),
        onTapUp: (_) => _scaleController.reverse(),
        onTapCancel: () => _scaleController.reverse(),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.15),
                      AppTheme.surfaceDark.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon with Stories ring indicator
                    Stack(
                      children: [
                        // Stories ring (visible cuando hasStories)
                        if (widget.hasStories)
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17),
                              gradient: AppTheme.goldGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.4),
                                  blurRadius: 12,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                          ),
                        // Icon container
                        Container(
                          width: 52,
                          height: 52,
                          margin: widget.hasStories
                              ? const EdgeInsets.all(3)
                              : EdgeInsets.zero,
                          decoration: BoxDecoration(
                            gradient: AppTheme.goldGradient,
                            borderRadius: BorderRadius.circular(14),
                            border: widget.hasStories
                                ? Border.all(
                                    color: AppTheme.backgroundDark,
                                    width: 2,
                                  )
                                : null,
                            boxShadow: widget.hasStories
                                ? null
                                : [
                                    BoxShadow(
                                      color:
                                          AppTheme.primaryColor.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: const Icon(
                            Icons.menu_book_rounded,
                            color: AppTheme.textOnPrimary,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.label,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                              if (widget.hasStories) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.goldGradient,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'NUEVO',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppTheme.textOnPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 8,
                                          letterSpacing: 0.5,
                                        ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.reference,
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppTheme.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    // Actions
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Chat button (si tiene Stories)
                        if (widget.hasStories && widget.onChatTap != null)
                          GestureDetector(
                            onTap: widget.onChatTap,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceLight.withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: AppTheme.textSecondary,
                                size: 20,
                              ),
                            ),
                          ),
                        // Chevron / Play
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.hasStories
                                ? Icons.play_arrow_rounded
                                : Icons.chevron_right,
                            color: AppTheme.primaryColor,
                            size: 22,
                          ),
                        ),
                      ],
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

class _ContentCard extends StatefulWidget {
  final String label;
  final String duration;
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final int delay;
  final bool isNew;

  const _ContentCard({
    required this.label,
    required this.duration,
    required this.title,
    required this.icon,
    required this.onTap,
    this.delay = 0,
    this.isNew = false,
  });

  @override
  State<_ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<_ContentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
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
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + widget.delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: GlassContainer(
            padding: const EdgeInsets.all(18),
            borderRadius: 20,
            blur: 8,
            backgroundOpacity: 0.4,
            child: Row(
              children: [
                // Icon with optional golden ring
                Stack(
                  children: [
                    // Golden ring (visible when isNew)
                    if (widget.isNew)
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          gradient: AppTheme.goldGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      ),
                    // Icon container
                    Container(
                      width: 52,
                      height: 52,
                      margin: widget.isNew
                          ? const EdgeInsets.all(3)
                          : EdgeInsets.zero,
                      decoration: BoxDecoration(
                        gradient: widget.isNew ? AppTheme.goldGradient : null,
                        color: widget.isNew
                            ? null
                            : AppTheme.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: widget.isNew
                            ? Border.all(
                                color: AppTheme.backgroundDark,
                                width: 2,
                              )
                            : Border.all(
                                color: AppTheme.primaryColor.withOpacity(0.2),
                              ),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.isNew
                            ? AppTheme.textOnPrimary
                            : AppTheme.primaryColor,
                        size: 26,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.label,
                            style:
                                Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: widget.isNew
                                          ? AppTheme.primaryColor
                                          : AppTheme.textTertiary,
                                      fontWeight: widget.isNew
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      letterSpacing: 0.5,
                                    ),
                          ),
                          // "NUEVO" badge when isNew
                          if (widget.isNew) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppTheme.goldGradient,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'NUEVO',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppTheme.textOnPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 8,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                            ),
                          ],
                          if (!widget.isNew) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppTheme.textTertiary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.duration,
                              style:
                                  Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppTheme.textTertiary,
                                      ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                // Chevron or Play button
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.isNew
                        ? AppTheme.primaryColor.withOpacity(0.2)
                        : AppTheme.surfaceLight.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isNew
                        ? Icons.play_arrow_rounded
                        : Icons.chevron_right,
                    color: widget.isNew
                        ? AppTheme.primaryColor
                        : AppTheme.textSecondary,
                    size: widget.isNew ? 22 : 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GospelErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _GospelErrorCard({
    this.message = 'Error al cargar el evangelio',
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.surfaceDark.withOpacity(0.6),
                AppTheme.surfaceDark.withOpacity(0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.surfaceLight.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.cloud_off_outlined,
                color: AppTheme.textTertiary,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    'Reintentar',
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
    );
  }
}
