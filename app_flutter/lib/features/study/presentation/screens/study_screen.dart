import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = [
      StudyPlan(
        id: '1',
        name: 'Fe Cuando Familia Está Lejos',
        description: 'Para migrantes separados de familiares',
        days: 7,
        icon: '🏠',
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
      ),
      StudyPlan(
        id: '2',
        name: 'Trabajo y Provisión Divina',
        description: 'Cuando el trabajo escasea',
        days: 5,
        icon: '💼',
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF10B981)],
        ),
      ),
      StudyPlan(
        id: '3',
        name: 'Soltería Enraizada en Cristo',
        description: 'Vivir la soltería con propósito',
        days: 7,
        icon: '💝',
        gradient: const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
        ),
      ),
      StudyPlan(
        id: '4',
        name: 'Resiste la Ansiedad con Fe',
        description: 'Encontrar paz en tiempos difíciles',
        days: 5,
        icon: '🕊️',
        gradient: const LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
        ),
      ),
      StudyPlan(
        id: '5',
        name: 'Gratitud en Medio del Caos',
        description: 'Cultivar gratitud en tiempos difíciles',
        days: 5,
        icon: '🙏',
        gradient: AppTheme.goldGradient,
      ),
      StudyPlan(
        id: '6',
        name: 'Discípulo en Dos Idiomas',
        description: 'Fe entre dos mundos',
        days: 7,
        icon: '🌎',
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
        ),
      ),
      StudyPlan(
        id: '7',
        name: 'Sanidad del Corazón Inmigrante',
        description: 'Sanar heridas del camino',
        days: 7,
        icon: '❤️‍🩹',
        gradient: const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFF87171)],
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: AppTheme.goldGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: AppTheme.textOnPrimary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estudiar',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            'Planes de estudio bíblico',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textTertiary,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Active Plan Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _ActivePlanCard(
                    plan: plans[0],
                    currentDay: 3,
                  ),
                ),

                const SizedBox(height: 28),

                // Plans List Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassContainer(
                    blur: 8,
                    backgroundOpacity: 0.3,
                    borderRadius: 14,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: AppTheme.goldGradient,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Planes de Estudio',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppTheme.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Diseñados para hispanohablantes',
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            '${plans.length} planes',
                            style:
                                Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Plans List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400 + (index * 60)),
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
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _StudyPlanTile(plan: plan),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivePlanCard extends StatefulWidget {
  final StudyPlan plan;
  final int currentDay;

  const _ActivePlanCard({
    required this.plan,
    required this.currentDay,
  });

  @override
  State<_ActivePlanCard> createState() => _ActivePlanCardState();
}

class _ActivePlanCardState extends State<_ActivePlanCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.currentDay / widget.plan.days;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.surfaceDark.withOpacity(0.6),
                AppTheme.surfaceDark.withOpacity(0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.play_circle_filled,
                          color: AppTheme.textOnPrimary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Plan Activo',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppTheme.textOnPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Día ${widget.currentDay} de ${widget.plan.days}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Plan info
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: widget.plan.gradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              widget.plan.gradient.colors.first.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget.plan.icon,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.plan.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.plan.description,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textTertiary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Progress bar
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return Column(
                    children: [
                      Stack(
                        children: [
                          // Background
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLight.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          // Progress
                          FractionallySizedBox(
                            widthFactor: progress * _progressController.value,
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                gradient: AppTheme.goldGradient,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppTheme.primaryColor.withOpacity(0.5),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(progress * 100 * _progressController.value).toInt()}% completado',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                          Text(
                            '${widget.plan.days - widget.currentDay} días restantes',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textTertiary,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),

              // Continue button
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continuar estudio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textOnPrimary,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: AppTheme.textOnPrimary,
                      ),
                    ],
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

class _StudyPlanTile extends StatefulWidget {
  final StudyPlan plan;

  const _StudyPlanTile({required this.plan});

  @override
  State<_StudyPlanTile> createState() => _StudyPlanTileState();
}

class _StudyPlanTileState extends State<_StudyPlanTile>
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
      onTap: () {
        // Navigate to plan detail
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark.withOpacity(0.4),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppTheme.surfaceLight.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  // Icon with gradient
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: widget.plan.gradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color:
                              widget.plan.gradient.colors.first.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget.plan.icon,
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.plan.name,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.plan.description,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textTertiary,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 12,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.plan.days} días',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Arrow
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.textSecondary,
                      size: 14,
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

class StudyPlan {
  final String id;
  final String name;
  final String description;
  final int days;
  final String icon;
  final LinearGradient gradient;

  StudyPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.days,
    required this.icon,
    required this.gradient,
  });
}
