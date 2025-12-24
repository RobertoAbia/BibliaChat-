import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../chat/presentation/screens/chat_screen.dart';
import '../../../daily_gospel/presentation/providers/daily_gospel_provider.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Get from Supabase
  int _streakDays = 0;
  int _todayProgress = 0; // 0-100

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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Gospel Card (Evangelio del Día)
                        _buildGospelCard(),

                        const SizedBox(height: 16),

                        // Devotional Card
                        _ContentCard(
                          label: 'DEVOCIONAL PERSONALIZADO',
                          duration: '3 MIN',
                          title: 'El Regalo de la Paz',
                          icon: Icons.auto_stories,
                          delay: 100,
                          onTap: () {
                            // TODO: Navigate to devotional
                          },
                        ),

                        const SizedBox(height: 16),

                        // Prayer Card
                        _ContentCard(
                          label: 'MI ORACIÓN',
                          duration: '2 MIN',
                          title: 'Momento de conexión con Dios',
                          icon: Icons.favorite_outline,
                          delay: 200,
                          onTap: () {
                            // TODO: Navigate to prayer
                          },
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
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
                Text(
                  '$_streakDays',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
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
                  '$_todayProgress%',
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
                  widthFactor: _todayProgress / 100,
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

  Widget _buildGospelCard() {
    final gospelAsync = ref.watch(dailyGospelProvider);
    final profileAsync = ref.watch(currentUserProfileProvider);

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
        return _GospelCardCompact(
          label: label,
          reference: gospel.reference,
          onTap: () {
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
  final VoidCallback onTap;

  const _GospelCardCompact({
    required this.label,
    required this.reference,
    required this.onTap,
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
                    // Icon
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
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
                    const SizedBox(width: 16),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.label,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.reference,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    // Chevron
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        color: AppTheme.primaryColor,
                        size: 22,
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

class _ContentCard extends StatefulWidget {
  final String label;
  final String duration;
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final int delay;

  const _ContentCard({
    required this.label,
    required this.duration,
    required this.title,
    required this.icon,
    required this.onTap,
    this.delay = 0,
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
                // Icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    color: AppTheme.primaryColor,
                    size: 26,
                  ),
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
                                      color: AppTheme.textTertiary,
                                      letterSpacing: 0.5,
                                    ),
                          ),
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
                // Chevron
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: AppTheme.textSecondary,
                    size: 20,
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
