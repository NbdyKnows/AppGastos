import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/theme/app_theme.dart';

/// Menú lateral (Drawer) de Ajustes de la aplicación.
class SettingsDrawer extends ConsumerWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final hapticsEnabled = ref.watch(hapticsEnabledProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);

    return Drawer(
      backgroundColor: colors.fondo,
      child: SafeArea(
        top: false,
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
                    'v1.0.0',
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
          ],
        ),
      ),
    );
  }
}
