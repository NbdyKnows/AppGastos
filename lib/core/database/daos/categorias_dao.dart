import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'categorias_dao.g.dart';

@DriftAccessor(tables: [Categorias, Transacciones, EtiquetasCategoria])
class CategoriasDao extends DatabaseAccessor<AppDatabase> with _$CategoriasDaoMixin {
  CategoriasDao(super.db);

  /// Observa todas las categorías activas ordenadas por prioridad de UI (orderIndex ASC, id ASC).
  Stream<List<Categoria>> watchCategorias({bool onlyActive = true}) {
    return (select(categorias)
          ..where((tbl) => onlyActive ? tbl.activo.equals(true) : const Constant(true))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.orderIndex),
            (tbl) => OrderingTerm.asc(tbl.id),
          ]))
        .watch();
  }

  /// Inserta una nueva categoría.
  Future<int> insertCategoria(CategoriasCompanion categoria) {
    return into(categorias).insert(categoria);
  }

  /// Actualiza una categoría existente.
  Future<bool> updateCategoria(CategoriasCompanion categoria) {
    return update(categorias).replace(categoria);
  }

  /// Desactiva o elimina una categoría.
  /// Si la categoría tiene transacciones o etiquetas vinculadas, la marca como inactiva (activo = false)
  /// para preservar la integridad referencial. Si no tiene vínculos, la elimina físicamente.
  Future<bool> deleteOrDeactivateCategoria(int id) async {
    // 1. Verificar si hay transacciones asociadas
    final txCountQuery = selectOnly(transacciones)
      ..addColumns([transacciones.id.count()])
      ..where(transacciones.categoriaId.equals(id));
    final txCount = await txCountQuery.map((r) => r.read(transacciones.id.count())).getSingle() ?? 0;

    // 2. Si tiene transacciones, desactivar (soft-delete)
    if (txCount > 0) {
      await (update(categorias)..where((t) => t.id.equals(id))).write(
        const CategoriasCompanion(activo: Value(false)),
      );
      return false; // Indicador de desactivación
    }

    // 3. Eliminar etiquetas asociadas si no tienen restricciones
    await (delete(etiquetasCategoria)..where((t) => t.categoriaId.equals(id))).go();

    // 4. Eliminar físicamente la categoría
    final deletedRows = await (delete(categorias)..where((t) => t.id.equals(id))).go();
    return deletedRows > 0; // Indicador de eliminación física
  }

  /// Actualiza el índice de prioridad de una categoría.
  Future<void> updatePriority(int id, int newOrderIndex) async {
    await (update(categorias)..where((t) => t.id.equals(id))).write(
      CategoriasCompanion(
        orderIndex: Value(newOrderIndex),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Reactiva una categoría previamente desactivada.
  Future<void> reactivateCategoria(int id) async {
    await (update(categorias)..where((t) => t.id.equals(id))).write(
      CategoriasCompanion(
        activo: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
