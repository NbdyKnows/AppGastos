import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/daos/transacciones_dao.dart';
import '../../../core/database/database.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/providers/settings_provider.dart';

/// Provider para el controlador de transacciones y operaciones de base de datos.
final transactionControllerProvider =
    StateNotifierProvider<TransactionController, AsyncValue<void>>((ref) {
  return TransactionController(ref);
});

/// Controlador de mutaciones con soporte reactivo para estados de carga y captura de errores.
class TransactionController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  TransactionController(this._ref) : super(const AsyncData(null));

  TransaccionesDao get _transaccionesDao => _ref.read(transaccionesDaoProvider);
  AppDatabase get _db => _ref.read(databaseProvider);

  /// Registra un movimiento simple o en cuotas.
  Future<void> registrarMovimiento({
    required double monto,
    required DateTime fecha,
    required String tipo,
    required int medioPagoId,
    int? medioPagoDestinoId,
    int? categoriaId,
    int? etiquetaId,
    String? nota,
    int cuotas = 1,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (cuotas > 1 && tipo == 'gasto') {
        await _transaccionesDao.insertarTransaccionConCuotas(
          montoTotal: monto,
          totalCuotas: cuotas,
          fechaInicial: fecha,
          medioPagoId: medioPagoId,
          categoriaId: categoriaId,
          etiquetaId: etiquetaId,
          nota: nota,
        );
      } else {
        await _transaccionesDao.insertarTransaccion(
          TransaccionesCompanion.insert(
            monto: monto,
            fecha: fecha,
            tipo: Value(tipo),
            nota: Value(nota),
            numeroCuota: const Value(1),
            totalCuotas: Value(cuotas),
            categoriaId: Value(categoriaId),
            etiquetaId: Value(etiquetaId),
            medioPagoId: medioPagoId,
            medioPagoDestinoId: Value(medioPagoDestinoId),
          ),
        );
      }
    });

    if (!state.hasError && _ref.read(hapticsEnabledProvider)) {
      try {
        HapticFeedback.mediumImpact();
      } catch (_) {}
    }
  }

  /// Liquida la deuda de una tarjeta de crédito transfiriendo saldo desde una cuenta de débito o efectivo.
  Future<void> liquidarTarjeta({
    required int medioPagoOrigenId,
    required int medioPagoDestinoId,
    required double monto,
    DateTime? fecha,
    String? nota,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _transaccionesDao.insertarPagoTarjeta(
        monto: monto,
        fecha: fecha ?? DateTime.now(),
        medioPagoOrigenId: medioPagoOrigenId,
        medioPagoTarjetaId: medioPagoDestinoId,
        nota: nota ?? 'Liquidación de tarjeta',
      );
    });

    if (!state.hasError && _ref.read(hapticsEnabledProvider)) {
      try {
        HapticFeedback.mediumImpact();
      } catch (_) {}
    }
  }

  /// Elimina una transacción por su identificador.
  Future<void> eliminarMovimiento(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await (_db.delete(_db.transacciones)..where((tbl) => tbl.id.equals(id))).go();
    });
  }

  /// Registra un nuevo medio de pago en la base de datos local.
  Future<void> registrarMedioPago(MediosPagoCompanion medio) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _db.into(_db.mediosPago).insert(medio);
    });
  }

  /// Actualiza un medio de pago existente en la base de datos local.
  Future<void> actualizarMedioPago({
    required int id,
    required String nombre,
    String? banco,
    required String tipo,
    double saldoInicial = 0.0,
    double? lineaCredito,
    int? diaCorte,
    int? diaPago,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await (_db.update(_db.mediosPago)..where((tbl) => tbl.id.equals(id))).write(
        MediosPagoCompanion(
          nombre: Value(nombre),
          banco: Value(banco),
          tipo: Value(tipo),
          saldoInicial: Value(saldoInicial),
          lineaCredito: Value(lineaCredito),
          diaCorte: Value(diaCorte),
          diaPago: Value(diaPago),
        ),
      );
    });

    if (!state.hasError && _ref.read(hapticsEnabledProvider)) {
      try {
        HapticFeedback.mediumImpact();
      } catch (_) {}
    }
  }

  /// Desactiva de forma segura un medio de pago sin romper integridad referencial.
  Future<void> desactivarMedioPago(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await (_db.update(_db.mediosPago)..where((tbl) => tbl.id.equals(id))).write(
        const MediosPagoCompanion(
          activo: Value(false),
        ),
      );
    });

    if (!state.hasError && _ref.read(hapticsEnabledProvider)) {
      try {
        HapticFeedback.mediumImpact();
      } catch (_) {}
    }
  }

  /// Vacía todas las transacciones registradas (Factory Reset de movimientos)
  /// preservando medios de pago y categorías.
  Future<void> wipeAllData() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _db.clearAllTransactions();
    });

    if (!state.hasError && _ref.read(hapticsEnabledProvider)) {
      try {
        HapticFeedback.mediumImpact();
      } catch (_) {}
    }
  }
}
