import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import 'database_providers.dart';
import 'settings_provider.dart';

/// Stream de todos los temas de la BD (sistema + custom), ordenados sistema-primero.
final allThemesProvider = StreamProvider<List<AppThemeEntry>>((ref) {
  final dao = ref.watch(themesDaoProvider);
  return dao.watchAllThemes();
});

/// AppColors activo, calculado reactivamente a partir de:
/// - La lista de temas de la BD
/// - El tema seleccionado (nombre + variante Dark/Light)
///
/// Fallback seguro: si la BD aún no tiene temas o el nombre seleccionado
/// no existe, retorna [AppColors.lemonDarkFallback].
final activeThemeColorsProvider = Provider<AppColors>((ref) {
  final themesAsync = ref.watch(allThemesProvider);
  final selectedPalette = ref.watch(selectedThemePaletteProvider);
  final isDark = ref.watch(isDarkModeProvider);

  return themesAsync.when(
    data: (themes) {
      // Busca coincidencia exacta: "Lemon Dark" o "Lemon Light"
      final variantName = '$selectedPalette ${isDark ? 'Dark' : 'Light'}';
      AppThemeEntry? found = themes.where((t) => t.name == variantName).firstOrNull;

      // Si no hay variante exacta, busca solo por la paleta base (ej. temas custom sin Dark/Light)
      found ??= themes.where((t) => t.name == selectedPalette).firstOrNull;

      if (found == null) return AppColors.lemonDarkFallback;
      return AppColors.fromDbTheme(found);
    },
    loading: () => AppColors.lemonDarkFallback,
    error: (error, stack) => AppColors.lemonDarkFallback,
  );
});
