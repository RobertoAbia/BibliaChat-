import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../domain/entities/plan.dart';
import '../../domain/entities/user_plan.dart';
import '../providers/study_provider.dart';

class PlanDetailScreen extends ConsumerWidget {
  final String planId;

  const PlanDetailScreen({super.key, required this.planId});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(planDetailProvider(planId));
    final daysAsync = ref.watch(planDaysProvider(planId));
    final actionsState = ref.watch(studyActionsProvider);
    final userPlansAsync = ref.watch(allUserPlansProvider);

    // Find userPlan for this plan (if exists)
    final userPlans = userPlansAsync.valueOrNull ?? [];
    final userPlan = userPlans.cast<UserPlan?>().firstWhere(
          (up) => up?.planId == planId,
          orElse: () => null,
        );
    final isCompleted = userPlan?.isCompleted ?? false;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: planAsync.when(
          data: (plan) {
            if (plan == null) {
              return const Center(child: Text('Plan no encontrado'));
            }

            final gradient = _getGradientForPlan(plan);

            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 200,
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
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            gradient.colors.first.withOpacity(0.3),
                            AppTheme.backgroundDark,
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            // Icon
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: gradient,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: gradient.colors.first.withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  plan.iconEmoji,
                                  style: const TextStyle(fontSize: 40),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              plan.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Content
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Completion Banner (if completed)
                      if (isCompleted) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF10B981).withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF10B981),
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '¡Plan completado!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: const Color(0xFF10B981),
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Has terminado los 7 días de este plan',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppTheme.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Description Card
                      GlassContainer(
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
                                  width: 4,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: gradient,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    'Sobre este plan',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppTheme.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              plan.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppTheme.textSecondary,
                                    height: 1.6,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _InfoChip(
                                  icon: Icons.calendar_today_outlined,
                                  label: '${plan.daysTotal} días',
                                ),
                                const SizedBox(width: 12),
                                _InfoChip(
                                  icon: Icons.timer_outlined,
                                  label: '10-15 min/día',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Days List Header
                      Text(
                        'Contenido del plan',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),

                      const SizedBox(height: 12),

                      // Days List
                      daysAsync.when(
                        data: (days) => Column(
                          children: days.map((day) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _DayPreviewTile(
                                dayNumber: day.dayNumber,
                                title: day.displayTitle,
                                verseRef: day.verseReferences.isNotEmpty
                                    ? day.verseReferences.first
                                    : '',
                              ),
                            );
                          }).toList(),
                        ),
                        loading: () => Column(
                          children: List.generate(
                            7,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ShimmerLoading.card(height: 70),
                            ),
                          ),
                        ),
                        error: (_, __) => const Center(
                          child: Text('Error al cargar los días'),
                        ),
                      ),

                      const SizedBox(height: 80), // Space for button
                    ]),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          ),
          error: (_, __) => const Center(
            child: Text('Error al cargar el plan'),
          ),
        ),
      ),
      // Start Plan Button (or Review Content if completed)
      bottomNavigationBar: planAsync.when(
        data: (plan) {
          if (plan == null) return const SizedBox.shrink();

          return Container(
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
                gradient: isCompleted
                    ? const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                      )
                    : AppTheme.goldGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isCompleted
                        ? const Color(0xFF10B981).withOpacity(0.4)
                        : AppTheme.primaryColor.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: actionsState.isLoading
                    ? null
                    : () async {
                        if (isCompleted && userPlan != null) {
                          // Navigate to day 1 in readOnly mode
                          context.push('/study/day/${userPlan.id}?readOnly=true&day=1');
                        } else {
                          // Start new plan
                          final newUserPlan = await ref
                              .read(studyActionsProvider.notifier)
                              .startPlan(planId);
                          if (!context.mounted) return;

                          if (newUserPlan != null) {
                            // Navigate to day screen, replacing current route
                            context.go('/study/day/${newUserPlan.id}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('¡Plan iniciado!'),
                                backgroundColor: AppTheme.primaryColor,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          } else {
                            // Show error
                            final errorState = ref.read(studyActionsProvider);
                            String errorMsg = 'Error al iniciar el plan';
                            if (errorState.hasError) {
                              errorMsg = errorState.error.toString();
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMsg),
                                backgroundColor: Colors.red,
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
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: actionsState.isLoading
                    ? const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          color: AppTheme.textOnPrimary,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isCompleted
                                ? Icons.visibility_rounded
                                : Icons.play_arrow_rounded,
                            color: AppTheme.textOnPrimary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isCompleted ? 'Revisar contenido' : 'Comenzar plan',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textOnPrimary,
                            ),
                          ),
                        ],
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
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _DayPreviewTile extends StatelessWidget {
  final int dayNumber;
  final String title;
  final String verseRef;

  const _DayPreviewTile({
    required this.dayNumber,
    required this.title,
    required this.verseRef,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark.withOpacity(0.4),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppTheme.surfaceLight.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '$dayNumber',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    if (verseRef.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        verseRef,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textTertiary,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.lock_outline,
                size: 18,
                color: AppTheme.textTertiary.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
