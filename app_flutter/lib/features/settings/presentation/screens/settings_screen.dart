import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

import '../../../../app.dart' show dialogContextProvider;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/daily_progress_provider.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../../../study/presentation/providers/study_provider.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authStatus = ref.watch(authStatusProvider);
    final isAnonymous = authStatus == AuthStatus.anonymous;
    final isEmailUnverified = authStatus == AuthStatus.emailUnverified;
    final email = ref.watch(currentEmailProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final isSubscriptionLoaded = !ref.watch(subscriptionProvider).isLoading;
    final profileAsync = ref.watch(currentUserProfileProvider);
    final profileName = profileAsync.valueOrNull?.name;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            key: const PageStorageKey<String>('settings_scroll'),
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppTheme.backgroundDark,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 4,
                shadowColor: Colors.black26,
                toolbarHeight: 76,
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
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
                          Icons.person_rounded,
                          color: AppTheme.textOnPrimary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Perfil',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            'Tu cuenta y preferencias',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textTertiary,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      _getInitial(profileName ?? email),
                      style: const TextStyle(
                        fontSize: 32,
                        color: AppTheme.textOnPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profileName ?? 'Usuario',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isAnonymous || isEmailUnverified)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.warningColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isEmailUnverified ? 'Pendiente' : 'Sin guardar',
                            style: const TextStyle(
                              color: AppTheme.warningColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      Text(
                        email ?? 'Cuenta anónima',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stats pills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: _buildStatPill(
                      context,
                      '🔥',
                      ref.watch(streakDaysDisplayProvider).toString(),
                      'Racha',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: _buildStatPill(
                      context,
                      '📚',
                      ref.watch(allUserPlansProvider).when(
                        data: (plans) => plans.where((p) => p.isCompleted).length.toString(),
                        loading: () => '-',
                        error: (_, __) => '-',
                      ),
                      'Planes completados',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),

            // Settings Sections
            _buildSection(
              context,
              title: 'Cuenta',
              items: [
                // No premium: CTA prominente arriba de todo (hide while loading)
                if (isSubscriptionLoaded && !isPremium)
                  SettingsItem(
                    icon: Icons.workspace_premium,
                    title: 'Pásate a Premium',
                    subtitle: 'Chat ilimitado y más',
                    isHighlighted: true,
                    onTap: () => context.push(RouteConstants.paywall),
                  ),
                SettingsItem(
                  icon: Icons.person_outline,
                  title: 'Editar Perfil',
                  onTap: () => context.push(RouteConstants.profileEdit),
                ),
                // Estado 1: Anónimo — vincular email
                if (isAnonymous)
                  SettingsItem(
                    icon: Icons.shield_outlined,
                    title: 'Guardar mi cuenta',
                    subtitle: 'Vincular email para no perder datos',
                    isHighlighted: true,
                    onTap: () {
                      context.push(RouteConstants.linkEmail);
                    },
                  ),
                // Estado 2: Email pendiente de verificación
                if (isEmailUnverified)
                  SettingsItem(
                    icon: Icons.mark_email_unread_outlined,
                    title: 'Verificar tu email',
                    subtitle: email ?? 'Revisa tu correo',
                    isWarning: true,
                    onTap: () {
                      final encodedEmail = Uri.encodeComponent(email ?? '');
                      context.push('${RouteConstants.verifyEmail}?email=$encodedEmail');
                    },
                  ),
                // Estado 3: Email verificado
                if (!isAnonymous && !isEmailUnverified)
                  SettingsItem(
                    icon: Icons.verified_user_outlined,
                    title: 'Cuenta vinculada',
                    subtitle: email,
                    onTap: () {},
                  ),
              ],
            ),

            _buildSection(
              context,
              title: 'Preferencias',
              items: [
                SettingsItem(
                  icon: Icons.widgets_outlined,
                  title: 'Widget de versículos',
                  subtitle: 'Añádelo a tu pantalla',
                  onTap: () => context.push(RouteConstants.widgetSetup),
                ),
                SettingsItem(
                  icon: Icons.favorite_outline,
                  title: 'Mis Reflexiones',
                  subtitle: 'Mensajes guardados',
                  onTap: () => context.push(RouteConstants.savedMessages),
                ),
              ],
            ),

            _buildSection(
              context,
              title: 'Información',
              items: [
                SettingsItem(
                  icon: Icons.star_outline,
                  title: 'Valorar la app',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Disponible próximamente'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  },
                ),
                SettingsItem(
                  icon: Icons.share_outlined,
                  title: 'Compartir con un amigo',
                  onTap: () {
                    Share.share(
                      '¡Descubre Biblia Chat! La app cristiana que entiende tu fe, tu idioma y tu cultura. 🙏',
                      subject: 'Te recomiendo Biblia Chat',
                    );
                  },
                ),
                SettingsItem(
                  icon: Icons.description_outlined,
                  title: 'Términos de uso',
                  onTap: () => context.push(RouteConstants.termsConditions),
                ),
                SettingsItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Política de privacidad',
                  onTap: () => context.push(RouteConstants.privacyPolicy),
                ),
                // Premium: gestionar suscripción al final de Información (hide while loading)
                if (isSubscriptionLoaded && isPremium)
                  SettingsItem(
                    icon: Icons.credit_card,
                    title: 'Gestionar suscripción',
                    subtitle: 'Cambiar plan o cancelar',
                    onTap: () async {
                      await launchUrl(
                        Uri.parse('https://apps.apple.com/account/subscriptions'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
              ],
            ),

            _buildSection(
              context,
              title: 'Zona de peligro',
              items: [
                SettingsItem(
                  icon: Icons.logout,
                  title: 'Cerrar sesión',
                  isDestructive: true,
                  onTap: () {
                    _showLogoutDialog(context, ref, isAnonymous);
                  },
                ),
                SettingsItem(
                  icon: Icons.delete_forever,
                  title: 'Borrar mi cuenta',
                  isDestructive: true,
                  onTap: () {
                    _showDeleteAccountDialog(context, ref);
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
            Text(
              'Biblia Chat v1.0.0',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 32),
          ],
        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitial(String? email) {
    if (email == null || email.isEmpty) return 'U';
    return email[0].toUpperCase();
  }

  Widget _buildStatPill(BuildContext context, String emoji, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<SettingsItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.textTertiary,
                ),
          ),
        ),
        ...items.map((item) => _buildSettingsItem(context, item)),
      ],
    );
  }

  Widget _buildSettingsItem(BuildContext context, SettingsItem item) {
    final Color? accentColor = item.isDestructive
        ? AppTheme.errorColor
        : item.isWarning
            ? AppTheme.warningColor
            : item.isHighlighted
                ? AppTheme.primaryColor
                : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: (item.isHighlighted || item.isWarning)
          ? BoxDecoration(
              color: (accentColor ?? AppTheme.primaryColor).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (accentColor ?? AppTheme.primaryColor).withOpacity(0.3),
              ),
            )
          : null,
      child: ListTile(
        leading: Icon(
          item.icon,
          color: accentColor,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: accentColor,
            fontWeight: (item.isHighlighted || item.isWarning) ? FontWeight.w600 : null,
          ),
        ),
        subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: item.onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref, bool isAnonymous) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        // Guardar el contexto del diálogo para que BackButtonInterceptor pueda cerrarlo
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(dialogContextProvider.notifier).state = dialogContext;
        });
        return AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Cerrar sesión',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          isAnonymous
              ? 'ATENCIÓN: Tu cuenta es anónima. Si cierras sesión, perderás TODOS tus datos (conversaciones, racha, progreso).\n\nEsta acción no se puede deshacer.\n\nTe recomendamos vincular un email primero.'
              : '¿Estás seguro de que quieres cerrar sesión?',
          style: TextStyle(
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          if (isAnonymous)
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.push(RouteConstants.linkEmail);
              },
              child: Text(
                'Vincular email',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
            ),
          TextButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
              if (context.mounted) {
                // Navegar a Splash para reiniciar el flujo de auth
                context.go(RouteConstants.splash);
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: isAnonymous ? AppTheme.errorColor : null,
            ),
            child: Text(
              isAnonymous ? 'Cerrar (perder datos)' : 'Cerrar sesión',
            ),
          ),
        ],
      );
      },
    ).then((_) {
      ref.read(dialogContextProvider.notifier).state = null;
    });
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        // Guardar el contexto del diálogo para que BackButtonInterceptor pueda cerrarlo
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(dialogContextProvider.notifier).state = dialogContext;
        });
        return AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Borrar cuenta',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          'Esta acción eliminará permanentemente tu cuenta y todos tus datos. Esta acción no se puede deshacer.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            onPressed: () async {
              Navigator.pop(dialogContext);

              // Mostrar loading
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Borrando cuenta...'),
                    duration: Duration(seconds: 10),
                  ),
                );
              }

              final success = await ref.read(authNotifierProvider.notifier).deleteAccount();

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              if (success) {
                // La sesión se invalida - ir a splash para reiniciar
                context.go(RouteConstants.splash);
              } else {
                final error = ref.read(authNotifierProvider).errorMessage;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error ?? 'Error al borrar cuenta'),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
              }
            },
            child: const Text('Borrar cuenta'),
          ),
        ],
      );
      },
    ).then((_) {
      ref.read(dialogContextProvider.notifier).state = null;
    });
  }
}

class SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isDestructive;
  final bool isHighlighted;
  final bool isWarning;
  final VoidCallback onTap;

  SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.isDestructive = false,
    this.isHighlighted = false,
    this.isWarning = false,
    required this.onTap,
  });
}
