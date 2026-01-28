import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/daily_progress_provider.dart';
import '../../../study/presentation/providers/study_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAnonymous = ref.watch(isAnonymousProvider);
    final email = ref.watch(currentEmailProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: SingleChildScrollView(
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
                      _getInitial(email),
                      style: const TextStyle(
                        fontSize: 32,
                        color: AppTheme.textOnPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Usuario',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isAnonymous)
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
                          child: const Text(
                            'Sin guardar',
                            style: TextStyle(
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

            // Stats
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat(context, ref.watch(streakDaysDisplayProvider).toString(), 'Racha'),
                  _buildStat(context, ref.watch(allUserPlansProvider).whenOrNull(
                    data: (plans) => plans.where((p) => p.isCompleted).length,
                  )?.toString() ?? '0', 'Planes\nCompletados'),
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
                SettingsItem(
                  icon: Icons.person_outline,
                  title: 'Editar Perfil',
                  onTap: () => context.push(RouteConstants.profileEdit),
                ),
                // Solo mostrar "Guardar mi cuenta" si es anónimo
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
                // Mostrar email vinculado si no es anónimo
                if (!isAnonymous)
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
                  onTap: () async {
                    final InAppReview inAppReview = InAppReview.instance;
                    if (await inAppReview.isAvailable()) {
                      inAppReview.requestReview();
                    } else {
                      // Fallback: abrir store directamente
                      inAppReview.openStoreListing(
                        appStoreId: '6740001949', // App Store ID
                      );
                    }
                  },
                ),
                SettingsItem(
                  icon: Icons.share_outlined,
                  title: 'Compartir con un amigo',
                  onTap: () {
                    Share.share(
                      '¡Descubre Biblia Chat! La app cristiana que entiende tu fe, tu idioma y tu cultura. 🙏\n\n'
                      'Descárgala gratis:\n'
                      'iOS: https://apps.apple.com/app/biblia-chat/id6740001949\n'
                      'Android: https://play.google.com/store/apps/details?id=ee.bikain.bibliachat',
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
    );
  }

  String _getInitial(String? email) {
    if (email == null || email.isEmpty) return 'U';
    return email[0].toUpperCase();
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppTheme.primaryColor,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: item.isHighlighted
          ? BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
              ),
            )
          : null,
      child: ListTile(
        leading: Icon(
          item.icon,
          color: item.isDestructive
              ? AppTheme.errorColor
              : item.isHighlighted
                  ? AppTheme.primaryColor
                  : null,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: item.isDestructive
                ? AppTheme.errorColor
                : item.isHighlighted
                    ? AppTheme.primaryColor
                    : null,
            fontWeight: item.isHighlighted ? FontWeight.w600 : null,
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
      builder: (dialogContext) => AlertDialog(
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
                // FIX: Navegar a Splash después de logout
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
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
                // La sesión se invalida automáticamente
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
      ),
    );
  }
}

class SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isDestructive;
  final bool isHighlighted;
  final VoidCallback onTap;

  SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.isDestructive = false,
    this.isHighlighted = false,
    required this.onTap,
  });
}
