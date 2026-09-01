import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../transactions/controllers/transaction_controller.dart';

/// Menú lateral (Drawer) de Ajustes de la aplicación.
class SettingsDrawer extends ConsumerWidget {
  const SettingsDrawer({super.key});

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.superficie,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Borrar datos de prueba',
          style: TextStyle(
            color: colors.textoPrimario,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar todas las transacciones registradas? Tus cuentas y categorías base se mantendrán intactas.',
          style: TextStyle(color: colors.textoSecundario, fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar', style: TextStyle(color: colors.textoSecundario)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.gasto,
              foregroundColor: colors.textoPrimario,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () async {
              Navigator.pop(ctx); // Cierra diálogo
              Navigator.pop(context); // Cierra Drawer
              await ref.read(transactionControllerProvider.notifier).wipeAllData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Datos de prueba eliminados correctamente'),
                    backgroundColor: colors.superficie,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Borrar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required WidgetRef ref,
    required String name,
    required String currentSelected,
    required Color accentColor,
    required Color surfaceColor,
    required AppColors colors,
  }) {
    final isSelected = currentSelected.toLowerCase() == name.toLowerCase();

    return InkWell(
      onTap: () {
        ref.read(selectedThemePaletteProvider.notifier).state = name;
        if (ref.read(hapticsEnabledProvider)) {
          try {
            HapticFeedback.selectionClick();
          } catch (_) {}
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.acento.withValues(alpha: 0.15)
              : colors.superficie,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.acento : colors.textoSecundario.withValues(alpha: 0.2),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor,
                border: Border.all(color: surfaceColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: isSelected ? colors.textoPrimario : colors.textoSecundario,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, size: 16, color: colors.acento),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final hapticsEnabled = ref.watch(hapticsEnabledProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final selectedPalette = ref.watch(selectedThemePaletteProvider);

    return Drawer(
      backgroundColor: colors.fondo,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: colors.superficie,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Ajustes',
                      style: TextStyle(
                        color: colors.textoPrimario,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'v1.1.0',
                      style: TextStyle(
                        color: colors.textoSecundario,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                secondary: Icon(Icons.vibration, color: colors.acento),
                title: Text(
                  'Vibración y Haptics',
                  style: TextStyle(
                    color: colors.textoPrimario,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                value: hapticsEnabled,
                activeThumbColor: colors.acento,
                activeTrackColor: colors.acento.withValues(alpha: 0.5),
                onChanged: (val) {
                  ref.read(hapticsEnabledProvider.notifier).state = val;
                },
              ),
              SwitchListTile(
                secondary: Icon(Icons.dark_mode, color: colors.acento),
                title: Text(
                  'Modo Oscuro',
                  style: TextStyle(
                    color: colors.textoPrimario,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                value: isDarkMode,
                activeThumbColor: colors.acento,
                activeTrackColor: colors.acento.withValues(alpha: 0.5),
                onChanged: (val) {
                  ref.read(isDarkModeProvider.notifier).state = val;
                },
              ),

              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'PALETA DE COLORES',
                  style: TextStyle(
                    color: colors.textoSecundario,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.2,
                  children: [
                    _buildThemeOption(
                      context: context,
                      ref: ref,
                      name: 'Lemon',
                      currentSelected: selectedPalette,
                      accentColor: const Color(0xFFFFF3B0),
                      surfaceColor: const Color(0xFF1B2A41),
                      colors: colors,
                    ),
                    _buildThemeOption(
                      context: context,
                      ref: ref,
                      name: 'Dracula',
                      currentSelected: selectedPalette,
                      accentColor: const Color(0xFFFF79C6),
                      surfaceColor: const Color(0xFF282A36),
                      colors: colors,
                    ),
                    _buildThemeOption(
                      context: context,
                      ref: ref,
                      name: 'Emerald',
                      currentSelected: selectedPalette,
                      accentColor: const Color(0xFF34D399),
                      surfaceColor: const Color(0xFF122C24),
                      colors: colors,
                    ),
                    _buildThemeOption(
                      context: context,
                      ref: ref,
                      name: 'Indigo',
                      currentSelected: selectedPalette,
                      accentColor: const Color(0xFF818CF8),
                      surfaceColor: const Color(0xFF1E293B),
                      colors: colors,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Divider(color: colors.textoSecundario.withValues(alpha: 0.2), indent: 16, endIndent: 16),
              const SizedBox(height: 8),
              ListTile(
                leading: Icon(Icons.delete_sweep_rounded, color: colors.gasto),
                title: Text(
                  'Borrar datos de prueba',
                  style: TextStyle(
                    color: colors.gasto,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  'Vaciar historial de movimientos',
                  style: TextStyle(
                    color: colors.textoSecundario,
                    fontSize: 12,
                  ),
                ),
                onTap: () => _showClearDataDialog(context, ref),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
