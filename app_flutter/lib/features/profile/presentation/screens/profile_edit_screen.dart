import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../onboarding/presentation/widgets/onboarding_country_page.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/profile_edit_provider.dart';
import '../providers/user_profile_provider.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  bool _initialized = false;
  final _nameController = TextEditingController();
  String? _selectedCountryCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final profile = await ref.read(currentUserProfileProvider.future);
    if (profile != null && mounted) {
      ref.read(profileEditProvider.notifier).loadProfile(profile);
      _nameController.text = profile.name ?? '';
      // Usar countryCode guardado si existe, sino buscar por origin group
      if (profile.countryCode != null) {
        _selectedCountryCode = profile.countryCode;
      } else if (profile.origin != null) {
        final country = hispanicCountries.firstWhere(
          (c) => c.originGroup == profile.origin!.dbValue,
          orElse: () => hispanicCountries.first,
        );
        _selectedCountryCode = country.code;
      }
      setState(() => _initialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editState = ref.watch(profileEditProvider);
    final notifier = ref.read(profileEditProvider.notifier);

    // Escuchar cambios de guardado
    ref.listen<ProfileEditState>(profileEditProvider, (prev, next) {
      if (next.isSaved) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Cambios guardados'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        notifier.resetSavedFlag();
        ref.invalidate(currentUserProfileProvider);
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (notifier.hasChanges) {
              _showDiscardDialog();
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: !_initialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sección: Datos Personales
                      _buildSectionHeader('Datos Personales'),
                      _buildNameField(editState, notifier),
                      _buildGenderSection(editState, notifier),

                      // Sección: Fe y Creencias
                      _buildSectionHeader('Fe y Creencias'),
                      _buildDenominationSection(editState, notifier),

                      // Sección: Origen
                      _buildSectionHeader('Origen'),
                      _buildOriginSection(editState, notifier),
                      _buildAgeGroupSection(editState, notifier),

                      // Sección: Recordatorio
                      _buildSectionHeader('Recordatorio'),
                      _buildReminderSection(editState, notifier),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                // Loading overlay
                if (editState.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
      bottomNavigationBar: _initialized
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: notifier.hasChanges && !editState.isLoading
                      ? () => notifier.saveChanges()
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: AppTheme.textOnPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    editState.isLoading ? 'Guardando...' : 'Guardar cambios',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildNameField(ProfileEditState state, ProfileEditNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: 'Nombre',
          hintText: 'Tu nombre',
          prefixIcon: const Icon(Icons.person_outline),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: AppTheme.surfaceDark,
        ),
        onChanged: notifier.updateName,
      ),
    );
  }

  Widget _buildGenderSection(
      ProfileEditState state, ProfileEditNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: GenderType.values.map((g) {
          final isSelected = state.gender == g;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => notifier.updateGender(g),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryColor.withOpacity(0.2)
                        : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.surfaceLight.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        g == GenderType.male ? Icons.male : Icons.female,
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.textTertiary,
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        g.displayName,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : AppTheme.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDenominationSection(
      ProfileEditState state, ProfileEditNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: Denomination.values.map((d) {
          final isSelected = state.denomination == d;
          return ChoiceChip(
            label: Text(d.displayName),
            selected: isSelected,
            onSelected: (_) => notifier.updateDenomination(d),
            selectedColor: AppTheme.primaryColor.withOpacity(0.3),
            backgroundColor: AppTheme.surfaceDark,
            labelStyle: TextStyle(
              color:
                  isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            side: BorderSide(
              color: isSelected
                  ? AppTheme.primaryColor
                  : AppTheme.surfaceLight.withOpacity(0.3),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOriginSection(
      ProfileEditState state, ProfileEditNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: DropdownButtonFormField<String>(
          value: _selectedCountryCode,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            hintText: 'Selecciona tu país',
            hintStyle: TextStyle(
              color: AppTheme.textSecondary.withOpacity(0.7),
            ),
          ),
          dropdownColor: AppTheme.surfaceDark,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppTheme.primaryColor,
          ),
          isExpanded: true,
          menuMaxHeight: 300,
          items: hispanicCountries.map((country) {
            return DropdownMenuItem<String>(
              value: country.code,
              child: Row(
                children: [
                  Text(
                    country.flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(country.name),
                ],
              ),
            );
          }).toList(),
          onChanged: (code) {
            if (code != null) {
              setState(() => _selectedCountryCode = code);
              // Encontrar el país y actualizar el originGroup y countryCode
              final country = hispanicCountries.firstWhere(
                (c) => c.code == code,
              );
              final originGroup = OriginGroup.fromString(country.originGroup);
              if (originGroup != null) {
                notifier.updateOrigin(originGroup);
              }
              notifier.updateCountryCode(code);
            }
          },
        ),
      ),
    );
  }

  Widget _buildAgeGroupSection(
      ProfileEditState state, ProfileEditNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: AgeGroup.values.map((a) {
          final isSelected = state.ageGroup == a;
          return ChoiceChip(
            label: Text(a.displayName),
            selected: isSelected,
            onSelected: (_) => notifier.updateAgeGroup(a),
            selectedColor: AppTheme.primaryColor.withOpacity(0.3),
            backgroundColor: AppTheme.surfaceDark,
            labelStyle: TextStyle(
              color:
                  isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            side: BorderSide(
              color: isSelected
                  ? AppTheme.primaryColor
                  : AppTheme.surfaceLight.withOpacity(0.3),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReminderSection(
      ProfileEditState state, ProfileEditNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Toggle
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            title: Text(
              'Recordatorio diario',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
            subtitle: Text(
              'Recibe una notificación cada día',
              style: TextStyle(color: AppTheme.textTertiary, fontSize: 12),
            ),
            value: state.reminderEnabled,
            onChanged: notifier.updateReminderEnabled,
            activeColor: AppTheme.primaryColor,
          ),
          // Time picker (solo si está activo)
          if (state.reminderEnabled)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: Icon(Icons.access_time, color: AppTheme.primaryColor),
              title: Text(
                'Hora del recordatorio',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
              trailing: Text(
                state.reminderTime != null
                    ? _formatTime(state.reminderTime!)
                    : '08:00',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: state.reminderTime != null
                      ? TimeOfDay.fromDateTime(state.reminderTime!)
                      : const TimeOfDay(hour: 8, minute: 0),
                );
                if (time != null) {
                  final now = DateTime.now();
                  notifier.updateReminderTime(DateTime(
                    now.year,
                    now.month,
                    now.day,
                    time.hour,
                    time.minute,
                  ));
                }
              },
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showDiscardDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Descartar cambios',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          'Tienes cambios sin guardar. ¿Quieres descartarlos?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );
  }
}
