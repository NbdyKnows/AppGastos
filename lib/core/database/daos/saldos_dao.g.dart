// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saldos_dao.dart';

// ignore_for_file: type=lint
mixin _$SaldosDaoMixin on DatabaseAccessor<AppDatabase> {
  $MediosPagoTable get mediosPago => attachedDatabase.mediosPago;
  $CategoriasTable get categorias => attachedDatabase.categorias;
  $EtiquetasCategoriaTable get etiquetasCategoria =>
      attachedDatabase.etiquetasCategoria;
  $TransaccionesTable get transacciones => attachedDatabase.transacciones;
  SaldosDaoManager get managers => SaldosDaoManager(this);
}

class SaldosDaoManager {
  final _$SaldosDaoMixin _db;
  SaldosDaoManager(this._db);
  $$MediosPagoTableTableManager get mediosPago =>
      $$MediosPagoTableTableManager(_db.attachedDatabase, _db.mediosPago);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db.attachedDatabase, _db.categorias);
  $$EtiquetasCategoriaTableTableManager get etiquetasCategoria =>
      $$EtiquetasCategoriaTableTableManager(
        _db.attachedDatabase,
        _db.etiquetasCategoria,
      );
  $$TransaccionesTableTableManager get transacciones =>
      $$TransaccionesTableTableManager(_db.attachedDatabase, _db.transacciones);
}
