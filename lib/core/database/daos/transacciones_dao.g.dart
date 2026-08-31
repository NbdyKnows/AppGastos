// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transacciones_dao.dart';

// ignore_for_file: type=lint
mixin _$TransaccionesDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriasTable get categorias => attachedDatabase.categorias;
  $EtiquetasCategoriaTable get etiquetasCategoria =>
      attachedDatabase.etiquetasCategoria;
  $MediosPagoTable get mediosPago => attachedDatabase.mediosPago;
  $TransaccionesTable get transacciones => attachedDatabase.transacciones;
  TransaccionesDaoManager get managers => TransaccionesDaoManager(this);
}

class TransaccionesDaoManager {
  final _$TransaccionesDaoMixin _db;
  TransaccionesDaoManager(this._db);
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
