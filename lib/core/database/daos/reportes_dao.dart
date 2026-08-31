import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'reportes_dao.g.dart';

/// DTO para la agregación de gastos por categoría
class CategoriaGastoData {
  final int categoriaId;
  final String nombre;
  final String colorHex;
  final String icono;
  final double totalGasto;

  const CategoriaGastoData({
    required this.categoriaId,
    required this.nombre,
    required this.colorHex,
    required this.icono,
    required this.totalGasto,
  });
}

/// DTO para la agregación de gastos por medio de pago
class MedioPagoGastoData {
  final int medioPagoId;
  final String nombre;
  final String tipo;
  final String? banco;
  final double totalGasto;

  const MedioPagoGastoData({
    required this.medioPagoId,
    required this.nombre,
    required this.tipo,
    this.banco,
    required this.totalGasto,
  });
}

/// DTO para el flujo de caja en un periodo
class FlujoDeCajaData {
  final double totalIngresos;
  final double totalGastos;

  double get balance => totalIngresos - totalGastos;

  const FlujoDeCajaData({
    required this.totalIngresos,
    required this.totalGastos,
  });
}

/// DTO para transacciones a exportar (PDF / Excel)
class TransaccionExportData {
  final int id;
  final DateTime fecha;
  final String tipo;
  final double monto;
  final String? nota;
  final String categoria;
  final String medioPago;
  final int? numeroCuota;
  final int? totalCuotas;

  const TransaccionExportData({
    required this.id,
    required this.fecha,
    required this.tipo,
    required this.monto,
    this.nota,
    required this.categoria,
    required this.medioPago,
    this.numeroCuota,
    this.totalCuotas,
  });
}

@DriftAccessor(tables: [Transacciones, Categorias, MediosPago])
class ReportesDao extends DatabaseAccessor<AppDatabase> with _$ReportesDaoMixin {
  ReportesDao(super.db);

  /// 1. watchGastosPorCategoria: Stream de gastos agrupados por categoría ordenados de mayor a menor monto.
  Stream<List<CategoriaGastoData>> watchGastosPorCategoria(DateTime inicio, DateTime fin) {
    final query = customSelect(
      '''
      SELECT 
        c.id AS categoria_id,
        c.nombre AS categoria_nombre,
        c.color_hex AS categoria_color,
        c.icono AS categoria_icono,
        COALESCE(SUM(t.monto), 0.0) AS total_gasto
      FROM transacciones t
      JOIN categorias c ON t.categoria_id = c.id
      WHERE t.tipo = 'gasto' 
        AND t.fecha >= :inicio 
        AND t.fecha <= :fin
      GROUP BY c.id
      ORDER BY total_gasto DESC
      ''',
      variables: [
        Variable.withDateTime(inicio),
        Variable.withDateTime(fin),
      ],
      readsFrom: {transacciones, categorias},
    );

    return query.watch().map((rows) {
      return rows.map((r) => CategoriaGastoData(
        categoriaId: r.read<int>('categoria_id'),
        nombre: r.read<String>('categoria_nombre'),
        colorHex: r.read<String>('categoria_color'),
        icono: r.read<String>('categoria_icono'),
        totalGasto: r.read<double>('total_gasto'),
      )).toList();
    });
  }

  /// 2. watchGastosPorMedioPago: Stream de gastos agrupados por medio de pago ordenados de mayor a menor monto.
  Stream<List<MedioPagoGastoData>> watchGastosPorMedioPago(DateTime inicio, DateTime fin) {
    final query = customSelect(
      '''
      SELECT 
        m.id AS medio_pago_id,
        m.nombre AS medio_pago_nombre,
        m.tipo AS medio_pago_tipo,
        m.banco AS medio_pago_banco,
        COALESCE(SUM(t.monto), 0.0) AS total_gasto
      FROM transacciones t
      JOIN medios_pago m ON t.medio_pago_id = m.id
      WHERE t.tipo = 'gasto' 
        AND t.fecha >= :inicio 
        AND t.fecha <= :fin
      GROUP BY m.id
      ORDER BY total_gasto DESC
      ''',
      variables: [
        Variable.withDateTime(inicio),
        Variable.withDateTime(fin),
      ],
      readsFrom: {transacciones, mediosPago},
    );

    return query.watch().map((rows) {
      return rows.map((r) => MedioPagoGastoData(
        medioPagoId: r.read<int>('medio_pago_id'),
        nombre: r.read<String>('medio_pago_nombre'),
        tipo: r.read<String>('medio_pago_tipo'),
        banco: r.readNullable<String>('medio_pago_banco'),
        totalGasto: r.read<double>('total_gasto'),
      )).toList();
    });
  }

  /// 3. watchFlujoDeCaja: Stream con suma total de ingresos vs gastos en el periodo.
  Stream<FlujoDeCajaData> watchFlujoDeCaja(DateTime inicio, DateTime fin) {
    final query = customSelect(
      '''
      SELECT 
        COALESCE(SUM(CASE WHEN tipo = 'ingreso' THEN monto ELSE 0.0 END), 0.0) AS total_ingresos,
        COALESCE(SUM(CASE WHEN tipo = 'gasto' THEN monto ELSE 0.0 END), 0.0) AS total_gastos
      FROM transacciones
      WHERE fecha >= :inicio AND fecha <= :fin
      ''',
      variables: [
        Variable.withDateTime(inicio),
        Variable.withDateTime(fin),
      ],
      readsFrom: {transacciones},
    );

    return query.watchSingle().map((row) => FlujoDeCajaData(
      totalIngresos: row.read<double>('total_ingresos'),
      totalGastos: row.read<double>('total_gastos'),
    ));
  }

  /// 4. watchLiquidezRetenida: Stream con la suma de compras con tarjeta de crédito fechadas después del fin del mes actual.
  Stream<double> watchLiquidezRetenida([DateTime? referenceDate]) {
    final now = referenceDate ?? DateTime.now();
    final finMesActual = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);

    final query = customSelect(
      '''
      SELECT 
        COALESCE(SUM(t.monto), 0.0) AS liquidez_retenida
      FROM transacciones t
      JOIN medios_pago m ON t.medio_pago_id = m.id
      WHERE m.tipo = 'crédito'
        AND t.tipo = 'gasto'
        AND t.fecha > :finMesActual
      ''',
      variables: [Variable.withDateTime(finMesActual)],
      readsFrom: {transacciones, mediosPago},
    );

    return query.watchSingle().map((row) => row.read<double>('liquidez_retenida'));
  }

  /// 5. getTransaccionesParaExportar: Future de lectura única con JOINs a Categorías y MediosPago.
  Future<List<TransaccionExportData>> getTransaccionesParaExportar(DateTime inicio, DateTime fin) async {
    final query = customSelect(
      '''
      SELECT 
        t.id,
        t.fecha,
        t.tipo,
        t.monto,
        t.nota,
        t.numero_cuota,
        t.total_cuotas,
        COALESCE(c.nombre, 'Sin categoría') AS categoria_nombre,
        COALESCE(m.nombre, 'Sin medio') AS medio_pago_nombre
      FROM transacciones t
      LEFT JOIN categorias c ON t.categoria_id = c.id
      LEFT JOIN medios_pago m ON t.medio_pago_id = m.id
      WHERE t.fecha >= :inicio AND t.fecha <= :fin
      ORDER BY t.fecha DESC, t.id DESC
      ''',
      variables: [
        Variable.withDateTime(inicio),
        Variable.withDateTime(fin),
      ],
      readsFrom: {transacciones, categorias, mediosPago},
    );

    final rows = await query.get();
    return rows.map((r) => TransaccionExportData(
      id: r.read<int>('id'),
      fecha: r.read<DateTime>('fecha'),
      tipo: r.read<String>('tipo'),
      monto: r.read<double>('monto'),
      nota: r.readNullable<String>('nota'),
      categoria: r.read<String>('categoria_nombre'),
      medioPago: r.read<String>('medio_pago_nombre'),
      numeroCuota: r.readNullable<int>('numero_cuota'),
      totalCuotas: r.readNullable<int>('total_cuotas'),
    )).toList();
  }
}
