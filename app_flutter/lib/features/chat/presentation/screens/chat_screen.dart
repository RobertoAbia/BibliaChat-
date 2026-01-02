import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/lottie_helper.dart';
import '../../domain/entities/chat_message.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  /// ID del chat existente (para abrir conversación existente)
  final String? chatId;

  /// Topic key (para chat de topic específico, ej: desde Stories)
  final String? topicKey;

  /// Texto inicial del evangelio (cuando viene de Stories)
  final String? initialGospelText;
  final String? initialGospelReference;
  final String? initialUserMessage;

  const ChatScreen({
    super.key,
    this.chatId,
    this.topicKey,
    this.initialGospelText,
    this.initialGospelReference,
    this.initialUserMessage,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _sendButtonController;
  late Animation<double> _sendButtonScale;

  late ChatIdentifier _chatIdentifier;

  @override
  void initState() {
    super.initState();

    // Determinar el identificador del chat
    if (widget.chatId != null) {
      _chatIdentifier = ChatIdentifier.existing(widget.chatId!);
    } else if (widget.initialGospelText != null) {
      // Viene de Stories: SIEMPRE crear chat nuevo (no buscar existente)
      _chatIdentifier = const ChatIdentifier.newChat();
    } else if (widget.topicKey != null) {
      _chatIdentifier = ChatIdentifier.topic(widget.topicKey!);
    } else {
      _chatIdentifier = const ChatIdentifier.newChat();
    }

    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _sendButtonScale = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _sendButtonController, curve: Curves.easeInOut),
    );

    // Inicializar después del primer frame para evitar problemas de contexto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  Future<void> _initializeChat() async {
    if (!mounted) return;

    final notifier = ref.read(chatNotifierProvider(_chatIdentifier).notifier);

    // Para chats nuevos, resetear el estado primero (evita reutilizar chat viejo cacheado)
    if (_chatIdentifier.isNewChat && widget.initialGospelText == null) {
      notifier.resetForNewChat();
    }

    // Inicializar el chat (cargar historial)
    try {
      await notifier.initialize();
    } catch (e) {
      debugPrint('Error initializing chat: $e');
      return;
    }

    if (!mounted) return;

    // Para chats desde Stories, SIEMPRE añadir mensajes iniciales (es un chat nuevo)
    if (widget.initialGospelText != null) {
      // Solo añadir el mensaje del asistente (el contenido de la Story)
      // NO añadir userContent aquí porque sendMessage() lo añadirá después
      notifier.addInitialMessages(
        assistantContent: widget.initialGospelText!,
      );

      // Si hay mensaje del usuario, enviarlo para obtener respuesta real
      if (widget.initialUserMessage != null &&
          widget.initialUserMessage!.isNotEmpty) {
        // Pasar el topicKey y el contexto de la Story para que la IA sepa de qué habla
        notifier.sendMessage(
          widget.initialUserMessage!,
          topicKey: widget.topicKey,
          systemContext: widget.initialGospelText,
        );
      }
    } else {
      // Para otros casos, solo añadir si está vacío
      final state = ref.read(chatNotifierProvider(_chatIdentifier));
      if (state.messages.isEmpty && !state.showStarterSuggestions) {
        if (widget.topicKey != null) {
          notifier.addInitialAssistantMessage(
            'Hola, soy tu acompañante espiritual. Estoy aquí para escucharte y conversar contigo sobre ${_getTopicTitle(widget.topicKey!)}. ¿Qué hay en tu corazón hoy?',
          );
        }
      }
    }
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
      'evangelio_del_dia': 'el evangelio de hoy',
      'lectura_del_dia': 'la lectura de hoy',
      'otro': 'lo que necesites',
    };
    return topics[key] ?? 'lo que necesites';
  }

  String _getTopicDisplayTitle(String? key) {
    if (key == null) return 'Nueva conversación';
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
      'evangelio_del_dia': 'Evangelio del día',
      'lectura_del_dia': 'Lectura del día',
      'otro': 'Conversación',
    };
    return topics[key] ?? 'Conversación';
  }

  void _sendMessage([String? suggestionText]) {
    final text = suggestionText ?? _messageController.text.trim();
    if (text.isEmpty) return;

    _sendButtonController.forward().then((_) {
      _sendButtonController.reverse();
    });

    if (suggestionText == null) {
      _messageController.clear();
    }

    // Enviar mensaje usando el provider
    ref.read(chatNotifierProvider(_chatIdentifier).notifier).sendMessage(text);

    _scrollToBottom();
  }

  void _onSuggestionTap(StarterSuggestion suggestion) {
    _sendMessage(suggestion.text);
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
    // Escuchar cambios en el estado del chat
    final chatState = ref.watch(chatNotifierProvider(_chatIdentifier));

    // Scroll al fondo cuando cambian los mensajes
    ref.listen<ChatState>(chatNotifierProvider(_chatIdentifier), (prev, next) {
      if (prev?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(chatState),
              Expanded(
                child: chatState.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                        ),
                      )
                    : chatState.showStarterSuggestions
                        ? _buildStarterSuggestions()
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            itemCount: chatState.messages.length +
                                (chatState.isSending ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == chatState.messages.length &&
                                  chatState.isSending) {
                                return const _TypingIndicator();
                              }
                              return _MessageBubble(
                                message: chatState.messages[index],
                                index: index,
                              );
                            },
                          ),
              ),
              if (chatState.error != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: AppTheme.errorColor.withOpacity(0.1),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppTheme.errorColor, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          chatState.error!,
                          style: const TextStyle(
                            color: AppTheme.errorColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () => ref
                            .read(chatNotifierProvider(_chatIdentifier).notifier)
                            .clearError(),
                        color: AppTheme.errorColor,
                      ),
                    ],
                  ),
                ),
              _buildInputArea(chatState.isSending),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(ChatState chatState) {
    // Usar displayTitle que prioriza: título generado > topic > "Nueva conversación"
    final title = chatState.displayTitle;

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
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

              // Menu button con opciones
              _buildMenuButton(chatState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(ChatState chatState) {
    // Solo mostrar menú si hay un chat existente
    final hasChat = chatState.chatId != null;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: PopupMenuButton<String>(
        icon: const Icon(
          Icons.more_vert,
          color: AppTheme.textSecondary,
          size: 18,
        ),
        padding: EdgeInsets.zero,
        color: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppTheme.surfaceLight.withOpacity(0.3),
          ),
        ),
        enabled: hasChat,
        onSelected: (value) {
          switch (value) {
            case 'rename':
              _showRenameDialog(chatState);
              break;
            case 'delete':
              _showDeleteDialog(chatState);
              break;
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'rename',
            child: Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppTheme.textPrimary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Renombrar',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: AppTheme.errorColor,
                ),
                const SizedBox(width: 12),
                Text(
                  'Eliminar',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(ChatState chatState) {
    final controller = TextEditingController(text: chatState.title ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppTheme.surfaceLight.withOpacity(0.3),
          ),
        ),
        title: Text(
          'Renombrar conversación',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'Nuevo nombre',
            hintStyle: TextStyle(color: AppTheme.textTertiary),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.surfaceLight.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryColor),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) {
                Navigator.pop(context);
                await ref
                    .read(chatNotifierProvider(_chatIdentifier).notifier)
                    .updateTitle(newTitle);
              }
            },
            child: Text(
              'Guardar',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(ChatState chatState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppTheme.surfaceLight.withOpacity(0.3),
          ),
        ),
        title: Text(
          'Eliminar conversación',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar esta conversación? Esta acción no se puede deshacer.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Cerrar diálogo
              final success = await ref
                  .read(chatNotifierProvider(_chatIdentifier).notifier)
                  .deleteChat();
              if (success && mounted) {
                // Refrescar lista de chats y volver
                ref.read(userChatsRefreshProvider.notifier).state++;
                Navigator.of(context).pop(); // Volver a la lista
              }
            },
            child: Text(
              'Eliminar',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarterSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI greeting message bubble
          _buildAIGreetingBubble(),

          const SizedBox(height: 24),

          // Suggestions section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Puedes empezar con:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),

          const SizedBox(height: 12),

          // Starter suggestions
          ...starterSuggestions.map((suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _StarterSuggestionTile(
                  suggestion: suggestion,
                  onTap: () => _onSuggestionTap(suggestion),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildAIGreetingBubble() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-20 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18).copyWith(
              bottomLeft: const Radius.circular(4),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.surfaceDark.withOpacity(0.7),
                      AppTheme.surfaceDark.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18).copyWith(
                    bottomLeft: const Radius.circular(4),
                  ),
                  border: Border.all(
                    color: AppTheme.surfaceLight.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Hola! 👋',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Soy tu acompañante espiritual. Estoy aquí para escucharte, '
                      'conversar contigo y ayudarte a encontrar paz y guía en la Palabra de Dios.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            height: 1.4,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '¿Qué hay en tu corazón hoy?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                            fontStyle: FontStyle.italic,
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

  Widget _buildInputArea(bool isSending) {
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
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppTheme.textTertiary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _messageController,
                          cursorColor: AppTheme.textPrimary,
                          enabled: !isSending,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: isSending
                                ? 'Esperando respuesta...'
                                : 'Escribe tu mensaje...',
                            hintStyle:
                                const TextStyle(color: AppTheme.textTertiary),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            fillColor: Colors.transparent,
                            filled: false,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
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
                        onTap: isSending ? null : () => _sendMessage(),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: isSending
                                ? LinearGradient(
                                    colors: [
                                      AppTheme.primaryColor.withOpacity(0.5),
                                      AppTheme.primaryDark.withOpacity(0.5),
                                    ],
                                  )
                                : AppTheme.goldGradient,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: isSending
                                ? null
                                : [
                                    BoxShadow(
                                      color:
                                          AppTheme.primaryColor.withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: Icon(
                            Icons.send_rounded,
                            color: isSending
                                ? AppTheme.textTertiary
                                : AppTheme.textOnPrimary,
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

class _StarterSuggestionTile extends StatefulWidget {
  final StarterSuggestion suggestion;
  final VoidCallback onTap;

  const _StarterSuggestionTile({
    required this.suggestion,
    required this.onTap,
  });

  @override
  State<_StarterSuggestionTile> createState() => _StarterSuggestionTileState();
}

class _StarterSuggestionTileState extends State<_StarterSuggestionTile>
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.surfaceLight.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    widget.suggestion.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.suggestion.text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.textTertiary,
                    size: 16,
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
  const _TypingIndicator();

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
                          return const _FallbackTypingDots();
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
  const _FallbackTypingDots();

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
