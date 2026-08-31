import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Extension de Tema que define la paleta dinámica de colores de la aplicación
/// cargada directamente desde assets/themes.json.
class AppColors extends ThemeExtension<AppColors> {
  final Color fondo;
  final Color superficie;
  final Color textoPrimario;
  final Color textoSecundario;
  final Color acento;
  final Color gasto;
  final Color ingreso;

  const AppColors({
    required this.fondo,
    required this.superficie,
    required this.textoPrimario,
    required this.textoSecundario,
    required this.acento,
    required this.gasto,
    required this.ingreso,
  });

  /// Fallback de seguridad hardcodeado en caso de fallo de lectura del JSON o asset faltante.
  static const AppColors lemonDarkFallback = AppColors(
    fondo: Color(0xFF0C1821),
    superficie: Color(0xFF1B2A41),
    textoPrimario: Color(0xFFFFFFFF),
    textoSecundario: Color(0xFF94A3B8),
    acento: Color(0xFFFFF3B0),
    gasto: Color(0xFFFF6B6B),
    ingreso: Color(0xFF5C9E6D),
  );

  /// Fallback de seguridad para el tema claro
  static const AppColors lemonLightFallback = AppColors(
    fondo: Color(0xFFF4F5F7),
    superficie: Color(0xFFFFFFFF),
    textoPrimario: Color(0xFF0C1821),
    textoSecundario: Color(0xFF5C6A79),
    acento: Color(0xFFF4D144),
    gasto: Color(0xFFE05656),
    ingreso: Color(0xFF388E3C),
  );

  /// Parsea un mapa JSON a una instancia de AppColors
  factory AppColors.fromJson(Map<String, dynamic> json) {
    return AppColors(
      fondo: _parseHexColor(json['fondo'] as String? ?? '#0C1821'),
      superficie: _parseHexColor(json['superficie'] as String? ?? '#1B2A41'),
      textoPrimario: _parseHexColor(json['textoPrimario'] as String? ?? '#FFFFFF'),
      textoSecundario: _parseHexColor(json['textoSecundario'] as String? ?? '#94A3B8'),
      acento: _parseHexColor(json['acento'] as String? ?? '#FFF3B0'),
      gasto: _parseHexColor(json['gasto'] as String? ?? '#FF6B6B'),
      ingreso: _parseHexColor(json['ingreso'] as String? ?? '#5C9E6D'),
    );
  }

  static Color _parseHexColor(String hexString) {
    final buffer = StringBuffer();
    var cleanHex = hexString.replaceAll('#', '').trim();
    if (cleanHex.length == 6) {
      buffer.write('FF');
      buffer.write(cleanHex);
    } else if (cleanHex.length == 8) {
      buffer.write(cleanHex);
    } else {
      return const Color(0xFF0C1821);
    }
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  ThemeExtension<AppColors> copyWith({
    Color? fondo,
    Color? superficie,
    Color? textoPrimario,
    Color? textoSecundario,
    Color? acento,
    Color? gasto,
    Color? ingreso,
  }) {
    return AppColors(
      fondo: fondo ?? this.fondo,
      superficie: superficie ?? this.superficie,
      textoPrimario: textoPrimario ?? this.textoPrimario,
      textoSecundario: textoSecundario ?? this.textoSecundario,
      acento: acento ?? this.acento,
      gasto: gasto ?? this.gasto,
      ingreso: ingreso ?? this.ingreso,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      fondo: Color.lerp(fondo, other.fondo, t) ?? fondo,
      superficie: Color.lerp(superficie, other.superficie, t) ?? superficie,
      textoPrimario: Color.lerp(textoPrimario, other.textoPrimario, t) ?? textoPrimario,
      textoSecundario: Color.lerp(textoSecundario, other.textoSecundario, t) ?? textoSecundario,
      acento: Color.lerp(acento, other.acento, t) ?? acento,
      gasto: Color.lerp(gasto, other.gasto, t) ?? gasto,
      ingreso: Color.lerp(ingreso, other.ingreso, t) ?? ingreso,
    );
  }
}

/// Gestor y constructor del ThemeData
class AppTheme {
  /// Carga todos los temas declarados en el archivo JSON
  static Future<Map<String, AppColors>> loadThemesFromJson([String assetPath = 'assets/themes.json']) async {
    final jsonStr = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> rawMap = json.decode(jsonStr) as Map<String, dynamic>;
    final result = <String, AppColors>{};
    rawMap.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        result[key] = AppColors.fromJson(value);
      }
    });
    return result;
  }

  /// Carga el tema inicial con fallback seguro
  static Future<AppColors> loadInitialTheme({
    String themeName = 'Lemon Dark',
    String assetPath = 'assets/themes.json',
  }) async {
    try {
      final themes = await loadThemesFromJson(assetPath);
      return themes[themeName] ?? AppColors.lemonDarkFallback;
    } catch (_) {
      return AppColors.lemonDarkFallback;
    }
  }

  /// Construye un ThemeData completo integrando AppColors y la estética Lemon Cash
  static ThemeData buildTheme(AppColors colors) {
    final isDark = colors.fondo.computeLuminance() < 0.5;

    final baseTextTheme = TextTheme(
      displayLarge: TextStyle(
        color: colors.textoPrimario,
        fontSize: 38,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.0,
      ),
      displayMedium: TextStyle(
        color: colors.textoPrimario,
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
      ),
      headlineLarge: TextStyle(
        color: colors.textoPrimario,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        color: colors.textoPrimario,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.4,
      ),
      titleLarge: TextStyle(
        color: colors.textoPrimario,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: colors.textoPrimario,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: colors.textoPrimario,
        fontSize: 15,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: colors.textoSecundario,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: TextStyle(
        color: colors.textoPrimario,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        color: colors.textoSecundario,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );

    final interTextTheme = GoogleFonts.interTextTheme(baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: colors.fondo,
      cardColor: colors.superficie,
      fontFamily: GoogleFonts.inter().fontFamily,
      colorScheme: isDark
          ? ColorScheme.dark(
              surface: colors.superficie,
              primary: colors.acento,
              secondary: colors.acento,
              error: colors.gasto,
              onSurface: colors.textoPrimario,
              onPrimary: colors.fondo,
            )
          : ColorScheme.light(
              surface: colors.superficie,
              primary: colors.acento,
              secondary: colors.acento,
              error: colors.gasto,
              onSurface: colors.textoPrimario,
              onPrimary: colors.fondo,
            ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.fondo,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: colors.textoPrimario),
        titleTextStyle: GoogleFonts.inter(
          color: colors.textoPrimario,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.superficie,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.acento,
        foregroundColor: isDark ? colors.fondo : const Color(0xFF0C1821),
        elevation: 6,
        shape: const CircleBorder(),
      ),
      bottomAppBarTheme: BottomAppBarThemeData(
        color: colors.superficie,
        elevation: 10,
        shape: const CircularNotchedRectangle(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.superficie,
        hintStyle: GoogleFonts.inter(
          color: colors.textoSecundario,
          fontSize: 15,
        ),
        labelStyle: GoogleFonts.inter(
          color: colors.textoSecundario,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colors.acento, width: 1.5),
        ),
      ),
      textTheme: interTextTheme,
      extensions: [colors],
    );
  }
}

/// Extensión para acceder fácilmente a los colores de AppColors desde cualquier BuildContext
/// Garantiza CERO colores hardcodeados en los widgets.
extension BuildContextAppColors on BuildContext {
  AppColors get appColors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.lemonDarkFallback;
}
