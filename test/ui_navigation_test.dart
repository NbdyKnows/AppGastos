import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_appgastos/core/database/database.dart';
import 'package:flutter_appgastos/core/database/seed_data.dart';
import 'package:flutter_appgastos/core/providers/database_providers.dart';
import 'package:flutter_appgastos/core/theme/app_theme.dart';
import 'package:flutter_appgastos/main.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
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

  Widget buildTestApp() {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: const MyApp(initialColors: AppColors.lemonDarkFallback),
    );
  }

  group('UI & Navigation Tests (Lemon Cash Style)', () {
    test('AppColors fromJson & fallback verification', () {
      final jsonMap = {
        'fondo': '#0C1821',
        'superficie': '#1B2A41',
        'textoPrimario': '#FFFFFF',
        'textoSecundario': '#324A5F',
        'acento': '#FFF3B0',
        'gasto': '#9E2A2B',
        'ingreso': '#5C9E6D',
      };
      final colors = AppColors.fromJson(jsonMap);
      expect(colors.fondo, const Color(0xFF0C1821));
      expect(colors.superficie, const Color(0xFF1B2A41));
      expect(colors.textoPrimario, const Color(0xFFFFFFFF));
      expect(colors.acento, const Color(0xFFFFF3B0));
      expect(colors.gasto, const Color(0xFF9E2A2B));
      expect(colors.ingreso, const Color(0xFF5C9E6D));
    });

    testWidgets('Preserves state across IndexedStack navigation shell', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Starts at Home (Tab 0)
      expect(find.text('Saldo Actual'), findsOneWidget);

      // Navigate to Historial (Tab 1)
      await tester.tap(find.byIcon(Icons.swap_horiz_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Movimientos Registrados'), findsOneWidget);

      // Navigate to Medios (Tab 2)
      await tester.tap(find.byIcon(Icons.credit_card_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Medios de pago'), findsOneWidget);
      expect(find.text('Registrar Medios'), findsOneWidget);

      // Navigate to Reportes (Tab 3)
      await tester.tap(find.byIcon(Icons.bar_chart_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Reportes'), findsWidgets);
      expect(find.text('Smart Insights'), findsOneWidget);
      expect(find.text('Por Categoría'), findsOneWidget);
      expect(find.text('Por Método de Pago'), findsOneWidget);

      // Return to Home (Tab 0) and verify state is intact
      await tester.tap(find.byIcon(Icons.home_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Saldo Actual'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('Opens QuickRecordModal from FAB and can navigate to Detailed Form', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Tap FAB central '+'
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();

      // Verify modal content
      expect(find.text('Registrar'), findsOneWidget);
      expect(find.text('Más opciones...'), findsOneWidget);
      expect(find.text('Transporte'), findsOneWidget);

      // Tap "Más opciones..." to open TransactionFormScreen
      await tester.tap(find.text('Más opciones...'));
      await tester.pumpAndSettle();

      expect(find.text('Nuevo Movimiento'), findsOneWidget);
      expect(find.text('Agregar Movimiento'), findsOneWidget);
      expect(find.text('NOTAS ADICIONALES'), findsOneWidget);

      // Go back
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Saldo Actual'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('Dashboard sub-tabs switch cleanly (Inicio vs A pagar)', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Switch to 'A pagar' tab
      await tester.tap(find.widgetWithText(Tab, 'A pagar'));
      await tester.pumpAndSettle();
      expect(find.text('Tarjetas de Crédito Activas'), findsOneWidget);

      // Switch back to 'Inicio' tab
      await tester.tap(find.widgetWithText(Tab, 'Inicio'));
      await tester.pumpAndSettle();
      expect(find.text('Saldo Actual'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('Tapping payment method opens edit modal and allows editing name and saving', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Navigate to Medios / Cards tab (Index 2 - credit card icon)
      await tester.tap(find.byIcon(Icons.credit_card_rounded));
      await tester.pumpAndSettle();

      // Verify Medios screen
      expect(find.text('Medios de pago'), findsOneWidget);
      expect(find.text('Cuenta Sueldo'), findsOneWidget);

      // Tap on 'Cuenta Sueldo' to open Edit Modal
      await tester.tap(find.text('Cuenta Sueldo'));
      await tester.pumpAndSettle();

      // Modal should be open
      expect(find.text('Editar Medio de Pago'), findsOneWidget);
      expect(find.text('Guardar Cambios'), findsOneWidget);
      expect(find.text('Eliminar Medio de Pago'), findsOneWidget);

      // Edit name to 'Cuenta Sueldo Principal'
      final nameField = find.widgetWithText(TextField, 'Cuenta Sueldo');
      expect(nameField, findsOneWidget);
      await tester.enterText(nameField, 'Cuenta Sueldo Principal');
      await tester.pumpAndSettle();

      // Tap Guardar Cambios
      await tester.tap(find.text('Guardar Cambios'));
      await tester.pumpAndSettle();

      // Verify updated name is displayed in the list
      expect(find.text('Cuenta Sueldo Principal'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 50));
    });
  });
}
