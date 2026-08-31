import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/database.dart';
import 'core/database/seed_data.dart';
import 'core/providers/database_providers.dart';
import 'core/providers/settings_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/main_navigation_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // a) Carga de los temas
  Map<String, AppColors> themes;
  try {
    themes = await AppTheme.loadThemesFromJson();
  } catch (e) {
    themes = {
      'Lemon Dark': AppColors.lemonDarkFallback,
      'Lemon Light': AppColors.lemonLightFallback,
    };
  }

  // b) Instanciación única de AppDatabase()
  final db = AppDatabase();

  // c) Ejecución del Seeding inicial pasando esa única instancia
  await seedInitialData(db);

  // Envuelve MyApp() en un ProviderScope con override de databaseProvider
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: MyApp(themes: themes),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Map<String, AppColors>? themes;
  final AppColors? initialColors;

  const MyApp({super.key, this.themes, this.initialColors});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isDarkMode = ref.watch(isDarkModeProvider);
        final currentThemes = themes ?? {
          'Lemon Dark': initialColors ?? AppColors.lemonDarkFallback,
          'Lemon Light': AppColors.lemonLightFallback,
        };
        final themeColors = isDarkMode
            ? (currentThemes['Lemon Dark'] ?? AppColors.lemonDarkFallback)
            : (currentThemes['Lemon Light'] ?? AppColors.lemonLightFallback);

        return MaterialApp(
          title: 'AppGastos', // No cambiar este nombre
          debugShowCheckedModeBanner: false,
          theme: AppTheme.buildTheme(themeColors),
          home: const MainNavigationShell(),
        );
      },
    );
  }
}


