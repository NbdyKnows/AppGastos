import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/transaction_model.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/stream_providers.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../transactions/controllers/transaction_controller.dart';

/// Modal de Registro Rápido "Fricción Cero".
/// Se despliega desde el FAB central '+' y permite registrar gastos/ingresos en segundos.
class QuickRecordModal extends ConsumerStatefulWidget {
  final ValueChanged<TransactionItem>? onTransactionCreated;

  const QuickRecordModal({super.key, this.onTransactionCreated});

  static Future<TransactionItem?> show(
    BuildContext context, {
    ValueChanged<TransactionItem>? onTransactionCreated,
  }) {
    return showModalBottomSheet<TransactionItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => QuickRecordModal(
        onTransactionCreated: onTransactionCreated,
      ),
    );
  }

  @override
  ConsumerState<QuickRecordModal> createState() => _QuickRecordModalState();
}

class _QuickRecordModalState extends ConsumerState<QuickRecordModal> {
  bool _isExpense = true;
  final TextEditingController _amountController = TextEditingController();
  int? _selectedMethodId;
  String? _selectedMethodName;
  String? _selectedMethodType;
  int? _selectedCategoryId;
  String _selectedCategoryName = 'Comidas';
  int _installments = 1;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  bool get _isCredit => _selectedMethodType == 'crédito';

  void _handleRegister() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ingresa un monto válido mayor a 0'),
          backgroundColor: context.appColors.gasto,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final medioId = _selectedMethodId;
    if (medioId == null) return;

    ref.read(transactionControllerProvider.notifier).registrarMovimiento(
      monto: amount,
      fecha: DateTime.now(),
      tipo: _isExpense ? 'gasto' : 'ingreso',
      medioPagoId: medioId,
      categoriaId: _selectedCategoryId,
      cuotas: _isCredit ? _installments : 1,
      nota: _selectedCategoryName,
    );
  }

  void _handleMoreOptions() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final draft = TransactionItem(
      id: 'tx-${DateTime.now().millisecondsSinceEpoch}',
      title: _selectedCategoryName,
      category: _selectedCategoryName,
      amount: amount,
      isExpense: _isExpense,
      date: DateTime.now(),
      paymentMethod: _selectedMethodName ?? 'Efectivo',
      installments: _isCredit ? _installments : 1,
    );

    AppRouter.pop(context); // Cierra modal
    AppRouter.toTransactionForm(
      context,
      isEditing: false,
      data: draft,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final categoriasAsync = ref.watch(categoriasListProvider);
    final mediosAsync = ref.watch(mediosPagoListProvider);

    // Escuchar el TransactionController para manejo de error y navegación en éxito
    ref.listen<AsyncValue<void>>(transactionControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar: ${next.error}'),
            backgroundColor: colors.gasto,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (previous is AsyncLoading && next is AsyncData) {
        AppRouter.pop(context);
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: colors.fondo,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: colors.superficie, width: 1.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: bottomInset + 16,
          left: 20,
          right: 20,
          top: 12,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barra de arrastre superior
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colors.textoSecundario.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 1. Selector Ingreso / Gasto
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.superficie,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isExpense = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _isExpense ? colors.gasto : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Gasto',
                            style: TextStyle(
                              color: colors.textoPrimario,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isExpense = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !_isExpense ? colors.ingreso : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Ingreso',
                            style: TextStyle(
                              color: colors.textoPrimario,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Campo de Monto con Autofoco y Tipografía Lemon Cash
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: colors.superficie,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'S/ ',
                      style: TextStyle(
                        color: colors.textoPrimario,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        autofocus: true,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: TextStyle(
                          color: colors.textoPrimario,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                        ),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: TextStyle(
                            color: colors.textoSecundario.withValues(alpha: 0.5),
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 3. Selector de Método de Pago y Cuotas Condicionales
              mediosAsync.when(
                data: (mediosList) {
                  if (mediosList.isNotEmpty && _selectedMethodId == null) {
                    _selectedMethodId = mediosList.first.id;
                    _selectedMethodName = mediosList.first.nombre;
                    _selectedMethodType = mediosList.first.tipo;
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.superficie,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _selectedMethodId ?? (mediosList.isNotEmpty ? mediosList.first.id : null),
                              isExpanded: true,
                              dropdownColor: colors.superficie,
                              icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.textoPrimario),
                              style: TextStyle(color: colors.textoPrimario, fontSize: 14, fontWeight: FontWeight.w600),
                              items: mediosList.map((m) {
                                return DropdownMenuItem(
                                  value: m.id,
                                  child: Text(m.nombre),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  final selected = mediosList.firstWhere((m) => m.id == val);
                                  setState(() {
                                    _selectedMethodId = val;
                                    _selectedMethodName = selected.nombre;
                                    _selectedMethodType = selected.tipo;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      // Si es crédito: Selector de cuotas al lado
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: _isCredit
                            ? Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: colors.superficie,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: _installments > 1
                                            ? () => setState(() => _installments--)
                                            : null,
                                        child: Icon(
                                          Icons.remove_circle_outline_rounded,
                                          size: 20,
                                          color: _installments > 1 ? colors.acento : colors.textoSecundario,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          '$_installments c.',
                                          style: TextStyle(
                                            color: colors.textoPrimario,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _installments < 24
                                            ? () => setState(() => _installments++)
                                            : null,
                                        child: Icon(
                                          Icons.add_circle_outline_rounded,
                                          size: 20,
                                          color: colors.acento,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (e, st) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 14),

              // 4. Píldoras de Contexto (Categorías Reales de la BD)
              categoriasAsync.when(
                data: (categorias) {
                  if (categorias.isNotEmpty && _selectedCategoryId == null) {
                    _selectedCategoryId = categorias.first.id;
                    _selectedCategoryName = categorias.first.nombre;
                  }

                  return SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categorias.length,
                      separatorBuilder: (ctx, i) => const SizedBox(width: 8),
                      itemBuilder: (ctx, i) {
                        final cat = categorias[i];
                        final isSelected = _selectedCategoryId == cat.id;
                        return GestureDetector(
                          onTap: () {
                            if (ref.read(hapticsEnabledProvider)) {
                              HapticFeedback.lightImpact();
                            }
                            setState(() {
                              _selectedCategoryId = cat.id;
                              _selectedCategoryName = cat.nombre;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? colors.acento : colors.superficie,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                cat.nombre,
                                style: TextStyle(
                                  color: isSelected ? colors.fondo : colors.textoPrimario,
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (e, st) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 20),

              // 5. Botón Enorme de Registrar
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.acento,
                    foregroundColor: colors.fondo,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: _handleRegister,
                  child: Text(
                    'Registrar',
                    style: TextStyle(
                      color: colors.fondo,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),

              // 6. Válvula de Escape: "Más opciones..."
              Center(
                child: TextButton(
                  onPressed: _handleMoreOptions,
                  style: TextButton.styleFrom(
                    foregroundColor: colors.textoSecundario,
                  ),
                  child: Text(
                    'Más opciones...',
                    style: TextStyle(
                      color: colors.textoSecundario,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: colors.textoSecundario,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
