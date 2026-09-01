import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/providers/stream_providers.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/kip_snackbar.dart';
import '../../cards/widgets/payment_method_picker_sheet.dart';
import '../../categories/widgets/category_manager_sheet.dart';
import '../controllers/transaction_controller.dart';

/// Pantalla de Formulario Detallado reutilizable tanto para Modo Creación como Modo Edición.
class TransactionFormScreen extends ConsumerStatefulWidget {
  final bool isEditing;
  final TransactionItem? initialData;
  final ValueChanged<TransactionItem>? onSave;
  final ValueChanged<String>? onDelete;

  const TransactionFormScreen({
    super.key,
    this.isEditing = false,
    this.initialData,
    this.onSave,
    this.onDelete,
  });

  @override
  ConsumerState<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  late bool _isExpense;
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  int? _selectedCategoryId;
  String? _selectedCategoryName;
  int? _selectedPaymentMethodId;
  String? _selectedPaymentMethodName;
  String? _selectedPaymentMethodType;
  late DateTime _selectedDate;
  late int _installments;

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    _isExpense = data?.isExpense ?? true;
    _titleController = TextEditingController(text: data?.title ?? '');
    _amountController = TextEditingController(
      text: data != null ? data.amount.toStringAsFixed(2) : '',
    );
    _notesController = TextEditingController(text: data?.notes ?? '');
    _selectedCategoryName = data?.category;
    _selectedPaymentMethodName = data?.paymentMethod;
    _selectedDate = data?.date ?? DateTime.now();
    _installments = data?.installments ?? 1;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _isCreditMethod =>
      _selectedPaymentMethodType == 'crédito' ||
      (_selectedPaymentMethodName != null &&
          (_selectedPaymentMethodName!.toLowerCase().contains('crédito') ||
              _selectedPaymentMethodName!.toLowerCase().contains('credito')));

  Future<void> _pickDate() async {
    final colors = context.appColors;
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: colors.acento,
              onPrimary: colors.fondo,
              surface: colors.superficie,
              onSurface: colors.textoPrimario,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: colors.fondo,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _handleDelete() {
    final colors = context.appColors;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.superficie,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          '¿Eliminar movimiento?',
          style: TextStyle(
            color: colors.textoPrimario,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Esta acción no se puede deshacer.',
          style: TextStyle(color: colors.textoSecundario),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancelar',
              style: TextStyle(color: colors.textoSecundario),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.gasto,
              foregroundColor: colors.textoPrimario,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx); // Cierra diálogo
              final idStr = widget.initialData?.id;
              if (idStr != null) {
                final id = int.tryParse(idStr);
                if (id != null) {
                  ref.read(transactionControllerProvider.notifier).eliminarMovimiento(id);
                } else {
                  widget.onDelete?.call(idStr);
                  AppRouter.pop(context);
                }
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _handleSave() {
    final parsedAmount = double.tryParse(_amountController.text) ?? 0.0;
    if (parsedAmount <= 0) {
      KipSnackBar.show(context, 'Ingresa un monto válido mayor a 0', isError: true);
      return;
    }

    final medioId = _selectedPaymentMethodId;
    if (medioId == null) {
      KipSnackBar.show(context, 'Selecciona un medio de pago', isError: true);
      return;
    }

    ref.read(transactionControllerProvider.notifier).registrarMovimiento(
      monto: parsedAmount,
      fecha: _selectedDate,
      tipo: _isExpense ? 'gasto' : 'ingreso',
      medioPagoId: medioId,
      // Fix: nunca enviar categoría si es ingreso
      categoriaId: _isExpense ? _selectedCategoryId : null,
      nota: _titleController.text.trim().isNotEmpty
          ? _titleController.text.trim()
          : (_isExpense ? _selectedCategoryName : 'Ingreso'),
      cuotas: _isCreditMethod ? _installments : 1,
    );

    widget.onSave?.call(
      TransactionItem(
        id: widget.initialData?.id ?? 'tx-${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim().isEmpty
            ? (_isExpense ? (_selectedCategoryName ?? 'Gasto') : 'Ingreso')
            : _titleController.text.trim(),
        category: _isExpense ? (_selectedCategoryName ?? 'General') : 'Ingreso',
        amount: parsedAmount,
        isExpense: _isExpense,
        date: _selectedDate,
        paymentMethod: _selectedPaymentMethodName ?? 'Efectivo',
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        installments: _isCreditMethod ? _installments : 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final categoriasAsync = ref.watch(categoriasListProvider);
    final mediosAsync = ref.watch(mediosPagoListProvider);

    // Escuchar el TransactionController para manejo de error y navegación en éxito
    ref.listen<AsyncValue<void>>(transactionControllerProvider, (previous, next) {
      if (next.hasError) {
        if (!context.mounted) return;
        KipSnackBar.show(context, 'Error al procesar: ${next.error}', isError: true);
      } else if (previous is AsyncLoading && next is AsyncData) {
        if (!context.mounted) return;
        KipSnackBar.show(context, 'Movimiento guardado ✓');
        AppRouter.pop(context);
      }
    });

    final formattedDate =
        '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}';

    return Scaffold(
      backgroundColor: colors.fondo,
      appBar: AppBar(
        backgroundColor: colors.fondo,
        title: Text(
          widget.isEditing ? 'Editar Movimiento' : 'Nuevo Movimiento',
          style: TextStyle(
            color: colors.textoPrimario,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.textoPrimario),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (widget.isEditing)
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: colors.gasto),
              tooltip: 'Eliminar Movimiento',
              onPressed: _handleDelete,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Selector Tipo: Ingreso / Gasto
              Container(
                decoration: BoxDecoration(
                  color: colors.superficie,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isExpense = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isExpense ? colors.gasto : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Gasto',
                            style: TextStyle(
                              color: colors.textoPrimario,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _isExpense = false;
                          _selectedCategoryId = null;
                          _selectedCategoryName = null;
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isExpense ? colors.ingreso : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Ingreso',
                            style: TextStyle(
                              color: colors.textoPrimario,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 2. Monto con Tipografía Gigante Lemon Cash
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: colors.superficie,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MONTO',
                      style: TextStyle(
                        color: colors.textoSecundario,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
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
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. Título / Concepto
              Text(
                'CONCEPTO',
                style: TextStyle(
                  color: colors.textoSecundario,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: TextStyle(color: colors.textoPrimario),
                decoration: InputDecoration(
                  hintText: 'Ej: Almuerzo, Uber, Sueldo...',
                  fillColor: colors.superficie,
                ),
              ),

              // 4. Píldoras de Categoría — Ocultas completamente en Modo Ingreso
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: _isExpense
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'CATEGORÍA',
                            style: TextStyle(
                              color: colors.textoSecundario,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          categoriasAsync.when(
                            data: (categorias) {
                              if (categorias.isNotEmpty && _selectedCategoryId == null && _isExpense) {
                                final match = categorias.firstWhere(
                                  (c) => _selectedCategoryName != null && c.nombre.toLowerCase().contains(_selectedCategoryName!.toLowerCase()),
                                  orElse: () => categorias.first,
                                );
                                _selectedCategoryId = match.id;
                                _selectedCategoryName = match.nombre;
                              }

                              return Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ...categorias.map((cat) {
                                    final isSelected = _selectedCategoryId == cat.id;
                                    return ChoiceChip(
                                      label: Text(
                                        cat.nombre,
                                        style: TextStyle(
                                          color: isSelected ? colors.fondo : colors.textoPrimario,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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
                                        if (val) {
                                          if (ref.read(hapticsEnabledProvider)) {
                                            HapticFeedback.lightImpact();
                                          }
                                          setState(() {
                                            _selectedCategoryId = cat.id;
                                            _selectedCategoryName = cat.nombre;
                                          });
                                        }
                                      },
                                    );
                                  }),
                                  // Chip para gestionar o crear nueva categoría
                                  ActionChip(
                                    avatar: Icon(Icons.add_rounded, size: 16, color: colors.acento),
                                    label: Text(
                                      'Nueva',
                                      style: TextStyle(
                                        color: colors.acento,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    backgroundColor: colors.superficie,
                                    side: BorderSide(
                                      color: colors.acento.withValues(alpha: 0.35),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    onPressed: () => CategoryManagerSheet.show(context),
                                  ),
                                ],
                              );
                            },
                            loading: () => const SizedBox.shrink(),
                            error: (e, st) => const SizedBox.shrink(),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 20),

              // 5. Método de Pago
              Text(
                'MÉTODO DE PAGO',
                style: TextStyle(
                  color: colors.textoSecundario,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              mediosAsync.when(
                data: (medios) {
                  if (medios.isNotEmpty && _selectedPaymentMethodId == null) {
                    final match = medios.firstWhere(
                      (m) => _selectedPaymentMethodName != null && m.nombre.toLowerCase().contains(_selectedPaymentMethodName!.toLowerCase()),
                      orElse: () => medios.first,
                    );
                    _selectedPaymentMethodId = match.id;
                    _selectedPaymentMethodName = match.nombre;
                    _selectedPaymentMethodType = match.tipo;
                  }

                  return GestureDetector(
                    onTap: () {
                      PaymentMethodPickerSheet.show(
                        context: context,
                        medios: medios,
                        selectedId: _selectedPaymentMethodId ?? (medios.isNotEmpty ? medios.first.id : null),
                        onSelected: (selected) {
                          setState(() {
                            _selectedPaymentMethodId = selected.id;
                            _selectedPaymentMethodName = selected.nombre;
                            _selectedPaymentMethodType = selected.tipo;
                          });
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: colors.superficie,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isCreditMethod ? Icons.credit_card_rounded : Icons.account_balance_wallet_rounded,
                            size: 20,
                            color: colors.acento,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedPaymentMethodName != null
                                  ? '$_selectedPaymentMethodName (${_selectedPaymentMethodType ?? "Cuenta"})'
                                  : (medios.isNotEmpty ? '${medios.first.nombre} (${medios.first.banco ?? medios.first.tipo})' : 'Selecciona medio'),
                              style: TextStyle(
                                color: colors.textoPrimario,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded, color: colors.textoSecundario, size: 22),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (e, st) => const SizedBox.shrink(),
              ),

              // 6. Selector de Cuotas (Animado si es Crédito)
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: _isCreditMethod
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: colors.superficie,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CUOTAS',
                                    style: TextStyle(
                                      color: colors.textoSecundario,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    'Plan de financiamiento',
                                    style: TextStyle(
                                      color: colors.textoSecundario.withValues(alpha: 0.8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: _installments > 1
                                        ? () => setState(() => _installments--)
                                        : null,
                                    icon: Icon(
                                      Icons.remove_circle_outline_rounded,
                                      color: _installments > 1 ? colors.acento : colors.textoSecundario,
                                    ),
                                  ),
                                  Text(
                                    '$_installments',
                                    style: TextStyle(
                                      color: colors.textoPrimario,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _installments < 36
                                        ? () => setState(() => _installments++)
                                        : null,
                                    icon: Icon(
                                      Icons.add_circle_outline_rounded,
                                      color: colors.acento,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 20),

              // 7. Selector de Fecha
              Text(
                'FECHA',
                style: TextStyle(
                  color: colors.textoSecundario,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: colors.superficie,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: colors.textoPrimario,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(Icons.calendar_today_rounded, color: colors.acento, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 8. Notas Adicionales
              Text(
                'NOTAS ADICIONALES',
                style: TextStyle(
                  color: colors.textoSecundario,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 3,
                style: TextStyle(color: colors.textoPrimario),
                decoration: InputDecoration(
                  hintText: 'Detalles opcionales sobre esta transacción...',
                  fillColor: colors.superficie,
                ),
              ),

              const SizedBox(height: 32),

              // 9. Botón Principal
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.acento,
                    foregroundColor: colors.fondo,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: _handleSave,
                  child: Text(
                    widget.isEditing ? 'Guardar cambios' : 'Agregar Movimiento',
                    style: TextStyle(
                      color: colors.fondo,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
