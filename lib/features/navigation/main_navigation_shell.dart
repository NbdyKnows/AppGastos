import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/theme/app_theme.dart';
import '../cards/screens/cards_screen.dart';
import '../home/screens/home_screen.dart';
import '../quick_record/quick_record_modal.dart';
import '../reports/screens/reports_screen.dart';
import '../transactions/screens/transactions_screen.dart';

/// Shell de Navegación Principal de la Aplicación.
/// Utiliza IndexedStack para preservar el estado y scroll de todas las vistas,
/// y un BottomAppBar con muesca circular (Notch) y FloatingActionButton central prominente.
class MainNavigationShell extends ConsumerStatefulWidget {
  const MainNavigationShell({super.key});

  @override
  ConsumerState<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends ConsumerState<MainNavigationShell> {
  int _currentIndex = 0;

  void _openQuickRecordModal() {
    if (ref.read(hapticsEnabledProvider)) {
      HapticFeedback.lightImpact();
    }
    QuickRecordModal.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    // Pantallas mantenidas en IndexedStack para preservar estado y scroll
    const screens = [
      HomeScreen(),
      TransactionsScreen(),
      CardsScreen(),
      ReportsScreen(),
    ];

    return Scaffold(
      backgroundColor: colors.fondo,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openQuickRecordModal,
        backgroundColor: colors.acento,
        elevation: 4,
        shape: const CircleBorder(),
        child: Icon(
          Icons.add_rounded,
          color: colors.fondo,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: colors.superficie,
        elevation: 12,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Lado Izquierdo: Inicio y Historial
              Row(
                children: [
                  _buildNavIcon(
                    index: 0,
                    icon: Icons.home_rounded,
                    label: 'Inicio',
                    colors: colors,
                  ),
                  const SizedBox(width: 8),
                  _buildNavIcon(
                    index: 1,
                    icon: Icons.swap_horiz_rounded,
                    label: 'Historial',
                    colors: colors,
                  ),
                ],
              ),

              // Espacio central para el botón FAB recortado
              const SizedBox(width: 48),

              // Lado Derecho: Medios y Reportes
              Row(
                children: [
                  _buildNavIcon(
                    index: 2,
                    icon: Icons.credit_card_rounded,
                    label: 'Medios',
                    colors: colors,
                  ),
                  const SizedBox(width: 8),
                  _buildNavIcon(
                    index: 3,
                    icon: Icons.bar_chart_rounded,
                    label: 'Reportes',
                    colors: colors,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon({
    required int index,
    required IconData icon,
    required String label,
    required AppColors colors,
  }) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? colors.acento : colors.textoSecundario,
            ),
          ],
        ),
      ),
    );
  }
}
