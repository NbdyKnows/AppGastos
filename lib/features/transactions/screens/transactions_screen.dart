import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/providers/stream_providers.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_theme.dart';

/// Pantalla 2: Historial y Auditoría — "Movimientos Registrados"
/// Incluye timeline dinámico de meses extraído de la BD, con scroll posicionado
/// en el mes más reciente y manejo correcto de zona horaria.
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  /// null = mostrar todos los movimientos
  DateTime? _selectedMonth;
  final ScrollController _chipScrollController = ScrollController();
  bool _hasScrolledToEnd = false;

  @override
  void dispose() {
    _chipScrollController.dispose();
    super.dispose();
  }

  void _openEdit(TransactionItem item) {
    AppRouter.toTransactionForm(context, isEditing: true, data: item);
  }

  /// Nombre de mes para el chip. Si es el año actual → "Sep". Si es año pasado → "Dic 2025".
  String _labelForMonth(DateTime month) {
    const meses = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    final label = meses[month.month - 1];
    return month.year == DateTime.now().year ? label : '$label ${month.year}';
  }

  Map<String, List<TransactionItem>> _groupTransactions(List<TransactionItem> items) {
    final Map<String, List<TransactionItem>> grouped = {};
    final now = DateTime.now();

    for (final item in items) {
      String groupKey;
      final diffDays = now.difference(item.date).inDays;
      if (diffDays == 0 && item.date.day == now.day) {
        groupKey = 'Hoy — ${_formatDate(item.date)}';
      } else if (diffDays <= 1 && item.date.day == now.subtract(const Duration(days: 1)).day) {
        groupKey = 'Ayer — ${_formatDate(item.date)}';
      } else {
        groupKey = _formatDate(item.date);
      }
      grouped.putIfAbsent(groupKey, () => []).add(item);
    }
    return grouped;
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year.toString().substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final historialAsync = ref.watch(historialMovimientosProvider);
    final mesesAsync = ref.watch(mesesConMovimientosProvider);

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
          'Movimientos Registrados',
          style: TextStyle(color: colors.textoPrimario, fontWeight: FontWeight.w800, fontSize: 20),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Timeline dinámico de meses ─────────────────────────────────────
          SizedBox(
            height: 44,
            child: mesesAsync.when(
              data: (meses) {
                // Scroll al extremo derecho (mes más reciente) la primera vez que carga
                if (!_hasScrolledToEnd && meses.isNotEmpty) {
                  _hasScrolledToEnd = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_chipScrollController.hasClients) {
                      _chipScrollController.jumpTo(_chipScrollController.position.maxScrollExtent);
                    }
                  });
                }

                // Los meses llegan en orden DESC (más reciente primero).
                // Invertimos para mostrar cronológico de izquierda a derecha.
                final ordenados = meses.reversed.toList();
                // Total de chips: "Todos" + un chip por mes + posibles separadores de año
                final items = <_ChipItem>[_ChipItem.todos()];
                int? lastYear;
                for (final mes in ordenados) {
                  if (lastYear != null && mes.year != lastYear) {
                    items.add(_ChipItem.yearSeparator(mes.year));
                  }
                  items.add(_ChipItem.month(mes));
                  lastYear = mes.year;
                }

                return ListView.separated(
                  controller: _chipScrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (ctx, i) => const SizedBox(width: 6),
                  itemBuilder: (ctx, index) {
                    final item = items[index];

                    // Separador de año
                    if (item.isSeparator) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.superficie,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${item.year}',
                            style: TextStyle(
                              color: colors.textoSecundario,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      );
                    }

                    // Chip "Todos"
                    if (item.isTodos) {
                      final isSelected = _selectedMonth == null;
                      return ChoiceChip(
                        label: Text(
                          'Todos',
                          style: TextStyle(
                            color: isSelected ? colors.fondo : colors.textoPrimario,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: colors.acento,
                        backgroundColor: colors.superficie,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        onSelected: (_) => setState(() => _selectedMonth = null),
                      );
                    }

                    // Chip de mes
                    final mes = item.month!;
                    final isSelected = _selectedMonth?.year == mes.year && _selectedMonth?.month == mes.month;
                    return ChoiceChip(
                      label: Text(
                        _labelForMonth(mes),
                        style: TextStyle(
                          color: isSelected ? colors.fondo : colors.textoPrimario,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: colors.acento,
                      backgroundColor: colors.superficie,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      onSelected: (val) {
                        if (val) setState(() => _selectedMonth = mes);
                      },
                    );
                  },
                );
              },
              loading: () => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  ChoiceChip(
                    label: const Text('Todos'),
                    selected: true,
                    onSelected: (_) {},
                  ),
                ],
              ),
              error: (err, st) => const SizedBox.shrink(),
            ),
          ),

          const SizedBox(height: 12),

          // ── Lista de Movimientos ───────────────────────────────────────────
          Expanded(
            child: historialAsync.when(
              data: (allList) {
                final filteredList = _selectedMonth == null
                    ? allList
                    : allList.where((tx) =>
                        tx.date.year == _selectedMonth!.year &&
                        tx.date.month == _selectedMonth!.month).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No hay movimientos para este período',
                        style: TextStyle(color: colors.textoSecundario, fontSize: 14),
                      ),
                    ),
                  );
                }

                final groupedData = _groupTransactions(filteredList);

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: groupedData.keys.length,
                  itemBuilder: (ctx, groupIndex) {
                    final groupKey = groupedData.keys.elementAt(groupIndex);
                    final txList = groupedData[groupKey]!;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: Text(
                              groupKey,
                              style: TextStyle(
                                color: colors.textoSecundario,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          Material(
                            color: colors.superficie,
                            borderRadius: BorderRadius.circular(28),
                            clipBehavior: Clip.antiAlias,
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: txList.length,
                              separatorBuilder: (ctx, i) => Divider(
                                color: colors.fondo.withValues(alpha: 0.5),
                                height: 1,
                                indent: 20,
                                endIndent: 20,
                              ),
                              itemBuilder: (ctx, i) {
                                final tx = txList[i];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: (tx.isExpense ? colors.gasto : colors.ingreso).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      tx.isExpense ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                                      color: tx.isExpense ? colors.gasto : colors.ingreso,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    tx.title,
                                    style: TextStyle(color: colors.textoPrimario, fontWeight: FontWeight.w700, fontSize: 15),
                                  ),
                                  subtitle: Text(
                                    '${tx.category} • ${tx.paymentMethod}',
                                    style: TextStyle(color: colors.textoSecundario, fontSize: 12),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${tx.isExpense ? '-' : '+'} S/ ${tx.amount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: tx.isExpense ? colors.textoPrimario : colors.ingreso,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(Icons.chevron_right_rounded, color: colors.textoSecundario, size: 20),
                                    ],
                                  ),
                                  onTap: () => _openEdit(tx),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator(color: colors.acento)),
              error: (err, st) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded, color: colors.gasto, size: 36),
                    const SizedBox(height: 8),
                    Text('Error al cargar el historial', style: TextStyle(color: colors.gasto, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Modelo de ítem del timeline ──────────────────────────────────────────────

class _ChipItem {
  final DateTime? month;
  final int? year;
  final bool isTodos;
  final bool isSeparator;

  const _ChipItem._({this.month, this.year, this.isTodos = false, this.isSeparator = false});

  factory _ChipItem.todos() => const _ChipItem._(isTodos: true);
  factory _ChipItem.month(DateTime m) => _ChipItem._(month: m);
  factory _ChipItem.yearSeparator(int y) => _ChipItem._(year: y, isSeparator: true);
}
