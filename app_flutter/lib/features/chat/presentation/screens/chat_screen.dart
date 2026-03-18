import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/services/message_limit_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/lottie_helper.dart';
import '../../domain/entities/chat_message.dart';
import '../providers/chat_provider.dart';
import '../providers/message_limit_provider.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';
import '../../../saved_messages/presentation/providers/saved_message_provider.dart';

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
  final FocusNode _messageFocusNode = FocusNode();
  late AnimationController _sendButtonController;
  late Animation<double> _sendButtonScale;

  late ChatIdentifier _chatIdentifier;

  /// Contenido del día (plan/Stories) pendiente de enviar como systemMessage
  /// Se envía con el primer mensaje del usuario y luego se limpia
  String? _pendingSystemMessage;

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
    debugPrint('🔍 _initializeChat START - mounted: $mounted');
    debugPrint('   chatId: ${widget.chatId}');
    debugPrint('   pendingContent: ${ref.read(pendingPlanContentProvider) != null}');

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

    // Obtener contenido del plan desde provider (alternativa a widget.initialGospelText)
    final pendingPlanContent = ref.read(pendingPlanContentProvider);
    final initialContent = widget.initialGospelText ?? pendingPlanContent;

    debugPrint('🔍 ChatScreen _initializeChat:');
    debugPrint('   pendingPlanContent: ${pendingPlanContent != null ? "${pendingPlanContent.length} chars" : "null"}');
    debugPrint('   initialContent: ${initialContent != null ? "${initialContent.length} chars" : "null"}');

    // Limpiar el provider después de leerlo
    if (pendingPlanContent != null) {
      ref.read(pendingPlanContentProvider.notifier).state = null;
    }

    // Si hay contenido inicial (Stories o Plan del día), prepararlo para enviar
    if (initialContent != null) {
      // Para chats existentes (plan), verificar si el contenido ya existe para no duplicar
      final state = ref.read(chatNotifierProvider(_chatIdentifier));
      debugPrint('   messages count: ${state.messages.length}');
      final contentAlreadyExists = state.messages.any(
        (m) => m.role == 'assistant' && m.content == initialContent,
      );
      debugPrint('   contentAlreadyExists: $contentAlreadyExists');

      if (!contentAlreadyExists) {
        // Mostrar el contenido localmente como mensaje del asistente
        notifier.addInitialMessages(
          assistantContent: initialContent,
        );
        // Guardar para enviar con el primer mensaje del usuario
        _pendingSystemMessage = initialContent;
      }

      // Si hay mensaje del usuario (solo desde Stories con mensaje predefinido), enviarlo
      if (widget.initialUserMessage != null &&
          widget.initialUserMessage!.isNotEmpty) {
        notifier.sendMessage(
          widget.initialUserMessage!,
          topicKey: widget.topicKey,
          systemMessage: initialContent,
        );
        _pendingSystemMessage = null; // Ya se envió
      }

      _scrollToBottom();
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

  Future<void> _sendMessage([String? suggestionText]) async {
    final text = suggestionText ?? _messageController.text.trim();
    if (text.isEmpty) return;

    // Verificar si el usuario puede enviar mensaje (premium o tiene mensajes restantes)
    final canSend = ref.read(canSendMessageProvider);
    if (!canSend) {
      _showMessageLimitDialog();
      return;
    }

    _sendButtonController.forward().then((_) {
      _sendButtonController.reverse();
    });

    if (suggestionText == null) {
      _messageController.clear();
    }

    // Enviar mensaje usando el provider
    // Si hay contenido pendiente (del día del plan), incluirlo como systemMessage
    ref.read(chatNotifierProvider(_chatIdentifier).notifier).sendMessage(
      text,
      systemMessage: _pendingSystemMessage,
    );

    // Limpiar el contenido pendiente (ya se envió)
    if (_pendingSystemMessage != null) {
      setState(() {
        _pendingSystemMessage = null;
      });
    }

    // Incrementar contador de mensajes (solo si no es premium)
    final isPremium = ref.read(isPremiumProvider);
    if (!isPremium) {
      await ref.read(messageLimitProvider.notifier).incrementAndRefresh();
    }

    _scrollToBottom();
  }

  void _showMessageLimitDialog() {
    final remaining = ref.read(remainingMessagesProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: const Color(0xFFD0D8E4),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Límite de mensajes',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Has usado tus ${MessageLimitService.freeDailyLimit} mensajes gratuitos de hoy.',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              'Desbloquea mensajes ilimitados con Premium.',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Volver mañana',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push(RouteConstants.paywall);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Ver planes'),
          ),
        ],
      ),
    );
  }

  void _onSuggestionTap(StarterSuggestion suggestion) {
    _sendMessage(suggestion.text);
  }

  /// Rellena el input con el texto dado y pone el cursor al final
  void _fillInputWith(String text) {
    _messageController.text = text;
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: text.length),
    );
    _messageFocusNode.requestFocus();
  }

  /// Elimina un mensaje específico
  Future<void> _deleteMessage(String messageId) async {
    final success = await ref
        .read(chatNotifierProvider(_chatIdentifier).notifier)
        .deleteMessage(messageId);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Mensaje eliminado',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1A2740),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/chat'); // Siempre va al tab de chats
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          bottom: false,
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
                              final message = chatState.messages[index];
                              return _MessageBubble(
                                message: message,
                                index: index,
                                onDelete: () => _deleteMessage(message.id),
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
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFD8DEE8),
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
                    color: const Color(0xFFD0D8E4),
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
        color: const Color(0xFFD0D8E4),
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
            color: const Color(0xFFD0D8E4),
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
            color: const Color(0xFFD0D8E4),
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
                color: const Color(0xFFD0D8E4),
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
    final router = GoRouter.of(context); // Capturar GoRouter desde contexto de la PANTALLA
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: const Color(0xFFD0D8E4),
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
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancelar',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(dialogContext);
              Navigator.pop(dialogContext); // Cerrar diálogo

              final success = await ref
                  .read(chatNotifierProvider(_chatIdentifier).notifier)
                  .deleteChat();

              if (success) {
                // Refrescar lista de chats
                ref.read(userChatsRefreshProvider.notifier).state++;

                // Mostrar confirmación
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Conversación eliminada',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: const Color(0xFF1A2740),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 2),
                  ),
                );

                // Volver a la lista con GoRouter
                router.pop();
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            // Icono centrado con gradiente dorado
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 36,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Texto simple centrado
            Text(
              '¿En qué te puedo ayudar?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),

            const Spacer(flex: 2),

            // Chips de sugerencias
            _buildSuggestionChips(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChips() {
    // Sugerencias con emoji, texto corto y texto completo para el input
    final suggestions = [
      ('🙏', 'Oración para...', 'Necesito una oración para '),
      ('📖', 'Duda sobre...', 'Tengo una duda sobre '),
      ('💬', 'Hablar de...', 'Me gustaría hablar de '),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: suggestions.map((s) => _buildChip(s.$1, s.$2, s.$3)).toList(),
    );
  }

  Widget _buildChip(String emoji, String label, String fullText) {
    return GestureDetector(
      onTap: () => _fillInputWith(fullText),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFD0D8E4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(bool isSending) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: const Color(0xFFD8DEE8),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 4),
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
                          focusNode: _messageFocusNode,
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
                const SizedBox(height: 4),
                _buildFooterWithMessageCount(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterWithMessageCount() {
    final isPremium = ref.watch(isPremiumProvider);
    final remaining = ref.watch(remainingMessagesProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Badge de mensajes restantes (solo para usuarios free)
        if (!isPremium && remaining >= 0) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: remaining <= 1
                  ? AppTheme.errorColor.withOpacity(0.2)
                  : const Color(0xFFD0D8E4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  remaining <= 1 ? Icons.warning_amber_rounded : Icons.chat_bubble_outline,
                  size: 12,
                  color: remaining <= 1 ? AppTheme.errorColor : AppTheme.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  '$remaining/${MessageLimitService.freeDailyLimit}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: remaining <= 1 ? AppTheme.errorColor : AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
        // Texto de disclaimer
        Flexible(
          child: Text(
            'Biblia Chat puede cometer errores.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textTertiary,
                  fontSize: 11,
                ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends ConsumerWidget {
  final ChatMessage message;
  final int index;
  final VoidCallback? onDelete;

  const _MessageBubble({
    required this.message,
    required this.index,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      child: GestureDetector(
        onLongPress: onDelete != null ? () => _showDeleteOption(context) : null,
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
                          : null,
                      color: message.isUser
                          ? null
                          : AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(18).copyWith(
                        bottomRight:
                            message.isUser ? const Radius.circular(4) : null,
                        bottomLeft:
                            !message.isUser ? const Radius.circular(4) : null,
                      ),
                      border: message.isUser
                          ? null
                          : Border.all(
                              color: const Color(0xFFD0D8E4).withOpacity(0.5),
                            ),
                      boxShadow: message.isUser
                          ? [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: const Color(0xFF1A2740).withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
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
                _SaveButton(
                  messageId: message.id,
                ),
              ],
            ],
          ),
        ),
      ),
      ),
    );
  }

  void _showDeleteOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD0D8E4),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: AppTheme.errorColor,
              ),
              title: Text(
                'Eliminar mensaje',
                style: TextStyle(color: AppTheme.errorColor),
              ),
              onTap: () {
                Navigator.pop(context);
                onDelete?.call();
              },
            ),
            Divider(height: 1, color: AppTheme.textTertiary.withOpacity(0.3)),
            ListTile(
              leading: Icon(
                Icons.close,
                color: AppTheme.textSecondary,
              ),
              title: Text(
                'Cancelar',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// Save/unsave button for AI messages (heart icon)
class _SaveButton extends ConsumerWidget {
  final String messageId;

  const _SaveButton({required this.messageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(isMessageSavedProvider(messageId));

    return GestureDetector(
      onTap: () => _toggleSave(context, ref),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSaved
              ? AppTheme.primaryColor.withOpacity(0.2)
              : const Color(0xFFD0D8E4),
          borderRadius: BorderRadius.circular(10),
          border: isSaved
              ? Border.all(color: AppTheme.primaryColor.withOpacity(0.5))
              : null,
        ),
        child: Icon(
          isSaved ? Icons.favorite : Icons.favorite_border,
          color: isSaved ? AppTheme.primaryColor : AppTheme.textTertiary,
          size: 16,
        ),
      ),
    );
  }

  Future<void> _toggleSave(BuildContext context, WidgetRef ref) async {
    await ref.read(savedMessageNotifierProvider.notifier).toggleSave(messageId);
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18).copyWith(
                    bottomLeft: const Radius.circular(4),
                  ),
                  border: Border.all(
                    color: const Color(0xFFD0D8E4),
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
