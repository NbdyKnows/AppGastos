import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:excel/excel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_appgastos/core/database/database.dart';
import 'package:flutter_appgastos/core/database/seed_data.dart';
import 'package:flutter_appgastos/core/providers/database_providers.dart';
import 'package:flutter_appgastos/core/providers/report_providers.dart';

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

  group('Fase 4: ReportesDao - Consultas Analíticas de Agregación', () {
    test('watchGastosPorCategoria agrupa y ordena de mayor a menor monto', () async {
      final now = DateTime.now();
      final rango = calcularRangoMes(now);

      final gastosCat = await db.reportesDao.watchGastosPorCategoria(rango.inicio, rango.fin).first;

      // En el seed hay: Comidas (450), Mascotas (65), Transporte (15)
      expect(gastosCat.length, 3);
      expect(gastosCat[0].nombre, 'Comidas');
      expect(gastosCat[0].totalGasto, 450.0);
      expect(gastosCat[1].nombre, 'Mascotas');
      expect(gastosCat[1].totalGasto, 65.0);
      expect(gastosCat[2].nombre, 'Transporte');
      expect(gastosCat[2].totalGasto, 15.0);
    });

    test('watchGastosPorMedioPago agrupa correctamente por medio de pago', () async {
      final now = DateTime.now();
      final rango = calcularRangoMes(now);

      final gastosMedio = await db.reportesDao.watchGastosPorMedioPago(rango.inicio, rango.fin).first;

      // En el seed: Tarjeta Estratégica (450), Billetera (65 + 15 = 80)
      expect(gastosMedio.length, 2);
      expect(gastosMedio[0].nombre, 'Tarjeta Estratégica');
      expect(gastosMedio[0].totalGasto, 450.0);
      expect(gastosMedio[1].nombre, 'Billetera');
      expect(gastosMedio[1].totalGasto, 80.0);
    });

    test('watchFlujoDeCaja calcula suma de ingresos, gastos y balance', () async {
      final now = DateTime.now();
      final rango = calcularRangoMes(now);

      final flujo = await db.reportesDao.watchFlujoDeCaja(rango.inicio, rango.fin).first;

      // En el seed inicial solo hay gastos: 450 + 65 + 15 = 530.0, ingresos = 0.0
      expect(flujo.totalIngresos, 0.0);
      expect(flujo.totalGastos, 530.0);
      expect(flujo.balance, -530.0);

      // Insertar un ingreso en este mes
      final medios = await (db.select(db.mediosPago)..limit(1)).get();
      await db.transaccionesDao.insertarTransaccion(
        TransaccionesCompanion.insert(
          monto: 3000.0,
          fecha: now,
          tipo: const Value('ingreso'),
          medioPagoId: medios.first.id,
        ),
      );

      final flujoActualizado = await db.reportesDao.watchFlujoDeCaja(rango.inicio, rango.fin).first;
      expect(flujoActualizado.totalIngresos, 3000.0);
      expect(flujoActualizado.totalGastos, 530.0);
      expect(flujoActualizado.balance, 2470.0);
    });

    test('watchLiquidezRetenida suma transacciones de crédito a cuotas en meses futuros', () async {
      final now = DateTime.now();
      final tarjeta = (await (db.select(db.mediosPago)..where((m) => m.tipo.equals('crédito'))).get()).first;

      // Comprar en 3 cuotas empezando este mes
      // Cuota 1 = este mes, Cuota 2 = mes +1, Cuota 3 = mes +2
      await db.transaccionesDao.insertarTransaccionConCuotas(
        montoTotal: 300.0,
        totalCuotas: 3,
        fechaInicial: now,
        medioPagoId: tarjeta.id,
        nota: 'Compra a 3 cuotas',
      );

      // Las cuotas 2 y 3 (100 + 100 = 200) caen en meses futuros
      final liquidez = await db.reportesDao.watchLiquidezRetenida().first;
      expect(liquidez, 200.0);
    });

    test('getTransaccionesParaExportar retorna lista estática (Future) con JOINs completos', () async {
      final now = DateTime.now();
      final rango = calcularRangoMes(now);

      final txs = await db.reportesDao.getTransaccionesParaExportar(rango.inicio, rango.fin);

      expect(txs.length, 3);
      expect(txs.first.categoria, isNotEmpty);
      expect(txs.first.medioPago, isNotEmpty);
      expect(txs.every((t) => t.monto > 0), isTrue);
    });
  });

  group('Fase 4: Riverpod Providers & Smart Insights', () {
    test('smartInsightsProvider genera insights dinámicos con datos del seed', () async {
      // Esperar a que los stream providers emitan sus valores iniciales
      await container.read(gastosPorCategoriaProvider.future);
      await container.read(flujoDeCajaProvider.future);
      await container.read(liquidezRetenidaProvider.future);

      final insights = container.read(smartInsightsProvider);

      expect(insights.length, 3);

      // Insight 1: Comidas es la categoría top (S/ 450.00)
      expect(insights[0].title, 'Hábitos de Consumo');
      expect(insights[0].categoryTag, 'Comidas');
      expect(insights[0].description, contains('Comidas'));
      expect(insights[0].description, contains('450.00'));

      // Insight 2: Salud Totalera
      expect(insights[1].title, 'Salud Totalera');
      expect(insights[1].categoryTag, 'Estrategia Crédito');

      // Insight 3: Proyección o Alerta
      expect(insights[2].title, isIn(['Proyección de Ahorro', 'Alerta de Presupuesto']));
    });

    test('smartInsightsProvider maneja Empty States correctamente para un mes sin datos', () async {
      // Cambiar a un mes futuro sin movimientos
      final mesFuturo = DateTime(2027, 6, 1);
      container.read(mesSeleccionadoProvider.notifier).state = mesFuturo;

      // Esperar a que los stream providers emitan para el nuevo mes
      await container.read(gastosPorCategoriaProvider.future);
      await container.read(flujoDeCajaProvider.future);
      await container.read(liquidezRetenidaProvider.future);

      final insights = container.read(smartInsightsProvider);

      expect(insights.length, 3);
      expect(insights[0].description, contains('Aún no has registrado gastos'));
      expect(insights[1].description, contains('S/ 0.00'));
      expect(insights[2].description, contains('Registra tus ingresos y gastos'));
    });
  });

  group('Fase 4: Exportación de Datos', () {
    test('Generación de Excel con estructura de columnas y filas de transacciones', () async {
      final now = DateTime.now();
      final rango = calcularRangoMes(now);
      final txs = await db.reportesDao.getTransaccionesParaExportar(rango.inicio, rango.fin);

      final excel = Excel.createExcel();
      final sheet = excel['Transacciones'];

      sheet.appendRow([
        TextCellValue('ID'),
        TextCellValue('Fecha'),
        TextCellValue('Tipo'),
        TextCellValue('Categoría'),
        TextCellValue('Detalle / Nota'),
        TextCellValue('Medio de Pago'),
        TextCellValue('Monto (S/)'),
      ]);

      for (final t in txs) {
        sheet.appendRow([
          IntCellValue(t.id),
          TextCellValue(t.fecha.toIso8601String()),
          TextCellValue(t.tipo),
          TextCellValue(t.categoria),
          TextCellValue(t.nota ?? ''),
          TextCellValue(t.medioPago),
          DoubleCellValue(t.monto),
        ]);
      }

      final bytes = excel.save();
      expect(bytes, isNotNull);
      expect(bytes!.isNotEmpty, isTrue);
    });
  });
}
