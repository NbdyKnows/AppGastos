import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/providers/theme_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/kip_snackbar.dart';
import '../../transactions/controllers/transaction_controller.dart';

/// Menú lateral (Drawer) de Ajustes de Kip.
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
          style: TextStyle(color: colors.textoPrimario, fontWeight: FontWeight.bold),
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
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);   // Cierra diálogo
              Navigator.pop(context); // Cierra Drawer
              await ref.read(transactionControllerProvider.notifier).wipeAllData();
              // Fix 1: verificar mounted antes de mostrar SnackBar post-async
              if (!context.mounted) return;
              KipSnackBar.show(context, 'Historial eliminado');
            },
            child: const Text('Borrar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ─── Theme Overflow Modal ─────────────────────────────────────────────────

  void _openThemeManager(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ThemeManagerSheet(parentRef: ref),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final hapticsEnabled = ref.watch(hapticsEnabledProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final selectedPalette = ref.watch(selectedThemePaletteProvider);
    final selectedFont = ref.watch(fontFamilyProvider);
    final themesAsync = ref.watch(allThemesProvider);

    return Drawer(
      backgroundColor: colors.fondo,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header compacto
              Container(
                color: colors.superficie,
                padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ajustes',
                      style: TextStyle(
                        color: colors.textoPrimario,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'Kip v1.2',
                          style: TextStyle(
                            color: colors.textoSecundario,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'v1.1.0',
                          style: TextStyle(
                            color: colors.textoSecundario.withValues(alpha: 0.4),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // Toggles compactos
              SwitchListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                secondary: Icon(Icons.vibration, color: colors.acento, size: 20),
                title: Text(
                  'Vibración y Haptics',
                  style: TextStyle(color: colors.textoPrimario, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                value: hapticsEnabled,
                activeThumbColor: colors.acento,
                activeTrackColor: colors.acento.withValues(alpha: 0.5),
                onChanged: (val) => ref.read(hapticsEnabledProvider.notifier).state = val,
              ),
              SwitchListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                secondary: Icon(Icons.dark_mode, color: colors.acento, size: 20),
                title: Text(
                  'Modo Oscuro',
                  style: TextStyle(color: colors.textoPrimario, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                value: isDarkMode,
                activeThumbColor: colors.acento,
                activeTrackColor: colors.acento.withValues(alpha: 0.5),
                onChanged: (val) => ref.read(isDarkModeProvider.notifier).state = val,
              ),

              const SizedBox(height: 8),

              // ── PALETA DE COLORES ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'PALETA DE COLORES',
                  style: TextStyle(
                    color: colors.textoSecundario,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              // Burbujas de temas (máximo 4 visibles + "···" de overflow)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: themesAsync.when(
                  data: (themes) {
                    // Filtrar por variante activa (Dark o Light) para no mostrar duplicados
                    final variant = isDarkMode ? 'Dark' : 'Light';
                    final filtered = themes
                        .where((t) => t.name.endsWith(variant) || (!t.name.contains('Dark') && !t.name.contains('Light')))
                        .toList();

                    // Extraer paleta base: "Lemon Dark" → "Lemon"
                    String paletteOf(AppThemeEntry t) {
                      return t.name
                          .replaceAll(' Dark', '')
                          .replaceAll(' Light', '')
                          .trim();
                    }

                    final visible = filtered.take(4).toList();
                    final hasOverflow = filtered.length > 4;

                    return Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        ...visible.map((theme) {
                          final palette = paletteOf(theme);
                          final isSelected = selectedPalette == palette || selectedPalette == theme.name;
                          final accentColor = AppColors.parseHexColor(theme.accentHex);
                          final surfaceColor = AppColors.parseHexColor(theme.surfaceHex);
                          return _ThemeBubble(
                            name: palette,
                            accentColor: accentColor,
                            surfaceColor: surfaceColor,
                            isSelected: isSelected,
                            onTap: () {
                              ref.read(selectedThemePaletteProvider.notifier).state = palette;
                              if (ref.read(hapticsEnabledProvider)) {
                                try { HapticFeedback.selectionClick(); } catch (_) {}
                              }
                            },
                          );
                        }),
                        if (hasOverflow)
                          _ThemeBubble(
                            name: '···',
                            accentColor: colors.textoSecundario,
                            surfaceColor: colors.superficie,
                            isSelected: false,
                            isOverflow: true,
                            onTap: () => _openThemeManager(context, ref),
                          ),
                        if (!hasOverflow)
                          _ThemeBubble(
                            name: '+ Nuevo',
                            accentColor: colors.acento,
                            surfaceColor: colors.superficie,
                            isSelected: false,
                            isOverflow: true,
                            onTap: () => _openThemeManager(context, ref),
                          ),
                      ],
                    );
                  },
                  loading: () => const SizedBox(height: 30),
                  error: (error, stack) => const SizedBox.shrink(),
                ),
              ),

              const SizedBox(height: 10),

              // ── TIPOGRAFÍA ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'TIPOGRAFÍA',
                  style: TextStyle(
                    color: colors.textoSecundario,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: AppTheme.availableFonts.map((font) {
                    final isSelected = selectedFont == font;
                    return GestureDetector(
                      onTap: () {
                        ref.read(fontFamilyProvider.notifier).state = font;
                        if (ref.read(hapticsEnabledProvider)) {
                          try { HapticFeedback.selectionClick(); } catch (_) {}
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.acento.withValues(alpha: 0.15)
                              : colors.superficie,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? colors.acento : colors.textoSecundario.withValues(alpha: 0.2),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              font,
                              style: TextStyle(
                                fontFamily: font,
                                color: isSelected ? colors.textoPrimario : colors.textoSecundario,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 4),
                              Icon(Icons.check_circle_rounded, size: 12, color: colors.acento),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 8),
              Divider(color: colors.textoSecundario.withValues(alpha: 0.2), indent: 16, endIndent: 16),
              const SizedBox(height: 4),

              // Borrar datos
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: Icon(Icons.delete_sweep_rounded, color: colors.gasto, size: 22),
                title: Text(
                  'Borrar datos de prueba',
                  style: TextStyle(color: colors.gasto, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                subtitle: Text(
                  'Vaciar historial de movimientos',
                  style: TextStyle(color: colors.textoSecundario, fontSize: 11),
                ),
                onTap: () => _showClearDataDialog(context, ref),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Burbuja de Tema ──────────────────────────────────────────────────────────

class _ThemeBubble extends StatelessWidget {
  final String name;
  final Color accentColor;
  final Color surfaceColor;
  final bool isSelected;
  final bool isOverflow;
  final VoidCallback onTap;

  const _ThemeBubble({
    required this.name,
    required this.accentColor,
    required this.surfaceColor,
    required this.isSelected,
    required this.onTap,
    this.isOverflow = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.acento.withValues(alpha: 0.15)
              : colors.superficie,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.acento : colors.textoSecundario.withValues(alpha: 0.2),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isOverflow)
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor,
                  border: Border.all(color: surfaceColor, width: 1.5),
                ),
              ),
            if (!isOverflow) const SizedBox(width: 5),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? colors.textoPrimario : colors.textoSecundario,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 12,
              ),
            ),
            if (isSelected && !isOverflow) ...[
              const SizedBox(width: 4),
              Icon(Icons.check_circle_rounded, size: 12, color: colors.acento),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Modal de Gestión de Temas ────────────────────────────────────────────────

class _ThemeManagerSheet extends ConsumerStatefulWidget {
  final WidgetRef parentRef;
  const _ThemeManagerSheet({required this.parentRef});

  @override
  ConsumerState<_ThemeManagerSheet> createState() => _ThemeManagerSheetState();
}

class _ThemeManagerSheetState extends ConsumerState<_ThemeManagerSheet> {
  bool _showCreateForm = false;
  final _nameCtrl = TextEditingController();
  final _bgCtrl = TextEditingController(text: '#');
  final _surfaceCtrl = TextEditingController(text: '#');
  final _textCtrl = TextEditingController(text: '#');
  final _accentCtrl = TextEditingController(text: '#');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bgCtrl.dispose();
    _surfaceCtrl.dispose();
    _textCtrl.dispose();
    _accentCtrl.dispose();
    super.dispose();
  }

  Future<void> _createTheme() async {
    final name = _nameCtrl.text.trim();
    final bg = _bgCtrl.text.trim();
    final surface = _surfaceCtrl.text.trim();
    final text = _textCtrl.text.trim();
    final accent = _accentCtrl.text.trim();

    if (name.isEmpty || bg.length < 4 || surface.length < 4 || text.length < 4 || accent.length < 4) {
      if (!mounted) return;
      KipSnackBar.show(context, 'Completa todos los campos HEX', isError: true);
      return;
    }

    final dao = ref.read(themesDaoProvider);
    final exists = await dao.themeNameExists(name);
    if (!mounted) return;

    if (exists) {
      KipSnackBar.show(context, 'Ya existe un tema con ese nombre', isError: true);
      return;
    }

    await dao.insertTheme(AppThemesCompanion.insert(
      name: name,
      backgroundHex: bg,
      surfaceHex: surface,
      textHex: text,
      accentHex: accent,
      isCustom: const Value(true),
    ));

    if (!mounted) return;
    KipSnackBar.show(context, 'Tema "$name" creado');
    setState(() => _showCreateForm = false);
  }

  Future<void> _deleteTheme(AppThemeEntry theme) async {
    // Fix 3: Si el tema a borrar es el activo, cambiar a Lemon primero
    final currentPalette = ref.read(selectedThemePaletteProvider);
    final themePalette = theme.name.replaceAll(' Dark', '').replaceAll(' Light', '').trim();
    if (currentPalette == themePalette || currentPalette == theme.name) {
      ref.read(selectedThemePaletteProvider.notifier).state = 'Lemon';
    }

    final dao = ref.read(themesDaoProvider);
    await dao.deleteTheme(theme.id);

    if (!mounted) return;
    KipSnackBar.show(context, 'Tema eliminado');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final themesAsync = ref.watch(allThemesProvider);
    final selectedPalette = ref.watch(selectedThemePaletteProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.fondo,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 20, right: 20, top: 12,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40, height: 5,
                decoration: BoxDecoration(
                  color: colors.textoSecundario.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Temas',
                  style: TextStyle(color: colors.textoPrimario, fontSize: 20, fontWeight: FontWeight.w800),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _showCreateForm = !_showCreateForm),
                  icon: Icon(_showCreateForm ? Icons.close : Icons.add, size: 18, color: colors.acento),
                  label: Text(
                    _showCreateForm ? 'Cancelar' : '+ Crear tema',
                    style: TextStyle(color: colors.acento, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Formulario de creación
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _showCreateForm
                  ? _CreateThemeForm(
                      nameCtrl: _nameCtrl,
                      bgCtrl: _bgCtrl,
                      surfaceCtrl: _surfaceCtrl,
                      textCtrl: _textCtrl,
                      accentCtrl: _accentCtrl,
                      colors: colors,
                      onSave: _createTheme,
                    )
                  : const SizedBox.shrink(),
            ),

            // Lista de temas
            themesAsync.when(
              data: (themes) => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: themes.length,
                separatorBuilder: (separatorContext, index) => Divider(
                  color: colors.textoSecundario.withValues(alpha: 0.15),
                  height: 1,
                ),
                itemBuilder: (ctx, i) {
                  final theme = themes[i];
                  final palette = theme.name.replaceAll(' Dark', '').replaceAll(' Light', '').trim();
                  final isSelected = selectedPalette == palette || selectedPalette == theme.name;
                  final accentColor = AppColors.parseHexColor(theme.accentHex);

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    leading: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.parseHexColor(theme.backgroundHex),
                        border: Border.all(color: accentColor, width: 2.5),
                      ),
                      child: isSelected
                          ? Icon(Icons.check, size: 16, color: accentColor)
                          : null,
                    ),
                    title: Text(
                      theme.name,
                      style: TextStyle(
                        color: colors.textoPrimario,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      theme.isCustom ? 'Personalizado' : 'Sistema',
                      style: TextStyle(color: colors.textoSecundario, fontSize: 11),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (theme.isCustom)
                          IconButton(
                            icon: Icon(Icons.delete_outline_rounded, color: colors.gasto, size: 20),
                            onPressed: () => _deleteTheme(theme),
                          ),
                        IconButton(
                          icon: Icon(
                            isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                            color: isSelected ? colors.acento : colors.textoSecundario,
                            size: 22,
                          ),
                          onPressed: () {
                            ref.read(selectedThemePaletteProvider.notifier).state = palette;
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Formulario de Creación de Tema ──────────────────────────────────────────

class _CreateThemeForm extends StatelessWidget {
  final TextEditingController nameCtrl, bgCtrl, surfaceCtrl, textCtrl, accentCtrl;
  final AppColors colors;
  final VoidCallback onSave;

  const _CreateThemeForm({
    required this.nameCtrl,
    required this.bgCtrl,
    required this.surfaceCtrl,
    required this.textCtrl,
    required this.accentCtrl,
    required this.colors,
    required this.onSave,
  });

  Widget _hexField(TextEditingController ctrl, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(
          controller: ctrl,
          style: TextStyle(color: colors.textoPrimario, fontSize: 14),
          decoration: InputDecoration(
            labelText: label,
            hintText: '#1A2B3C',
            filled: true,
            fillColor: colors.superficie,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _hexField(nameCtrl..text = nameCtrl.text, 'Nombre del tema'),
        _hexField(bgCtrl, 'Fondo HEX'),
        _hexField(surfaceCtrl, 'Superficie HEX'),
        _hexField(textCtrl, 'Texto HEX'),
        _hexField(accentCtrl, 'Acento HEX'),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.acento,
            foregroundColor: colors.fondo,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: onSave,
          child: const Text('Guardar tema', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
