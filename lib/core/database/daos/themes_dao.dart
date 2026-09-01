import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'themes_dao.g.dart';

@DriftAccessor(tables: [AppThemes])
class ThemesDao extends DatabaseAccessor<AppDatabase> with _$ThemesDaoMixin {
  ThemesDao(super.db);

  /// Stream reactivo de todos los temas (sistema + custom), ordenados: sistema primero, luego los custom.
  Stream<List<AppThemeEntry>> watchAllThemes() {
    return (select(appThemes)
          ..orderBy([
            (t) => OrderingTerm.asc(t.isCustom),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .watch();
  }

  /// Cuenta cuántos temas existen en total.
  Future<int> countThemes() {
    return appThemes.count().getSingle();
  }

  /// Inserta un tema (sistema o custom).
  Future<int> insertTheme(AppThemesCompanion theme) {
    return into(appThemes).insert(theme, mode: InsertMode.insertOrIgnore);
  }

  /// Elimina un tema custom por su id.
  /// Lanza [ArgumentError] si se intenta borrar un tema del sistema.
  Future<void> deleteTheme(int id) async {
    final theme = await (select(appThemes)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (theme == null) return;
    if (!theme.isCustom) {
      throw ArgumentError('No se puede eliminar un tema del sistema.');
    }
    await (delete(appThemes)..where((t) => t.id.equals(id))).go();
  }

  /// Verifica si ya existe un tema con el nombre dado (case-insensitive).
  Future<bool> themeNameExists(String name) async {
    final result = await (select(appThemes)
          ..where((t) => t.name.lower().equals(name.toLowerCase())))
        .getSingleOrNull();
    return result != null;
  }
}
