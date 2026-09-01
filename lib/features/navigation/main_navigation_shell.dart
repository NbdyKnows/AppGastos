import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/theme/app_theme.dart';
import '../cards/screens/cards_screen.dart';
import '../home/screens/home_screen.dart';
import '../quick_record/quick_record_modal.dart';
import '../reports/screens/reports_screen.dart';
import '../settings/widgets/settings_drawer.dart';
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
      drawer: const SettingsDrawer(),
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
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        color: colors.superficie,
        elevation: 12,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              // Lado Izquierdo: Inicio y Movimientos
              Expanded(
                child: _buildNavIcon(
                  index: 0,
                  icon: Icons.home_rounded,
                  label: 'Inicio',
                  colors: colors,
                ),
              ),
              Expanded(
                child: _buildNavIcon(
                  index: 1,
                  icon: Icons.swap_horiz_rounded,
                  label: 'Movimientos',
                  colors: colors,
                ),
              ),

              // Espacio central perfectamente dimensionado para el FAB
              const SizedBox(width: 52),

              // Lado Derecho: Medios y Reportes
              Expanded(
                child: _buildNavIcon(
                  index: 2,
                  icon: Icons.credit_card_rounded,
                  label: 'Medios',
                  colors: colors,
                ),
              ),
              Expanded(
                child: _buildNavIcon(
                  index: 3,
                  icon: Icons.bar_chart_rounded,
                  label: 'Reportes',
                  colors: colors,
                ),
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
    final color = isSelected ? colors.acento : colors.textoSecundario;

    return InkWell(
      onTap: () {
        if (_currentIndex != index) {
          if (ref.read(hapticsEnabledProvider)) {
            try {
              HapticFeedback.selectionClick();
            } catch (_) {}
          }
          setState(() => _currentIndex = index);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Indicador superior de pestaña activa estilo Interbank
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: isSelected ? 26 : 0,
            decoration: BoxDecoration(
              color: isSelected ? colors.acento : Colors.transparent,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(3)),
            ),
          ),
          const Spacer(),
          Icon(
            icon,
            size: 22,
            color: color,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
