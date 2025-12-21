import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      ChatTopic(
        key: 'familia_separada',
        title: 'Oración por familia separada',
        icon: '🏠',
        description: 'Para quienes tienen familiares lejos',
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
      ),
      ChatTopic(
        key: 'desempleo',
        title: 'Fe en desempleo',
        icon: '💼',
        description: 'Cuando el trabajo escasea',
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF10B981)],
        ),
      ),
      ChatTopic(
        key: 'solteria',
        title: 'Soltería cristiana',
        icon: '💝',
        description: 'Vivir la soltería con propósito',
        gradient: const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
        ),
      ),
      ChatTopic(
        key: 'ansiedad_miedo',
        title: 'Ansiedad y miedo',
        icon: '🕊️',
        description: 'Encontrar paz en tiempos difíciles',
        gradient: const LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
        ),
      ),
      ChatTopic(
        key: 'identidad_bicultural',
        title: 'Identidad bicultural',
        icon: '🌎',
        description: 'Entre dos mundos y culturas',
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
        ),
      ),
      ChatTopic(
        key: 'reconciliacion',
        title: 'Reconciliación familiar',
        icon: '🤝',
        description: 'Sanar relaciones rotas',
        gradient: const LinearGradient(
          colors: [Color(0xFF14B8A6), Color(0xFF2DD4BF)],
        ),
      ),
      ChatTopic(
        key: 'sacramentos',
        title: 'Bautismo / Confirmación',
        icon: '✝️',
        description: 'Preguntas sobre sacramentos',
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
        ),
      ),
      ChatTopic(
        key: 'oracion',
        title: 'Oración personalizada',
        icon: '🙏',
        description: 'Orar juntos sobre tu situación',
        gradient: AppTheme.goldGradient,
      ),
      ChatTopic(
        key: 'preguntas_biblia',
        title: 'Preguntas sobre la Biblia',
        icon: '📖',
        description: 'Dudas y estudios bíblicos',
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
        ),
      ),
      ChatTopic(
        key: 'otro',
        title: 'Otro tema',
        icon: '💬',
        description: 'Cualquier otra cosa en tu corazón',
        gradient: const LinearGradient(
          colors: [Color(0xFF6B7280), Color(0xFF9CA3AF)],
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
                        Icons.chat_bubble_rounded,
                        color: AppTheme.textOnPrimary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chat IA',
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          'Tu compañero espiritual',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textTertiary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Subtitle with glass effect
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
                        child: Text(
                          '¿Sobre qué quieres conversar hoy?',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Topics list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400 + (index * 50)),
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
                        child: _ChatTopicTile(topic: topic),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatTopicTile extends StatefulWidget {
  final ChatTopic topic;

  const _ChatTopicTile({required this.topic});

  @override
  State<_ChatTopicTile> createState() => _ChatTopicTileState();
}

class _ChatTopicTileState extends State<_ChatTopicTile>
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

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () => context.go('/chat/${widget.topic.key}'),
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
                  // Icon with gradient background
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: widget.topic.gradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: (widget.topic.gradient.colors.first)
                              .withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget.topic.icon,
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.topic.title,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.topic.description,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textTertiary,
                                  ),
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

class ChatTopic {
  final String key;
  final String title;
  final String icon;
  final String description;
  final LinearGradient gradient;

  ChatTopic({
    required this.key,
    required this.title,
    required this.icon,
    required this.description,
    required this.gradient,
  });
}
