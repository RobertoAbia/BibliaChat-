import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/chat_message.dart';
import '../providers/chat_provider.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  String? _lastLocation;

  @override
  void initState() {
    super.initState();
    // Escuchar cambios de ruta para refrescar cuando volvemos de un chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupRouteListener();
    });
  }

  void _setupRouteListener() {
    final router = GoRouter.of(context);
    router.routerDelegate.addListener(_onRouteChange);
  }

  @override
  void dispose() {
    // Intentar remover el listener si el context sigue válido
    try {
      final router = GoRouter.of(context);
      router.routerDelegate.removeListener(_onRouteChange);
    } catch (_) {
      // Context ya no es válido, ignorar
    }
    super.dispose();
  }

  void _onRouteChange() {
    if (!mounted) return;

    final router = GoRouter.of(context);
    final currentLocation = router.routerDelegate.currentConfiguration.uri.path;

    // Si volvemos a /chat desde una ruta de chat (ej: /chat/id/xxx, /chat/new, /chat/topic/xxx)
    if (currentLocation == '/chat' &&
        _lastLocation != null &&
        _lastLocation!.startsWith('/chat/')) {
      // Refrescar la lista de chats
      ref.invalidate(refreshableUserChatsProvider);
    }

    _lastLocation = currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    final chatsAsync = ref.watch(refreshableUserChatsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.read(userChatsRefreshProvider.notifier).state++;
              await ref.read(refreshableUserChatsProvider.future);
            },
            color: AppTheme.primaryColor,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: AppTheme.backgroundDark,
                  surfaceTintColor: Colors.transparent,
                  scrolledUnderElevation: 4,
                  shadowColor: Colors.black26,
                  toolbarHeight: 76,
                  automaticallyImplyLeading: false,
                  flexibleSpace: _buildHeader(context),
                ),
                      // New conversation button
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                          child: Center(
                            child: _NewConversationButton(
                              onTap: () async {
                                await context.push('/chat/new');
                                // Refrescar lista al volver del chat
                                if (!context.mounted) return;
                                ref.read(userChatsRefreshProvider.notifier).state++;
                              },
                            ),
                          ),
                        ),
                      ),

                      // Recent conversations section
                      chatsAsync.when(
                        data: (chats) {
                          if (chats.isEmpty) {
                            return SliverToBoxAdapter(
                              child: _buildEmptyState(context),
                            );
                          }

                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                                    child: Text(
                                      'Conversaciones recientes',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            color: AppTheme.textTertiary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  );
                                }

                                final chat = chats[index - 1];
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                                  child: _ChatTile(
                                    chat: chat,
                                    onReturn: () {
                                      if (!context.mounted) return;
                                      ref.read(userChatsRefreshProvider.notifier).state++;
                                    },
                                  ),
                                );
                              },
                              childCount: chats.length + 1, // +1 for header
                            ),
                          );
                        },
                        loading: () => const SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        error: (error, stack) => SliverToBoxAdapter(
                          child: _buildErrorState(context, error.toString()),
                        ),
                      ),

                      // Guided topics section (collapsed by default)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                          child: _GuidedTopicsSection(
                            onTopicReturn: () {
                              if (!context.mounted) return;
                              ref.read(userChatsRefreshProvider.notifier).state++;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
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
                'Tus Conversaciones',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              color: AppTheme.textTertiary.withOpacity(0.5),
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Aún no tienes conversaciones',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón de arriba para empezar a conversar',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textTertiary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: AppTheme.errorColor.withOpacity(0.5),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar conversaciones',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.errorColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textTertiary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NewConversationButton extends StatefulWidget {
  final VoidCallback onTap;

  const _NewConversationButton({required this.onTap});

  @override
  State<_NewConversationButton> createState() => _NewConversationButtonState();
}

class _NewConversationButtonState extends State<_NewConversationButton>
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          decoration: BoxDecoration(
            gradient: AppTheme.goldGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppTheme.textOnPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Nueva conversación',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatTile extends StatefulWidget {
  final Chat chat;
  final VoidCallback? onReturn;

  const _ChatTile({required this.chat, this.onReturn});

  @override
  State<_ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<_ChatTile>
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

  String _getTopicIcon(String? topicKey) {
    if (topicKey == null) return '💬';
    const icons = {
      'familia_separada': '🏠',
      'desempleo': '💼',
      'solteria': '💝',
      'ansiedad_miedo': '🕊️',
      'identidad_bicultural': '🌎',
      'reconciliacion': '🤝',
      'sacramentos': '✝️',
      'oracion': '🙏',
      'preguntas_biblia': '📖',
      'evangelio_del_dia': '📜',
      'lectura_del_dia': '📜',
      'otro': '💬',
    };
    return icons[topicKey] ?? '💬';
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return DateFormat('dd/MM').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () async {
        await context.push('/chat/id/${widget.chat.id}');
        if (!mounted) return;
        widget.onReturn?.call();
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
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFD0D8E4),
                ),
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD0D8E4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        _getTopicIcon(widget.chat.topicKey),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.chat.displayTitle,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: AppTheme.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.chat.lastMessageAt != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                _formatTime(widget.chat.lastMessageAt),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textTertiary,
                                      fontSize: 11,
                                    ),
                              ),
                            ],
                          ],
                        ),
                        if (widget.chat.lastMessagePreview != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.chat.lastMessagePreview!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textTertiary,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Arrow
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8DEE8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.textTertiary,
                      size: 12,
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

class _GuidedTopicsSection extends StatelessWidget {
  final VoidCallback? onTopicReturn;

  _GuidedTopicsSection({this.onTopicReturn});

  final List<ChatTopic> topics = [
    ChatTopic(
      key: 'familia_separada',
      title: 'Familia separada',
      icon: '🏠',
      gradient: const LinearGradient(
        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      ),
    ),
    ChatTopic(
      key: 'desempleo',
      title: 'Fe en desempleo',
      icon: '💼',
      gradient: const LinearGradient(
        colors: [Color(0xFF059669), Color(0xFF10B981)],
      ),
    ),
    ChatTopic(
      key: 'solteria',
      title: 'Soltería',
      icon: '💝',
      gradient: const LinearGradient(
        colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
      ),
    ),
    ChatTopic(
      key: 'ansiedad_miedo',
      title: 'Ansiedad',
      icon: '🕊️',
      gradient: const LinearGradient(
        colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
      ),
    ),
    ChatTopic(
      key: 'identidad_bicultural',
      title: 'Bicultural',
      icon: '🌎',
      gradient: const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
      ),
    ),
    ChatTopic(
      key: 'reconciliacion',
      title: 'Reconciliación',
      icon: '🤝',
      gradient: const LinearGradient(
        colors: [Color(0xFF14B8A6), Color(0xFF2DD4BF)],
      ),
    ),
    ChatTopic(
      key: 'sacramentos',
      title: 'Sacramentos',
      icon: '✝️',
      gradient: const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
      ),
    ),
    ChatTopic(
      key: 'oracion',
      title: 'Oración',
      icon: '🙏',
      gradient: AppTheme.goldGradient,
    ),
    ChatTopic(
      key: 'preguntas_biblia',
      title: 'Biblia',
      icon: '📖',
      gradient: const LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
      ),
    ),
    ChatTopic(
      key: 'otro',
      title: 'Otro tema',
      icon: '💬',
      gradient: const LinearGradient(
        colors: [Color(0xFF6B7280), Color(0xFF9CA3AF)],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFD8DEE8),
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              initiallyExpanded: false,
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD0D8E4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.topic_outlined,
                      color: AppTheme.textSecondary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Temas guiados',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD0D8E4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${topics.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textTertiary,
                            fontSize: 11,
                          ),
                    ),
                  ),
                ],
              ),
              trailing: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8DEE8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.textTertiary,
                  size: 20,
                ),
              ),
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: topics.map((topic) => _TopicChip(
                    topic: topic,
                    onReturn: onTopicReturn,
                  )).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicChip extends StatefulWidget {
  final ChatTopic topic;
  final VoidCallback? onReturn;

  const _TopicChip({required this.topic, this.onReturn});

  @override
  State<_TopicChip> createState() => _TopicChipState();
}

class _TopicChipState extends State<_TopicChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
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
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () async {
        await context.push('/chat/topic/${widget.topic.key}');
        if (!mounted) return;
        widget.onReturn?.call();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: widget.topic.gradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: widget.topic.gradient.colors.first.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.topic.icon,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 6),
              Text(
                widget.topic.title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
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
  final LinearGradient gradient;

  ChatTopic({
    required this.key,
    required this.title,
    required this.icon,
    required this.gradient,
  });
}
