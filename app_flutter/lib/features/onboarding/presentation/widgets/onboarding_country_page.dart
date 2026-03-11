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

/// Lista de países hispanohablantes ordenada por población hispana en EE.UU.
/// Fuente: Pew Research Center / U.S. Census Bureau (2023)
const hispanicCountries = [
  HispanicCountry(code: 'MX', name: 'México', flag: '🇲🇽', originGroup: 'mexico_centroamerica'),       // ~37M
  HispanicCountry(code: 'PR', name: 'Puerto Rico', flag: '🇵🇷', originGroup: 'caribe'),                 // ~5.9M
  HispanicCountry(code: 'US', name: 'Estados Unidos', flag: '🇺🇸', originGroup: 'usa_hispano'),         // ~4.5M (hispanos nacidos en EEUU sin origen específico)
  HispanicCountry(code: 'SV', name: 'El Salvador', flag: '🇸🇻', originGroup: 'mexico_centroamerica'),   // ~2.5M
  HispanicCountry(code: 'CU', name: 'Cuba', flag: '🇨🇺', originGroup: 'caribe'),                       // ~2.5M
  HispanicCountry(code: 'DO', name: 'República Dominicana', flag: '🇩🇴', originGroup: 'caribe'),        // ~2.4M
  HispanicCountry(code: 'GT', name: 'Guatemala', flag: '🇬🇹', originGroup: 'mexico_centroamerica'),     // ~1.8M
  HispanicCountry(code: 'CO', name: 'Colombia', flag: '🇨🇴', originGroup: 'sudamerica'),                // ~1.4M
  HispanicCountry(code: 'HN', name: 'Honduras', flag: '🇭🇳', originGroup: 'mexico_centroamerica'),      // ~1.1M
  HispanicCountry(code: 'EC', name: 'Ecuador', flag: '🇪🇨', originGroup: 'sudamerica'),                 // ~800K
  HispanicCountry(code: 'PE', name: 'Perú', flag: '🇵🇪', originGroup: 'sudamerica'),                    // ~700K
  HispanicCountry(code: 'VE', name: 'Venezuela', flag: '🇻🇪', originGroup: 'sudamerica'),               // ~640K
  HispanicCountry(code: 'NI', name: 'Nicaragua', flag: '🇳🇮', originGroup: 'mexico_centroamerica'),     // ~460K
  HispanicCountry(code: 'AR', name: 'Argentina', flag: '🇦🇷', originGroup: 'sudamerica'),               // ~300K
  HispanicCountry(code: 'PA', name: 'Panamá', flag: '🇵🇦', originGroup: 'mexico_centroamerica'),        // ~210K
  HispanicCountry(code: 'ES', name: 'España', flag: '🇪🇸', originGroup: 'espana'),                      // ~170K
  HispanicCountry(code: 'CR', name: 'Costa Rica', flag: '🇨🇷', originGroup: 'mexico_centroamerica'),    // ~160K
  HispanicCountry(code: 'CL', name: 'Chile', flag: '🇨🇱', originGroup: 'sudamerica'),                   // ~150K
  HispanicCountry(code: 'BO', name: 'Bolivia', flag: '🇧🇴', originGroup: 'sudamerica'),                 // ~120K
  HispanicCountry(code: 'UY', name: 'Uruguay', flag: '🇺🇾', originGroup: 'sudamerica'),                 // ~65K
  HispanicCountry(code: 'PY', name: 'Paraguay', flag: '🇵🇾', originGroup: 'sudamerica'),                // ~25K
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

          // Question (main heading — clean, bold)
          Text(
            '¿De qué país eres?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
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

                  // Bible verse (subtle decorative quote)
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      '«¿A dónde me iré de tu Espíritu? Dondequiera que esté, allí estás tú.» — Salmo 139:7-10',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textTertiary,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Fixed bottom button
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
            child: SafeArea(
              top: false,
              child: Opacity(
                opacity: _selectedCode != null ? 1.0 : 0.4,
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
                      onPressed: _selectedCode != null ? widget.onNext : null,
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
