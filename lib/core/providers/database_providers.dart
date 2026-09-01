import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/daos/categorias_dao.dart';
import '../database/daos/reportes_dao.dart';
import '../database/daos/saldos_dao.dart';
import '../database/daos/themes_dao.dart';
import '../database/daos/transacciones_dao.dart';
import '../database/database.dart';

/// Proveedor principal de la base de datos SQLite (Drift).
/// Lanza un [UnimplementedError] por defecto para exigir su override en el ProviderScope raíz de main().
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProvider debe ser sobreescrito en el ProviderScope raíz.');
});

/// Proveedor del DAO de Transacciones
final transaccionesDaoProvider = Provider<TransaccionesDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.transaccionesDao;
});

/// Proveedor del DAO de Saldos
final saldosDaoProvider = Provider<SaldosDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.saldosDao;
});

/// Proveedor del DAO de Reportes
final reportesDaoProvider = Provider<ReportesDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.reportesDao;
});

/// Proveedor del DAO de Temas
final themesDaoProvider = Provider<ThemesDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.themesDao;
});

/// Proveedor del DAO de Categorías
final categoriasDaoProvider = Provider<CategoriasDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.categoriasDao;
});
