import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/database.dart';

/// Extension de Tema que define la paleta dinámica de colores de la aplicación.
/// A partir de Kip v1.2, los colores se cargan desde la tabla AppThemes en Drift.
/// El color [gasto] ya no es estático: se calcula matemáticamente a partir de
/// la luminosidad de [superficie] usando HSLColor para garantizar contraste.
class AppColors extends ThemeExtension<AppColors> {
  final Color fondo;
  final Color superficie;
  final Color textoPrimario;
  final Color textoSecundario;
  final Color acento;
  final Color ingreso;
  final Color? _gastoOverride;

  const AppColors({
    required this.fondo,
    required this.superficie,
    required this.textoPrimario,
    required this.textoSecundario,
    required this.acento,
    required this.ingreso,
    Color? gasto,
  }) : _gastoOverride = gasto;

  // ─── Color Dinámico de Gasto ──────────────────────────────────────────────

  /// Calcula un rojo armónico con contraste garantizado basado en la luminosidad
  /// del color de superficie del tema activo.
  ///
  /// Algoritmo:
  /// - Matiz fijo: 4° (rojo ligeramente cálido, evita el rojo puro que cansa la vista)
  /// - Saturación: 85% (vivido pero no agresivo)
  /// - Luminosidad: dinámica según la luminancia percibida de [superficie]:
  ///     · Superficies oscuras (luminance < 0.18): L = 62% → rojo brillante legible
  ///     · Superficies claras: L = 46% → rojo más profundo para contrastar con el blanco
  Color get gastoColor {
    final lum = superficie.computeLuminance();
    final lightness = lum < 0.18 ? 0.62 : 0.46;
    return HSLColor.fromAHSL(1.0, 4.0, 0.85, lightness).toColor();
  }

  /// Alias de retrocompatibilidad. Si no se especificó un gasto fijo,
  /// retorna el color calculado dinámicamente con contraste garantizado.
  Color get gasto => _gastoOverride ?? gastoColor;

  // ─── Fallbacks de Seguridad ───────────────────────────────────────────────

  static const AppColors lemonDarkFallback = AppColors(
    fondo: Color(0xFF0C1821),
    superficie: Color(0xFF1B2A41),
    textoPrimario: Color(0xFFFFFFFF),
    textoSecundario: Color(0xFF94A3B8),
    acento: Color(0xFFFFF3B0),
    ingreso: Color(0xFF5C9E6D),
  );

  static const AppColors lemonLightFallback = AppColors(
    fondo: Color(0xFFF4F5F7),
    superficie: Color(0xFFFFFFFF),
    textoPrimario: Color(0xFF0C1821),
    textoSecundario: Color(0xFF5C6A79),
    acento: Color(0xFFF4D144),
    ingreso: Color(0xFF388E3C),
  );

  // ─── Factories ────────────────────────────────────────────────────────────

  /// Parsea un mapa JSON a una instancia de AppColors (mantenido para fallback en main.dart).
  factory AppColors.fromJson(Map<String, dynamic> json) {
    return AppColors(
      fondo: parseHexColor(json['fondo'] as String? ?? '#0C1821'),
      superficie: parseHexColor(json['superficie'] as String? ?? '#1B2A41'),
      textoPrimario: parseHexColor(json['textoPrimario'] as String? ?? '#FFFFFF'),
      textoSecundario: parseHexColor(json['textoSecundario'] as String? ?? '#94A3B8'),
      acento: parseHexColor(json['acento'] as String? ?? '#FFF3B0'),
      ingreso: parseHexColor(json['ingreso'] as String? ?? '#5C9E6D'),
      gasto: json.containsKey('gasto') ? parseHexColor(json['gasto'] as String) : null,
    );
  }

  /// Construye AppColors a partir de un registro de la tabla AppThemes de Drift.
  factory AppColors.fromDbTheme(AppThemeEntry entry) {
    return AppColors(
      fondo: parseHexColor(entry.backgroundHex),
      superficie: parseHexColor(entry.surfaceHex),
      textoPrimario: parseHexColor(entry.textHex),
      // textoSecundario: calculado como una versión desaturada/opacada del textoPrimario
      textoSecundario: parseHexColor(entry.textHex).withValues(alpha: 0.6),
      acento: parseHexColor(entry.accentHex),
      ingreso: _deriveIngresoColor(parseHexColor(entry.accentHex)),
    );
  }

  /// Deriva un color de ingreso a partir del acento del tema.
  /// Se desplaza el matiz 120° (hacia verde) manteniendo la luminosidad del tema.
  static Color _deriveIngresoColor(Color acento) {
    final hsl = HSLColor.fromColor(acento);
    final newHue = (hsl.hue + 120) % 360;
    return hsl.withHue(newHue).withSaturation(0.6).toColor();
  }

  /// Convierte un string HEX en objeto Color de Flutter.
  static Color parseHexColor(String hexString) {
    final buffer = StringBuffer();
    final cleanHex = hexString.replaceAll('#', '').trim();
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

  // ─── ThemeExtension ───────────────────────────────────────────────────────

  @override
  ThemeExtension<AppColors> copyWith({
    Color? fondo,
    Color? superficie,
    Color? textoPrimario,
    Color? textoSecundario,
    Color? acento,
    Color? ingreso,
    Color? gasto,
  }) {
    return AppColors(
      fondo: fondo ?? this.fondo,
      superficie: superficie ?? this.superficie,
      textoPrimario: textoPrimario ?? this.textoPrimario,
      textoSecundario: textoSecundario ?? this.textoSecundario,
      acento: acento ?? this.acento,
      ingreso: ingreso ?? this.ingreso,
      gasto: gasto ?? _gastoOverride,
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
      ingreso: Color.lerp(ingreso, other.ingreso, t) ?? ingreso,
      gasto: Color.lerp(gasto, other.gasto, t),
    );
  }
}

// ─── AppTheme ─────────────────────────────────────────────────────────────────

/// Gestor y constructor del ThemeData.
class AppTheme {
  /// Fuentes curadas disponibles en Kip.
  static const List<String> availableFonts = [
    'Inter',
    'Outfit',
    'Poppins',
    'Space Grotesk',
    'Roboto',
  ];

  /// Carga todos los temas declarados en el archivo JSON (mantenido para fallback).
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

  /// Construye un ThemeData completo integrando AppColors y la tipografía seleccionada.
  /// [fontFamily] debe ser uno de [availableFonts]. Por defecto: 'Inter'.
  static ThemeData buildTheme(AppColors colors, {String fontFamily = 'Inter'}) {
    final isDark = colors.fondo.computeLuminance() < 0.5;

    // Construir el TextTheme base y aplicar la fuente dinámica
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

    // Aplicar la fuente seleccionada via google_fonts (usa assets locales por GoogleFonts.config)
    TextTheme themedTextTheme;
    try {
      themedTextTheme = GoogleFonts.getTextTheme(fontFamily, baseTextTheme);
    } catch (_) {
      // Si la fuente no se encuentra, usar Inter como fallback seguro
      themedTextTheme = GoogleFonts.interTextTheme(baseTextTheme);
    }

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: colors.fondo,
      cardColor: colors.superficie,
      fontFamily: GoogleFonts.getFont(fontFamily).fontFamily,
      colorScheme: isDark
          ? ColorScheme.dark(
              surface: colors.superficie,
              primary: colors.acento,
              secondary: colors.acento,
              error: colors.gastoColor,
              onSurface: colors.textoPrimario,
              onPrimary: colors.fondo,
            )
          : ColorScheme.light(
              surface: colors.superficie,
              primary: colors.acento,
              secondary: colors.acento,
              error: colors.gastoColor,
              onSurface: colors.textoPrimario,
              onPrimary: colors.fondo,
            ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.fondo,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: colors.textoPrimario),
        titleTextStyle: GoogleFonts.getFont(
          fontFamily,
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
        hintStyle: GoogleFonts.getFont(
          fontFamily,
          color: colors.textoSecundario,
          fontSize: 15,
        ),
        labelStyle: GoogleFonts.getFont(
          fontFamily,
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
      textTheme: themedTextTheme,
      extensions: [colors],
    );
  }
}

/// Extensión para acceder fácilmente a los colores de AppColors desde cualquier BuildContext.
/// Garantiza CERO colores hardcodeados en los widgets.
extension BuildContextAppColors on BuildContext {
  AppColors get appColors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.lemonDarkFallback;
}
