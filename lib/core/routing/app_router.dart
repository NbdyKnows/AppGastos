import 'package:flutter/material.dart';
import '../../features/transactions/screens/transaction_form_screen.dart';
import '../models/transaction_model.dart';

/// Enrutador Centralizado y Fuertemente Tipado para navegación sin librerías externas.
class AppRouter {
  AppRouter._();

  /// Navega a la pantalla de formulario de transacciones (modo nuevo o edición).
  static Future<T?> toTransactionForm<T>(
    BuildContext context, {
    bool isEditing = false,
    TransactionItem? data,
    ValueChanged<TransactionItem>? onSave,
    ValueChanged<String>? onDelete,
  }) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute<T>(
        builder: (ctx) => TransactionFormScreen(
          isEditing: isEditing,
          initialData: data,
          onSave: onSave,
          onDelete: onDelete,
        ),
      ),
    );
  }

  /// Cierra la pantalla o modal actual con un resultado opcional.
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }
}
