import 'package:drift/drift.dart';

/// 1. Categorias:
/// id (PK, autoIncrement), nombre (max: 50), colorHex (max: 7), icono,
/// orden (default 0), esPorDefecto (boolean default false),
/// presupuestoAsignado (real default 0.0), activo (boolean default true),
/// createdAt, updatedAt.
@DataClassName('Categoria')
class Categorias extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 50)();
  TextColumn get colorHex => text().withLength(min: 1, max: 7)();
  TextColumn get icono => text()();
  IntColumn get orden => integer().withDefault(const Constant(0))();
  /// Prioridad de visualización en los chips del Quick Record (1 = primero, 0 = sin prioridad).
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  BoolColumn get esPorDefecto => boolean().withDefault(const Constant(false))();
  RealColumn get presupuestoAsignado => real().withDefault(const Constant(0.0))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// 2. EtiquetasCategoria:
/// id (PK), nombre (max: 30), categoriaId (referencia a Categorias con onDelete: KeyAction.restrict).
/// Constraint de tabla: UNIQUE(nombre, categoriaId).
@DataClassName('EtiquetaCategoria')
class EtiquetasCategoria extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 30)();
  IntColumn get categoriaId => integer().references(Categorias, #id, onDelete: KeyAction.restrict)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {nombre, categoriaId},
  ];
}

/// 3. MediosPago:
/// Unifica cuentas. id (PK), nombre, banco (nullable),
/// tipo (CHECK tipo IN ('débito', 'crédito', 'efectivo')),
/// saldoInicial (real default 0.0), lineaCredito (nullable),
/// diaCorte (nullable), diaPago (nullable), activo (boolean default true).
/// Constraint condicional:
/// CHECK ((tipo != 'crédito') OR (lineaCredito IS NOT NULL AND diaCorte IS NOT NULL AND diaPago IS NOT NULL))
@DataClassName('MedioPago')
class MediosPago extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get banco => text().nullable()();
  TextColumn get tipo => text().customConstraint("NOT NULL CHECK (tipo IN ('débito', 'crédito', 'efectivo'))")();
  RealColumn get saldoInicial => real().withDefault(const Constant(0.0))();
  RealColumn get lineaCredito => real().nullable()();
  IntColumn get diaCorte => integer().nullable()();
  IntColumn get diaPago => integer().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  @override
  List<String> get customConstraints => [
    "CHECK ((tipo != 'crédito') OR (linea_credito IS NOT NULL AND dia_corte IS NOT NULL AND dia_pago IS NOT NULL))",
  ];
}

/// 4. GastosFijos:
/// id (PK), nombre, monto (real), diaCobro (CHECK diaCobro BETWEEN 1 AND 31),
/// esAhorro (boolean default false), activo (boolean default true),
/// categoriaId (referencia, KeyAction.restrict).
@DataClassName('GastoFijo')
class GastosFijos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  RealColumn get monto => real()();
  IntColumn get diaCobro => integer().customConstraint("NOT NULL CHECK (dia_cobro BETWEEN 1 AND 31)")();
  BoolColumn get esAhorro => boolean().withDefault(const Constant(false))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  IntColumn get categoriaId => integer().references(Categorias, #id, onDelete: KeyAction.restrict)();
}

/// 5. Transacciones:
/// id (PK), monto (real), fecha (dateTime),
/// tipo (CHECK tipo IN ('gasto', 'ingreso', 'pago_tarjeta', 'transferencia_interna') default 'gasto'),
/// nota (nullable), numeroCuota (nullable), totalCuotas (nullable).
/// Relaciones:
/// categoriaId (KeyAction.restrict), etiquetaId (KeyAction.restrict),
/// transaccionPadreId (refiere a Transacciones.id, onDelete: KeyAction.cascade).
/// Partida Doble:
/// medioPagoId (NOT NULL, origen, KeyAction.restrict),
/// medioPagoDestinoId (nullable, KeyAction.restrict).
/// Constraint de Transferencia:
/// CHECK (medioPagoDestinoId IS NULL OR medioPagoDestinoId != medioPagoId).
@DataClassName('Transaccion')
class Transacciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get monto => real()();
  DateTimeColumn get fecha => dateTime()();
  TextColumn get tipo => text().customConstraint("NOT NULL DEFAULT 'gasto' CHECK (tipo IN ('gasto', 'ingreso', 'pago_tarjeta', 'transferencia_interna'))")();
  TextColumn get nota => text().nullable()();
  IntColumn get numeroCuota => integer().nullable()();
  IntColumn get totalCuotas => integer().nullable()();
  IntColumn get categoriaId => integer().nullable().references(Categorias, #id, onDelete: KeyAction.restrict)();
  IntColumn get etiquetaId => integer().nullable().references(EtiquetasCategoria, #id, onDelete: KeyAction.restrict)();
  @ReferenceName('cuotasHijas')
  IntColumn get transaccionPadreId => integer().nullable().references(Transacciones, #id, onDelete: KeyAction.cascade)();
  @ReferenceName('transaccionesOrigen')
  IntColumn get medioPagoId => integer().references(MediosPago, #id, onDelete: KeyAction.restrict)();
  @ReferenceName('transaccionesDestino')
  IntColumn get medioPagoDestinoId => integer().nullable().references(MediosPago, #id, onDelete: KeyAction.restrict)();

  @override
  List<String> get customConstraints => [
    'CHECK (medio_pago_destino_id IS NULL OR medio_pago_destino_id != medio_pago_id)',
  ];
}

/// 6. AppThemes:
/// Motor de temas dinámicos. Almacena paletas del sistema y personalizadas.
/// Los temas de sistema tienen isCustom = false y no pueden borrarse.
@DataClassName('AppThemeEntry')
class AppThemes extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// Nombre único del tema, ej. "Lemon Dark", "Mi Tema Azul".
  TextColumn get name => text().withLength(min: 1, max: 50).unique()();
  TextColumn get backgroundHex => text()();
  TextColumn get surfaceHex => text()();
  TextColumn get textHex => text()();
  TextColumn get accentHex => text()();
  /// false = tema de sistema (no se puede borrar). true = creado por el usuario.
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
}
