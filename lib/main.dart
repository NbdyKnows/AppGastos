import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/database/database.dart';
import 'core/database/seed_data.dart';
import 'core/providers/database_providers.dart';
import 'core/providers/settings_provider.dart';
import 'core/providers/theme_providers.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/main_navigation_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fix 4: Deshabilitar la descarga de fuentes en red.
  // Google Fonts usará exclusivamente los assets locales declarados en pubspec.yaml.
  GoogleFonts.config.allowRuntimeFetching = false;

  // Instanciación única de AppDatabase
  final db = AppDatabase();

  // Seed de datos iniciales (categorías, medios de pago, temas del sistema)
  await seedInitialData(db);

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: const KipApp(),
    ),
  );
}

class KipApp extends ConsumerWidget {
  final AppColors? initialColors;

  const KipApp({super.key, this.initialColors});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Leer el tema activo desde la BD (reactivo) o usar initialColors si fue provisto (tests)
    final dbColors = ref.watch(activeThemeColorsProvider);
    final activeColors = initialColors ?? dbColors;

    // Leer la fuente seleccionada (persistida en SharedPreferences)
    final fontFamily = ref.watch(fontFamilyProvider);

    return MaterialApp(
      title: 'Kip',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildTheme(activeColors, fontFamily: fontFamily),
      home: const MainNavigationShell(),
    );
  }
}

/// Alias para compatibilidad total con tests existentes.
typedef MyApp = KipApp;
