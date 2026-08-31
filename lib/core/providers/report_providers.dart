import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/daos/reportes_dao.dart';
import '../models/insight_model.dart';
import 'database_providers.dart';

/// Utilitario para calcular el rango de fechas [inicio, fin] de un mes dado.
/// - [inicio]: Día 1 del mes a las 00:00:00.000
/// - [fin]: Último día válido del mes a las 23:59:59.999
({DateTime inicio, DateTime fin}) calcularRangoMes(DateTime mes) {
  final inicio = DateTime(mes.year, mes.month, 1, 0, 0, 0, 0);
  final fin = DateTime(mes.year, mes.month + 1, 0, 23, 59, 59, 999);
  return (inicio: inicio, fin: fin);
}

/// Formateador simple de moneda peruana (S/ 1,234.50)
String formatearMoneda(double monto) {
  final partes = monto.toStringAsFixed(2).split('.');
  final entero = partes[0];
  final decimales = partes[1];

  final regExp = RegExp(r'\B(?=(\d{3})+(?!\d))');
  final enteroConComas = entero.replaceAllMapped(regExp, (Match m) => ',');
  return 'S/ $enteroConComas.$decimales';
}

/// 1. Proveedor del mes seleccionado en la pantalla de Reportes.
/// Inicializado por defecto en el primer día del mes actual.
final mesSeleccionadoProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

/// 2. StreamProvider de Gastos por Categoría para el mes seleccionado
final gastosPorCategoriaProvider = StreamProvider<List<CategoriaGastoData>>((ref) {
  final dao = ref.watch(reportesDaoProvider);
  final mes = ref.watch(mesSeleccionadoProvider);
  final rango = calcularRangoMes(mes);
  return dao.watchGastosPorCategoria(rango.inicio, rango.fin);
});

/// 3. StreamProvider de Gastos por Medio de Pago para el mes seleccionado
final gastosPorMedioPagoProvider = StreamProvider<List<MedioPagoGastoData>>((ref) {
  final dao = ref.watch(reportesDaoProvider);
  final mes = ref.watch(mesSeleccionadoProvider);
  final rango = calcularRangoMes(mes);
  return dao.watchGastosPorMedioPago(rango.inicio, rango.fin);
});

/// 4. StreamProvider de Flujo de Caja (Ingresos vs Gastos) para el mes seleccionado
final flujoDeCajaProvider = StreamProvider<FlujoDeCajaData>((ref) {
  final dao = ref.watch(reportesDaoProvider);
  final mes = ref.watch(mesSeleccionadoProvider);
  final rango = calcularRangoMes(mes);
  return dao.watchFlujoDeCaja(rango.inicio, rango.fin);
});

/// 5. StreamProvider de Liquidez Retenida en cuotas futuras de crédito
final liquidezRetenidaProvider = StreamProvider<double>((ref) {
  final dao = ref.watch(reportesDaoProvider);
  return dao.watchLiquidezRetenida();
});

/// 6. Provider transformador que combina los datos y genera las tarjetas de Smart Insights.
/// Maneja obligatoriamente Empty States cuando no hay datos registrados en el periodo.
final smartInsightsProvider = Provider<List<InsightItem>>((ref) {
  final gastosCatAsync = ref.watch(gastosPorCategoriaProvider);
  final flujoAsync = ref.watch(flujoDeCajaProvider);
  final liquidezAsync = ref.watch(liquidezRetenidaProvider);

  final gastosCat = gastosCatAsync.value ?? [];
  final flujo = flujoAsync.value ?? const FlujoDeCajaData(totalIngresos: 0.0, totalGastos: 0.0);
  final liquidez = liquidezAsync.value ?? 0.0;

  final List<InsightItem> insights = [];

  // Insight 1: Hábitos de Consumo (Categoría #1)
  if (gastosCat.isNotEmpty && gastosCat.first.totalGasto > 0) {
    final topCat = gastosCat.first;
    final montoStr = formatearMoneda(topCat.totalGasto);
    insights.add(
      InsightItem(
        id: 'insight-habitos',
        title: 'Hábitos de Consumo',
        description: 'Este mes destinaste $montoStr a ${topCat.nombre}. Es tu categoría más alta.',
        icon: Icons.trending_down_rounded,
        categoryTag: topCat.nombre,
      ),
    );
  } else {
    insights.add(
      const InsightItem(
        id: 'insight-habitos-empty',
        title: 'Hábitos de Consumo',
        description: 'Aún no has registrado gastos este mes. ¡Empieza a registrar tus movimientos con el botón (+)!',
        icon: Icons.receipt_long_rounded,
        categoryTag: 'Sin movimientos',
      ),
    );
  }

  // Insight 2: Salud Totalera (Liquidez Retenida en cuotas futuras)
  if (liquidez > 0) {
    final liquidezStr = formatearMoneda(liquidez);
    insights.add(
      InsightItem(
        id: 'insight-salud',
        title: 'Salud Totalera',
        description: 'Liquidez retenida: Tienes $liquidezStr trabajando para ti mientras financias compras a cuotas sin intereses.',
        icon: Icons.speed_rounded,
        categoryTag: 'Estrategia Crédito',
      ),
    );
  } else {
    insights.add(
      const InsightItem(
        id: 'insight-salud-empty',
        title: 'Salud Totalera',
        description: 'Liquidez retenida: S/ 0.00. Aprovecha tus compras a cuotas sin intereses para maximizar tu liquidez disponible.',
        icon: Icons.speed_rounded,
        categoryTag: 'Estrategia Crédito',
      ),
    );
  }

  // Insight 3: Proyección de Ahorro / Flujo de Caja (Ingresos - Gastos)
  final remanente = flujo.balance;
  if (flujo.totalIngresos > 0 || flujo.totalGastos > 0) {
    if (remanente >= 0) {
      final remanenteStr = formatearMoneda(remanente);
      insights.add(
        InsightItem(
          id: 'insight-proyeccion',
          title: 'Proyección de Ahorro',
          description: 'Tasa de Ahorro: Te quedan $remanenteStr libres para inyectar en tu fondo del Depa 30 / S&P 500.',
          icon: Icons.trending_up_rounded,
          categoryTag: 'Metas Financieras',
        ),
      );
    } else {
      final deficitStr = formatearMoneda(remanente.abs());
      insights.add(
        InsightItem(
          id: 'insight-alerta',
          title: 'Alerta de Presupuesto',
          description: 'Alerta de sobregiro: Tus gastos superan tus ingresos por $deficitStr. Considera recortar gastos discrecionales.',
          icon: Icons.warning_amber_rounded,
          categoryTag: 'Sobregiro',
        ),
      );
    }
  } else {
    insights.add(
      const InsightItem(
        id: 'insight-proyeccion-empty',
        title: 'Proyección de Ahorro',
        description: 'Tasa de Ahorro: Registra tus ingresos y gastos para proyectar tu ahorro hacia tus fondos de inversión y metas.',
        icon: Icons.trending_up_rounded,
        categoryTag: 'Metas Financieras',
      ),
    );
  }

  return insights;
});
