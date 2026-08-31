import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'transacciones_dao.g.dart';

@DriftAccessor(tables: [Transacciones, Categorias, EtiquetasCategoria, MediosPago])
class TransaccionesDao extends DatabaseAccessor<AppDatabase> with _$TransaccionesDaoMixin {
  TransaccionesDao(super.db);

  /// Inserción simple de una transacción
  Future<int> insertarTransaccion(TransaccionesCompanion transaccion) {
    return into(transacciones).insert(transaccion);
  }

  /// Inserción de compra en cuotas (estrategia sin fila placeholder)
  ///
  /// - Cuota #1: transaccionPadreId = NULL, numeroCuota = 1, fecha = fecha inicial
  /// - Cuotas 2..N: transaccionPadreId = cuota1.id, numeroCuota = i, fecha calculada sin desbordamiento
  /// - Ajuste de redondeo: la última cuota absorbe la diferencia de céntimos para que
  ///   la suma exacta de todas las cuotas sea igual a montoTotal.
  /// - Toda la operación se ejecuta atómicamente dentro de un bloque `transaction(() async { ... })`.
  Future<int> insertarTransaccionConCuotas({
    required double montoTotal,
    required int totalCuotas,
    required DateTime fechaInicial,
    required int medioPagoId,
    int? categoriaId,
    int? etiquetaId,
    String? nota,
  }) async {
    if (totalCuotas < 1) {
      throw ArgumentError('totalCuotas debe ser al menos 1');
    }

    return transaction(() async {
      // 1. Cálculo de monto base y ajuste para la última cuota
      final cuotaBaseCentavos = ((montoTotal / totalCuotas) * 100).round();
      final cuotaBase = cuotaBaseCentavos / 100.0;

      // Suma de las primeras N - 1 cuotas
      final sumaPrimerasCuotas = cuotaBase * (totalCuotas - 1);
      // La última cuota absorbe la diferencia exacta de redondeo
      final montoUltimaCuota = double.parse((montoTotal - sumaPrimerasCuotas).toStringAsFixed(2));

      // 2. Inserción de la cuota #1 (ancla)
      final fechaCuota1 = _calcularFechaCuota(fechaInicial, 0);
      final montoCuota1 = totalCuotas == 1 ? montoUltimaCuota : cuotaBase;

      final cuota1Id = await into(transacciones).insert(
        TransaccionesCompanion(
          monto: Value(montoCuota1),
          fecha: Value(fechaCuota1),
          tipo: const Value('gasto'),
          nota: Value(nota),
          numeroCuota: const Value(1),
          totalCuotas: Value(totalCuotas),
          categoriaId: Value(categoriaId),
          etiquetaId: Value(etiquetaId),
          transaccionPadreId: const Value(null),
          medioPagoId: Value(medioPagoId),
          medioPagoDestinoId: const Value(null),
        ),
      );

      // 3. Inserción de las cuotas 2..totalCuotas referenciando la cuota #1
      for (int i = 2; i <= totalCuotas; i++) {
        final cuotaIndex = i - 1;
        final fechaCuota = _calcularFechaCuota(fechaInicial, cuotaIndex);
        final montoCuota = (i == totalCuotas) ? montoUltimaCuota : cuotaBase;

        await into(transacciones).insert(
          TransaccionesCompanion(
            monto: Value(montoCuota),
            fecha: Value(fechaCuota),
            tipo: const Value('gasto'),
            nota: Value(nota),
            numeroCuota: Value(i),
            totalCuotas: Value(totalCuotas),
            categoriaId: Value(categoriaId),
            etiquetaId: Value(etiquetaId),
            transaccionPadreId: Value(cuota1Id),
            medioPagoId: Value(medioPagoId),
            medioPagoDestinoId: const Value(null),
          ),
        );
      }

      return cuota1Id;
    });
  }

  /// Inserción atómica de pago de tarjeta de crédito
  /// Mueve saldo usando medioPagoId (origen: débito/efectivo) y medioPagoDestinoId (tarjeta de crédito).
  Future<int> insertarPagoTarjeta({
    required double monto,
    required DateTime fecha,
    required int medioPagoOrigenId,
    required int medioPagoTarjetaId,
    String? nota,
  }) async {
    return transaction(() async {
      return into(transacciones).insert(
        TransaccionesCompanion(
          monto: Value(monto),
          fecha: Value(fecha),
          tipo: const Value('pago_tarjeta'),
          nota: Value(nota),
          numeroCuota: const Value(null),
          totalCuotas: const Value(null),
          categoriaId: const Value(null),
          etiquetaId: const Value(null),
          transaccionPadreId: const Value(null),
          medioPagoId: Value(medioPagoOrigenId),
          medioPagoDestinoId: Value(medioPagoTarjetaId),
        ),
      );
    });
  }

  /// Inserción atómica de transferencia interna entre cuentas
  Future<int> insertarTransferenciaInterna({
    required double monto,
    required DateTime fecha,
    required int medioPagoOrigenId,
    required int medioPagoDestinoId,
    String? nota,
  }) async {
    return transaction(() async {
      return into(transacciones).insert(
        TransaccionesCompanion(
          monto: Value(monto),
          fecha: Value(fecha),
          tipo: const Value('transferencia_interna'),
          nota: Value(nota),
          numeroCuota: const Value(null),
          totalCuotas: const Value(null),
          categoriaId: const Value(null),
          etiquetaId: const Value(null),
          transaccionPadreId: const Value(null),
          medioPagoId: Value(medioPagoOrigenId),
          medioPagoDestinoId: Value(medioPagoDestinoId),
        ),
      );
    });
  }

  /// Helper para cálculo seguro de fecha sumando meses sin desbordamiento.
  /// Si el día base no existe en el mes destino (ej. 31 en mes de 30 días, o en febrero),
  /// se ajusta al último día válido de ese mes.
  DateTime _calcularFechaCuota(DateTime fechaBase, int cuotaOffset) {
    if (cuotaOffset == 0) return fechaBase;

    final rawMonth = fechaBase.month + cuotaOffset;
    final targetYear = fechaBase.year + (rawMonth - 1) ~/ 12;
    final targetMonth = ((rawMonth - 1) % 12) + 1;

    // Obtener el último día del mes destino usando día 0 del mes siguiente
    final maxDiasMes = DateTime(targetYear, targetMonth + 1, 0).day;
    final targetDay = fechaBase.day > maxDiasMes ? maxDiasMes : fechaBase.day;

    return DateTime(
      targetYear,
      targetMonth,
      targetDay,
      fechaBase.hour,
      fechaBase.minute,
      fechaBase.second,
      fechaBase.millisecond,
      fechaBase.microsecond,
    );
  }
}
