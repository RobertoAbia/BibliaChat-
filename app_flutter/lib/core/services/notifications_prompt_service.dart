import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';
import 'notification_service.dart';

/// Muestra el priming de notificaciones (diálogo propio + prompt nativo) una
/// sola vez. Se llama tras pagar (PurchaseSuccessScreen) y al entrar a Home por
/// primera vez, de modo que tanto pagadores como usuarios free reciban el ask
/// — pero nunca antes del paywall (eso generaba fricción).
class NotificationsPromptService {
  static const _kShownKey = 'notifications_prompt_shown';
  static bool _shownThisSession = false;

  /// Muestra el diálogo de priming si no se ha mostrado antes. Si el usuario
  /// acepta, lanza el prompt nativo del sistema. No-op en web.
  static Future<void> showIfNotShown(BuildContext context) async {
    if (kIsWeb || _shownThisSession) return;

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kShownKey) ?? false) return;

    // Si el usuario ya decidió antes (concedió o denegó), no tiene sentido
    // el priming: marcamos como mostrado y salimos.
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.notDetermined) {
      await prefs.setBool(_kShownKey, true);
      _shownThisSession = true;
      return;
    }

    _shownThisSession = true;
    await prefs.setBool(_kShownKey, true);

    if (!context.mounted) return;
    final accepted = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const _NotificationsPrimingDialog(),
        ) ??
        false;

    if (accepted) {
      await NotificationService().requestPermissionIfNeeded();
    }
  }
}

class _NotificationsPrimingDialog extends StatelessWidget {
  const _NotificationsPrimingDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: const Color(0xFFD0D8E4).withOpacity(0.3)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No te pierdas tu momento de paz',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Activa las notificaciones para recibir tu recordatorio diario, mantener tu racha y no perderte tu momento de oración.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                  minimumSize: Size.zero,
                ),
                child: const Text(
                  'Activar notificaciones',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Ahora no',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
