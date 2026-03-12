import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/providers/story_viewed_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/daily_progress_provider.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../chat/presentation/screens/chat_screen.dart';
import '../../../daily_gospel/presentation/providers/daily_gospel_provider.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../../../study/presentation/providers/study_provider.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// Día seleccionado en el calendario (por defecto hoy).
  DateTime _selectedDate = DateTime.now();

  /// Guard: esperar a que los providers tengan datos antes de renderizar.
  /// _forceReady es safety net: si algo falla, mostramos la UI igual tras 150ms.
  bool _forceReady = false;
  @override
  void initState() {
    super.initState();
    // Safety net: si los providers no resuelven rápido, mostrar UI igual
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted && !_forceReady) {
        setState(() => _forceReady = true);
      }
    });
  }

  /// Compara si el día seleccionado es hoy.
  bool get _isViewingToday {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    // Guard: no renderizar hasta que los providers críticos tengan datos.
    // _forceReady (150ms) es safety net para que la UI nunca se quede bloqueada.
    if (!_forceReady) {
      final gospel = ref.watch(dailyGospelProvider);
      final week = ref.watch(weekCompletionProvider);
      final plan = ref.watch(activePlanDataProvider);

      final allReady = (gospel.hasValue || gospel.hasError) &&
          (week.hasValue || week.hasError) &&
          (plan.hasValue || plan.hasError);

      if (!allReady) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.backgroundGradient,
            ),
          ),
        );
      }
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppTheme.backgroundDark,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 4,
                shadowColor: Colors.black26,
                toolbarHeight: 88,
                automaticallyImplyLeading: false,
                flexibleSpace: _buildHeader(context),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
            ],
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
          // App logo
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
              child: Image.asset(
                'assets/images/splash_logo.png',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
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
          GestureDetector(
            onTap: () => _showStreakInfo(context),
            child: GlassContainer(
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
          ),

        ],
      ),
    );
  }

  /// Gradiente dorado brillante para hoy completado.
  static const _brightGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE8C967),
      Color(0xFFD4AF37),
    ],
  );

  /// Gradiente dorado tenue para días completados no seleccionados.
  static const _dimGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x80E8C967), // 0.5 opacity
      Color(0x80D4AF37), // 0.5 opacity
    ],
  );

  Widget _buildWeekCalendar(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: now.weekday - 1));

    // Obtener días completados de la semana
    final weekCompletionAsync = ref.watch(weekCompletionProvider);
    final completedDates = weekCompletionAsync.valueOrNull ?? <String>{};

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
            final dayOnly = DateTime(day.year, day.month, day.day);
            final dayNames = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

            final isToday = dayOnly == today;
            final isPast = dayOnly.isBefore(today);
            final dateStr = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
            final isDayCompleted = completedDates.contains(dateStr);

            // Determinar estado del día (para tap behavior)
            final _DayState dayState;
            if (isToday) {
              dayState = _DayState.today;
            } else if (!isPast) {
              dayState = _DayState.future;
            } else {
              dayState = isDayCompleted
                  ? _DayState.pastCompleted
                  : _DayState.pastLocked;
            }

            // Comprobar si este día está seleccionado
            final isSelected = _selectedDate.year == dayOnly.year &&
                _selectedDate.month == dayOnly.month &&
                _selectedDate.day == dayOnly.day;

            // Tap handler según estado
            final VoidCallback? onTap;
            switch (dayState) {
              case _DayState.today:
                onTap = () => setState(() => _selectedDate = today);
              case _DayState.pastCompleted:
                onTap = () => setState(() => _selectedDate = dayOnly);
              case _DayState.pastLocked:
                onTap = () => _onLockedDayTapped(dayOnly);
              case _DayState.future:
                onTap = null;
            }

            // --- VISUAL: Letra fija en hoy, Círculo = selector + completación ---
            final isPremium = ref.watch(isPremiumProvider);

            // Letra: azul fijo en hoy, gris el resto (no se mueve al seleccionar)
            final letterColor = isToday
                ? AppTheme.primaryColor
                : AppTheme.textTertiary;

            // Círculo: dorado bright = seleccionado+completado, dim = completado no seleccionado
            final Gradient? circleGradient;
            final Color? circleColor;
            final Border? circleBorder;
            final List<BoxShadow>? circleShadow;

            if (isDayCompleted) {
              // Completado: bright si seleccionado, dim si no
              circleGradient = isSelected ? _brightGoldGradient : _dimGoldGradient;
              circleColor = null;
              circleBorder = null;
              circleShadow = [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(isSelected ? 0.5 : 0.15),
                  blurRadius: isSelected ? 12 : 4,
                  spreadRadius: isSelected ? 2 : 0,
                ),
              ];
            } else if (dayState == _DayState.pastLocked) {
              // Pasado no completado
              circleGradient = null;
              circleColor = const Color(0xFFD0D8E4);
              circleBorder = isSelected
                  ? Border.all(color: AppTheme.primaryColor, width: 2)
                  : Border.all(color: AppTheme.surfaceLight.withOpacity(0.5), width: 1);
              circleShadow = null;
            } else if (isToday && isSelected) {
              // Hoy no completado + seleccionado: borde azul grueso
              circleGradient = null;
              circleColor = Colors.transparent;
              circleBorder = Border.all(color: AppTheme.primaryColor, width: 2);
              circleShadow = null;
            } else {
              // Hoy no completado no seleccionado / futuro: borde sutil
              circleGradient = null;
              circleColor = Colors.transparent;
              circleBorder = Border.all(
                color: AppTheme.surfaceLight.withOpacity(0.5),
                width: 1,
              );
              circleShadow = null;
            }

            // Número: blanco sobre dorado, gris sobre transparente
            final numberColor = isDayCompleted
                ? AppTheme.textOnPrimary
                : (dayState == _DayState.future
                    ? AppTheme.textTertiary
                    : AppTheme.textSecondary);

            return GestureDetector(
                onTap: onTap,
                child: Column(
                  children: [
                    Text(
                      dayNames[index],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: letterColor,
                            fontWeight: isToday
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 38,
                      height: 44,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              gradient: circleGradient,
                              color: circleColor,
                              shape: BoxShape.circle,
                              border: circleBorder,
                              boxShadow: circleShadow,
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: numberColor,
                                      fontWeight: isDayCompleted || isToday
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                              ),
                            ),
                          ),
                          // Candado superpuesto en la parte inferior del círculo
                          if (dayState == _DayState.pastLocked)
                            Positioned(
                              bottom: 0,
                              child: Icon(
                                isPremium ? Icons.lock_open_rounded : Icons.lock_rounded,
                                color: AppTheme.textTertiary,
                                size: 14,
                              ),
                            ),
                        ],
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


  void _showStreakInfo(BuildContext context) {
    final streak = ref.read(streakDaysDisplayProvider);
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fuego con glow dorado
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _brightGoldGradient,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD4AF37).withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🔥', style: TextStyle(fontSize: 36)),
                  ),
                ),
                const SizedBox(height: 20),
                // Número grande
                Text(
                  '$streak',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: const Color(0xFFE8C967),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  streak == 1 ? 'día de racha' : 'días de racha',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                const SizedBox(height: 20),
                // Divider dorado sutil
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: const Color(0xFFD4AF37).withOpacity(0.2),
                ),
                const SizedBox(height: 20),
                // Explicación
                Text(
                  'Completa las 3 reflexiones cada día para mantener tu racha activa.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Botón
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37).withOpacity(0.12),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Entendido',
                      style: TextStyle(
                        color: Color(0xFFE8C967),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onLockedDayTapped(DateTime date) {
    final isPremium = ref.read(isPremiumProvider);
    if (isPremium) {
      setState(() => _selectedDate = date);
    } else {
      context.push(RouteConstants.paywall);
    }
  }

  Widget _buildProgressSection(BuildContext context) {
    // Progreso adaptativo según día seleccionado
    final int progress;
    if (_isViewingToday) {
      progress = ref.watch(todayProgressProvider);
    } else {
      // Día pasado: progreso basado en slides vistos (0%, 33%, 66%, 100%)
      final pastViewedSlides = ref.watch(viewedSlidesForDateProvider(_selectedDate)).valueOrNull ?? <int>{};
      progress = (pastViewedSlides.length / 3 * 100).round();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isViewingToday ? 'Progreso de hoy' : 'Progreso del día',
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

  /// Opens Stories at a specific slide index.
  /// Si [forDate] es null, usa el gospel de hoy. Si no, carga el de esa fecha.
  Future<void> _openStoriesAtIndex(int slideIndex, {DateTime? forDate}) async {
    final userId = ref.read(currentUserIdProvider);
    final profileAsync = ref.read(currentUserProfileProvider);
    final service = ref.read(storyViewedServiceProvider);

    if (userId == null) return;

    // Cargar gospel: hoy o fecha específica
    final gospel = forDate != null
        ? await ref.read(gospelForDateProvider(forDate).future)
        : ref.read(dailyGospelProvider).valueOrNull;

    if (gospel == null || !gospel.hasStoriesContent) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'No hay contenido disponible para este día',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF1A2740),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      return;
    }

    // Determine topic based on denomination
    final isCatholic = profileAsync.valueOrNull?.denomination == Denomination.catolica;
    final topicKey = isCatholic ? 'evangelio_del_dia' : 'lectura_del_dia';

    // Open Stories at the specified slide using GoRouter
    await context.push(
      '/home/stories',
      extra: {
        'gospel': gospel,
        'initialSlideIndex': slideIndex,
        'topicKey': topicKey,
        'singleSlideIndex': slideIndex,
        'onSlideViewed': (int index) async {
          // Mark slide as viewed (with user ID)
          await service.markSlideAsViewed(userId, gospel.date, index);
        },
      },
    );

    // Refresh the viewed slides state for UI
    ref.invalidate(viewedSlidesProvider);
    if (forDate != null) {
      ref.invalidate(viewedSlidesForDateProvider(forDate));
    }

    // Read directly from SharedPreferences to check completion
    final viewedSlides = await service.getViewedSlides(userId, gospel.date);
    debugPrint('After Stories: viewedSlides = $viewedSlides (length=${viewedSlides.length})');

    if (viewedSlides.length >= 3) {
      final bool marked;
      final String snackMessage;

      if (forDate != null) {
        // Día pasado: marcar esa fecha
        marked = await markPastDateAsCompleted(ref, forDate);
        final newStreak = ref.read(streakDaysDisplayProvider);
        snackMessage = '¡Día recuperado! 🔥 $newStreak ${newStreak == 1 ? 'día' : 'días'} seguidos';
      } else {
        // Hoy: marcar con optimistic UI
        marked = await markDayAsCompleted(ref);
        final newStreak = ref.read(streakDaysDisplayProvider);
        snackMessage = '¡Felicidades! 🔥 $newStreak ${newStreak == 1 ? 'día' : 'días'} seguidos';
      }

      if (marked && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              snackMessage,
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
      debugPrint('Not all slides viewed yet: ${viewedSlides.length}/3');
    }
  }

  Widget _buildContentCards() {
    final activePlanAsync = ref.watch(activePlanDataProvider);

    // Datos según día seleccionado
    final AsyncValue gospelAsync;
    final Set<int> viewedSlides;
    final DateTime? forDate;

    if (_isViewingToday) {
      gospelAsync = ref.watch(dailyGospelProvider);
      final viewedAsync = ref.watch(viewedSlidesProvider);
      // Mientras carga, asumir todo visto para evitar flash de badge NUEVO
      viewedSlides = viewedAsync.isLoading ? {0, 1, 2} : (viewedAsync.valueOrNull ?? <int>{});
      forDate = null;
    } else {
      gospelAsync = ref.watch(gospelForDateProvider(_selectedDate));
      final pastViewedAsync = ref.watch(viewedSlidesForDateProvider(_selectedDate));
      viewedSlides = pastViewedAsync.valueOrNull ?? <int>{};
      forDate = _selectedDate;
    }

    final hasContent = (gospelAsync.valueOrNull as dynamic)?.hasStoriesContent ?? false;

    // Determine label based on denomination
    final profileAsync = ref.watch(currentUserProfileProvider);
    final isCatholic = profileAsync.whenOrNull(
      data: (profile) => profile?.denomination == Denomination.catolica,
    ) ?? false;
    final sectionTitle = 'Reflexiones del día';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          if (hasContent) ...[
            Row(
              children: [
                Text(
                  sectionTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  '· 3 reflexiones',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

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
            onTap: () => _openStoriesAtIndex(1, forDate: forDate),
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
            onTap: () => _openStoriesAtIndex(2, forDate: forDate),
          ),

          // Active Plan Card (only if user has an active plan)
          // Separated from daily content with divider
          activePlanAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (activePlan) {
              if (activePlan == null) return const SizedBox(height: 32);
              return Column(
                children: [
                  const SizedBox(height: 24),
                  // Divider with label
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFD0D8E4),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'TU PLAN ACTIVO',
                          style: TextStyle(
                            color: AppTheme.textTertiary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFD0D8E4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _ActivePlanCard(
                    planName: activePlan.plan.name,
                    planEmoji: activePlan.plan.iconEmoji,
                    currentDay: activePlan.userPlan.currentDay,
                    totalDays: activePlan.plan.daysTotal,
                    progressPercent: activePlan.progressPercent,
                    onTap: () {
                      context.push('/study/day/${activePlan.userPlan.id}');
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGospelCard() {
    final userId = ref.watch(currentUserIdProvider);
    final profileAsync = ref.watch(currentUserProfileProvider);

    // Gospel y slides según día seleccionado
    final AsyncValue gospelAsync;
    final Set<int> viewedSlides;
    final DateTime? forDate;

    if (_isViewingToday) {
      gospelAsync = ref.watch(dailyGospelProvider);
      final viewedAsync = ref.watch(viewedSlidesProvider);
      // Mientras carga, asumir todo visto para evitar flash de badge NUEVO
      viewedSlides = viewedAsync.isLoading ? {0, 1, 2} : (viewedAsync.valueOrNull ?? <int>{});
      forDate = null;
    } else {
      gospelAsync = ref.watch(gospelForDateProvider(_selectedDate));
      final pastViewedAsync = ref.watch(viewedSlidesForDateProvider(_selectedDate));
      viewedSlides = pastViewedAsync.valueOrNull ?? <int>{};
      forDate = _selectedDate;
    }

    // Determine label and topic based on denomination
    final isCatholic = profileAsync.whenOrNull(
      data: (profile) => profile?.denomination == Denomination.catolica,
    ) ?? false;

    final label = isCatholic ? 'EVANGELIO DEL DÍA' : 'LECTURA DEL DÍA';
    final topicKey = isCatholic ? 'evangelio_del_dia' : 'lectura_del_dia';

    final cardChild = gospelAsync.when(
      loading: () => const _GospelCardPlaceholder(key: ValueKey('placeholder')),
      error: (error, stack) => _GospelErrorCard(
        onRetry: () {
          if (_isViewingToday) {
            ref.invalidate(dailyGospelProvider);
          } else {
            ref.invalidate(gospelForDateProvider(_selectedDate));
          }
        },
      ),
      data: (gospel) {
        if (gospel == null || userId == null) {
          return _GospelErrorCard(
            message: 'No hay contenido disponible',
            onRetry: () {
              if (_isViewingToday) {
                ref.invalidate(dailyGospelProvider);
              } else {
                ref.invalidate(gospelForDateProvider(_selectedDate));
              }
            },
          );
        }
        final isSlide0New = gospel.hasStoriesContent && !viewedSlides.contains(0);

        return _GospelCardCompact(
          key: const ValueKey('gospel'),
          label: label,
          reference: gospel.reference,
          hasStories: isSlide0New,
          onTap: () async {
            if (gospel.hasStoriesContent) {
              await _openStoriesAtIndex(0, forDate: forDate);
            } else {
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
        );
      },
    );

    return cardChild;
  }
}

// ============================================
// WIDGETS
// ============================================

/// Placeholder glass que reserva el espacio del gospel card mientras carga.
/// Misma estructura y tamaño que _GospelCardCompact para evitar layout shift.
class _GospelCardPlaceholder extends StatelessWidget {
  const _GospelCardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
                AppTheme.surfaceLight.withOpacity(0.08),
                AppTheme.surfaceLight,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFD8DEE8),
            ),
          ),
          child: Row(
            children: [
              // Icono placeholder
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(width: 16),
              // Líneas placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8DEE8),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 160,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8DEE8),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GospelCardCompact extends StatefulWidget {
  final String label;
  final String reference;
  final bool hasStories;
  final VoidCallback onTap;

  const _GospelCardCompact({
    super.key,
    required this.label,
    required this.reference,
    this.hasStories = false,
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
    return GestureDetector(
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
                    Colors.white,
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
                            Flexible(
                              child: Text(
                                widget.label,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
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
    return GestureDetector(
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
                          Flexible(
                            child: Text(
                              widget.label,
                              overflow: TextOverflow.ellipsis,
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
                        : const Color(0xFFD0D8E4),
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
                Colors.white,
                AppTheme.surfaceLight,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFD8DEE8),
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

class _ActivePlanCard extends StatefulWidget {
  final String planName;
  final String planEmoji;
  final int currentDay;
  final int totalDays;
  final double progressPercent;
  final VoidCallback onTap;

  const _ActivePlanCard({
    required this.planName,
    required this.planEmoji,
    required this.currentDay,
    required this.totalDays,
    required this.progressPercent,
    required this.onTap,
  });

  @override
  State<_ActivePlanCard> createState() => _ActivePlanCardState();
}

class _ActivePlanCardState extends State<_ActivePlanCard>
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
    return GestureDetector(
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
                      AppTheme.primaryColor.withOpacity(0.12),
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.08),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Emoji + Label + Chevron
                    Row(
                      children: [
                        // Plan emoji
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: AppTheme.goldGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              widget.planEmoji,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Plan name only (label is in divider now)
                        Expanded(
                          child: Text(
                            widget.planName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Chevron
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Progress section
                    Row(
                      children: [
                        Text(
                          'Día ${widget.currentDay} de ${widget.totalDays}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ),
                        const Spacer(),
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              AppTheme.goldGradient.createShader(bounds),
                          child: Text(
                            '${(widget.progressPercent * 100).round()}%',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Progress bar
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD0D8E4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: widget.progressPercent.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppTheme.goldGradient,
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.4),
                                blurRadius: 6,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
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
}

/// Estado de cada día en el calendario semanal.
enum _DayState { today, pastCompleted, pastLocked, future }
