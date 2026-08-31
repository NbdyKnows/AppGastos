import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../models/payment_method_model.dart';
import '../models/transaction_model.dart';
import 'database_providers.dart';

/// 1. Saldo disponible reactivo (Total de cuentas Débito y Efectivo activas).
/// Mantiene estado vivo (SIN autoDispose) para respetar IndexedStack.
final saldoDisponibleProvider = StreamProvider<double>((ref) {
  final db = ref.watch(databaseProvider);

  final query = db.customSelect(
    '''
    SELECT 
      (
        COALESCE((SELECT SUM(saldo_inicial) FROM medios_pago WHERE activo = 1 AND tipo != 'crédito'), 0.0)
        + COALESCE((SELECT SUM(t.monto) FROM transacciones t JOIN medios_pago m ON t.medio_pago_id = m.id WHERE m.tipo != 'crédito' AND t.tipo = 'ingreso'), 0.0)
        - COALESCE((SELECT SUM(t.monto) FROM transacciones t JOIN medios_pago m ON t.medio_pago_id = m.id WHERE m.tipo != 'crédito' AND t.tipo = 'gasto'), 0.0)
        + COALESCE((SELECT SUM(t.monto) FROM transacciones t JOIN medios_pago m ON t.medio_pago_destino_id = m.id WHERE m.tipo != 'crédito' AND (t.tipo = 'transferencia_interna' OR t.tipo = 'pago_tarjeta')), 0.0)
        - COALESCE((SELECT SUM(t.monto) FROM transacciones t JOIN medios_pago m ON t.medio_pago_id = m.id WHERE m.tipo != 'crédito' AND t.medio_pago_destino_id IS NOT NULL AND (t.tipo = 'transferencia_interna' OR t.tipo = 'pago_tarjeta')), 0.0)
      ) AS saldo_total
    ''',
    readsFrom: {db.mediosPago, db.transacciones},
  );

  return query.watchSingle().map((row) => row.read<double>('saldo_total'));
});

/// 2. Tarjetas de crédito activas y sus deudas calculadas.
/// Mantiene estado vivo (SIN autoDispose) para respetar IndexedStack.
final tarjetasActivasProvider = StreamProvider<List<PaymentMethodItem>>((ref) {
  final db = ref.watch(databaseProvider);

  final query = db.customSelect(
    '''
    SELECT 
      m.id,
      m.nombre,
      m.banco,
      m.tipo,
      m.linea_credito,
      m.dia_corte,
      m.dia_pago,
      (
        COALESCE(m.saldo_inicial, 0.0)
        + COALESCE((SELECT SUM(t.monto) FROM transacciones t WHERE t.medio_pago_id = m.id AND t.tipo = 'gasto'), 0.0)
        - COALESCE((SELECT SUM(t.monto) FROM transacciones t WHERE t.medio_pago_destino_id = m.id AND (t.tipo = 'pago_tarjeta' OR t.tipo = 'transferencia_interna')), 0.0)
      ) AS deuda_calculada
    FROM medios_pago m
    WHERE m.tipo = 'crédito' AND m.activo = 1
    ORDER BY m.id ASC
    ''',
    readsFrom: {db.mediosPago, db.transacciones},
  );

  return query.watch().map((rows) {
    return rows.map((row) {
      final id = row.read<int>('id');
      final nombre = row.read<String>('nombre');
      final banco = row.readNullable<String>('banco') ?? '';
      final tipo = row.read<String>('tipo');
      final lineaCredito = row.readNullable<double>('linea_credito');
      final diaCorte = row.readNullable<int>('dia_corte');
      final diaPago = row.readNullable<int>('dia_pago');
      final deuda = row.read<double>('deuda_calculada');

      final cutoffStr = diaCorte != null ? '${diaCorte.toString().padLeft(2, '0')}/09' : null;
      final paymentStr = diaPago != null ? '${diaPago.toString().padLeft(2, '0')}/09' : null;

      return PaymentMethodItem(
        id: id.toString(),
        name: nombre,
        bank: banco.isNotEmpty ? banco : nombre,
        type: tipo,
        usedAmount: deuda,
        creditLimit: lineaCredito,
        cutoffDate: cutoffStr,
        paymentDate: paymentStr,
      );
    }).toList();
  });
});

/// 3. Últimos movimientos (límite 10, ordenados cronológicamente).
/// Mantiene estado vivo (SIN autoDispose) para respetar IndexedStack.
final ultimosMovimientosProvider = StreamProvider<List<TransactionItem>>((ref) {
  final db = ref.watch(databaseProvider);

  final query = db.customSelect(
    '''
    SELECT 
      t.id,
      t.monto,
      t.fecha,
      t.tipo,
      t.nota,
      t.numero_cuota,
      t.total_cuotas,
      t.categoria_id,
      c.nombre AS categoria_nombre,
      t.medio_pago_id,
      m.nombre AS medio_pago_nombre
    FROM transacciones t
    LEFT JOIN categorias c ON t.categoria_id = c.id
    LEFT JOIN medios_pago m ON t.medio_pago_id = m.id
    ORDER BY t.fecha DESC, t.id DESC
    LIMIT 10
    ''',
    readsFrom: {db.transacciones, db.categorias, db.mediosPago},
  );

  return query.watch().map((rows) {
    return rows.map((row) {
      final id = row.read<int>('id').toString();
      final monto = row.read<double>('monto');
      final fecha = row.read<DateTime>('fecha');
      final tipo = row.read<String>('tipo');
      final nota = row.readNullable<String>('nota');
      final totalCuotas = row.readNullable<int>('total_cuotas') ?? 1;
      final catNombre = row.readNullable<String>('categoria_nombre') ?? 'General';
      final medioNombre = row.readNullable<String>('medio_pago_nombre') ?? 'Efectivo';

      return TransactionItem(
        id: id,
        title: (nota != null && nota.trim().isNotEmpty) ? nota : catNombre,
        category: catNombre,
        amount: monto,
        isExpense: tipo == 'gasto',
        date: fecha,
        paymentMethod: medioNombre,
        notes: nota,
        installments: totalCuotas,
      );
    }).toList();
  });
});

/// 4. Historial completo de movimientos para la pantalla de auditoría.
/// Mantiene estado vivo (SIN autoDispose) para respetar IndexedStack.
final historialMovimientosProvider = StreamProvider<List<TransactionItem>>((ref) {
  final db = ref.watch(databaseProvider);

  final query = db.customSelect(
    '''
    SELECT 
      t.id,
      t.monto,
      t.fecha,
      t.tipo,
      t.nota,
      t.numero_cuota,
      t.total_cuotas,
      t.categoria_id,
      c.nombre AS categoria_nombre,
      t.medio_pago_id,
      m.nombre AS medio_pago_nombre
    FROM transacciones t
    LEFT JOIN categorias c ON t.categoria_id = c.id
    LEFT JOIN medios_pago m ON t.medio_pago_id = m.id
    ORDER BY t.fecha DESC, t.id DESC
    ''',
    readsFrom: {db.transacciones, db.categorias, db.mediosPago},
  );

  return query.watch().map((rows) {
    return rows.map((row) {
      final id = row.read<int>('id').toString();
      final monto = row.read<double>('monto');
      final fecha = row.read<DateTime>('fecha');
      final tipo = row.read<String>('tipo');
      final nota = row.readNullable<String>('nota');
      final totalCuotas = row.readNullable<int>('total_cuotas') ?? 1;
      final catNombre = row.readNullable<String>('categoria_nombre') ?? 'General';
      final medioNombre = row.readNullable<String>('medio_pago_nombre') ?? 'Efectivo';

      return TransactionItem(
        id: id,
        title: (nota != null && nota.trim().isNotEmpty) ? nota : catNombre,
        category: catNombre,
        amount: monto,
        isExpense: tipo == 'gasto',
        date: fecha,
        paymentMethod: medioNombre,
        notes: nota,
        installments: totalCuotas,
      );
    }).toList();
  });
});

/// 5. Todos los medios de pago con sus saldos/deudas calculadas para CardsScreen.
final todosLosMediosPagoProvider = StreamProvider<List<PaymentMethodItem>>((ref) {
  final db = ref.watch(databaseProvider);

  final query = db.customSelect(
    '''
    SELECT 
      m.id,
      m.nombre,
      m.banco,
      m.tipo,
      m.linea_credito,
      m.dia_corte,
      m.dia_pago,
      CASE 
        WHEN m.tipo = 'crédito' THEN (
          COALESCE(m.saldo_inicial, 0.0)
          + COALESCE((SELECT SUM(t.monto) FROM transacciones t WHERE t.medio_pago_id = m.id AND t.tipo = 'gasto'), 0.0)
          - COALESCE((SELECT SUM(t.monto) FROM transacciones t WHERE t.medio_pago_destino_id = m.id AND (t.tipo = 'pago_tarjeta' OR t.tipo = 'transferencia_interna')), 0.0)
        )
        ELSE (
          COALESCE(m.saldo_inicial, 0.0)
          + COALESCE((SELECT SUM(t.monto) FROM transacciones t WHERE t.medio_pago_id = m.id AND t.tipo = 'ingreso'), 0.0)
          - COALESCE((SELECT SUM(t.monto) FROM transacciones t WHERE t.medio_pago_id = m.id AND t.tipo = 'gasto'), 0.0)
          + COALESCE((SELECT SUM(t.monto) FROM transacciones t WHERE t.medio_pago_destino_id = m.id AND (t.tipo = 'transferencia_interna' OR t.tipo = 'pago_tarjeta')), 0.0)
          - COALESCE((SELECT SUM(t.monto) FROM transacciones t WHERE t.medio_pago_id = m.id AND t.medio_pago_destino_id IS NOT NULL AND (t.tipo = 'transferencia_interna' OR t.tipo = 'pago_tarjeta')), 0.0)
        )
      END AS monto_calculado
    FROM medios_pago m
    WHERE m.activo = 1
    ORDER BY m.id ASC
    ''',
    readsFrom: {db.mediosPago, db.transacciones},
  );

  return query.watch().map((rows) {
    return rows.map((row) {
      final id = row.read<int>('id');
      final nombre = row.read<String>('nombre');
      final banco = row.readNullable<String>('banco') ?? '';
      final tipo = row.read<String>('tipo');
      final lineaCredito = row.readNullable<double>('linea_credito');
      final diaCorte = row.readNullable<int>('dia_corte');
      final diaPago = row.readNullable<int>('dia_pago');
      final monto = row.read<double>('monto_calculado');

      final cutoffStr = diaCorte != null ? '${diaCorte.toString().padLeft(2, '0')}/09' : null;
      final paymentStr = diaPago != null ? '${diaPago.toString().padLeft(2, '0')}/09' : null;

      return PaymentMethodItem(
        id: id.toString(),
        name: nombre,
        bank: banco.isNotEmpty ? banco : nombre,
        type: tipo,
        usedAmount: monto,
        creditLimit: lineaCredito,
        cutoffDate: cutoffStr,
        paymentDate: paymentStr,
      );
    }).toList();
  });
});

/// 6. Cuentas de origen disponibles (Débito y Efectivo) para liquidar tarjetas.
final cuentasDebitoYEfectivoProvider = StreamProvider<List<MedioPago>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.mediosPago)
        ..where((tbl) => tbl.tipo.isNotValue('crédito') & tbl.activo.equals(true))
        ..orderBy([(tbl) => OrderingTerm.asc(tbl.id)]))
      .watch();
});

/// 7. Lista de Categorías activas.
final categoriasListProvider = StreamProvider<List<Categoria>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.categorias)
        ..where((tbl) => tbl.activo.equals(true))
        ..orderBy([(tbl) => OrderingTerm.asc(tbl.orden), (tbl) => OrderingTerm.asc(tbl.id)]))
      .watch();
});

/// 8. Lista de Medios de Pago activos.
final mediosPagoListProvider = StreamProvider<List<MedioPago>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.mediosPago)
        ..where((tbl) => tbl.activo.equals(true))
        ..orderBy([(tbl) => OrderingTerm.asc(tbl.id)]))
      .watch();
});
