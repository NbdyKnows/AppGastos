import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/reportes_dao.dart';
import 'daos/saldos_dao.dart';
import 'daos/transacciones_dao.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Categorias,
    EtiquetasCategoria,
    MediosPago,
    GastosFijos,
    Transacciones,
  ],
  daos: [
    TransaccionesDao,
    SaldosDao,
    ReportesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();

      // Trigger para inserción: validar que etiquetaId pertenece a la categoriaId de la transacción
      await customStatement('''
        CREATE TRIGGER trg_transacciones_check_etiqueta_insert
        BEFORE INSERT ON transacciones
        WHEN NEW.etiqueta_id IS NOT NULL
        BEGIN
          SELECT RAISE(ABORT, 'etiqueta no pertenece a la categoría')
          WHERE NOT EXISTS (
            SELECT 1 FROM etiquetas_categoria
            WHERE id = NEW.etiqueta_id AND categoria_id = NEW.categoria_id
          );
        END;
      ''');

      // Trigger para actualización: validar que etiquetaId pertenece a la categoriaId de la transacción
      await customStatement('''
        CREATE TRIGGER trg_transacciones_check_etiqueta_update
        BEFORE UPDATE ON transacciones
        WHEN NEW.etiqueta_id IS NOT NULL
        BEGIN
          SELECT RAISE(ABORT, 'etiqueta no pertenece a la categoría')
          WHERE NOT EXISTS (
            SELECT 1 FROM etiquetas_categoria
            WHERE id = NEW.etiqueta_id AND categoria_id = NEW.categoria_id
          );
        END;
      ''');

      // Índices para optimización de queries frecuentes
      await customStatement('CREATE INDEX idx_trans_fecha ON transacciones(fecha);');
      await customStatement('CREATE INDEX idx_trans_categoria ON transacciones(categoria_id);');
      await customStatement('CREATE INDEX idx_trans_mediopago ON transacciones(medio_pago_id);');
      await customStatement('CREATE INDEX idx_trans_mediopago_destino ON transacciones(medio_pago_destino_id);');
      await customStatement('CREATE INDEX idx_trans_padre ON transacciones(transaccion_padre_id);');
    },
    beforeOpen: (details) async {
      // Garantizar foreign keys activas en cada apertura
      await customStatement('PRAGMA foreign_keys = ON;');
    },
  );

  /// Vacía la tabla de transacciones de forma segura sin destruir cuentas ni categorías base.
  Future<void> clearAllTransactions() async {
    await delete(transacciones).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'finanzas_local.sqlite'));
    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        rawDb.execute('PRAGMA foreign_keys = ON;');
      },
    );
  });
}
