import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/lottie_helper.dart';

class ChatScreen extends StatefulWidget {
  final String topicKey;

  const ChatScreen({super.key, required this.topicKey});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  late AnimationController _sendButtonController;
  late Animation<double> _sendButtonScale;

  @override
  void initState() {
    super.initState();

    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _sendButtonScale = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _sendButtonController, curve: Curves.easeInOut),
    );

    // Add initial AI message with delay for animation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              content:
                  'Hola, soy tu acompañante espiritual. Estoy aquí para escucharte y conversar contigo sobre ${_getTopicTitle(widget.topicKey)}. ¿Qué hay en tu corazón hoy?',
              isUser: false,
            ),
          );
        });
      }
    });
  }

  String _getTopicTitle(String key) {
    final topics = {
      'familia_separada': 'tu familia',
      'desempleo': 'fe en tiempos de desempleo',
      'solteria': 'la soltería cristiana',
      'ansiedad_miedo': 'ansiedad y miedo',
      'identidad_bicultural': 'identidad bicultural',
      'reconciliacion': 'reconciliación familiar',
      'sacramentos': 'sacramentos',
      'oracion': 'oración',
      'preguntas_biblia': 'la Biblia',
      'otro': 'lo que necesites',
    };
    return topics[key] ?? 'lo que necesites';
  }

  String _getTopicDisplayTitle(String key) {
    final topics = {
      'familia_separada': 'Familia separada',
      'desempleo': 'Fe en desempleo',
      'solteria': 'Soltería cristiana',
      'ansiedad_miedo': 'Ansiedad y miedo',
      'identidad_bicultural': 'Identidad bicultural',
      'reconciliacion': 'Reconciliación',
      'sacramentos': 'Sacramentos',
      'oracion': 'Oración',
      'preguntas_biblia': 'Preguntas bíblicas',
      'otro': 'Conversación',
    };
    return topics[key] ?? 'Conversación';
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    _sendButtonController.forward().then((_) {
      _sendButtonController.reverse();
    });

    setState(() {
      _messages.add(
        ChatMessage(
          content: _messageController.text.trim(),
          isUser: true,
        ),
      );
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response (in real app, call Edge Function)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              content:
                  'Gracias por compartir eso conmigo. Entiendo que esto es importante para ti. La Biblia nos recuerda en Filipenses 4:6-7: "Por nada estéis afanosos, sino sean conocidas vuestras peticiones delante de Dios en toda oración y ruego, con acción de gracias."\n\n¿Te gustaría que oremos juntos sobre esto?',
              isUser: false,
            ),
          );
          _isLoading = false;
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _sendButtonController.dispose();
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
              _buildAppBar(),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  itemCount: _messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length && _isLoading) {
                      return _TypingIndicator();
                    }
                    return _MessageBubble(
                      message: _messages[index],
                      index: index,
                    );
                  },
                ),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark.withOpacity(0.5),
            border: Border(
              bottom: BorderSide(
                color: AppTheme.surfaceLight.withOpacity(0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppTheme.textPrimary,
                    size: 18,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),

              // AI Avatar
              Container(
                width: 42,
                height: 42,
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
                  Icons.auto_awesome,
                  color: AppTheme.textOnPrimary,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              // Title and status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTopicDisplayTitle(widget.topicKey),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.successColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.successColor.withOpacity(0.5),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'IA activa',
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

              // Menu button
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppTheme.textSecondary,
                    size: 18,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark.withOpacity(0.6),
            border: Border(
              top: BorderSide(
                color: AppTheme.surfaceLight.withOpacity(0.2),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: GlassContainer.input(
                        child: TextField(
                          controller: _messageController,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Escribe tu mensaje...',
                            hintStyle: TextStyle(color: AppTheme.textTertiary),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          maxLines: 4,
                          minLines: 1,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedBuilder(
                      animation: _sendButtonController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _sendButtonScale.value,
                          child: child,
                        );
                      },
                      child: GestureDetector(
                        onTap: _sendMessage,
                        child: Container(
                          width: 48,
                          height: 48,
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
                          child: const Icon(
                            Icons.send_rounded,
                            color: AppTheme.textOnPrimary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Biblia Chat puede cometer errores. Verifica la información importante.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textTertiary,
                        fontSize: 11,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final int index;

  const _MessageBubble({
    required this.message,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            message.isUser ? 20 * (1 - value) : -20 * (1 - value),
            0,
          ),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          child: Column(
            crossAxisAlignment: message.isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomRight:
                      message.isUser ? const Radius.circular(4) : null,
                  bottomLeft:
                      !message.isUser ? const Radius.circular(4) : null,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: message.isUser ? 8 : 10,
                    sigmaY: message.isUser ? 8 : 10,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: message.isUser
                          ? AppTheme.goldGradient
                          : LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.surfaceDark.withOpacity(0.7),
                                AppTheme.surfaceDark.withOpacity(0.5),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(18).copyWith(
                        bottomRight:
                            message.isUser ? const Radius.circular(4) : null,
                        bottomLeft:
                            !message.isUser ? const Radius.circular(4) : null,
                      ),
                      border: message.isUser
                          ? null
                          : Border.all(
                              color: AppTheme.surfaceLight.withOpacity(0.3),
                            ),
                      boxShadow: message.isUser
                          ? [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: message.isUser
                            ? AppTheme.textOnPrimary
                            : AppTheme.textPrimary,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),

              // Actions for AI messages
              if (!message.isUser) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ActionButton(
                      icon: Icons.favorite_border,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.bookmark_border,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.share_outlined,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppTheme.textTertiary,
          size: 16,
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(-20 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18).copyWith(
              bottomLeft: const Radius.circular(4),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(18).copyWith(
                    bottomLeft: const Radius.circular(4),
                  ),
                  border: Border.all(
                    color: AppTheme.surfaceLight.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 20,
                      child: Lottie.asset(
                        LottieAssets.typingIndicator,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return _FallbackTypingDots();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Escribiendo...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textTertiary,
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

class _FallbackTypingDots extends StatefulWidget {
  @override
  State<_FallbackTypingDots> createState() => _FallbackTypingDotsState();
}

class _FallbackTypingDotsState extends State<_FallbackTypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = ((_controller.value + delay) % 1.0);
            final scale = 0.5 + (value < 0.5 ? value : 1.0 - value);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
