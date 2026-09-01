import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/database/daos/reportes_dao.dart';
import '../../../core/providers/report_providers.dart';

const _meses = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
];

class ExportService {
  /// Exporta las transacciones del mes a formato PDF y abre el diálogo nativo para compartir/imprimir.
  static Future<void> exportToPdf({
    required ReportesDao dao,
    required DateTime mes,
  }) async {
    final rango = calcularRangoMes(mes);
    final transacciones = await dao.getTransaccionesParaExportar(rango.inicio, rango.fin);
    final mesNombre = '${_meses[mes.month - 1]} ${mes.year}'.toUpperCase();
    final now = DateTime.now();
    final fechaGeneracion =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    double totalIngresos = 0.0;
    double totalGastos = 0.0;

    for (final t in transacciones) {
      if (t.tipo == 'ingreso') {
        totalIngresos += t.monto;
      } else if (t.tipo == 'gasto') {
        totalGastos += t.monto;
      }
    }
    final balanceNeto = totalIngresos - totalGastos;

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'KIP - REPORTE MENSUAL',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.teal900,
                    ),
                  ),
                  pw.Text(
                    mesNombre,
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blueGrey800,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Generado: $fechaGeneracion',
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
              ),
              pw.Divider(thickness: 1, color: PdfColors.grey400),
              pw.SizedBox(height: 8),
            ],
          );
        },
        build: (context) {
          return [
            // Resumen de Totales
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _buildPdfSummaryItem(
                    label: 'TOTAL INGRESOS',
                    value: 'S/ ${totalIngresos.toStringAsFixed(2)}',
                    color: PdfColors.green800,
                  ),
                  _buildPdfSummaryItem(
                    label: 'TOTAL GASTOS',
                    value: 'S/ ${totalGastos.toStringAsFixed(2)}',
                    color: PdfColors.red800,
                  ),
                  _buildPdfSummaryItem(
                    label: 'BALANCE NETO',
                    value: 'S/ ${balanceNeto.toStringAsFixed(2)}',
                    color: balanceNeto >= 0 ? PdfColors.blue800 : PdfColors.red900,
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Tabla de Transacciones
            if (transacciones.isEmpty)
              pw.Center(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(24),
                  child: pw.Text(
                    'No hay transacciones registradas en este periodo.',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontStyle: pw.FontStyle.italic,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              )
            else
              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 9,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.blueGrey800,
                ),
                cellStyle: const pw.TextStyle(fontSize: 8),
                cellAlignment: pw.Alignment.centerLeft,
                columnWidths: {
                  0: const pw.FixedColumnWidth(65), // Fecha
                  1: const pw.FixedColumnWidth(55), // Tipo
                  2: const pw.FixedColumnWidth(75), // Categoría
                  3: const pw.FlexColumnWidth(2),   // Detalle
                  4: const pw.FixedColumnWidth(75), // Medio de Pago
                  5: const pw.FixedColumnWidth(60), // Monto
                },
                headers: ['Fecha', 'Tipo', 'Categoría', 'Detalle / Nota', 'Medio de Pago', 'Monto'],
                data: transacciones.map((t) {
                  final fechaStr =
                      '${t.fecha.day.toString().padLeft(2, '0')}/${t.fecha.month.toString().padLeft(2, '0')}/${t.fecha.year.toString().substring(2)} '
                      '${t.fecha.hour.toString().padLeft(2, '0')}:${t.fecha.minute.toString().padLeft(2, '0')}';
                  final cuotasStr = (t.totalCuotas != null && t.totalCuotas! > 1)
                      ? ' [${t.numeroCuota}/${t.totalCuotas}]'
                      : '';
                  final detalle = '${t.nota ?? '-'}$cuotasStr';
                  final montoSign = t.tipo == 'ingreso' ? '+' : (t.tipo == 'gasto' ? '-' : '');
                  final montoStr = '$montoSign S/ ${t.monto.toStringAsFixed(2)}';

                  return [
                    fechaStr,
                    t.tipo.toUpperCase(),
                    t.categoria,
                    detalle,
                    t.medioPago,
                    montoStr,
                  ];
                }).toList(),
              ),
          ];
        },
      ),
    );

    final bytes = await pdf.save();
    final filename = 'reporte_gastos_${mes.year}_${mes.month.toString().padLeft(2, '0')}.pdf';
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }

  static pw.Widget _buildPdfSummaryItem({
    required String label,
    required String value,
    required PdfColor color,
  }) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Exporta las transacciones del mes a formato Excel (.xlsx) y lo comparte vía share_plus.
  static Future<void> exportToExcel({
    required ReportesDao dao,
    required DateTime mes,
  }) async {
    final rango = calcularRangoMes(mes);
    final transacciones = await dao.getTransaccionesParaExportar(rango.inicio, rango.fin);
    final mesNombre = '${_meses[mes.month - 1]} ${mes.year}'.toUpperCase();

    final excel = Excel.createExcel();
    final sheetName = 'Transacciones';
    excel.rename(excel.getDefaultSheet() ?? 'Sheet1', sheetName);
    final sheet = excel[sheetName];

    // Estilo de encabezados
    final headerStyle = CellStyle(
      bold: true,
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      backgroundColorHex: ExcelColor.fromHexString('#1E293B'),
      horizontalAlign: HorizontalAlign.Center,
    );

    // Fila 1: Título del Reporte
    final titleCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    titleCell.value = TextCellValue('KIP - REPORTE DE TRANSACCIONES ($mesNombre)');
    titleCell.cellStyle = CellStyle(bold: true, fontSize: 13);

    // Fila 3: Encabezados de la tabla
    final headers = [
      'ID',
      'Fecha',
      'Tipo',
      'Categoría',
      'Detalle / Nota',
      'Medio de Pago',
      'Cuota Actual',
      'Total Cuotas',
      'Monto (S/)',
    ];

    for (int col = 0; col < headers.length; col++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 2));
      cell.value = TextCellValue(headers[col]);
      cell.cellStyle = headerStyle;
    }

    double totalIngresos = 0.0;
    double totalGastos = 0.0;

    // Llenar datos
    int currentRow = 3;
    for (final t in transacciones) {
      if (t.tipo == 'ingreso') {
        totalIngresos += t.monto;
      } else if (t.tipo == 'gasto') {
        totalGastos += t.monto;
      }

      final fechaIso =
          '${t.fecha.year}-${t.fecha.month.toString().padLeft(2, '0')}-${t.fecha.day.toString().padLeft(2, '0')} '
          '${t.fecha.hour.toString().padLeft(2, '0')}:${t.fecha.minute.toString().padLeft(2, '0')}:${t.fecha.second.toString().padLeft(2, '0')}';

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow)).value = IntCellValue(t.id);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRow)).value = TextCellValue(fechaIso);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: currentRow)).value = TextCellValue(t.tipo);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: currentRow)).value = TextCellValue(t.categoria);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: currentRow)).value = TextCellValue(t.nota ?? '');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: currentRow)).value = TextCellValue(t.medioPago);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: currentRow)).value =
          t.numeroCuota != null ? IntCellValue(t.numeroCuota!) : TextCellValue('-');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: currentRow)).value =
          t.totalCuotas != null ? IntCellValue(t.totalCuotas!) : TextCellValue('-');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: currentRow)).value = DoubleCellValue(t.monto);

      currentRow++;
    }

    // Fila de resumen
    currentRow++;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: currentRow)).value =
        TextCellValue('Total Ingresos:');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: currentRow)).value =
        DoubleCellValue(totalIngresos);

    currentRow++;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: currentRow)).value =
        TextCellValue('Total Gastos:');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: currentRow)).value =
        DoubleCellValue(totalGastos);

    currentRow++;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: currentRow)).value =
        TextCellValue('Balance Neto:');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: currentRow)).value =
        DoubleCellValue(totalIngresos - totalGastos);

    // Guardar archivo temporalmente y compartir
    final fileBytes = excel.save();
    if (fileBytes == null) {
      throw Exception('No se pudo codificar el archivo Excel.');
    }

    final tempDir = await getTemporaryDirectory();
    final filename = 'reporte_gastos_${mes.year}_${mes.month.toString().padLeft(2, '0')}.xlsx';
    final filePath = '${tempDir.path}/$filename';
    final file = File(filePath);
    await file.writeAsBytes(fileBytes, flush: true);

    await Share.shareXFiles(
      [XFile(filePath)],
      text: 'Reporte de Transacciones - Kip ($mesNombre)',
    );
  }
}
