import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/models/payment_method_model.dart';
import '../../../core/providers/stream_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../transactions/controllers/transaction_controller.dart';

/// Pantalla 4: Centro Estratégico (Ícono Tarjeta 💳)
/// Gestión de Medios de Pago y formulario inteligente para agregar nuevos medios.
class CardsScreen extends ConsumerStatefulWidget {
  const CardsScreen({super.key});

  @override
  ConsumerState<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends ConsumerState<CardsScreen> {
  final _nameController = TextEditingController();
  final _creditLimitController = TextEditingController();
  final _cutoffDateController = TextEditingController();
  final _paymentDateController = TextEditingController();

  String _selectedBank = 'Interbank';
  String _selectedType = 'credito'; // 'debito' | 'credito'

  final List<String> _banks = [
    'Interbank',
    'BCP',
    'BBVA',
    'Scotiabank',
    'BanBif',
    'Efectivo',
    '+ Agregar nuevo banco',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _creditLimitController.dispose();
    _cutoffDateController.dispose();
    _paymentDateController.dispose();
    super.dispose();
  }

  void _handleAddBankDialog() {
    final colors = context.appColors;
    final newBankCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.superficie,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Nuevo Banco',
          style: TextStyle(
            color: colors.textoPrimario,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: newBankCtrl,
          autofocus: true,
          style: TextStyle(color: colors.textoPrimario),
          decoration: InputDecoration(
            hintText: 'Nombre de la entidad...',
            fillColor: colors.fondo,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar', style: TextStyle(color: colors.textoSecundario)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.acento,
              foregroundColor: colors.fondo,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              final val = newBankCtrl.text.trim();
              if (val.isNotEmpty) {
                setState(() {
                  _banks.insert(_banks.length - 1, val);
                  _selectedBank = val;
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _showLiquidarModal(PaymentMethodItem card) {
    final colors = context.appColors;
    final cuentasDebito = ref.read(cuentasDebitoYEfectivoProvider).value ?? [];
    if (cuentasDebito.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No tienes cuentas de débito o efectivo para liquidar'),
          backgroundColor: colors.gasto,
        ),
      );
      return;
    }

    int selectedOrigenId = cuentasDebito.first.id;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: BoxDecoration(
            color: colors.fondo,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border(top: BorderSide(color: colors.superficie, width: 1.5)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              Text(
                'Liquidar Tarjeta',
                style: TextStyle(color: colors.textoPrimario, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Pagarás S/ ${card.usedAmount.toStringAsFixed(2)} a ${card.name}',
                style: TextStyle(color: colors.textoSecundario, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Text(
                'SELECCIONA CUENTA ORIGEN',
                style: TextStyle(color: colors.textoSecundario, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.superficie,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedOrigenId,
                    isExpanded: true,
                    dropdownColor: colors.superficie,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.textoPrimario),
                    style: TextStyle(color: colors.textoPrimario, fontSize: 14, fontWeight: FontWeight.w600),
                    items: cuentasDebito.map((c) {
                      return DropdownMenuItem(
                        value: c.id,
                        child: Text('${c.nombre} (${c.banco ?? c.tipo})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() => selectedOrigenId = val);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.acento,
                    foregroundColor: colors.fondo,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final cardId = int.tryParse(card.id);
                    if (cardId != null) {
                      await ref.read(transactionControllerProvider.notifier).liquidarTarjeta(
                        medioPagoOrigenId: selectedOrigenId,
                        medioPagoDestinoId: cardId,
                        monto: card.usedAmount,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Tarjeta ${card.name} liquidada exitosamente'),
                            backgroundColor: colors.superficie,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Confirmar Liquidación',
                    style: TextStyle(color: colors.fondo, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditPaymentMethodModal(PaymentMethodItem method) {
    final colors = context.appColors;
    final id = int.tryParse(method.id);
    if (id == null) return;

    final editNameCtrl = TextEditingController(text: method.name);
    String editSelectedBank = method.bank.isNotEmpty ? method.bank : 'Interbank';
    if (!_banks.contains(editSelectedBank) && editSelectedBank.isNotEmpty) {
      _banks.insert(_banks.length - 1, editSelectedBank);
    }

    String editSelectedType = method.isCredit ? 'credito' : (method.type.toLowerCase() == 'efectivo' ? 'efectivo' : 'debito');
    final editInitialBalanceCtrl = TextEditingController(
      text: method.initialBalance > 0 ? method.initialBalance.toStringAsFixed(2) : '',
    );
    final editCreditLimitCtrl = TextEditingController(
      text: method.creditLimit != null ? method.creditLimit!.toStringAsFixed(2) : '',
    );
    final editCutoffCtrl = TextEditingController(
      text: method.rawCutoffDay != null ? method.rawCutoffDay.toString() : '',
    );
    final editPaymentCtrl = TextEditingController(
      text: method.rawPaymentDay != null ? method.rawPaymentDay.toString() : '',
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: BoxDecoration(
            color: colors.fondo,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border(top: BorderSide(color: colors.superficie, width: 1.5)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Editar Medio de Pago',
                      style: TextStyle(
                        color: colors.textoPrimario,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: colors.textoSecundario),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // NOMBRE
                Text(
                  'NOMBRE',
                  style: TextStyle(color: colors.textoSecundario, fontSize: 12, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: editNameCtrl,
                  style: TextStyle(color: colors.textoPrimario),
                  decoration: InputDecoration(
                    hintText: 'Ej: Tarjeta Sueldo, Billetera...',
                    fillColor: colors.superficie,
                  ),
                ),

                const SizedBox(height: 16),

                // BANCO
                Text(
                  'BANCO / ENTIDAD',
                  style: TextStyle(color: colors.textoSecundario, fontSize: 12, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.superficie,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _banks.contains(editSelectedBank) ? editSelectedBank : _banks.first,
                      isExpanded: true,
                      dropdownColor: colors.superficie,
                      icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.textoPrimario),
                      style: TextStyle(color: colors.textoPrimario, fontSize: 14, fontWeight: FontWeight.w600),
                      items: _banks.map((b) {
                        final isSpecial = b.startsWith('+');
                        return DropdownMenuItem(
                          value: b,
                          child: Text(
                            b,
                            style: TextStyle(
                              color: isSpecial ? colors.acento : colors.textoPrimario,
                              fontWeight: isSpecial ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val == '+ Agregar nuevo banco') {
                          _handleAddBankDialog();
                        } else if (val != null) {
                          setModalState(() => editSelectedBank = val);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // TIPO
                Text(
                  'TIPO',
                  style: TextStyle(color: colors.textoSecundario, fontSize: 12, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => editSelectedType = 'debito'),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: editSelectedType == 'debito' ? colors.acento : colors.superficie,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Débito',
                            style: TextStyle(
                              color: editSelectedType == 'debito' ? colors.fondo : colors.textoPrimario,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => editSelectedType = 'credito'),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: editSelectedType == 'credito' ? colors.acento : colors.superficie,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Crédito',
                            style: TextStyle(
                              color: editSelectedType == 'credito' ? colors.fondo : colors.textoPrimario,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => editSelectedType = 'efectivo'),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: editSelectedType == 'efectivo' ? colors.acento : colors.superficie,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Efectivo',
                            style: TextStyle(
                              color: editSelectedType == 'efectivo' ? colors.fondo : colors.textoPrimario,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Campos condicionales según tipo
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: editSelectedType == 'credito'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              'LÍNEA DE CRÉDITO',
                              style: TextStyle(color: colors.textoSecundario, fontSize: 12, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: editCreditLimitCtrl,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: TextStyle(color: colors.textoPrimario),
                              decoration: InputDecoration(
                                hintText: 'S/ 5000.00',
                                fillColor: colors.superficie,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'DÍA DE CORTE (1-31)',
                                        style: TextStyle(color: colors.textoSecundario, fontSize: 11, fontWeight: FontWeight.w800),
                                      ),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: editCutoffCtrl,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(color: colors.textoPrimario),
                                        decoration: InputDecoration(
                                          hintText: 'Ej: 10',
                                          fillColor: colors.superficie,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'DÍA DE PAGO (1-31)',
                                        style: TextStyle(color: colors.textoSecundario, fontSize: 11, fontWeight: FontWeight.w800),
                                      ),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: editPaymentCtrl,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(color: colors.textoPrimario),
                                        decoration: InputDecoration(
                                          hintText: 'Ej: 15',
                                          fillColor: colors.superficie,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              'SALDO INICIAL',
                              style: TextStyle(color: colors.textoSecundario, fontSize: 12, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: editInitialBalanceCtrl,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: TextStyle(color: colors.textoPrimario),
                              decoration: InputDecoration(
                                hintText: 'S/ 0.00',
                                fillColor: colors.superficie,
                              ),
                            ),
                          ],
                        ),
                ),

                const SizedBox(height: 24),

                // Botón Guardar Cambios
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.acento,
                      foregroundColor: colors.fondo,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () async {
                      final newName = editNameCtrl.text.trim();
                      if (newName.isEmpty) return;

                      final isCred = editSelectedType == 'credito';
                      final limit = isCred ? double.tryParse(editCreditLimitCtrl.text) : null;
                      final cutoff = isCred ? int.tryParse(editCutoffCtrl.text.trim().replaceAll(RegExp(r'[^0-9]'), '')) : null;
                      final pay = isCred ? int.tryParse(editPaymentCtrl.text.trim().replaceAll(RegExp(r'[^0-9]'), '')) : null;
                      final saldo = !isCred ? (double.tryParse(editInitialBalanceCtrl.text) ?? 0.0) : 0.0;

                      final dbTipo = isCred ? 'crédito' : (editSelectedType == 'efectivo' ? 'efectivo' : 'débito');

                      Navigator.pop(ctx);
                      await ref.read(transactionControllerProvider.notifier).actualizarMedioPago(
                        id: id,
                        nombre: newName,
                        banco: editSelectedBank,
                        tipo: dbTipo,
                        saldoInicial: saldo,
                        lineaCredito: limit,
                        diaCorte: cutoff,
                        diaPago: pay,
                      );

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Medio "$newName" actualizado correctamente'),
                            backgroundColor: colors.superficie,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Guardar Cambios',
                      style: TextStyle(color: colors.fondo, fontSize: 15, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Botón Eliminar Medio
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.gasto,
                      side: BorderSide(color: colors.gasto.withValues(alpha: 0.5), width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    icon: Icon(Icons.delete_outline_rounded, size: 20, color: colors.gasto),
                    label: Text(
                      'Eliminar Medio de Pago',
                      style: TextStyle(color: colors.gasto, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (diagCtx) => AlertDialog(
                          backgroundColor: colors.superficie,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          title: Text(
                            '¿Eliminar medio de pago?',
                            style: TextStyle(color: colors.textoPrimario, fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            'Se ocultará "${method.name}" de tus cuentas. Tus transacciones pasadas se conservarán.',
                            style: TextStyle(color: colors.textoSecundario),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(diagCtx),
                              child: Text('Cancelar', style: TextStyle(color: colors.textoSecundario)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.gasto,
                                foregroundColor: colors.textoPrimario,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: () async {
                                Navigator.pop(diagCtx); // Cierra diálogo
                                Navigator.pop(ctx); // Cierra modal
                                await ref.read(transactionControllerProvider.notifier).desactivarMedioPago(id);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Medio "${method.name}" eliminado'),
                                      backgroundColor: colors.superficie,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              child: const Text('Eliminar', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegisterMethod() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final isCredit = _selectedType == 'credito';
    final limit = isCredit ? double.tryParse(_creditLimitController.text) : null;
    final cutoff = isCredit ? int.tryParse(_cutoffDateController.text.trim().replaceAll(RegExp(r'[^0-9]'), '')) : null;
    final payDate = isCredit ? int.tryParse(_paymentDateController.text.trim().replaceAll(RegExp(r'[^0-9]'), '')) : null;

    final companion = MediosPagoCompanion.insert(
      nombre: name,
      banco: drift.Value(_selectedBank),
      tipo: isCredit ? 'crédito' : (_selectedType == 'efectivo' ? 'efectivo' : 'débito'),
      saldoInicial: const drift.Value(0.0),
      lineaCredito: drift.Value(limit),
      diaCorte: drift.Value(cutoff),
      diaPago: drift.Value(payDate),
      activo: const drift.Value(true),
    );

    await ref.read(transactionControllerProvider.notifier).registrarMedioPago(companion);

    _nameController.clear();
    _creditLimitController.clear();
    _cutoffDateController.clear();
    _paymentDateController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Medio de pago "$name" registrado exitosamente'),
          backgroundColor: context.appColors.superficie,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final mediosAsync = ref.watch(todosLosMediosPagoProvider);

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
          'Medios de pago',
          style: TextStyle(
            color: colors.textoPrimario,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección 1: Título "Medios"
            Text(
              'Medios',
              style: TextStyle(
                color: colors.textoPrimario,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),

            // Tarjeta Superior de Medios Configurados con Riverpod Stream
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.superficie,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: colors.textoSecundario.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: mediosAsync.when(
                data: (methods) {
                  if (methods.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'No hay medios de pago registrados',
                          style: TextStyle(color: colors.textoSecundario),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: methods.length,
                    separatorBuilder: (ctx, i) => Divider(
                      color: colors.fondo.withValues(alpha: 0.4),
                      height: 24,
                    ),
                    itemBuilder: (ctx, i) {
                      final method = methods[i];
                      final isCreditWithDebt = method.isCredit && method.usedAmount > 0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            onTap: () => _showEditPaymentMethodModal(method),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                method.name,
                                                style: TextStyle(
                                                  color: colors.textoPrimario,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Icon(
                                              Icons.edit_outlined,
                                              size: 14,
                                              color: colors.textoSecundario.withValues(alpha: 0.6),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          method.isCredit
                                              ? 'pagar: ${method.paymentDate ?? "xx/xx"}'
                                              : method.type.toUpperCase(),
                                          style: TextStyle(
                                            color: colors.textoSecundario,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'S/ ${method.usedAmount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: colors.textoPrimario,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        method.isCredit ? 'usado' : 'disponible',
                                        style: TextStyle(
                                          color: colors.textoSecundario,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Botón Destacado "Liquidar S/ ..." para tarjetas de crédito con deuda
                          if (isCreditWithDebt) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 42,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.acento,
                                  foregroundColor: colors.fondo,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () => _showLiquidarModal(method),
                                icon: Icon(Icons.check_circle_outline_rounded, size: 18, color: colors.fondo),
                                label: Text(
                                  'Liquidar S/ ${method.usedAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: colors.fondo,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(color: colors.acento),
                  ),
                ),
                error: (e, st) => Center(
                  child: Icon(Icons.error_outline_rounded, color: colors.gasto, size: 28),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Sección 2: Registrar Medios
            Text(
              'Registrar Medios',
              style: TextStyle(
                color: colors.textoPrimario,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),

            // Tarjeta de Formulario Inteligente
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Campo Nombre
                  Text(
                    'NOMBRE',
                    style: TextStyle(
                      color: colors.textoSecundario,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    style: TextStyle(color: colors.textoPrimario),
                    decoration: InputDecoration(
                      hintText: 'Ej: Tarjeta Dorada, Billetera...',
                      fillColor: colors.fondo,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Selector Banco
                  Text(
                    'BANCO',
                    style: TextStyle(
                      color: colors.textoSecundario,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.fondo,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _banks.contains(_selectedBank) ? _selectedBank : _banks.first,
                        isExpanded: true,
                        dropdownColor: colors.superficie,
                        icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.textoPrimario),
                        style: TextStyle(color: colors.textoPrimario, fontSize: 14, fontWeight: FontWeight.w600),
                        items: _banks.map((b) {
                          final isSpecial = b.startsWith('+');
                          return DropdownMenuItem(
                            value: b,
                            child: Text(
                              b,
                              style: TextStyle(
                                color: isSpecial ? colors.acento : colors.textoPrimario,
                                fontWeight: isSpecial ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val == '+ Agregar nuevo banco') {
                            _handleAddBankDialog();
                          } else if (val != null) {
                            setState(() => _selectedBank = val);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Selector Tipo (Débito / Crédito)
                  Text(
                    'TIPO',
                    style: TextStyle(
                      color: colors.textoSecundario,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedType = 'debito'),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedType == 'debito' ? colors.acento : colors.fondo,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Débito',
                              style: TextStyle(
                                color: _selectedType == 'debito' ? colors.fondo : colors.textoPrimario,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedType = 'credito'),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedType == 'credito' ? colors.acento : colors.fondo,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Crédito',
                              style: TextStyle(
                                color: _selectedType == 'credito' ? colors.fondo : colors.textoPrimario,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Expansión fluida si es Crédito
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: _selectedType == 'credito'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                'LÍNEA DE CRÉDITO',
                                style: TextStyle(
                                  color: colors.textoSecundario,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _creditLimitController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                style: TextStyle(color: colors.textoPrimario),
                                decoration: InputDecoration(
                                  hintText: 'S/ 5000.00',
                                  fillColor: colors.fondo,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'FECHA DE CORTE',
                                          style: TextStyle(
                                            color: colors.textoSecundario,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        TextField(
                                          controller: _cutoffDateController,
                                          style: TextStyle(color: colors.textoPrimario),
                                          decoration: InputDecoration(
                                            hintText: 'DD/MM (Ej: 10/09)',
                                            fillColor: colors.fondo,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'FECHA DE PAGO',
                                          style: TextStyle(
                                            color: colors.textoSecundario,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        TextField(
                                          controller: _paymentDateController,
                                          style: TextStyle(color: colors.textoPrimario),
                                          decoration: InputDecoration(
                                            hintText: 'DD/MM (Ej: 15/09)',
                                            fillColor: colors.fondo,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 24),

                  // Botón Registrar Medio
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.acento,
                        foregroundColor: colors.fondo,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _handleRegisterMethod,
                      child: Text(
                        'Registrar',
                        style: TextStyle(
                          color: colors.fondo,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
