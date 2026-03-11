import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Screen that guides users to add the Bible verse widget
/// to their Lock Screen (iOS) or Home Screen (Android).
class WidgetSetupScreen extends StatelessWidget {
  const WidgetSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Widget de versículos',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero preview
                      _buildWidgetPreview(context),
                      const SizedBox(height: 28),

                      // Description
                      Text(
                        'Recibe un versículo inspirador cada hora directamente en tu ${isIOS ? 'pantalla de bloqueo' : 'pantalla de inicio'}.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondary,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 32),

                      // Steps title
                      Text(
                        'Cómo añadirlo',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Steps
                      if (isIOS) ..._buildIOSSteps(context) else ..._buildAndroidSteps(context),

                      const SizedBox(height: 32),

                      // Tip
                      _buildTip(context, isIOS),
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

  Widget _buildWidgetPreview(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Mock widget
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_stories_rounded,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Biblia Chat',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '"El Señor es mi pastor; nada me falta."',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Salmos 23:1',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Así se verá en tu pantalla',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildIOSSteps(BuildContext context) {
    return [
      _buildStep(
        context,
        number: 1,
        icon: Icons.touch_app_rounded,
        title: 'Mantén pulsada la pantalla de bloqueo',
        subtitle: 'Hasta que aparezca la opción "Personalizar"',
      ),
      _buildStep(
        context,
        number: 2,
        icon: Icons.tune_rounded,
        title: 'Toca "Personalizar"',
        subtitle: 'Selecciona la pantalla de bloqueo (izquierda)',
      ),
      _buildStep(
        context,
        number: 3,
        icon: Icons.add_box_outlined,
        title: 'Toca el área de widgets',
        subtitle: 'Justo debajo de la hora',
      ),
      _buildStep(
        context,
        number: 4,
        icon: Icons.search_rounded,
        title: 'Busca "Biblia Chat"',
        subtitle: 'Desplázate o usa el buscador',
      ),
      _buildStep(
        context,
        number: 5,
        icon: Icons.check_circle_outline,
        title: 'Selecciona el widget de versículos',
        subtitle: 'Cambia cada hora automáticamente',
      ),
      _buildStep(
        context,
        number: 6,
        icon: Icons.done_all_rounded,
        title: 'Toca "OK" arriba a la derecha',
        subtitle: '¡Listo! Ya verás versículos en tu pantalla',
        isLast: true,
      ),
    ];
  }

  List<Widget> _buildAndroidSteps(BuildContext context) {
    return [
      _buildStep(
        context,
        number: 1,
        icon: Icons.touch_app_rounded,
        title: 'Mantén pulsada la pantalla de inicio',
        subtitle: 'En un espacio vacío, sin tocar apps',
      ),
      _buildStep(
        context,
        number: 2,
        icon: Icons.widgets_outlined,
        title: 'Toca "Widgets"',
        subtitle: 'Aparecerá en el menú inferior',
      ),
      _buildStep(
        context,
        number: 3,
        icon: Icons.search_rounded,
        title: 'Busca "Biblia Chat"',
        subtitle: 'Desplázate o usa el buscador',
      ),
      _buildStep(
        context,
        number: 4,
        icon: Icons.open_with_rounded,
        title: 'Arrastra el widget a tu pantalla',
        subtitle: 'Mantenlo pulsado y suéltalo donde quieras',
      ),
      _buildStep(
        context,
        number: 5,
        icon: Icons.done_all_rounded,
        title: '¡Listo!',
        subtitle: 'El versículo cambia cada hora automáticamente',
        isLast: true,
      ),
    ];
  }

  Widget _buildStep(
    BuildContext context, {
    required int number,
    required IconData icon,
    required String title,
    required String subtitle,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number + line
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 18, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.only(left: 26),
                    child: Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(BuildContext context, bool isIOS) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 20,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isIOS
                  ? 'También puedes añadir el widget en tu pantalla de inicio. Mantén pulsado un espacio vacío y toca el "+" arriba a la izquierda.'
                  : 'Puedes redimensionar el widget manteniendo pulsado y arrastrando los bordes.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
