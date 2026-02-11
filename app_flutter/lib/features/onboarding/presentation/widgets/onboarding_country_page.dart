import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';

/// País hispanohablante con su bandera y grupo de origen
class HispanicCountry {
  final String code;
  final String name;
  final String flag;
  final String originGroup; // Mapeo a origin_group de la BD

  const HispanicCountry({
    required this.code,
    required this.name,
    required this.flag,
    required this.originGroup,
  });
}

/// Lista de países hispanohablantes
const hispanicCountries = [
  // México y Centroamérica
  HispanicCountry(code: 'MX', name: 'México', flag: '🇲🇽', originGroup: 'mexico_centroamerica'),
  HispanicCountry(code: 'GT', name: 'Guatemala', flag: '🇬🇹', originGroup: 'mexico_centroamerica'),
  HispanicCountry(code: 'HN', name: 'Honduras', flag: '🇭🇳', originGroup: 'mexico_centroamerica'),
  HispanicCountry(code: 'SV', name: 'El Salvador', flag: '🇸🇻', originGroup: 'mexico_centroamerica'),
  HispanicCountry(code: 'NI', name: 'Nicaragua', flag: '🇳🇮', originGroup: 'mexico_centroamerica'),
  HispanicCountry(code: 'CR', name: 'Costa Rica', flag: '🇨🇷', originGroup: 'mexico_centroamerica'),
  HispanicCountry(code: 'PA', name: 'Panamá', flag: '🇵🇦', originGroup: 'mexico_centroamerica'),

  // Caribe
  HispanicCountry(code: 'CU', name: 'Cuba', flag: '🇨🇺', originGroup: 'caribe'),
  HispanicCountry(code: 'DO', name: 'República Dominicana', flag: '🇩🇴', originGroup: 'caribe'),
  HispanicCountry(code: 'PR', name: 'Puerto Rico', flag: '🇵🇷', originGroup: 'caribe'),

  // Sudamérica
  HispanicCountry(code: 'CO', name: 'Colombia', flag: '🇨🇴', originGroup: 'sudamerica'),
  HispanicCountry(code: 'VE', name: 'Venezuela', flag: '🇻🇪', originGroup: 'sudamerica'),
  HispanicCountry(code: 'EC', name: 'Ecuador', flag: '🇪🇨', originGroup: 'sudamerica'),
  HispanicCountry(code: 'PE', name: 'Perú', flag: '🇵🇪', originGroup: 'sudamerica'),
  HispanicCountry(code: 'BO', name: 'Bolivia', flag: '🇧🇴', originGroup: 'sudamerica'),
  HispanicCountry(code: 'CL', name: 'Chile', flag: '🇨🇱', originGroup: 'sudamerica'),
  HispanicCountry(code: 'AR', name: 'Argentina', flag: '🇦🇷', originGroup: 'sudamerica'),
  HispanicCountry(code: 'UY', name: 'Uruguay', flag: '🇺🇾', originGroup: 'sudamerica'),
  HispanicCountry(code: 'PY', name: 'Paraguay', flag: '🇵🇾', originGroup: 'sudamerica'),

  // España
  HispanicCountry(code: 'ES', name: 'España', flag: '🇪🇸', originGroup: 'espana'),

  // USA Hispano
  HispanicCountry(code: 'US', name: 'Estados Unidos', flag: '🇺🇸', originGroup: 'usa_hispano'),
];

class OnboardingCountryPage extends StatefulWidget {
  final String? selectedCountryCode;
  final ValueChanged<String> onSelect; // Devuelve el originGroup
  final ValueChanged<String>? onCountryCodeSelect; // Devuelve el código de país
  final VoidCallback? onNext;

  const OnboardingCountryPage({
    super.key,
    this.selectedCountryCode,
    required this.onSelect,
    this.onCountryCodeSelect,
    this.onNext,
  });

  @override
  State<OnboardingCountryPage> createState() => _OnboardingCountryPageState();
}

class _OnboardingCountryPageState extends State<OnboardingCountryPage> {
  String? _selectedCode;

  @override
  void initState() {
    super.initState();
    _selectedCode = widget.selectedCountryCode;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Verse reference badge with glass effect
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
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      color: AppTheme.primaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Salmo 139:7-10',
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

          // Bible verse (decorative, subtle)
          Text(
            '¿A dónde me iré de tu Espíritu? Dondequiera que esté, allí estás tú.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textTertiary,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
          ),

          const SizedBox(height: 24),

          // Question with glass effect
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
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    '¿De qué país eres?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Dropdown
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: DropdownButtonFormField<String>(
                      value: _selectedCode,
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
                          setState(() => _selectedCode = code);

                          // Encontrar el país y devolver el originGroup
                          final country = hispanicCountries.firstWhere(
                            (c) => c.code == code,
                          );
                          widget.onSelect(country.originGroup);
                          widget.onCountryCodeSelect?.call(code);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Mostrar país seleccionado
                  if (_selectedCode != null)
                    _buildSelectedCountry(),
                ],
              ),
            ),
          ),

          // Fixed bottom button with gradient fade
          Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.backgroundDark.withOpacity(0),
                    AppTheme.backgroundDark,
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                    onPressed: _selectedCode != null ? widget.onNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedCode != null ? AppTheme.primaryColor : AppTheme.surfaceDark,
                      foregroundColor: _selectedCode != null ? AppTheme.textOnPrimary : AppTheme.textTertiary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      minimumSize: Size.zero,
                      elevation: _selectedCode != null ? 8 : 0,
                      shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Continuar',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_selectedCode != null) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 20),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedCountry() {
    final country = hispanicCountries.firstWhere(
      (c) => c.code == _selectedCode,
    );

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            country.flag,
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                country.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                'Personalizaremos tu experiencia',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
