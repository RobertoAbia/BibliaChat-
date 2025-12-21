import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Get from Supabase
  int _streakDays = 0;
  int _todayProgress = 0; // 0-100
  bool _isLoading = false;

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
                        // Verse Card
                        _isLoading
                            ? const ShimmerVerseCard()
                            : _VerseCard(
                                reference: 'Proverbios 3:5-6',
                                text:
                                    'Confía en Jehová de todo tu corazón, y no te apoyes en tu propia prudencia. Reconócelo en todos tus caminos, y él enderezará tus veredas.',
                              ),

                        const SizedBox(height: 16),

                        // Devotional Card
                        _isLoading
                            ? const ShimmerContentCard()
                            : _ContentCard(
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
                        _isLoading
                            ? const ShimmerContentCard()
                            : _ContentCard(
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
          const SizedBox(height: 18),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.headphones,
                  label: 'Escuchar',
                  delay: 0,
                  onTap: () {
                    // TODO: Audio devotional
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.menu_book,
                  label: 'Leer',
                  delay: 100,
                  onTap: () {
                    // TODO: Read devotional
                  },
                ),
              ),
            ],
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
}

// ============================================
// WIDGETS
// ============================================

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int delay;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.delay = 0,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
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

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
      duration: Duration(milliseconds: 500 + widget.delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - value)),
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
            padding: const EdgeInsets.symmetric(vertical: 16),
            borderRadius: 14,
            blur: 8,
            backgroundOpacity: 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(widget.icon, color: AppTheme.primaryColor, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
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

class _VerseCard extends StatefulWidget {
  final String reference;
  final String text;

  const _VerseCard({
    required this.reference,
    required this.text,
  });

  @override
  State<_VerseCard> createState() => _VerseCardState();
}

class _VerseCardState extends State<_VerseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
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
      child: ClipRRect(
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
                  AppTheme.primaryColor.withOpacity(0.15),
                  AppTheme.surfaceDark.withOpacity(0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: AppTheme.primaryColor,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'VERSÍCULO DEL DÍA',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  '"${widget.text}"',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontStyle: FontStyle.italic,
                        height: 1.7,
                      ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 16,
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.reference,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
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
