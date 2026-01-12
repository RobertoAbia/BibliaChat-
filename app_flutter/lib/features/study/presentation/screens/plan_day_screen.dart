import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../domain/entities/plan.dart';
import '../../domain/entities/plan_day.dart';
import '../providers/study_provider.dart';

/// Provider for loading the current day's data
final currentDayDataProvider = FutureProvider.family<_DayScreenData?, String>(
  (ref, userPlanId) async {
    final activePlanData = await ref.watch(activePlanDataProvider.future);
    if (activePlanData == null) return null;

    return _DayScreenData(
      plan: activePlanData.plan,
      userPlanId: activePlanData.userPlan.id,
      planDay: activePlanData.currentPlanDay,
      currentDay: activePlanData.userPlan.currentDay,
      totalDays: activePlanData.plan.daysTotal,
    );
  },
);

class _DayScreenData {
  final Plan plan;
  final String userPlanId;
  final PlanDay planDay;
  final int currentDay;
  final int totalDays;

  _DayScreenData({
    required this.plan,
    required this.userPlanId,
    required this.planDay,
    required this.currentDay,
    required this.totalDays,
  });
}

class PlanDayScreen extends ConsumerStatefulWidget {
  final String userPlanId;

  const PlanDayScreen({super.key, required this.userPlanId});

  @override
  ConsumerState<PlanDayScreen> createState() => _PlanDayScreenState();
}

class _PlanDayScreenState extends ConsumerState<PlanDayScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      if (!_hasScrolledToBottom) {
        setState(() {
          _hasScrolledToBottom = true;
        });
      }
    }
  }

  LinearGradient _getGradientForPlan(Plan plan) {
    switch (plan.icon) {
      case 'self_improvement':
        return const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        );
      case 'volunteer_activism':
        return const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF10B981)],
        );
      case 'favorite':
        return const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
        );
      case 'spa':
        return const LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
        );
      case 'restaurant':
        return const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
        );
      case 'celebration':
        return AppTheme.goldGradient;
      case 'fitness_center':
        return const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFF87171)],
        );
      default:
        return AppTheme.goldGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayDataAsync = ref.watch(currentDayDataProvider(widget.userPlanId));
    final actionsState = ref.watch(studyActionsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: dayDataAsync.when(
          data: (data) {
            if (data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '¡Plan completado!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Has terminado todos los días',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Volver'),
                    ),
                  ],
                ),
              );
            }

            final gradient = _getGradientForPlan(data.plan);
            final planDay = data.planDay;

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // App Bar
                SliverAppBar(
                  pinned: true,
                  backgroundColor: AppTheme.backgroundDark,
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppTheme.textPrimary,
                        size: 20,
                      ),
                    ),
                    onPressed: () => context.pop(),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Día ${data.currentDay} de ${data.totalDays}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        data.plan.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textTertiary,
                            ),
                      ),
                    ],
                  ),
                  actions: [
                    // Progress indicator
                    Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: data.currentDay / data.totalDays,
                              backgroundColor:
                                  AppTheme.surfaceLight.withOpacity(0.3),
                              color: AppTheme.primaryColor,
                              strokeWidth: 3,
                            ),
                            Center(
                              child: Text(
                                '${data.currentDay}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Menu
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: AppTheme.textSecondary),
                      color: AppTheme.surfaceDark,
                      onSelected: (value) {
                        if (value == 'abandon') {
                          _showAbandonDialog(context, ref, data.userPlanId, data.plan.name);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'abandon',
                          child: Row(
                            children: [
                              Icon(Icons.exit_to_app, color: Colors.red, size: 20),
                              SizedBox(width: 12),
                              Text('Abandonar plan', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Content
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Day Title
                      if (planDay.title != null) ...[
                        Text(
                          planDay.title!,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Verse References
                      if (planDay.verseReferences.isNotEmpty) ...[
                        _SectionCard(
                          icon: Icons.menu_book_outlined,
                          iconGradient: gradient,
                          title: 'Versículo del día',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: planDay.verseReferences.map((ref) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.format_quote,
                                      size: 16,
                                      color: AppTheme.primaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        ref,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: AppTheme.primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Reflection
                      if (planDay.reflection != null) ...[
                        _SectionCard(
                          icon: Icons.lightbulb_outline,
                          iconGradient: const LinearGradient(
                            colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                          ),
                          title: 'Reflexión',
                          child: Text(
                            planDay.reflection!,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.textSecondary,
                                      height: 1.7,
                                    ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Practical Exercise
                      if (planDay.practicalExercise != null) ...[
                        _SectionCard(
                          icon: Icons.directions_run,
                          iconGradient: const LinearGradient(
                            colors: [Color(0xFF10B981), Color(0xFF34D399)],
                          ),
                          title: 'Ejercicio práctico',
                          child: Text(
                            planDay.practicalExercise!,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.textSecondary,
                                      height: 1.6,
                                    ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Question for Chat
                      if (planDay.question != null) ...[
                        _SectionCard(
                          icon: Icons.chat_bubble_outline,
                          iconGradient: const LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                          ),
                          title: 'Pregunta para reflexionar',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                planDay.question!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.textSecondary,
                                      height: 1.6,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: () {
                                  // Navigate to chat with this question as context
                                  context.push('/chat/new');
                                },
                                icon: const Icon(Icons.chat, size: 18),
                                label: const Text('Hablar con Biblia Chat'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.primaryColor,
                                  side: BorderSide(
                                    color: AppTheme.primaryColor.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Scroll hint
                      if (!_hasScrolledToBottom)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppTheme.textTertiary,
                                  size: 24,
                                ),
                                Text(
                                  'Desliza para continuar',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.textTertiary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 100), // Space for button
                    ]),
                  ),
                ),
              ],
            );
          },
          loading: () => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ShimmerLoading.text(width: 200),
                  const SizedBox(height: 24),
                  ShimmerLoading.card(height: 150),
                  const SizedBox(height: 16),
                  ShimmerLoading.card(height: 200),
                  const SizedBox(height: 16),
                  ShimmerLoading.card(height: 100),
                ],
              ),
            ),
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppTheme.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar el día',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Volver'),
                ),
              ],
            ),
          ),
        ),
      ),
      // Complete Day Button
      bottomNavigationBar: dayDataAsync.when(
        data: (data) {
          if (data == null) return const SizedBox.shrink();

          final isLastDay = data.currentDay >= data.totalDays;

          return AnimatedOpacity(
            opacity: _hasScrolledToBottom ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
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
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: _hasScrolledToBottom
                      ? AppTheme.goldGradient
                      : LinearGradient(
                          colors: [
                            AppTheme.surfaceLight.withOpacity(0.5),
                            AppTheme.surfaceLight.withOpacity(0.3),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _hasScrolledToBottom
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: ElevatedButton(
                  onPressed: !_hasScrolledToBottom || actionsState.isLoading
                      ? null
                      : () async {
                          final success = await ref
                              .read(studyActionsProvider.notifier)
                              .completeDay(
                                data.userPlanId,
                                data.currentDay,
                                data.totalDays,
                              );
                          if (success && context.mounted) {
                            if (isLastDay) {
                              // Show completion dialog
                              _showCompletionDialog(context, data.plan);
                            } else {
                              // Go back to study screen
                              context.pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '¡Día ${data.currentDay} completado! 🎉',
                                  ),
                                  backgroundColor: AppTheme.primaryColor,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: actionsState.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppTheme.textOnPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isLastDay
                                  ? Icons.emoji_events
                                  : Icons.check_circle_outline,
                              color: _hasScrolledToBottom
                                  ? AppTheme.textOnPrimary
                                  : AppTheme.textTertiary,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isLastDay
                                  ? 'Completar plan'
                                  : 'Completar día ${data.currentDay}',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: _hasScrolledToBottom
                                    ? AppTheme.textOnPrimary
                                    : AppTheme.textTertiary,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context, Plan plan) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.surfaceDark.withOpacity(0.9),
                    AppTheme.surfaceDark.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Trophy icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      size: 40,
                      color: AppTheme.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '¡Felicidades!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Has completado el plan',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"${plan.name}"',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textOnPrimary,
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

  void _showAbandonDialog(BuildContext context, WidgetRef ref, String userPlanId, String planName) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.surfaceDark.withOpacity(0.9),
                    AppTheme.surfaceDark.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.surfaceLight.withOpacity(0.3),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Warning icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      size: 32,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '¿Abandonar plan?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Perderás todo tu progreso en "$planName". Esta acción no se puede deshacer.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.textSecondary,
                            side: BorderSide(color: AppTheme.surfaceLight.withOpacity(0.5)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(dialogContext).pop();
                            final success = await ref
                                .read(studyActionsProvider.notifier)
                                .abandonPlan(userPlanId);
                            if (success && context.mounted) {
                              context.pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Plan abandonado'),
                                  backgroundColor: AppTheme.textTertiary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Abandonar'),
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
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final LinearGradient iconGradient;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.iconGradient,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      blur: 8,
      backgroundOpacity: 0.35,
      borderRadius: 16,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: iconGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
