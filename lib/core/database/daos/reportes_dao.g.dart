// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reportes_dao.dart';

// ignore_for_file: type=lint
mixin _$ReportesDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriasTable get categorias => attachedDatabase.categorias;
  $EtiquetasCategoriaTable get etiquetasCategoria =>
      attachedDatabase.etiquetasCategoria;
  $MediosPagoTable get mediosPago => attachedDatabase.mediosPago;
  $TransaccionesTable get transacciones => attachedDatabase.transacciones;
  ReportesDaoManager get managers => ReportesDaoManager(this);
}

class ReportesDaoManager {
  final _$ReportesDaoMixin _db;
  ReportesDaoManager(this._db);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db.attachedDatabase, _db.categorias);
  $$EtiquetasCategoriaTableTableManager get etiquetasCategoria =>
      $$EtiquetasCategoriaTableTableManager(
        _db.attachedDatabase,
        _db.etiquetasCategoria,
      );
  $$MediosPagoTableTableManager get mediosPago =>
      $$MediosPagoTableTableManager(_db.attachedDatabase, _db.mediosPago);
  $$TransaccionesTableTableManager get transacciones =>
      $$TransaccionesTableTableManager(_db.attachedDatabase, _db.transacciones);
}
