import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';

class OnboardingReminderPage extends StatefulWidget {
  final bool reminderEnabled;
  final TimeOfDay reminderTime;
  final ValueChanged<bool> onToggle;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final VoidCallback onNext;

  const OnboardingReminderPage({
    super.key,
    required this.reminderEnabled,
    required this.reminderTime,
    required this.onToggle,
    required this.onTimeChanged,
    required this.onNext,
  });

  @override
  State<OnboardingReminderPage> createState() => _OnboardingReminderPageState();
}

class _OnboardingReminderPageState extends State<OnboardingReminderPage> {
  Future<void> _handleToggle(bool value) async {
    if (value) {
      // Al activar, pedir permiso de notificaciones
      final granted = await NotificationService().requestPermission();
      if (granted) {
        widget.onToggle(true);
      }
      // Si deniega, no activar el toggle
    } else {
      widget.onToggle(false);
    }
  }

  void _showHourPicker() {
    final initialIndex = widget.reminderTime.hour;
    int selectedHour = initialIndex;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: const Color(0xFFD0D8E4).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text('Cancelar', style: TextStyle(color: AppTheme.textSecondary)),
                  ),
                  Text(
                    'Hora del recordatorio',
                    style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.onTimeChanged(TimeOfDay(hour: selectedHour, minute: 0));
                      Navigator.pop(ctx);
                    },
                    child: Text('OK', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFD0D8E4)),
            // Hour wheel
            Expanded(
              child: Stack(
                children: [
                  // Selection indicator lines
                  Center(
                    child: Container(
                      height: 48,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Wheel
                  ListWheelScrollView.useDelegate(
                    controller: FixedExtentScrollController(initialItem: initialIndex),
                    itemExtent: 48,
                    physics: const FixedExtentScrollPhysics(),
                    diameterRatio: 1.5,
                    magnification: 1.2,
                    useMagnifier: true,
                    onSelectedItemChanged: (index) => selectedHour = index,
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 24,
                      builder: (context, index) {
                        return Center(
                          child: Text(
                            _formatHour(index),
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12:00 AM';
    if (hour < 12) return '$hour:00 AM';
    if (hour == 12) return '12:00 PM';
    return '${hour - 12}:00 PM';
  }

  String _formatTime(TimeOfDay time) {
    return _formatHour(time.hour);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Icon badge
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.notifications_active_outlined,
                            color: AppTheme.primaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Recordatorios',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                Text(
                  '¿Quieres un recordatorio diario?',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppTheme.textPrimary,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                      ),
                ),

                const SizedBox(height: 24),

                // Subtitle with glass effect
                GlassContainer(
                  blur: 8,
                  backgroundOpacity: 0.35,
                  borderRadius: 14,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: AppTheme.goldGradient,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Te enviaremos una notificación para recordarte tu momento de oración y reflexión.',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Toggle card
                GestureDetector(
                  onTap: () => _handleToggle(!widget.reminderEnabled),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: widget.reminderEnabled
                              ? LinearGradient(
                                  colors: [
                                    AppTheme.primaryColor.withOpacity(0.2),
                                    AppTheme.primaryColor.withOpacity(0.08),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: widget.reminderEnabled
                              ? null
                              : AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: widget.reminderEnabled
                                ? AppTheme.primaryColor.withOpacity(0.6)
                                : const Color(0xFFD0D8E4),
                            width: widget.reminderEnabled ? 1.5 : 1,
                          ),
                          boxShadow: widget.reminderEnabled
                              ? [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.25),
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            // Icon
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: widget.reminderEnabled
                                    ? AppTheme.goldGradient
                                    : null,
                                color: widget.reminderEnabled
                                    ? null
                                    : AppTheme.surfaceLight.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                widget.reminderEnabled
                                    ? Icons.notifications_active
                                    : Icons.notifications_off_outlined,
                                color: widget.reminderEnabled
                                    ? AppTheme.textOnPrimary
                                    : AppTheme.textSecondary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.reminderEnabled
                                        ? 'Recordatorio activado'
                                        : 'Recordatorio desactivado',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppTheme.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.reminderEnabled
                                        ? 'Recibirás una notificación diaria'
                                        : 'No recibirás notificaciones',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppTheme.textTertiary,
                                        ),
                                  ),
                                ],
                              ),
                            ),

                            // Toggle switch
                            Switch(
                              value: widget.reminderEnabled,
                              onChanged: _handleToggle,
                              activeColor: AppTheme.primaryColor,
                              activeTrackColor:
                                  AppTheme.primaryColor.withOpacity(0.3),
                              inactiveThumbColor: AppTheme.textSecondary,
                              inactiveTrackColor:
                                  const Color(0xFFD0D8E4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Time picker (only shown when enabled)
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  child: widget.reminderEnabled
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onTap: _showHourPicker,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                          const Color(0xFFD0D8E4),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: AppTheme.surfaceLight
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Icon(
                                          Icons.access_time,
                                          color: AppTheme.primaryColor,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Hora del recordatorio',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: AppTheme.textSecondary,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _formatTime(widget.reminderTime),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    color: AppTheme.textPrimary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.edit_outlined,
                                        color: AppTheme.primaryColor,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                const SizedBox(height: 24),

                // Info text
                Center(
                  child: Text(
                    'Puedes cambiar esto en Ajustes',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // Fixed bottom button (always enabled - optional step)
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: widget.onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.chevron_right, size: 22, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
