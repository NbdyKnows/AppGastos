import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'saldos_dao.g.dart';

@DriftAccessor(tables: [MediosPago, Transacciones])
class SaldosDao extends DatabaseAccessor<AppDatabase> with _$SaldosDaoMixin {
  SaldosDao(super.db);

  /// Saldo disponible reactivo (Stream): solo para tipo != 'crédito'.
  /// Fórmula: saldoInicial + ingresos - gastos + transferencias entrantes - transferencias salientes.
  Stream<double> watchSaldoDisponible(int medioPagoId) {
    final query = customSelect(
      '''
      SELECT 
        (
          COALESCE((SELECT saldo_inicial FROM medios_pago WHERE id = :id), 0.0)
          + COALESCE((SELECT SUM(monto) FROM transacciones WHERE medio_pago_id = :id AND tipo = 'ingreso'), 0.0)
          - COALESCE((SELECT SUM(monto) FROM transacciones WHERE medio_pago_id = :id AND tipo = 'gasto'), 0.0)
          + COALESCE((SELECT SUM(monto) FROM transacciones WHERE medio_pago_destino_id = :id AND (tipo = 'transferencia_interna' OR tipo = 'pago_tarjeta')), 0.0)
          - COALESCE((SELECT SUM(monto) FROM transacciones WHERE medio_pago_id = :id AND medio_pago_destino_id IS NOT NULL AND (tipo = 'transferencia_interna' OR tipo = 'pago_tarjeta')), 0.0)
        ) AS saldo_calculado
      ''',
      variables: [Variable.withInt(medioPagoId)],
      readsFrom: {mediosPago, transacciones},
    );

    return query.watchSingle().map((row) => row.read<double>('saldo_calculado'));
  }

  /// Obtiene el saldo disponible puntual (Future): solo para tipo != 'crédito'.
  Future<double> getSaldoDisponible(int medioPagoId) async {
    final query = customSelect(
      '''
      SELECT 
        (
          COALESCE((SELECT saldo_inicial FROM medios_pago WHERE id = :id), 0.0)
          + COALESCE((SELECT SUM(monto) FROM transacciones WHERE medio_pago_id = :id AND tipo = 'ingreso'), 0.0)
          - COALESCE((SELECT SUM(monto) FROM transacciones WHERE medio_pago_id = :id AND tipo = 'gasto'), 0.0)
          + COALESCE((SELECT SUM(monto) FROM transacciones WHERE medio_pago_destino_id = :id AND (tipo = 'transferencia_interna' OR tipo = 'pago_tarjeta')), 0.0)
          - COALESCE((SELECT SUM(monto) FROM transacciones WHERE medio_pago_id = :id AND medio_pago_destino_id IS NOT NULL AND (tipo = 'transferencia_interna' OR tipo = 'pago_tarjeta')), 0.0)
        ) AS saldo_calculado
      ''',
      variables: [Variable.withInt(medioPagoId)],
      readsFrom: {mediosPago, transacciones},
    );

    final row = await query.getSingle();
    return row.read<double>('saldo_calculado');
  }

  /// Deuda actual reactiva (Stream): solo para tipo == 'crédito'.
  /// Fórmula: saldoInicial (deuda previa) + gastos - transferencias entrantes.
  ///
  /// Nota: Las transferencias entrantes a la tarjeta evalúan explícitamente
  /// tanto 'pago_tarjeta' como 'transferencia_interna' cuando medio_pago_destino_id = idTarjeta.
  Stream<double> watchDeudaActual(int medioPagoId) {
    final query = customSelect(
      '''
      SELECT 
        (
          COALESCE((SELECT saldo_inicial FROM medios_pago WHERE id = :id), 0.0)
          + COALESCE((SELECT SUM(monto) FROM transacciones WHERE medio_pago_id = :id AND tipo = 'gasto'), 0.0)
          - COALESCE((SELECT SUM(monto) FROM transacciones WHERE medio_pago_destino_id = :id AND (tipo = 'pago_tarjeta' OR tipo = 'transferencia_interna')), 0.0)
        ) AS deuda_calculada
      ''',
      variables: [Variable.withInt(medioPagoId)],
      readsFrom: {mediosPago, transacciones},
    );

    return query.watchSingle().map((row) => row.read<double>('deuda_calculada'));
  }

  /// Obtiene la deuda actual puntual (Future): solo para tipo == 'crédito'.
  Future<double> getDeudaActual(int medioPagoId) async {
    final query = customSelect(
      '''
      SELECT 
        (
          COALESCE((SELECT saldo_inicial FROM medios_pago WHERE id = :id), 0.0)
          + COALESCE((SELECT SUM(monto) FROM transacciones WHERE medio_pago_id = :id AND tipo = 'gasto'), 0.0)
          - COALESCE((SELECT SUM(monto) FROM transacciones WHERE medio_pago_destino_id = :id AND (tipo = 'pago_tarjeta' OR tipo = 'transferencia_interna')), 0.0)
        ) AS deuda_calculada
      ''',
      variables: [Variable.withInt(medioPagoId)],
      readsFrom: {mediosPago, transacciones},
    );

    final row = await query.getSingle();
    return row.read<double>('deuda_calculada');
  }
}
