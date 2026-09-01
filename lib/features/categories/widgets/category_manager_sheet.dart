import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/category_icons.dart';
import '../../../core/utils/kip_snackbar.dart';

/// Modal BottomSheet completo para gestionar Categorías en Kip.
/// Permite crear, editar nombre, color, ícono, prioridad de visualización y presupuesto asignado.
class CategoryManagerSheet extends ConsumerStatefulWidget {
  const CategoryManagerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CategoryManagerSheet(),
    );
  }

  @override
  ConsumerState<CategoryManagerSheet> createState() => _CategoryManagerSheetState();
}

class _CategoryManagerSheetState extends ConsumerState<CategoryManagerSheet> {
  bool _showArchived = false;

  void _openForm({Categoria? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CategoryFormSheet(existing: existing),
    );
  }

  Future<void> _confirmDelete(Categoria cat) async {
    final colors = context.appColors;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.superficie,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          '¿Eliminar categoría?',
          style: TextStyle(color: colors.textoPrimario, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Si la categoría "${cat.nombre}" tiene transacciones registradas, se archivará automáticamente para proteger tu historial.',
          style: TextStyle(color: colors.textoSecundario, fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar', style: TextStyle(color: colors.textoSecundario)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.gasto,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final dao = ref.read(categoriasDaoProvider);
      final physicallyDeleted = await dao.deleteOrDeactivateCategoria(cat.id);
      if (!mounted) return;
      KipSnackBar.show(
        context,
        physicallyDeleted
            ? 'Categoría eliminada'
            : 'Categoría archivada (tiene transacciones)',
      );
    }
  }

  Future<void> _changePriority(Categoria cat, int delta) async {
    final newPriority = (cat.orderIndex + delta).clamp(0, 999);
    final dao = ref.read(categoriasDaoProvider);
    await dao.updatePriority(cat.id, newPriority);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final dao = ref.watch(categoriasDaoProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.fondo,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: colors.superficie, width: 1.5)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 20,
        right: 20,
        top: 12,
      ),
      child: StreamBuilder<List<Categoria>>(
        stream: dao.watchCategorias(onlyActive: !_showArchived),
        builder: (context, snapshot) {
          final categorias = snapshot.data ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Barra de arrastre
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colors.textoSecundario.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Encabezado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categorías',
                          style: TextStyle(
                            color: colors.textoPrimario,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Prioridad y presupuestos',
                          style: TextStyle(
                            color: colors.textoSecundario,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.acento,
                        foregroundColor: colors.fondo,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Nueva', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      onPressed: () => _openForm(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Toggle mostrar archivadas
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Ver archivadas',
                      style: TextStyle(color: colors.textoSecundario, fontSize: 12),
                    ),
                    const SizedBox(width: 6),
                    Switch(
                      value: _showArchived,
                      activeThumbColor: colors.acento,
                      activeTrackColor: colors.acento.withValues(alpha: 0.5),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (val) => setState(() => _showArchived = val),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (snapshot.connectionState == ConnectionState.waiting && categorias.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator(color: colors.acento)),
                  )
                else if (categorias.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.category_outlined, size: 40, color: colors.textoSecundario.withValues(alpha: 0.5)),
                          const SizedBox(height: 8),
                          Text(
                            'No hay categorías disponibles',
                            style: TextStyle(color: colors.textoSecundario, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categorias.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 8),
                    itemBuilder: (ctx, i) {
                      final cat = categorias[i];
                      final catColor = AppColors.parseHexColor(cat.colorHex);
                      final iconData = CategoryIcons.getIcon(cat.icono);

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: colors.superficie,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colors.textoSecundario.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Avatar con ícono y color de la categoría
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: catColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(iconData, color: catColor, size: 22),
                            ),
                            const SizedBox(width: 12),

                            // Nombre, Prioridad y Presupuesto
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          cat.nombre,
                                          style: TextStyle(
                                            color: colors.textoPrimario,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (!cat.activo) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: colors.textoSecundario.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'Archivada',
                                            style: TextStyle(color: colors.textoSecundario, fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      // Badge de Prioridad
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: colors.acento.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Prioridad: #${cat.orderIndex}',
                                          style: TextStyle(
                                            color: colors.acento,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                      if (cat.presupuestoAsignado > 0) ...[
                                        const SizedBox(width: 6),
                                        Text(
                                          '• S/ ${cat.presupuestoAsignado.toStringAsFixed(0)}/mes',
                                          style: TextStyle(
                                            color: colors.textoSecundario,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Controles de Prioridad (Up/Down)
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: Icon(Icons.arrow_drop_up_rounded, color: colors.textoPrimario, size: 26),
                              tooltip: 'Mayor prioridad (menor número)',
                              onPressed: cat.orderIndex > 0 ? () => _changePriority(cat, -1) : null,
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: Icon(Icons.arrow_drop_down_rounded, color: colors.textoPrimario, size: 26),
                              tooltip: 'Menor prioridad',
                              onPressed: () => _changePriority(cat, 1),
                            ),

                            // Editar
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: Icon(Icons.edit_outlined, color: colors.textoSecundario, size: 20),
                              tooltip: 'Editar',
                              onPressed: () => _openForm(existing: cat),
                            ),

                            // Eliminar / Desactivar
                            if (cat.activo)
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: Icon(Icons.delete_outline_rounded, color: colors.gasto, size: 20),
                                tooltip: 'Eliminar',
                                onPressed: () => _confirmDelete(cat),
                              )
                            else
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: Icon(Icons.restore_rounded, color: colors.acento, size: 20),
                                tooltip: 'Reactivar',
                                onPressed: () async {
                                  await dao.reactivateCategoria(cat.id);
                                  if (!mounted) return;
                                  KipSnackBar.show(this.context, 'Categoría reactivada');
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Formulario para Crear / Editar Categoría ─────────────────────────────────

class _CategoryFormSheet extends ConsumerStatefulWidget {
  final Categoria? existing;
  const _CategoryFormSheet({this.existing});

  @override
  ConsumerState<_CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends ConsumerState<_CategoryFormSheet> {
  late TextEditingController _nameCtrl;
  late TextEditingController _priorityCtrl;
  late TextEditingController _budgetCtrl;
  late String _selectedIconKey;
  late String _selectedColorHex;

  static const List<String> _presetColors = [
    '#FF9800', // Naranja cálido
    '#2196F3', // Azul brillante
    '#4CAF50', // Verde natural
    '#E91E63', // Rosa intenso
    '#9C27B0', // Púrpura
    '#00BCD4', // Cyan
    '#FF5722', // Deep Orange
    '#607D8B', // Blue Grey
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.nombre ?? '');
    _priorityCtrl = TextEditingController(text: (e?.orderIndex ?? 1).toString());
    _budgetCtrl = TextEditingController(
      text: e != null && e.presupuestoAsignado > 0 ? e.presupuestoAsignado.toStringAsFixed(0) : '',
    );
    _selectedIconKey = e?.icono ?? 'restaurant';
    _selectedColorHex = e?.colorHex ?? _presetColors.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priorityCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      KipSnackBar.show(context, 'Ingresa el nombre de la categoría', isError: true);
      return;
    }

    final priority = int.tryParse(_priorityCtrl.text.trim()) ?? 0;
    final budget = double.tryParse(_budgetCtrl.text.trim()) ?? 0.0;
    final dao = ref.read(categoriasDaoProvider);

    if (widget.existing != null) {
      // Actualización
      final existing = widget.existing!;
      await dao.updateCategoria(
        CategoriasCompanion(
          id: Value(existing.id),
          nombre: Value(name),
          colorHex: Value(_selectedColorHex),
          icono: Value(_selectedIconKey),
          orderIndex: Value(priority),
          presupuestoAsignado: Value(budget),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      // Creación
      await dao.insertCategoria(
        CategoriasCompanion.insert(
          nombre: name,
          colorHex: _selectedColorHex,
          icono: _selectedIconKey,
          orderIndex: Value(priority),
          presupuestoAsignado: Value(budget),
          esPorDefecto: const Value(false),
          activo: const Value(true),
        ),
      );
    }

    if (!mounted) return;
    KipSnackBar.show(
      context,
      widget.existing != null ? 'Categoría actualizada' : 'Categoría creada',
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isEditing = widget.existing != null;

    return Container(
      decoration: BoxDecoration(
        color: colors.fondo,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: colors.superficie, width: 1.5)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 14,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.textoSecundario.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isEditing ? 'Editar Categoría' : 'Nueva Categoría',
              style: TextStyle(
                color: colors.textoPrimario,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),

            // Nombre
            TextField(
              controller: _nameCtrl,
              autofocus: !isEditing,
              style: TextStyle(color: colors.textoPrimario),
              decoration: InputDecoration(
                labelText: 'Nombre de categoría',
                hintText: 'Ej: Gimnasio, Cine, Salud...',
                filled: true,
                fillColor: colors.superficie,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Prioridad y Presupuesto
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priorityCtrl,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: colors.textoPrimario),
                    decoration: InputDecoration(
                      labelText: 'Prioridad UI (Orden)',
                      hintText: '1 = primero',
                      filled: true,
                      fillColor: colors.superficie,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _budgetCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(color: colors.textoPrimario),
                    decoration: InputDecoration(
                      labelText: 'Presupuesto (S/)',
                      hintText: '0.00 (Opcional)',
                      filled: true,
                      fillColor: colors.superficie,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Selector de Color
            Text(
              'COLOR REPRESENTATIVO',
              style: TextStyle(
                color: colors.textoSecundario,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: _presetColors.map((hex) {
                final isSelected = _selectedColorHex.toLowerCase() == hex.toLowerCase();
                final c = AppColors.parseHexColor(hex);
                return GestureDetector(
                  onTap: () => setState(() => _selectedColorHex = hex),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: c.withValues(alpha: 0.5), blurRadius: 8)]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Selector de Ícono
            Text(
              'ÍCONO',
              style: TextStyle(
                color: colors.textoSecundario,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 130,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: CategoryIcons.availableIcons.length,
                itemBuilder: (ctx, i) {
                  final item = CategoryIcons.availableIcons[i];
                  final isSelected = _selectedIconKey.toLowerCase() == item.key.toLowerCase();
                  final selectedColor = AppColors.parseHexColor(_selectedColorHex);

                  return InkWell(
                    onTap: () => setState(() => _selectedIconKey = item.key),
                    borderRadius: BorderRadius.circular(14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? selectedColor.withValues(alpha: 0.25)
                            : colors.superficie,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? selectedColor : colors.textoSecundario.withValues(alpha: 0.15),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            color: isSelected ? selectedColor : colors.textoSecundario,
                            size: 22,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected ? colors.textoPrimario : colors.textoSecundario,
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Botón Guardar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.acento,
                foregroundColor: colors.fondo,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              onPressed: _handleSave,
              child: Text(
                isEditing ? 'Guardar Cambios' : 'Crear Categoría',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
