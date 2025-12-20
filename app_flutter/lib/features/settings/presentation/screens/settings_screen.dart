import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

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
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Text(
                      'U',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
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
                  Text(
                    user?.email ?? 'Cuenta anónima',
                    style: Theme.of(context).textTheme.bodyMedium,
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
                  _buildStat(context, '1', 'Racha'),
                  _buildStat(context, '0', 'Planes'),
                  _buildStat(context, '10', 'Puntos'),
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
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.lock_outline,
                  title: 'Guardar mi cuenta',
                  subtitle: 'Vincular email para no perder datos',
                  onTap: () {},
                ),
              ],
            ),

            _buildSection(
              context,
              title: 'Preferencias',
              items: [
                SettingsItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notificaciones',
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.book_outlined,
                  title: 'Versión de la Biblia',
                  subtitle: 'RVR1960',
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Tema',
                  subtitle: 'Automático',
                  onTap: () {},
                ),
              ],
            ),

            _buildSection(
              context,
              title: 'Privacidad',
              items: [
                SettingsItem(
                  icon: Icons.psychology_outlined,
                  title: 'Memoria de la IA',
                  subtitle: 'Controla qué recuerda la app',
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.delete_outline,
                  title: 'Borrar memoria de la IA',
                  onTap: () {},
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
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.share_outlined,
                  title: 'Compartir con un amigo',
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.help_outline,
                  title: 'Centro de ayuda',
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.description_outlined,
                  title: 'Términos de uso',
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Política de privacidad',
                  onTap: () {},
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
                    _showLogoutDialog(context);
                  },
                ),
                SettingsItem(
                  icon: Icons.delete_forever,
                  title: 'Borrar mi cuenta',
                  isDestructive: true,
                  onTap: () {
                    _showDeleteAccountDialog(context);
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

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
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
                  color: Colors.grey[600],
                ),
          ),
        ),
        ...items.map((item) => ListTile(
              leading: Icon(
                item.icon,
                color: item.isDestructive ? Colors.red : null,
              ),
              title: Text(
                item.title,
                style: TextStyle(
                  color: item.isDestructive ? Colors.red : null,
                ),
              ),
              subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
              trailing: const Icon(Icons.chevron_right),
              onTap: item.onTap,
            )),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Borrar cuenta'),
        content: const Text(
          'Esta acción eliminará permanentemente tu cuenta y todos tus datos. Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              // Implement delete account
              Navigator.pop(context);
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
  final VoidCallback onTap;

  SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.isDestructive = false,
    required this.onTap,
  });
}
