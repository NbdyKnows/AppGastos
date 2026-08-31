import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_appgastos/core/database/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    // Usamos una base de datos en memoria para los tests unitarios
    db = AppDatabase(NativeDatabase.memory(
      setup: (rawDb) {
        rawDb.execute('PRAGMA foreign_keys = ON;');
      },
    ));
  });

  tearDown(() async {
    await db.close();
  });

  group('Esquema y Constraints de Base de Datos', () {
    test('Constraint condicional de MediosPago para tarjetas de crédito', () async {
      // 1. Débito no requiere lineaCredito, diaCorte, diaPago
      final debitoId = await db.into(db.mediosPago).insert(
        MediosPagoCompanion.insert(
          nombre: 'Cuenta Sueldo',
          tipo: 'débito',
          saldoInicial: const Value(1500.0),
        ),
      );
      expect(debitoId, isPositive);

      // 2. Crédito sin lineaCredito/diaCorte/diaPago debe fallar por CHECK constraint
      expect(
        () => db.into(db.mediosPago).insert(
          MediosPagoCompanion.insert(
            nombre: 'Tarjeta Incompleta',
            tipo: 'crédito',
          ),
        ),
        throwsA(isA<SqliteException>()),
      );

      // 3. Crédito completo debe insertarse exitosamente
      final creditoId = await db.into(db.mediosPago).insert(
        MediosPagoCompanion.insert(
          nombre: 'Tarjeta Visa Oro',
          tipo: 'crédito',
          saldoInicial: const Value(500.0),
          lineaCredito: const Value(20000.0),
          diaCorte: const Value(15),
          diaPago: const Value(5),
        ),
      );
      expect(creditoId, isPositive);
    });

    test('Trigger relacional: Valida que etiqueta pertenezca a la categoría de la transacción', () async {
      // Crear categorías
      final catComidaId = await db.into(db.categorias).insert(
        CategoriasCompanion.insert(
          nombre: 'Comida',
          colorHex: '#FF5722',
          icono: 'restaurant',
        ),
      );

      final catTransporteId = await db.into(db.categorias).insert(
        CategoriasCompanion.insert(
          nombre: 'Transporte',
          colorHex: '#2196F3',
          icono: 'directions_bus',
        ),
      );

      // Crear etiquetas asociadas a sus respectivas categorías
      final etqRestauranteId = await db.into(db.etiquetasCategoria).insert(
        EtiquetasCategoriaCompanion.insert(
          nombre: 'Restaurante',
          categoriaId: catComidaId,
        ),
      );

      final cuentaId = await db.into(db.mediosPago).insert(
        MediosPagoCompanion.insert(
          nombre: 'Efectivo',
          tipo: 'efectivo',
        ),
      );

      // Inserción con etiqueta y categoría concordantes: DEBE tener éxito
      final txExitosa = await db.transaccionesDao.insertarTransaccion(
        TransaccionesCompanion.insert(
          monto: 45.50,
          fecha: DateTime.now(),
          medioPagoId: cuentaId,
          categoriaId: Value(catComidaId),
          etiquetaId: Value(etqRestauranteId),
        ),
      );
      expect(txExitosa, isPositive);

      // Inserción con etiqueta perteneciente a OTRA categoría: DEBE fallar por Trigger
      expect(
        () => db.transaccionesDao.insertarTransaccion(
          TransaccionesCompanion.insert(
            monto: 30.00,
            fecha: DateTime.now(),
            medioPagoId: cuentaId,
            categoriaId: Value(catTransporteId), // Categoría mismatch
            etiquetaId: Value(etqRestauranteId), // Pertenece a Comida
          ),
        ),
        throwsA(
          predicate((e) => e is SqliteException && e.message.contains('etiqueta no pertenece a la categoría')),
        ),
      );
    });

    test('Verifica la creación de todos los índices requeridos en SQLite', () async {
      final indicesResult = await db.customSelect(
        "SELECT name FROM sqlite_master WHERE type = 'index' AND tbl_name = 'transacciones'",
      ).get();

      final nombresIndices = indicesResult.map((row) => row.read<String>('name')).toSet();

      expect(nombresIndices, containsAll([
        'idx_trans_fecha',
        'idx_trans_categoria',
        'idx_trans_mediopago',
        'idx_trans_mediopago_destino',
        'idx_trans_padre',
      ]));
    });
  });

  group('TransaccionesDao - Lógica de Negocio y Cuotas', () {
    test('Inserción en cuotas exactas con absorción de redondeo en última cuota', () async {
      final cuentaId = await db.into(db.mediosPago).insert(
        MediosPagoCompanion.insert(
          nombre: 'Tarjeta Crédito',
          tipo: 'crédito',
          lineaCredito: const Value(5000.0),
          diaCorte: const Value(20),
          diaPago: const Value(10),
        ),
      );

      // 100.00 dividido en 3 cuotas -> 33.33, 33.33, 33.34
      final fechaInicial = DateTime(2026, 1, 15);
      final idPadre = await db.transaccionesDao.insertarTransaccionConCuotas(
        montoTotal: 100.0,
        totalCuotas: 3,
        fechaInicial: fechaInicial,
        medioPagoId: cuentaId,
        nota: 'Compra TV en 3 cuotas',
      );

      final todasLasCuotas = await (db.select(db.transacciones)..orderBy([(t) => OrderingTerm.asc(t.numeroCuota)])).get();
      expect(todasLasCuotas.length, equals(3));

      // Cuota 1 (Ancla)
      expect(todasLasCuotas[0].id, equals(idPadre));
      expect(todasLasCuotas[0].numeroCuota, equals(1));
      expect(todasLasCuotas[0].transaccionPadreId, isNull);
      expect(todasLasCuotas[0].monto, equals(33.33));
      expect(todasLasCuotas[0].fecha, equals(DateTime(2026, 1, 15)));

      // Cuota 2
      expect(todasLasCuotas[1].numeroCuota, equals(2));
      expect(todasLasCuotas[1].transaccionPadreId, equals(idPadre));
      expect(todasLasCuotas[1].monto, equals(33.33));
      expect(todasLasCuotas[1].fecha, equals(DateTime(2026, 2, 15)));

      // Cuota 3 (Absorbe centavos)
      expect(todasLasCuotas[2].numeroCuota, equals(3));
      expect(todasLasCuotas[2].transaccionPadreId, equals(idPadre));
      expect(todasLasCuotas[2].monto, equals(33.34));
      expect(todasLasCuotas[2].fecha, equals(DateTime(2026, 3, 15)));

      // Suma exacta sin descuadre
      final suma = todasLasCuotas.fold<double>(0.0, (acc, item) => acc + item.monto);
      expect(double.parse(suma.toStringAsFixed(2)), equals(100.0));
    });

    test('Manejo seguro de desbordamiento de fin de mes en cuotas (ej. 31 de Enero)', () async {
      final cuentaId = await db.into(db.mediosPago).insert(
        MediosPagoCompanion.insert(
          nombre: 'Tarjeta Crédito',
          tipo: 'crédito',
          lineaCredito: const Value(5000.0),
          diaCorte: const Value(20),
          diaPago: const Value(10),
        ),
      );

      // Compra efectuada el 31 de enero en 4 cuotas
      final fechaInicial = DateTime(2026, 1, 31);
      await db.transaccionesDao.insertarTransaccionConCuotas(
        montoTotal: 400.0,
        totalCuotas: 4,
        fechaInicial: fechaInicial,
        medioPagoId: cuentaId,
      );

      final cuotas = await (db.select(db.transacciones)..orderBy([(t) => OrderingTerm.asc(t.numeroCuota)])).get();

      // Cuota 1: 31 de Enero
      expect(cuotas[0].fecha.year, equals(2026));
      expect(cuotas[0].fecha.month, equals(1));
      expect(cuotas[0].fecha.day, equals(31));

      // Cuota 2: 28 de Febrero (2026 no es bisiesto, último día válido = 28)
      expect(cuotas[1].fecha.year, equals(2026));
      expect(cuotas[1].fecha.month, equals(2));
      expect(cuotas[1].fecha.day, equals(28));

      // Cuota 3: 31 de Marzo
      expect(cuotas[2].fecha.year, equals(2026));
      expect(cuotas[2].fecha.month, equals(3));
      expect(cuotas[2].fecha.day, equals(31));

      // Cuota 4: 30 de Abril (Abril tiene 30 días, último día válido = 30)
      expect(cuotas[3].fecha.year, equals(2026));
      expect(cuotas[3].fecha.month, equals(4));
      expect(cuotas[3].fecha.day, equals(30));
    });
  });

  group('SaldosDao - Flujos Reactivos y Fórmulas Financieras', () {
    test('saldoDisponible para cuentas de débito/efectivo', () async {
      final debitoId = await db.into(db.mediosPago).insert(
        MediosPagoCompanion.insert(
          nombre: 'Cuenta Banco Ahorros',
          tipo: 'débito',
          saldoInicial: const Value(1000.0),
        ),
      );

      final efectivoId = await db.into(db.mediosPago).insert(
        MediosPagoCompanion.insert(
          nombre: 'Billetera Efectivo',
          tipo: 'efectivo',
          saldoInicial: const Value(200.0),
        ),
      );

      final tarjetaId = await db.into(db.mediosPago).insert(
        MediosPagoCompanion.insert(
          nombre: 'Tarjeta Crédito',
          tipo: 'crédito',
          lineaCredito: const Value(5000.0),
          diaCorte: const Value(15),
          diaPago: const Value(5),
        ),
      );

      // 1. Saldo inicial = 1000.0
      expect(await db.saldosDao.getSaldoDisponible(debitoId), equals(1000.0));

      // 2. Ingreso (+500.0) -> 1500.0
      await db.transaccionesDao.insertarTransaccion(
        TransaccionesCompanion.insert(
          monto: 500.0,
          fecha: DateTime.now(),
          tipo: const Value('ingreso'),
          medioPagoId: debitoId,
        ),
      );
      expect(await db.saldosDao.getSaldoDisponible(debitoId), equals(1500.0));

      // 3. Gasto (-200.0) -> 1300.0
      await db.transaccionesDao.insertarTransaccion(
        TransaccionesCompanion.insert(
          monto: 200.0,
          fecha: DateTime.now(),
          tipo: const Value('gasto'),
          medioPagoId: debitoId,
        ),
      );
      expect(await db.saldosDao.getSaldoDisponible(debitoId), equals(1300.0));

      // 4. Pago de Tarjeta (saliente de débito hacia crédito -300.0) -> 1000.0
      await db.transaccionesDao.insertarPagoTarjeta(
        monto: 300.0,
        fecha: DateTime.now(),
        medioPagoOrigenId: debitoId,
        medioPagoTarjetaId: tarjetaId,
      );
      expect(await db.saldosDao.getSaldoDisponible(debitoId), equals(1000.0));

      // 5. Transferencia interna entrante desde Efectivo (+100.0) -> 1100.0
      await db.transaccionesDao.insertarTransferenciaInterna(
        monto: 100.0,
        fecha: DateTime.now(),
        medioPagoOrigenId: efectivoId,
        medioPagoDestinoId: debitoId,
      );
      expect(await db.saldosDao.getSaldoDisponible(debitoId), equals(1100.0));
    });

    test('deudaActual para tarjetas de crédito considerando pagos y transferencias', () async {
      final tarjetaId = await db.into(db.mediosPago).insert(
        MediosPagoCompanion.insert(
          nombre: 'Tarjeta Crédito Principal',
          tipo: 'crédito',
          saldoInicial: const Value(300.0), // Deuda previa al instalar la app
          lineaCredito: const Value(10000.0),
          diaCorte: const Value(20),
          diaPago: const Value(5),
        ),
      );

      final debitoId = await db.into(db.mediosPago).insert(
        MediosPagoCompanion.insert(
          nombre: 'Cuenta Nómina',
          tipo: 'débito',
          saldoInicial: const Value(5000.0),
        ),
      );

      // 1. Deuda inicial = 300.0
      expect(await db.saldosDao.getDeudaActual(tarjetaId), equals(300.0));

      // 2. Gastos en tarjeta (+450.0) -> 750.0
      await db.transaccionesDao.insertarTransaccion(
        TransaccionesCompanion.insert(
          monto: 450.0,
          fecha: DateTime.now(),
          tipo: const Value('gasto'),
          medioPagoId: tarjetaId,
        ),
      );
      expect(await db.saldosDao.getDeudaActual(tarjetaId), equals(750.0));

      // 3. Pago de tarjeta entrante (-250.0 vía 'pago_tarjeta') -> 500.0
      await db.transaccionesDao.insertarPagoTarjeta(
        monto: 250.0,
        fecha: DateTime.now(),
        medioPagoOrigenId: debitoId,
        medioPagoTarjetaId: tarjetaId,
      );
      expect(await db.saldosDao.getDeudaActual(tarjetaId), equals(500.0));

      // 4. Transferencia interna entrante (-100.0 vía 'transferencia_interna') -> 400.0
      await db.transaccionesDao.insertarTransferenciaInterna(
        monto: 100.0,
        fecha: DateTime.now(),
        medioPagoOrigenId: debitoId,
        medioPagoDestinoId: tarjetaId,
      );
      expect(await db.saldosDao.getDeudaActual(tarjetaId), equals(400.0));
    });
  });
}
