import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/daos/reportes_dao.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/providers/report_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../services/export_service.dart';

const _meses = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
];

/// Pantalla 5: Analíticas y Reportes (Ícono Gráfico 📊)
/// Conectada a Riverpod y Drift para Data Storytelling interactivo, Smart Insights dinámicos y Exportación.
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _chartTabController;
  final PageController _pageController = PageController();
  int _currentInsightPage = 0;
  int _touchedPieIndex = -1;
  bool _isExporting = false;
  String? _exportingType;

  // Lista de los últimos 12 meses para el selector
  late final List<DateTime> _mesesDisponibles;

  @override
  void initState() {
    super.initState();
    _chartTabController = TabController(length: 2, vsync: this);
    _chartTabController.addListener(() {
      if (mounted) setState(() => _touchedPieIndex = -1);
    });

    final now = DateTime.now();
    _mesesDisponibles = List.generate(12, (index) {
      return DateTime(now.year, now.month - index, 1);
    });
  }

  @override
  void dispose() {
    _chartTabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Color _parseHexColor(String hexString, Color fallback) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return fallback;
    }
  }

  String _formatMonthLabel(DateTime date) {
    final now = DateTime.now();
    final mesStr = '${_meses[date.month - 1]} ${date.year}';

    if (date.year == now.year && date.month == now.month) {
      return '$mesStr (Este Mes)';
    }
    final mesAnterior = DateTime(now.year, now.month - 1, 1);
    if (date.year == mesAnterior.year && date.month == mesAnterior.month) {
      return '$mesStr (Mes Anterior)';
    }
    return mesStr;
  }

  Future<void> _handleExport(String format) async {
    if (_isExporting) return;

    setState(() {
      _isExporting = true;
      _exportingType = format;
    });

    try {
      final dao = ref.read(reportesDaoProvider);
      final mesSeleccionado = ref.read(mesSeleccionadoProvider);

      if (format == 'PDF') {
        await ExportService.exportToPdf(dao: dao, mes: mesSeleccionado);
      } else if (format == 'Excel' || format == 'XLSX' || format == 'XLSM') {
        await ExportService.exportToExcel(dao: dao, mes: mesSeleccionado);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reporte $format exportado con éxito.'),
            backgroundColor: context.appColors.acento,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al exportar reporte: $e'),
            backgroundColor: context.appColors.gasto,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
          _exportingType = null;
        });
      }
    }
  }

  void _showSearchDialog() {
    final colors = context.appColors;
    final searchCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.superficie,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(Icons.search_rounded, color: colors.acento),
            const SizedBox(width: 8),
            Text(
              'Buscar Movimientos',
              style: TextStyle(color: colors.textoPrimario, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: TextField(
          controller: searchCtrl,
          autofocus: true,
          style: TextStyle(color: colors.textoPrimario),
          decoration: InputDecoration(
            hintText: 'Buscar por categoría, método o monto...',
            fillColor: colors.fondo,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cerrar', style: TextStyle(color: colors.textoSecundario)),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildCategorySections(
    List<CategoriaGastoData> items,
    double totalGastos,
    AppColors colors,
  ) {
    if (items.isEmpty || totalGastos <= 0) {
      return [
        PieChartSectionData(
          color: colors.textoSecundario.withValues(alpha: 0.2),
          value: 1,
          radius: 50,
          showTitle: false,
        ),
      ];
    }

    final defaultColors = [
      colors.acento,
      colors.gasto,
      colors.ingreso,
      colors.textoSecundario,
      const Color(0xFFAB47BC),
      const Color(0xFF26A69A),
      const Color(0xFFFF7043),
    ];

    return List.generate(items.length, (i) {
      final item = items[i];
      final isTouched = i == _touchedPieIndex;
      final radius = isTouched ? 65.0 : 55.0;
      final pct = (item.totalGasto / totalGastos) * 100;
      final sliceColor = _parseHexColor(item.colorHex, defaultColors[i % defaultColors.length]);

      return PieChartSectionData(
        color: sliceColor,
        value: item.totalGasto,
        title: pct >= 5 ? '${pct.toInt()}%' : '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 15 : 12,
          fontWeight: FontWeight.w900,
          color: sliceColor == colors.acento ? colors.fondo : Colors.white,
        ),
      );
    });
  }

  List<PieChartSectionData> _buildMethodSections(
    List<MedioPagoGastoData> items,
    double totalGastos,
    AppColors colors,
  ) {
    if (items.isEmpty || totalGastos <= 0) {
      return [
        PieChartSectionData(
          color: colors.textoSecundario.withValues(alpha: 0.2),
          value: 1,
          radius: 50,
          showTitle: false,
        ),
      ];
    }

    final methodPalette = [
      colors.acento,
      colors.ingreso,
      colors.gasto,
      const Color(0xFF42A5F5),
      const Color(0xFFFFA726),
      const Color(0xFFAB47BC),
    ];

    return List.generate(items.length, (i) {
      final item = items[i];
      final isTouched = i == _touchedPieIndex;
      final radius = isTouched ? 65.0 : 55.0;
      final pct = (item.totalGasto / totalGastos) * 100;
      final sliceColor = methodPalette[i % methodPalette.length];

      return PieChartSectionData(
        color: sliceColor,
        value: item.totalGasto,
        title: pct >= 5 ? '${pct.toInt()}%' : '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 15 : 12,
          fontWeight: FontWeight.w900,
          color: sliceColor == colors.acento ? colors.fondo : Colors.white,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final mesSeleccionado = ref.watch(mesSeleccionadoProvider);

    final gastosCatAsync = ref.watch(gastosPorCategoriaProvider);
    final gastosMedioAsync = ref.watch(gastosPorMedioPagoProvider);
    final insightsList = ref.watch(smartInsightsProvider);

    final categorias = gastosCatAsync.value ?? [];
    final medios = gastosMedioAsync.value ?? [];

    final totalGastosCategorias = categorias.fold<double>(0.0, (sum, item) => sum + item.totalGasto);
    final totalGastosMedios = medios.fold<double>(0.0, (sum, item) => sum + item.totalGasto);
    final totalGastosPeriodo = _chartTabController.index == 0 ? totalGastosCategorias : totalGastosMedios;

    final methodPalette = [
      colors.acento,
      colors.ingreso,
      colors.gasto,
      const Color(0xFF42A5F5),
      const Color(0xFFFFA726),
      const Color(0xFFAB47BC),
    ];

    return Scaffold(
      backgroundColor: colors.fondo,
      appBar: AppBar(
        backgroundColor: colors.fondo,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(Icons.menu_rounded, color: colors.textoPrimario),
            tooltip: 'Ajustes',
            onPressed: () => ctx.findRootAncestorStateOfType<ScaffoldState>()?.openDrawer(),
          ),
        ),
        title: Text(
          'Reportes',
          style: TextStyle(
            color: colors.textoPrimario,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: colors.textoPrimario),
            tooltip: 'Buscar Movimientos',
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Cabecera de Filtros: Dropdown de Meses & Total Gasto Real
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.superficie,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colors.textoSecundario.withValues(alpha: 0.15),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DateTime>(
                      value: _mesesDisponibles.firstWhere(
                        (m) => m.year == mesSeleccionado.year && m.month == mesSeleccionado.month,
                        orElse: () => _mesesDisponibles.first,
                      ),
                      dropdownColor: colors.superficie,
                      icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.acento),
                      style: TextStyle(
                        color: colors.textoPrimario,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      items: _mesesDisponibles.map((m) {
                        return DropdownMenuItem<DateTime>(
                          value: m,
                          child: Text(_formatMonthLabel(m)),
                        );
                      }).toList(),
                      onChanged: (DateTime? nuevoMes) {
                        if (nuevoMes != null) {
                          ref.read(mesSeleccionadoProvider.notifier).state = nuevoMes;
                          setState(() => _touchedPieIndex = -1);
                        }
                      },
                    ),
                  ),
                ),
                Text(
                  'Total: ${formatearMoneda(totalGastosPeriodo)}',
                  style: TextStyle(
                    color: colors.textoSecundario,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 2. Gráfico Principal (fl_chart) con Selector Segmentado y Colores HEX
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: colors.superficie,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: colors.textoSecundario.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Selector Segmentado de Gráfico
                  Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: colors.fondo,
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: TabBar(
                      controller: _chartTabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: colors.acento,
                        borderRadius: BorderRadius.circular(17),
                      ),
                      dividerColor: Colors.transparent,
                      labelColor: colors.fondo,
                      unselectedLabelColor: colors.textoSecundario,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      tabs: const [
                        Tab(text: 'Por Categoría'),
                        Tab(text: 'Por Método de Pago'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Gráfico PieChart con soporte Empty State
                  SizedBox(
                    height: 190,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    _touchedPieIndex = -1;
                                    return;
                                  }
                                  _touchedPieIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: totalGastosPeriodo > 0 ? 3 : 0,
                            centerSpaceRadius: 42,
                            sections: _chartTabController.index == 0
                                ? _buildCategorySections(categorias, totalGastosCategorias, colors)
                                : _buildMethodSections(medios, totalGastosMedios, colors),
                          ),
                        ),
                        if (totalGastosPeriodo <= 0)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.pie_chart_outline_rounded, color: colors.textoSecundario.withValues(alpha: 0.6), size: 28),
                              const SizedBox(height: 2),
                              Text(
                                'Sin gastos',
                                style: TextStyle(
                                  color: colors.textoSecundario,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Leyenda Dinámica basada en datos reales
                  if (_chartTabController.index == 0)
                    if (categorias.isEmpty || totalGastosCategorias <= 0)
                      Text(
                        'No hay gastos por categoría en este mes',
                        style: TextStyle(color: colors.textoSecundario, fontSize: 12),
                      )
                    else
                      Wrap(
                        spacing: 14,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: List.generate(categorias.length, (i) {
                          final item = categorias[i];
                          final pct = (item.totalGasto / totalGastosCategorias) * 100;
                          final color = _parseHexColor(item.colorHex, colors.acento);
                          return _buildLegendItem(
                            color,
                            '${item.nombre} (${pct.toStringAsFixed(0)}% - S/ ${item.totalGasto.toStringAsFixed(0)})',
                            colors,
                          );
                        }),
                      )
                  else
                    if (medios.isEmpty || totalGastosMedios <= 0)
                      Text(
                        'No hay gastos por medio de pago en este mes',
                        style: TextStyle(color: colors.textoSecundario, fontSize: 12),
                      )
                    else
                      Wrap(
                        spacing: 14,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: List.generate(medios.length, (i) {
                          final item = medios[i];
                          final pct = (item.totalGasto / totalGastosMedios) * 100;
                          final color = methodPalette[i % methodPalette.length];
                          return _buildLegendItem(
                            color,
                            '${item.nombre} (${pct.toStringAsFixed(0)}% - S/ ${item.totalGasto.toStringAsFixed(0)})',
                            colors,
                          );
                        }),
                      ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. Tarjetas Deslizables (Smart Insights) - PageView Horizontal Reactivo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Smart Insights',
                  style: TextStyle(
                    color: colors.textoPrimario,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                // Indicador de Puntos (Dots Indicator)
                Row(
                  children: List.generate(insightsList.length, (i) {
                    final isCurrent = i == _currentInsightPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(left: 5),
                      width: isCurrent ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isCurrent ? colors.acento : colors.textoSecundario.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Contenedor PageView de Insights
            SizedBox(
              height: 155,
              child: PageView.builder(
                controller: _pageController,
                itemCount: insightsList.length,
                onPageChanged: (idx) => setState(() => _currentInsightPage = idx),
                itemBuilder: (ctx, i) {
                  final item = insightsList[i];
                  return Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors.superficie,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: colors.textoSecundario.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colors.acento.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(item.icon, color: colors.acento, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      color: colors.textoPrimario,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    item.categoryTag,
                                    style: TextStyle(
                                      color: colors.textoSecundario,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.description,
                          style: TextStyle(
                            color: colors.textoPrimario,
                            fontSize: 13,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // 4. Sección de Exportación (PDF & Excel)
            Text(
              'Exportar Reporte',
              style: TextStyle(
                color: colors.textoPrimario,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildExportButton(
                    title: 'PDF',
                    icon: Icons.picture_as_pdf_rounded,
                    colors: colors,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildExportButton(
                    title: 'Excel',
                    icon: Icons.table_chart_rounded,
                    colors: colors,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color dotColor, String label, AppColors colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: colors.textoSecundario,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildExportButton({
    required String title,
    required IconData icon,
    required AppColors colors,
  }) {
    final isThisExporting = _isExporting && _exportingType == title;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.textoPrimario,
        side: BorderSide(
          color: colors.textoSecundario.withValues(alpha: 0.3),
          width: 1.2,
        ),
        backgroundColor: colors.superficie,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: _isExporting ? null : () => _handleExport(title),
      child: isThisExporting
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(colors.acento),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: colors.acento),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: colors.textoPrimario,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
    );
  }
}
