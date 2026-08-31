import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_appgastos/core/database/database.dart';
import 'package:flutter_appgastos/core/database/seed_data.dart';
import 'package:flutter_appgastos/core/providers/database_providers.dart';
import 'package:flutter_appgastos/core/providers/stream_providers.dart';
import 'package:flutter_appgastos/features/transactions/controllers/transaction_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory(
      setup: (rawDb) {
        rawDb.execute('PRAGMA foreign_keys = ON;');
      },
    ));
    await seedInitialData(db);

    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  group('Fase 3: Riverpod State Management & Mutation Controller Tests', () {
    test('saldoDisponibleProvider emits correct initial total balance', () async {
      // In seed: Cuenta Sueldo = 2500, Yape = 200 - 65 - 15 = 120 -> Total = 2620.0
      final initialSaldo = await container.read(saldoDisponibleProvider.future);
      expect(initialSaldo, 2620.0);
    });

    test('tarjetasActivasProvider emits credit cards with current debt', () async {
      // In seed: Tarjeta Estratégica with expense 450 -> Debt = 450.0
      final cards = await container.read(tarjetasActivasProvider.future);
      expect(cards.length, 1);
      expect(cards.first.name, 'Tarjeta Estratégica');
      expect(cards.first.usedAmount, 450.0);
    });

    test('TransactionController.registrarMovimiento updates saldoDisponible reactively', () async {
      final controller = container.read(transactionControllerProvider.notifier);
      final medios = await container.read(mediosPagoListProvider.future);
      final sueldoAccount = medios.firstWhere((m) => m.nombre == 'Cuenta Sueldo');

      // Register new income of S/ 500
      await controller.registrarMovimiento(
        monto: 500.0,
        fecha: DateTime.now(),
        tipo: 'ingreso',
        medioPagoId: sueldoAccount.id,
        nota: 'Bono freelance',
      );

      final updatedSaldo = await container.read(saldoDisponibleProvider.future);
      expect(updatedSaldo, 2620.0 + 500.0);
    });

    test('TransactionController.liquidarTarjeta clears credit debt and deducts from debit', () async {
      final controller = container.read(transactionControllerProvider.notifier);
      final medios = await container.read(mediosPagoListProvider.future);
      final sueldoAccount = medios.firstWhere((m) => m.nombre == 'Cuenta Sueldo');
      final creditCard = medios.firstWhere((m) => m.nombre == 'Tarjeta Estratégica');

      // Liquidate credit card of S/ 450 from Cuenta Sueldo
      await controller.liquidarTarjeta(
        medioPagoOrigenId: sueldoAccount.id,
        medioPagoDestinoId: creditCard.id,
        monto: 450.0,
      );

      // Debt should now be 0.0
      final cards = await container.read(tarjetasActivasProvider.future);
      final updatedCredit = cards.firstWhere((c) => c.name == 'Tarjeta Estratégica');
      expect(updatedCredit.usedAmount, 0.0);

      // Available balance should decrease by 450.0 (2620.0 - 450.0 = 2170.0)
      final updatedSaldo = await container.read(saldoDisponibleProvider.future);
      expect(updatedSaldo, 2170.0);
    });

    test('TransactionController.eliminarMovimiento reverts balance accurately', () async {
      final controller = container.read(transactionControllerProvider.notifier);
      final txs = await container.read(ultimosMovimientosProvider.future);
      final yapeTx = txs.firstWhere((tx) => tx.amount == 65.0);

      final id = int.parse(yapeTx.id);
      await controller.eliminarMovimiento(id);

      // Deleting 65 expense adds 65 back to available balance (2620 + 65 = 2685)
      final updatedSaldo = await container.read(saldoDisponibleProvider.future);
      expect(updatedSaldo, 2685.0);
    });
  });
}
