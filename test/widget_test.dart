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
  testWidgets('App loads and displays Home screen smoke test', (WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory(
      setup: (rawDb) {
        rawDb.execute('PRAGMA foreign_keys = ON;');
      },
    ));
    await seedInitialData(db);

    // Build our app with fallback theme and in-memory database.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MyApp(initialColors: AppColors.lemonDarkFallback),
      ),
    );
    await tester.pumpAndSettle();

    // Verify that the title 'Inicio' is rendered
    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Saldo Actual'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));

    await db.close();
  });
}
