import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Utilitario global para mostrar SnackBars estilizados y consistentes en Kip.
///
/// Características:
/// - Flotante con bordes redondeados y márgenes compactos.
/// - Colores basados en el tema activo (sin colores hardcodeados).
/// - Incluye clearSnackBars() para evitar la acumulación de toasts.
///
/// IMPORTANTE: Siempre verificar [context.mounted] antes de llamar a este método
/// cuando la invocación ocurre después de operaciones asíncronas (await).
class KipSnackBar {
  /// Muestra un SnackBar flotante de feedback.
  ///
  /// [context] debe estar montado al momento de la llamada.
  /// Usar el patrón:
  /// ```dart
  /// await someAsyncOperation();
  /// if (!context.mounted) return;
  /// KipSnackBar.show(context, 'Guardado');
  /// ```
  ///
  /// [isError] → usa el color de error del tema (gastoColor).
  /// [duration] → por defecto 2 segundos (sutil, no invasivo).
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 2),
  }) {
    final colors = context.appColors;

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: isError ? Colors.white : colors.textoPrimario,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: isError
              ? colors.gastoColor.withValues(alpha: 0.92)
              : colors.superficie,
          behavior: SnackBarBehavior.floating,
          duration: duration,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isError
                ? BorderSide.none
                : BorderSide(
                    color: colors.textoSecundario.withValues(alpha: 0.15),
                    width: 1,
                  ),
          ),
          elevation: 4,
        ),
      );
  }
}
