import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/database/database.dart';
import '../../../core/theme/app_theme.dart';

/// BottomSheet moderno y estilizado para selección de medio de pago en Kip.
/// Elimina los menús emergentes flotantes cuadrados (DropdownButton) y proporciona
/// una experiencia táctil tipo fintech con íconos, subtítulos y feedback háptico.
class PaymentMethodPickerSheet extends StatelessWidget {
  final List<MedioPago> medios;
  final int? selectedId;
  final ValueChanged<MedioPago> onSelected;

  const PaymentMethodPickerSheet({
    super.key,
    required this.medios,
    required this.selectedId,
    required this.onSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required List<MedioPago> medios,
    required int? selectedId,
    required ValueChanged<MedioPago> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => PaymentMethodPickerSheet(
        medios: medios,
        selectedId: selectedId,
        onSelected: onSelected,
      ),
    );
  }

  IconData _getIconForType(String tipo) {
    final t = tipo.toLowerCase();
    if (t.contains('crédito') || t.contains('credito')) {
      return Icons.credit_card_rounded;
    } else if (t.contains('débito') || t.contains('debito') || t.contains('banco')) {
      return Icons.account_balance_rounded;
    }
    return Icons.account_balance_wallet_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.fondo,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: colors.superficie, width: 1.5)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 14,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Barra de arrastre
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.textoSecundario.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Medio de Pago',
            style: TextStyle(
              color: colors.textoPrimario,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Selecciona la cuenta o tarjeta para este movimiento',
            style: TextStyle(
              color: colors.textoSecundario,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: medios.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) {
              final m = medios[i];
              final isSelected = m.id == selectedId;
              final iconData = _getIconForType(m.tipo);

              return InkWell(
                onTap: () {
                  try {
                    HapticFeedback.selectionClick();
                  } catch (_) {}
                  onSelected(m);
                  Navigator.pop(ctx);
                },
                borderRadius: BorderRadius.circular(18),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.acento.withValues(alpha: 0.15)
                        : colors.superficie,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected ? colors.acento : colors.textoSecundario.withValues(alpha: 0.1),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected ? colors.acento : colors.fondo,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          iconData,
                          size: 20,
                          color: isSelected ? colors.fondo : colors.textoPrimario,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.nombre,
                              style: TextStyle(
                                color: colors.textoPrimario,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              m.banco != null && m.banco!.isNotEmpty
                                  ? '${m.tipo.toUpperCase()} • ${m.banco}'
                                  : m.tipo.toUpperCase(),
                              style: TextStyle(
                                color: colors.textoSecundario,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check_circle_rounded, color: colors.acento, size: 22),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
