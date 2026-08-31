import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_appgastos/core/database/database.dart';
import 'package:flutter_appgastos/core/database/seed_data.dart';
import 'package:flutter_appgastos/core/providers/database_providers.dart';
import 'package:flutter_appgastos/core/providers/settings_provider.dart';
import 'package:flutter_appgastos/core/theme/app_theme.dart';
import 'package:flutter_appgastos/features/settings/widgets/settings_drawer.dart';
import 'package:flutter_appgastos/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'haptics_enabled': true,
      'is_dark_mode': true,
    });

    db = AppDatabase(NativeDatabase.memory(
      setup: (rawDb) {
        rawDb.execute('PRAGMA foreign_keys = ON;');
      },
    ));
    await seedInitialData(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Fase 5: Settings Drawer, Providers & Dynamic Theming Tests', () {
    test('settings_provider manages haptics and dark mode flags', () async {
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
      );

      expect(container.read(hapticsEnabledProvider), true);
      expect(container.read(isDarkModeProvider), true);

      container.read(hapticsEnabledProvider.notifier).state = false;
      expect(container.read(hapticsEnabledProvider), false);

      container.read(isDarkModeProvider.notifier).state = false;
      expect(container.read(isDarkModeProvider), false);

      container.dispose();
    });

    testWidgets('Opens SettingsDrawer from Home hamburger menu and displays switches', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify App Title / Home Screen is rendered
      expect(find.text('Inicio'), findsWidgets);

      // Open Drawer using the hamburger menu button in AppBar
      final openDrawerButton = find.byIcon(Icons.menu_rounded).first;
      await tester.tap(openDrawerButton);
      await tester.pumpAndSettle();

      // Check Drawer elements
      expect(find.byType(SettingsDrawer), findsOneWidget);
      expect(find.text('Ajustes'), findsOneWidget);
      expect(find.text('v1.1.0'), findsOneWidget);
      expect(find.text('Vibración y Haptics'), findsOneWidget);
      expect(find.text('Modo Oscuro'), findsOneWidget);
      expect(find.text('Borrar datos de prueba'), findsOneWidget);

      // Toggle Dark Mode Switch
      final darkModeSwitchFinder = find.widgetWithText(SwitchListTile, 'Modo Oscuro');
      expect(darkModeSwitchFinder, findsOneWidget);
      await tester.tap(darkModeSwitchFinder);
      await tester.pumpAndSettle();

      // Toggle Haptics Switch
      final hapticsSwitchFinder = find.widgetWithText(SwitchListTile, 'Vibración y Haptics');
      expect(hapticsSwitchFinder, findsOneWidget);
      await tester.tap(hapticsSwitchFinder);
      await tester.pumpAndSettle();

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('Borrar datos de prueba dialog triggers wipeAllData and clears transactions', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Open Drawer
      await tester.tap(find.byIcon(Icons.menu_rounded).first);
      await tester.pumpAndSettle();

      // Tap "Borrar datos de prueba"
      await tester.tap(find.text('Borrar datos de prueba'));
      await tester.pumpAndSettle();

      // Dialog should be open
      expect(find.text('¿Estás seguro de que deseas eliminar todas las transacciones registradas? Tus cuentas y categorías base se mantendrán intactas.'), findsOneWidget);
      expect(find.text('Borrar'), findsOneWidget);

      // Tap Borrar
      await tester.tap(find.text('Borrar'));
      await tester.pumpAndSettle();

      // Verify transacciones count is 0 in DB
      final remainingCount = await db.transacciones.count().getSingle();
      expect(remainingCount, 0);

      // Verify categorias and medios_pago are preserved
      final catCount = await db.categorias.count().getSingle();
      expect(catCount > 0, true);
      final mediosCount = await db.mediosPago.count().getSingle();
      expect(mediosCount > 0, true);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 50));
    });

    test('Lemon Light scheme parsing from JSON', () {
      final lightJson = {
        'fondo': '#F4F5F7',
        'superficie': '#FFFFFF',
        'textoPrimario': '#0C1821',
        'textoSecundario': '#5C6A79',
        'acento': '#F4D144',
        'gasto': '#D32F2F',
        'ingreso': '#388E3C',
      };

      final colors = AppColors.fromJson(lightJson);
      expect(colors.fondo, const Color(0xFFF4F5F7));
      expect(colors.superficie, const Color(0xFFFFFFFF));
      expect(colors.textoPrimario, const Color(0xFF0C1821));
      expect(colors.textoSecundario, const Color(0xFF5C6A79));
      expect(colors.acento, const Color(0xFFF4D144));
      expect(colors.gasto, const Color(0xFFD32F2F));
      expect(colors.ingreso, const Color(0xFF388E3C));

      final themeData = AppTheme.buildTheme(colors);
      expect(themeData.brightness, Brightness.light);
    });
  });
}
