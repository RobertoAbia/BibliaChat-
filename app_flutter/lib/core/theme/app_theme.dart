import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ============================================
  // BRAND COLORS - Biblia Chat
  // Paleta: Azul Noche + Dorado
  // Elegante, premium, espiritual
  // ============================================

  // Primary Colors - Dorado Divino
  static const Color primaryColor = Color(0xFFD4AF37); // Dorado principal
  static const Color primaryLight = Color(0xFFE8C967); // Dorado claro
  static const Color primaryDark = Color(0xFFB8963A); // Dorado oscuro

  // Background Colors - Azul Noche (más azulado)
  static const Color backgroundDark = Color(0xFF141A2E); // Fondo principal
  static const Color backgroundDeep = Color(0xFF0F1424); // Fondo más oscuro
  static const Color surfaceDark = Color(0xFF1C2240); // Superficies/cards
  static const Color surfaceLight = Color(0xFF242D4A); // Superficies elevadas

  // Text Colors
  static const Color textPrimary = Color(0xFFFAFAFA); // Texto principal (blanco)
  static const Color textSecondary = Color(0xFFB8B8C8); // Texto secundario
  static const Color textTertiary = Color(0xFF6B6B80); // Texto terciario
  static const Color textOnPrimary = Color(0xFF1A1A2E); // Texto sobre dorado

  // Accent Colors
  static const Color accentBlue = Color(0xFF5B9BD5); // Azul acento
  static const Color accentPurple = Color(0xFF9B7ED9); // Púrpura suave

  // Semantic Colors
  static const Color successColor = Color(0xFF4ADE80); // Verde éxito
  static const Color errorColor = Color(0xFFEF4444); // Rojo error
  static const Color warningColor = Color(0xFFFBBF24); // Amarillo advertencia
  static const Color infoColor = Color(0xFF3B82F6); // Azul info

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF141A2E),
      Color(0xFF0F1424),
    ],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE8C967),
      Color(0xFFD4AF37),
      Color(0xFFB8963A),
    ],
  );

  static const LinearGradient goldButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE8C967),
      Color(0xFFD4AF37),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1C2240),
      Color(0xFF161C35),
    ],
  );

  static const LinearGradient cardGradientWarm = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF202540),
      Color(0xFF1A2035),
    ],
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1C2240),
      Color(0xFF242D4A),
      Color(0xFF1C2240),
    ],
  );

  // ============================================
  // GLASSMORPHISM STYLES
  // ============================================

  /// Blur estándar para glass effect
  static const double glassBlur = 10.0;

  /// Blur más intenso para fondos
  static const double glassBlurHeavy = 20.0;

  /// Opacidad del fondo glass
  static const double glassOpacity = 0.3;

  /// Color de fondo glass (surfaceDark con opacidad)
  static Color get glassBackground => surfaceDark.withOpacity(glassOpacity);

  /// Color de borde glass
  static Color get glassBorder => surfaceLight.withOpacity(0.2);

  /// Color de borde glass dorado
  static Color get glassBorderGold => primaryColor.withOpacity(0.3);

  /// Sombra para efecto glass
  static List<BoxShadow> get glassShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  /// Sombra dorada para selección/hover
  static List<BoxShadow> get glassGoldShadow => [
        BoxShadow(
          color: primaryColor.withOpacity(0.2),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ];

  /// Sombra glow dorada intensa
  static List<BoxShadow> get goldGlow => [
        BoxShadow(
          color: primaryColor.withOpacity(0.4),
          blurRadius: 30,
          spreadRadius: 5,
        ),
      ];

  /// Decoración para container glass estándar
  static BoxDecoration glassDecoration({
    double borderRadius = 20,
    bool showBorder = true,
    bool isSelected = false,
  }) {
    return BoxDecoration(
      color: glassBackground,
      borderRadius: BorderRadius.circular(borderRadius),
      border: showBorder
          ? Border.all(
              color: isSelected ? glassBorderGold : glassBorder,
              width: isSelected ? 1.5 : 1,
            )
          : null,
      boxShadow: isSelected ? glassGoldShadow : null,
    );
  }

  // ============================================
  // DARK THEME (Principal)
  // ============================================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentBlue,
        tertiary: accentPurple,
        surface: surfaceDark,
        error: errorColor,
        onPrimary: textOnPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Elevated Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // Outlined Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        hintStyle: const TextStyle(color: textTertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: surfaceLight.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundDeep,
        selectedItemColor: primaryColor,
        unselectedItemColor: textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: backgroundDeep,
        indicatorColor: primaryColor.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textTertiary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryColor, size: 26);
          }
          return const IconThemeData(color: textTertiary, size: 26);
        }),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: surfaceDark,
        selectedColor: primaryColor.withOpacity(0.2),
        disabledColor: surfaceDark,
        labelStyle: const TextStyle(color: textPrimary),
        secondaryLabelStyle: const TextStyle(color: textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: surfaceDark,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: surfaceLight.withOpacity(0.3),
        thickness: 1,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.3,
          height: 1.25,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          height: 1.3,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textTertiary,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.5,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textTertiary,
          letterSpacing: 0.5,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),

      // ListTile Theme
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return backgroundDark;
          }
          return textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return surfaceLight;
        }),
      ),
    );
  }

  // Alias para compatibilidad
  static ThemeData get lightTheme => darkTheme;
}

// ============================================
// EXTENSION: Acceso fácil a colores del tema
// ============================================
extension AppThemeExtension on BuildContext {
  Color get gold => AppTheme.primaryColor;
  Color get goldLight => AppTheme.primaryLight;
  Color get backgroundNight => AppTheme.backgroundDark;
  Color get surface => AppTheme.surfaceDark;
  Color get textWhite => AppTheme.textPrimary;
  Color get textGray => AppTheme.textSecondary;

  LinearGradient get goldGradient => AppTheme.goldGradient;
  LinearGradient get bgGradient => AppTheme.backgroundGradient;
}
