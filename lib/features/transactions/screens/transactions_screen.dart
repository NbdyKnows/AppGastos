import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/providers/stream_providers.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_theme.dart';

/// Pantalla 2: Historial y Auditoría (Ícono Flechas ⇆)
/// Bitácora completa de "Movimientos Registrados" con filtros rápidos y agrupación por fecha.
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String _selectedFilter = 'Todos';
  final List<String> _filters = ['Todos', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];

  final Map<String, int> _monthMap = {
    'Enero': 1,
    'Febrero': 2,
    'Marzo': 3,
    'Abril': 4,
    'Mayo': 5,
    'Junio': 6,
    'Julio': 7,
    'Agosto': 8,
    'Septiembre': 9,
    'Octubre': 10,
    'Noviembre': 11,
    'Diciembre': 12,
  };

  void _openEdit(TransactionItem item) {
    AppRouter.toTransactionForm(
      context,
      isEditing: true,
      data: item,
    );
  }

  Map<String, List<TransactionItem>> _groupTransactions(List<TransactionItem> items) {
    final Map<String, List<TransactionItem>> grouped = {};
    final now = DateTime.now();

    for (final item in items) {
      String groupKey;
      final diffDays = now.difference(item.date).inDays;
      if (diffDays == 0 && item.date.day == now.day) {
        groupKey = 'Hoy - ${_formatDate(item.date)}';
      } else if (diffDays <= 1 && item.date.day == now.subtract(const Duration(days: 1)).day) {
        groupKey = 'Ayer - ${_formatDate(item.date)}';
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

    return Scaffold(
      backgroundColor: colors.fondo,
      appBar: AppBar(
        backgroundColor: colors.fondo,
        elevation: 0,
        leading: Icon(Icons.menu_rounded, color: colors.textoPrimario),
        title: Text(
          'Movimientos Registrados',
          style: TextStyle(
            color: colors.textoPrimario,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Carrusel de Filtros Rápidos (Chips de Mes)
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (ctx, i) => const SizedBox(width: 8),
              itemBuilder: (ctx, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return ChoiceChip(
                  label: Text(
                    filter,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedFilter = filter);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // 2. Lista de Movimientos Agrupados por Fecha con Riverpod Stream
          Expanded(
            child: historialAsync.when(
              data: (allList) {
                // Filtrado por mes seleccionado
                final filteredList = _selectedFilter == 'Todos'
                    ? allList
                    : allList.where((tx) => tx.date.month == _monthMap[_selectedFilter]).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No hay movimientos para este filtro',
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
                          // Cabecera de Grupo de Fecha
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

                          // Tarjeta con las transacciones de esa fecha
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
                                    style: TextStyle(
                                      color: colors.textoPrimario,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${tx.category} • ${tx.paymentMethod}',
                                    style: TextStyle(
                                      color: colors.textoSecundario,
                                      fontSize: 12,
                                    ),
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
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: colors.textoSecundario,
                                        size: 20,
                                      ),
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
              loading: () => Center(
                child: CircularProgressIndicator(color: colors.acento),
              ),
              error: (err, st) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded, color: colors.gasto, size: 36),
                    const SizedBox(height: 8),
                    Text(
                      'Error al cargar el historial',
                      style: TextStyle(color: colors.gasto, fontWeight: FontWeight.bold),
                    ),
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
