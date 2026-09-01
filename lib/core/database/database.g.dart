// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriasTable extends Categorias
    with TableInfo<$CategoriasTable, Categoria> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 7,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconoMeta = const VerificationMeta('icono');
  @override
  late final GeneratedColumn<String> icono = GeneratedColumn<String>(
    'icono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ordenMeta = const VerificationMeta('orden');
  @override
  late final GeneratedColumn<int> orden = GeneratedColumn<int>(
    'orden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _esPorDefectoMeta = const VerificationMeta(
    'esPorDefecto',
  );
  @override
  late final GeneratedColumn<bool> esPorDefecto = GeneratedColumn<bool>(
    'es_por_defecto',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_por_defecto" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _presupuestoAsignadoMeta =
      const VerificationMeta('presupuestoAsignado');
  @override
  late final GeneratedColumn<double> presupuestoAsignado =
      GeneratedColumn<double>(
        'presupuesto_asignado',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    colorHex,
    icono,
    orden,
    orderIndex,
    esPorDefecto,
    presupuestoAsignado,
    activo,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorias';
  @override
  VerificationContext validateIntegrity(
    Insertable<Categoria> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('icono')) {
      context.handle(
        _iconoMeta,
        icono.isAcceptableOrUnknown(data['icono']!, _iconoMeta),
      );
    } else if (isInserting) {
      context.missing(_iconoMeta);
    }
    if (data.containsKey('orden')) {
      context.handle(
        _ordenMeta,
        orden.isAcceptableOrUnknown(data['orden']!, _ordenMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    if (data.containsKey('es_por_defecto')) {
      context.handle(
        _esPorDefectoMeta,
        esPorDefecto.isAcceptableOrUnknown(
          data['es_por_defecto']!,
          _esPorDefectoMeta,
        ),
      );
    }
    if (data.containsKey('presupuesto_asignado')) {
      context.handle(
        _presupuestoAsignadoMeta,
        presupuestoAsignado.isAcceptableOrUnknown(
          data['presupuesto_asignado']!,
          _presupuestoAsignadoMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Categoria map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Categoria(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      icono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icono'],
      )!,
      orden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      esPorDefecto: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_por_defecto'],
      )!,
      presupuestoAsignado: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}presupuesto_asignado'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CategoriasTable createAlias(String alias) {
    return $CategoriasTable(attachedDatabase, alias);
  }
}

class Categoria extends DataClass implements Insertable<Categoria> {
  final int id;
  final String nombre;
  final String colorHex;
  final String icono;
  final int orden;

  /// Prioridad de visualización en los chips del Quick Record (1 = primero, 0 = sin prioridad).
  final int orderIndex;
  final bool esPorDefecto;
  final double presupuestoAsignado;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Categoria({
    required this.id,
    required this.nombre,
    required this.colorHex,
    required this.icono,
    required this.orden,
    required this.orderIndex,
    required this.esPorDefecto,
    required this.presupuestoAsignado,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['color_hex'] = Variable<String>(colorHex);
    map['icono'] = Variable<String>(icono);
    map['orden'] = Variable<int>(orden);
    map['order_index'] = Variable<int>(orderIndex);
    map['es_por_defecto'] = Variable<bool>(esPorDefecto);
    map['presupuesto_asignado'] = Variable<double>(presupuestoAsignado);
    map['activo'] = Variable<bool>(activo);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriasCompanion toCompanion(bool nullToAbsent) {
    return CategoriasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      colorHex: Value(colorHex),
      icono: Value(icono),
      orden: Value(orden),
      orderIndex: Value(orderIndex),
      esPorDefecto: Value(esPorDefecto),
      presupuestoAsignado: Value(presupuestoAsignado),
      activo: Value(activo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Categoria.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Categoria(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      icono: serializer.fromJson<String>(json['icono']),
      orden: serializer.fromJson<int>(json['orden']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      esPorDefecto: serializer.fromJson<bool>(json['esPorDefecto']),
      presupuestoAsignado: serializer.fromJson<double>(
        json['presupuestoAsignado'],
      ),
      activo: serializer.fromJson<bool>(json['activo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'colorHex': serializer.toJson<String>(colorHex),
      'icono': serializer.toJson<String>(icono),
      'orden': serializer.toJson<int>(orden),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'esPorDefecto': serializer.toJson<bool>(esPorDefecto),
      'presupuestoAsignado': serializer.toJson<double>(presupuestoAsignado),
      'activo': serializer.toJson<bool>(activo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Categoria copyWith({
    int? id,
    String? nombre,
    String? colorHex,
    String? icono,
    int? orden,
    int? orderIndex,
    bool? esPorDefecto,
    double? presupuestoAsignado,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Categoria(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    colorHex: colorHex ?? this.colorHex,
    icono: icono ?? this.icono,
    orden: orden ?? this.orden,
    orderIndex: orderIndex ?? this.orderIndex,
    esPorDefecto: esPorDefecto ?? this.esPorDefecto,
    presupuestoAsignado: presupuestoAsignado ?? this.presupuestoAsignado,
    activo: activo ?? this.activo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Categoria copyWithCompanion(CategoriasCompanion data) {
    return Categoria(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      icono: data.icono.present ? data.icono.value : this.icono,
      orden: data.orden.present ? data.orden.value : this.orden,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      esPorDefecto: data.esPorDefecto.present
          ? data.esPorDefecto.value
          : this.esPorDefecto,
      presupuestoAsignado: data.presupuestoAsignado.present
          ? data.presupuestoAsignado.value
          : this.presupuestoAsignado,
      activo: data.activo.present ? data.activo.value : this.activo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Categoria(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('colorHex: $colorHex, ')
          ..write('icono: $icono, ')
          ..write('orden: $orden, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('esPorDefecto: $esPorDefecto, ')
          ..write('presupuestoAsignado: $presupuestoAsignado, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    colorHex,
    icono,
    orden,
    orderIndex,
    esPorDefecto,
    presupuestoAsignado,
    activo,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Categoria &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.colorHex == this.colorHex &&
          other.icono == this.icono &&
          other.orden == this.orden &&
          other.orderIndex == this.orderIndex &&
          other.esPorDefecto == this.esPorDefecto &&
          other.presupuestoAsignado == this.presupuestoAsignado &&
          other.activo == this.activo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriasCompanion extends UpdateCompanion<Categoria> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> colorHex;
  final Value<String> icono;
  final Value<int> orden;
  final Value<int> orderIndex;
  final Value<bool> esPorDefecto;
  final Value<double> presupuestoAsignado;
  final Value<bool> activo;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CategoriasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.icono = const Value.absent(),
    this.orden = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.esPorDefecto = const Value.absent(),
    this.presupuestoAsignado = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CategoriasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String colorHex,
    required String icono,
    this.orden = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.esPorDefecto = const Value.absent(),
    this.presupuestoAsignado = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : nombre = Value(nombre),
       colorHex = Value(colorHex),
       icono = Value(icono);
  static Insertable<Categoria> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? colorHex,
    Expression<String>? icono,
    Expression<int>? orden,
    Expression<int>? orderIndex,
    Expression<bool>? esPorDefecto,
    Expression<double>? presupuestoAsignado,
    Expression<bool>? activo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (colorHex != null) 'color_hex': colorHex,
      if (icono != null) 'icono': icono,
      if (orden != null) 'orden': orden,
      if (orderIndex != null) 'order_index': orderIndex,
      if (esPorDefecto != null) 'es_por_defecto': esPorDefecto,
      if (presupuestoAsignado != null)
        'presupuesto_asignado': presupuestoAsignado,
      if (activo != null) 'activo': activo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CategoriasCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? colorHex,
    Value<String>? icono,
    Value<int>? orden,
    Value<int>? orderIndex,
    Value<bool>? esPorDefecto,
    Value<double>? presupuestoAsignado,
    Value<bool>? activo,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CategoriasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      colorHex: colorHex ?? this.colorHex,
      icono: icono ?? this.icono,
      orden: orden ?? this.orden,
      orderIndex: orderIndex ?? this.orderIndex,
      esPorDefecto: esPorDefecto ?? this.esPorDefecto,
      presupuestoAsignado: presupuestoAsignado ?? this.presupuestoAsignado,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (icono.present) {
      map['icono'] = Variable<String>(icono.value);
    }
    if (orden.present) {
      map['orden'] = Variable<int>(orden.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (esPorDefecto.present) {
      map['es_por_defecto'] = Variable<bool>(esPorDefecto.value);
    }
    if (presupuestoAsignado.present) {
      map['presupuesto_asignado'] = Variable<double>(presupuestoAsignado.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('colorHex: $colorHex, ')
          ..write('icono: $icono, ')
          ..write('orden: $orden, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('esPorDefecto: $esPorDefecto, ')
          ..write('presupuestoAsignado: $presupuestoAsignado, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $EtiquetasCategoriaTable extends EtiquetasCategoria
    with TableInfo<$EtiquetasCategoriaTable, EtiquetaCategoria> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EtiquetasCategoriaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id) ON DELETE RESTRICT',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, categoriaId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'etiquetas_categoria';
  @override
  VerificationContext validateIntegrity(
    Insertable<EtiquetaCategoria> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {nombre, categoriaId},
  ];
  @override
  EtiquetaCategoria map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EtiquetaCategoria(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      )!,
    );
  }

  @override
  $EtiquetasCategoriaTable createAlias(String alias) {
    return $EtiquetasCategoriaTable(attachedDatabase, alias);
  }
}

class EtiquetaCategoria extends DataClass
    implements Insertable<EtiquetaCategoria> {
  final int id;
  final String nombre;
  final int categoriaId;
  const EtiquetaCategoria({
    required this.id,
    required this.nombre,
    required this.categoriaId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['categoria_id'] = Variable<int>(categoriaId);
    return map;
  }

  EtiquetasCategoriaCompanion toCompanion(bool nullToAbsent) {
    return EtiquetasCategoriaCompanion(
      id: Value(id),
      nombre: Value(nombre),
      categoriaId: Value(categoriaId),
    );
  }

  factory EtiquetaCategoria.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EtiquetaCategoria(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      categoriaId: serializer.fromJson<int>(json['categoriaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'categoriaId': serializer.toJson<int>(categoriaId),
    };
  }

  EtiquetaCategoria copyWith({int? id, String? nombre, int? categoriaId}) =>
      EtiquetaCategoria(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        categoriaId: categoriaId ?? this.categoriaId,
      );
  EtiquetaCategoria copyWithCompanion(EtiquetasCategoriaCompanion data) {
    return EtiquetaCategoria(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EtiquetaCategoria(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('categoriaId: $categoriaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, categoriaId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EtiquetaCategoria &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.categoriaId == this.categoriaId);
}

class EtiquetasCategoriaCompanion extends UpdateCompanion<EtiquetaCategoria> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<int> categoriaId;
  const EtiquetasCategoriaCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.categoriaId = const Value.absent(),
  });
  EtiquetasCategoriaCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required int categoriaId,
  }) : nombre = Value(nombre),
       categoriaId = Value(categoriaId);
  static Insertable<EtiquetaCategoria> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? categoriaId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (categoriaId != null) 'categoria_id': categoriaId,
    });
  }

  EtiquetasCategoriaCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<int>? categoriaId,
  }) {
    return EtiquetasCategoriaCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoriaId: categoriaId ?? this.categoriaId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EtiquetasCategoriaCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('categoriaId: $categoriaId')
          ..write(')'))
        .toString();
  }
}

class $MediosPagoTable extends MediosPago
    with TableInfo<$MediosPagoTable, MedioPago> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediosPagoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bancoMeta = const VerificationMeta('banco');
  @override
  late final GeneratedColumn<String> banco = GeneratedColumn<String>(
    'banco',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (tipo IN (\'débito\', \'crédito\', \'efectivo\'))',
  );
  static const VerificationMeta _saldoInicialMeta = const VerificationMeta(
    'saldoInicial',
  );
  @override
  late final GeneratedColumn<double> saldoInicial = GeneratedColumn<double>(
    'saldo_inicial',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _lineaCreditoMeta = const VerificationMeta(
    'lineaCredito',
  );
  @override
  late final GeneratedColumn<double> lineaCredito = GeneratedColumn<double>(
    'linea_credito',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diaCorteMeta = const VerificationMeta(
    'diaCorte',
  );
  @override
  late final GeneratedColumn<int> diaCorte = GeneratedColumn<int>(
    'dia_corte',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diaPagoMeta = const VerificationMeta(
    'diaPago',
  );
  @override
  late final GeneratedColumn<int> diaPago = GeneratedColumn<int>(
    'dia_pago',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    banco,
    tipo,
    saldoInicial,
    lineaCredito,
    diaCorte,
    diaPago,
    activo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medios_pago';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedioPago> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('banco')) {
      context.handle(
        _bancoMeta,
        banco.isAcceptableOrUnknown(data['banco']!, _bancoMeta),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('saldo_inicial')) {
      context.handle(
        _saldoInicialMeta,
        saldoInicial.isAcceptableOrUnknown(
          data['saldo_inicial']!,
          _saldoInicialMeta,
        ),
      );
    }
    if (data.containsKey('linea_credito')) {
      context.handle(
        _lineaCreditoMeta,
        lineaCredito.isAcceptableOrUnknown(
          data['linea_credito']!,
          _lineaCreditoMeta,
        ),
      );
    }
    if (data.containsKey('dia_corte')) {
      context.handle(
        _diaCorteMeta,
        diaCorte.isAcceptableOrUnknown(data['dia_corte']!, _diaCorteMeta),
      );
    }
    if (data.containsKey('dia_pago')) {
      context.handle(
        _diaPagoMeta,
        diaPago.isAcceptableOrUnknown(data['dia_pago']!, _diaPagoMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedioPago map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedioPago(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      banco: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}banco'],
      ),
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      saldoInicial: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saldo_inicial'],
      )!,
      lineaCredito: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}linea_credito'],
      ),
      diaCorte: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dia_corte'],
      ),
      diaPago: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dia_pago'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  $MediosPagoTable createAlias(String alias) {
    return $MediosPagoTable(attachedDatabase, alias);
  }
}

class MedioPago extends DataClass implements Insertable<MedioPago> {
  final int id;
  final String nombre;
  final String? banco;
  final String tipo;
  final double saldoInicial;
  final double? lineaCredito;
  final int? diaCorte;
  final int? diaPago;
  final bool activo;
  const MedioPago({
    required this.id,
    required this.nombre,
    this.banco,
    required this.tipo,
    required this.saldoInicial,
    this.lineaCredito,
    this.diaCorte,
    this.diaPago,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || banco != null) {
      map['banco'] = Variable<String>(banco);
    }
    map['tipo'] = Variable<String>(tipo);
    map['saldo_inicial'] = Variable<double>(saldoInicial);
    if (!nullToAbsent || lineaCredito != null) {
      map['linea_credito'] = Variable<double>(lineaCredito);
    }
    if (!nullToAbsent || diaCorte != null) {
      map['dia_corte'] = Variable<int>(diaCorte);
    }
    if (!nullToAbsent || diaPago != null) {
      map['dia_pago'] = Variable<int>(diaPago);
    }
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  MediosPagoCompanion toCompanion(bool nullToAbsent) {
    return MediosPagoCompanion(
      id: Value(id),
      nombre: Value(nombre),
      banco: banco == null && nullToAbsent
          ? const Value.absent()
          : Value(banco),
      tipo: Value(tipo),
      saldoInicial: Value(saldoInicial),
      lineaCredito: lineaCredito == null && nullToAbsent
          ? const Value.absent()
          : Value(lineaCredito),
      diaCorte: diaCorte == null && nullToAbsent
          ? const Value.absent()
          : Value(diaCorte),
      diaPago: diaPago == null && nullToAbsent
          ? const Value.absent()
          : Value(diaPago),
      activo: Value(activo),
    );
  }

  factory MedioPago.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedioPago(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      banco: serializer.fromJson<String?>(json['banco']),
      tipo: serializer.fromJson<String>(json['tipo']),
      saldoInicial: serializer.fromJson<double>(json['saldoInicial']),
      lineaCredito: serializer.fromJson<double?>(json['lineaCredito']),
      diaCorte: serializer.fromJson<int?>(json['diaCorte']),
      diaPago: serializer.fromJson<int?>(json['diaPago']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'banco': serializer.toJson<String?>(banco),
      'tipo': serializer.toJson<String>(tipo),
      'saldoInicial': serializer.toJson<double>(saldoInicial),
      'lineaCredito': serializer.toJson<double?>(lineaCredito),
      'diaCorte': serializer.toJson<int?>(diaCorte),
      'diaPago': serializer.toJson<int?>(diaPago),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  MedioPago copyWith({
    int? id,
    String? nombre,
    Value<String?> banco = const Value.absent(),
    String? tipo,
    double? saldoInicial,
    Value<double?> lineaCredito = const Value.absent(),
    Value<int?> diaCorte = const Value.absent(),
    Value<int?> diaPago = const Value.absent(),
    bool? activo,
  }) => MedioPago(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    banco: banco.present ? banco.value : this.banco,
    tipo: tipo ?? this.tipo,
    saldoInicial: saldoInicial ?? this.saldoInicial,
    lineaCredito: lineaCredito.present ? lineaCredito.value : this.lineaCredito,
    diaCorte: diaCorte.present ? diaCorte.value : this.diaCorte,
    diaPago: diaPago.present ? diaPago.value : this.diaPago,
    activo: activo ?? this.activo,
  );
  MedioPago copyWithCompanion(MediosPagoCompanion data) {
    return MedioPago(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      banco: data.banco.present ? data.banco.value : this.banco,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      saldoInicial: data.saldoInicial.present
          ? data.saldoInicial.value
          : this.saldoInicial,
      lineaCredito: data.lineaCredito.present
          ? data.lineaCredito.value
          : this.lineaCredito,
      diaCorte: data.diaCorte.present ? data.diaCorte.value : this.diaCorte,
      diaPago: data.diaPago.present ? data.diaPago.value : this.diaPago,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedioPago(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('banco: $banco, ')
          ..write('tipo: $tipo, ')
          ..write('saldoInicial: $saldoInicial, ')
          ..write('lineaCredito: $lineaCredito, ')
          ..write('diaCorte: $diaCorte, ')
          ..write('diaPago: $diaPago, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    banco,
    tipo,
    saldoInicial,
    lineaCredito,
    diaCorte,
    diaPago,
    activo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedioPago &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.banco == this.banco &&
          other.tipo == this.tipo &&
          other.saldoInicial == this.saldoInicial &&
          other.lineaCredito == this.lineaCredito &&
          other.diaCorte == this.diaCorte &&
          other.diaPago == this.diaPago &&
          other.activo == this.activo);
}

class MediosPagoCompanion extends UpdateCompanion<MedioPago> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> banco;
  final Value<String> tipo;
  final Value<double> saldoInicial;
  final Value<double?> lineaCredito;
  final Value<int?> diaCorte;
  final Value<int?> diaPago;
  final Value<bool> activo;
  const MediosPagoCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.banco = const Value.absent(),
    this.tipo = const Value.absent(),
    this.saldoInicial = const Value.absent(),
    this.lineaCredito = const Value.absent(),
    this.diaCorte = const Value.absent(),
    this.diaPago = const Value.absent(),
    this.activo = const Value.absent(),
  });
  MediosPagoCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.banco = const Value.absent(),
    required String tipo,
    this.saldoInicial = const Value.absent(),
    this.lineaCredito = const Value.absent(),
    this.diaCorte = const Value.absent(),
    this.diaPago = const Value.absent(),
    this.activo = const Value.absent(),
  }) : nombre = Value(nombre),
       tipo = Value(tipo);
  static Insertable<MedioPago> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? banco,
    Expression<String>? tipo,
    Expression<double>? saldoInicial,
    Expression<double>? lineaCredito,
    Expression<int>? diaCorte,
    Expression<int>? diaPago,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (banco != null) 'banco': banco,
      if (tipo != null) 'tipo': tipo,
      if (saldoInicial != null) 'saldo_inicial': saldoInicial,
      if (lineaCredito != null) 'linea_credito': lineaCredito,
      if (diaCorte != null) 'dia_corte': diaCorte,
      if (diaPago != null) 'dia_pago': diaPago,
      if (activo != null) 'activo': activo,
    });
  }

  MediosPagoCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String?>? banco,
    Value<String>? tipo,
    Value<double>? saldoInicial,
    Value<double?>? lineaCredito,
    Value<int?>? diaCorte,
    Value<int?>? diaPago,
    Value<bool>? activo,
  }) {
    return MediosPagoCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      banco: banco ?? this.banco,
      tipo: tipo ?? this.tipo,
      saldoInicial: saldoInicial ?? this.saldoInicial,
      lineaCredito: lineaCredito ?? this.lineaCredito,
      diaCorte: diaCorte ?? this.diaCorte,
      diaPago: diaPago ?? this.diaPago,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (banco.present) {
      map['banco'] = Variable<String>(banco.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (saldoInicial.present) {
      map['saldo_inicial'] = Variable<double>(saldoInicial.value);
    }
    if (lineaCredito.present) {
      map['linea_credito'] = Variable<double>(lineaCredito.value);
    }
    if (diaCorte.present) {
      map['dia_corte'] = Variable<int>(diaCorte.value);
    }
    if (diaPago.present) {
      map['dia_pago'] = Variable<int>(diaPago.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediosPagoCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('banco: $banco, ')
          ..write('tipo: $tipo, ')
          ..write('saldoInicial: $saldoInicial, ')
          ..write('lineaCredito: $lineaCredito, ')
          ..write('diaCorte: $diaCorte, ')
          ..write('diaPago: $diaPago, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $GastosFijosTable extends GastosFijos
    with TableInfo<$GastosFijosTable, GastoFijo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GastosFijosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoMeta = const VerificationMeta('monto');
  @override
  late final GeneratedColumn<double> monto = GeneratedColumn<double>(
    'monto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diaCobroMeta = const VerificationMeta(
    'diaCobro',
  );
  @override
  late final GeneratedColumn<int> diaCobro = GeneratedColumn<int>(
    'dia_cobro',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (dia_cobro BETWEEN 1 AND 31)',
  );
  static const VerificationMeta _esAhorroMeta = const VerificationMeta(
    'esAhorro',
  );
  @override
  late final GeneratedColumn<bool> esAhorro = GeneratedColumn<bool>(
    'es_ahorro',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_ahorro" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id) ON DELETE RESTRICT',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    monto,
    diaCobro,
    esAhorro,
    activo,
    categoriaId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gastos_fijos';
  @override
  VerificationContext validateIntegrity(
    Insertable<GastoFijo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('monto')) {
      context.handle(
        _montoMeta,
        monto.isAcceptableOrUnknown(data['monto']!, _montoMeta),
      );
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('dia_cobro')) {
      context.handle(
        _diaCobroMeta,
        diaCobro.isAcceptableOrUnknown(data['dia_cobro']!, _diaCobroMeta),
      );
    } else if (isInserting) {
      context.missing(_diaCobroMeta);
    }
    if (data.containsKey('es_ahorro')) {
      context.handle(
        _esAhorroMeta,
        esAhorro.isAcceptableOrUnknown(data['es_ahorro']!, _esAhorroMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GastoFijo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GastoFijo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      monto: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto'],
      )!,
      diaCobro: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dia_cobro'],
      )!,
      esAhorro: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_ahorro'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      )!,
    );
  }

  @override
  $GastosFijosTable createAlias(String alias) {
    return $GastosFijosTable(attachedDatabase, alias);
  }
}

class GastoFijo extends DataClass implements Insertable<GastoFijo> {
  final int id;
  final String nombre;
  final double monto;
  final int diaCobro;
  final bool esAhorro;
  final bool activo;
  final int categoriaId;
  const GastoFijo({
    required this.id,
    required this.nombre,
    required this.monto,
    required this.diaCobro,
    required this.esAhorro,
    required this.activo,
    required this.categoriaId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['monto'] = Variable<double>(monto);
    map['dia_cobro'] = Variable<int>(diaCobro);
    map['es_ahorro'] = Variable<bool>(esAhorro);
    map['activo'] = Variable<bool>(activo);
    map['categoria_id'] = Variable<int>(categoriaId);
    return map;
  }

  GastosFijosCompanion toCompanion(bool nullToAbsent) {
    return GastosFijosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      monto: Value(monto),
      diaCobro: Value(diaCobro),
      esAhorro: Value(esAhorro),
      activo: Value(activo),
      categoriaId: Value(categoriaId),
    );
  }

  factory GastoFijo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GastoFijo(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      monto: serializer.fromJson<double>(json['monto']),
      diaCobro: serializer.fromJson<int>(json['diaCobro']),
      esAhorro: serializer.fromJson<bool>(json['esAhorro']),
      activo: serializer.fromJson<bool>(json['activo']),
      categoriaId: serializer.fromJson<int>(json['categoriaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'monto': serializer.toJson<double>(monto),
      'diaCobro': serializer.toJson<int>(diaCobro),
      'esAhorro': serializer.toJson<bool>(esAhorro),
      'activo': serializer.toJson<bool>(activo),
      'categoriaId': serializer.toJson<int>(categoriaId),
    };
  }

  GastoFijo copyWith({
    int? id,
    String? nombre,
    double? monto,
    int? diaCobro,
    bool? esAhorro,
    bool? activo,
    int? categoriaId,
  }) => GastoFijo(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    monto: monto ?? this.monto,
    diaCobro: diaCobro ?? this.diaCobro,
    esAhorro: esAhorro ?? this.esAhorro,
    activo: activo ?? this.activo,
    categoriaId: categoriaId ?? this.categoriaId,
  );
  GastoFijo copyWithCompanion(GastosFijosCompanion data) {
    return GastoFijo(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      monto: data.monto.present ? data.monto.value : this.monto,
      diaCobro: data.diaCobro.present ? data.diaCobro.value : this.diaCobro,
      esAhorro: data.esAhorro.present ? data.esAhorro.value : this.esAhorro,
      activo: data.activo.present ? data.activo.value : this.activo,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GastoFijo(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('monto: $monto, ')
          ..write('diaCobro: $diaCobro, ')
          ..write('esAhorro: $esAhorro, ')
          ..write('activo: $activo, ')
          ..write('categoriaId: $categoriaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, monto, diaCobro, esAhorro, activo, categoriaId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GastoFijo &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.monto == this.monto &&
          other.diaCobro == this.diaCobro &&
          other.esAhorro == this.esAhorro &&
          other.activo == this.activo &&
          other.categoriaId == this.categoriaId);
}

class GastosFijosCompanion extends UpdateCompanion<GastoFijo> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<double> monto;
  final Value<int> diaCobro;
  final Value<bool> esAhorro;
  final Value<bool> activo;
  final Value<int> categoriaId;
  const GastosFijosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.monto = const Value.absent(),
    this.diaCobro = const Value.absent(),
    this.esAhorro = const Value.absent(),
    this.activo = const Value.absent(),
    this.categoriaId = const Value.absent(),
  });
  GastosFijosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required double monto,
    required int diaCobro,
    this.esAhorro = const Value.absent(),
    this.activo = const Value.absent(),
    required int categoriaId,
  }) : nombre = Value(nombre),
       monto = Value(monto),
       diaCobro = Value(diaCobro),
       categoriaId = Value(categoriaId);
  static Insertable<GastoFijo> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<double>? monto,
    Expression<int>? diaCobro,
    Expression<bool>? esAhorro,
    Expression<bool>? activo,
    Expression<int>? categoriaId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (monto != null) 'monto': monto,
      if (diaCobro != null) 'dia_cobro': diaCobro,
      if (esAhorro != null) 'es_ahorro': esAhorro,
      if (activo != null) 'activo': activo,
      if (categoriaId != null) 'categoria_id': categoriaId,
    });
  }

  GastosFijosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<double>? monto,
    Value<int>? diaCobro,
    Value<bool>? esAhorro,
    Value<bool>? activo,
    Value<int>? categoriaId,
  }) {
    return GastosFijosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      monto: monto ?? this.monto,
      diaCobro: diaCobro ?? this.diaCobro,
      esAhorro: esAhorro ?? this.esAhorro,
      activo: activo ?? this.activo,
      categoriaId: categoriaId ?? this.categoriaId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (diaCobro.present) {
      map['dia_cobro'] = Variable<int>(diaCobro.value);
    }
    if (esAhorro.present) {
      map['es_ahorro'] = Variable<bool>(esAhorro.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GastosFijosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('monto: $monto, ')
          ..write('diaCobro: $diaCobro, ')
          ..write('esAhorro: $esAhorro, ')
          ..write('activo: $activo, ')
          ..write('categoriaId: $categoriaId')
          ..write(')'))
        .toString();
  }
}

class $TransaccionesTable extends Transacciones
    with TableInfo<$TransaccionesTable, Transaccion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransaccionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _montoMeta = const VerificationMeta('monto');
  @override
  late final GeneratedColumn<double> monto = GeneratedColumn<double>(
    'monto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT \'gasto\' CHECK (tipo IN (\'gasto\', \'ingreso\', \'pago_tarjeta\', \'transferencia_interna\'))',
    defaultValue: const CustomExpression('\'gasto\''),
  );
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
    'nota',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numeroCuotaMeta = const VerificationMeta(
    'numeroCuota',
  );
  @override
  late final GeneratedColumn<int> numeroCuota = GeneratedColumn<int>(
    'numero_cuota',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalCuotasMeta = const VerificationMeta(
    'totalCuotas',
  );
  @override
  late final GeneratedColumn<int> totalCuotas = GeneratedColumn<int>(
    'total_cuotas',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _etiquetaIdMeta = const VerificationMeta(
    'etiquetaId',
  );
  @override
  late final GeneratedColumn<int> etiquetaId = GeneratedColumn<int>(
    'etiqueta_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES etiquetas_categoria (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _transaccionPadreIdMeta =
      const VerificationMeta('transaccionPadreId');
  @override
  late final GeneratedColumn<int> transaccionPadreId = GeneratedColumn<int>(
    'transaccion_padre_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transacciones (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _medioPagoIdMeta = const VerificationMeta(
    'medioPagoId',
  );
  @override
  late final GeneratedColumn<int> medioPagoId = GeneratedColumn<int>(
    'medio_pago_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medios_pago (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _medioPagoDestinoIdMeta =
      const VerificationMeta('medioPagoDestinoId');
  @override
  late final GeneratedColumn<int> medioPagoDestinoId = GeneratedColumn<int>(
    'medio_pago_destino_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medios_pago (id) ON DELETE RESTRICT',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    monto,
    fecha,
    tipo,
    nota,
    numeroCuota,
    totalCuotas,
    categoriaId,
    etiquetaId,
    transaccionPadreId,
    medioPagoId,
    medioPagoDestinoId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transacciones';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaccion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('monto')) {
      context.handle(
        _montoMeta,
        monto.isAcceptableOrUnknown(data['monto']!, _montoMeta),
      );
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    }
    if (data.containsKey('nota')) {
      context.handle(
        _notaMeta,
        nota.isAcceptableOrUnknown(data['nota']!, _notaMeta),
      );
    }
    if (data.containsKey('numero_cuota')) {
      context.handle(
        _numeroCuotaMeta,
        numeroCuota.isAcceptableOrUnknown(
          data['numero_cuota']!,
          _numeroCuotaMeta,
        ),
      );
    }
    if (data.containsKey('total_cuotas')) {
      context.handle(
        _totalCuotasMeta,
        totalCuotas.isAcceptableOrUnknown(
          data['total_cuotas']!,
          _totalCuotasMeta,
        ),
      );
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    }
    if (data.containsKey('etiqueta_id')) {
      context.handle(
        _etiquetaIdMeta,
        etiquetaId.isAcceptableOrUnknown(data['etiqueta_id']!, _etiquetaIdMeta),
      );
    }
    if (data.containsKey('transaccion_padre_id')) {
      context.handle(
        _transaccionPadreIdMeta,
        transaccionPadreId.isAcceptableOrUnknown(
          data['transaccion_padre_id']!,
          _transaccionPadreIdMeta,
        ),
      );
    }
    if (data.containsKey('medio_pago_id')) {
      context.handle(
        _medioPagoIdMeta,
        medioPagoId.isAcceptableOrUnknown(
          data['medio_pago_id']!,
          _medioPagoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medioPagoIdMeta);
    }
    if (data.containsKey('medio_pago_destino_id')) {
      context.handle(
        _medioPagoDestinoIdMeta,
        medioPagoDestinoId.isAcceptableOrUnknown(
          data['medio_pago_destino_id']!,
          _medioPagoDestinoIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaccion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaccion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      monto: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      nota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nota'],
      ),
      numeroCuota: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero_cuota'],
      ),
      totalCuotas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_cuotas'],
      ),
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      ),
      etiquetaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}etiqueta_id'],
      ),
      transaccionPadreId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaccion_padre_id'],
      ),
      medioPagoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medio_pago_id'],
      )!,
      medioPagoDestinoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medio_pago_destino_id'],
      ),
    );
  }

  @override
  $TransaccionesTable createAlias(String alias) {
    return $TransaccionesTable(attachedDatabase, alias);
  }
}

class Transaccion extends DataClass implements Insertable<Transaccion> {
  final int id;
  final double monto;
  final DateTime fecha;
  final String tipo;
  final String? nota;
  final int? numeroCuota;
  final int? totalCuotas;
  final int? categoriaId;
  final int? etiquetaId;
  final int? transaccionPadreId;
  final int medioPagoId;
  final int? medioPagoDestinoId;
  const Transaccion({
    required this.id,
    required this.monto,
    required this.fecha,
    required this.tipo,
    this.nota,
    this.numeroCuota,
    this.totalCuotas,
    this.categoriaId,
    this.etiquetaId,
    this.transaccionPadreId,
    required this.medioPagoId,
    this.medioPagoDestinoId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['monto'] = Variable<double>(monto);
    map['fecha'] = Variable<DateTime>(fecha);
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    if (!nullToAbsent || numeroCuota != null) {
      map['numero_cuota'] = Variable<int>(numeroCuota);
    }
    if (!nullToAbsent || totalCuotas != null) {
      map['total_cuotas'] = Variable<int>(totalCuotas);
    }
    if (!nullToAbsent || categoriaId != null) {
      map['categoria_id'] = Variable<int>(categoriaId);
    }
    if (!nullToAbsent || etiquetaId != null) {
      map['etiqueta_id'] = Variable<int>(etiquetaId);
    }
    if (!nullToAbsent || transaccionPadreId != null) {
      map['transaccion_padre_id'] = Variable<int>(transaccionPadreId);
    }
    map['medio_pago_id'] = Variable<int>(medioPagoId);
    if (!nullToAbsent || medioPagoDestinoId != null) {
      map['medio_pago_destino_id'] = Variable<int>(medioPagoDestinoId);
    }
    return map;
  }

  TransaccionesCompanion toCompanion(bool nullToAbsent) {
    return TransaccionesCompanion(
      id: Value(id),
      monto: Value(monto),
      fecha: Value(fecha),
      tipo: Value(tipo),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      numeroCuota: numeroCuota == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroCuota),
      totalCuotas: totalCuotas == null && nullToAbsent
          ? const Value.absent()
          : Value(totalCuotas),
      categoriaId: categoriaId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoriaId),
      etiquetaId: etiquetaId == null && nullToAbsent
          ? const Value.absent()
          : Value(etiquetaId),
      transaccionPadreId: transaccionPadreId == null && nullToAbsent
          ? const Value.absent()
          : Value(transaccionPadreId),
      medioPagoId: Value(medioPagoId),
      medioPagoDestinoId: medioPagoDestinoId == null && nullToAbsent
          ? const Value.absent()
          : Value(medioPagoDestinoId),
    );
  }

  factory Transaccion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaccion(
      id: serializer.fromJson<int>(json['id']),
      monto: serializer.fromJson<double>(json['monto']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      tipo: serializer.fromJson<String>(json['tipo']),
      nota: serializer.fromJson<String?>(json['nota']),
      numeroCuota: serializer.fromJson<int?>(json['numeroCuota']),
      totalCuotas: serializer.fromJson<int?>(json['totalCuotas']),
      categoriaId: serializer.fromJson<int?>(json['categoriaId']),
      etiquetaId: serializer.fromJson<int?>(json['etiquetaId']),
      transaccionPadreId: serializer.fromJson<int?>(json['transaccionPadreId']),
      medioPagoId: serializer.fromJson<int>(json['medioPagoId']),
      medioPagoDestinoId: serializer.fromJson<int?>(json['medioPagoDestinoId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'monto': serializer.toJson<double>(monto),
      'fecha': serializer.toJson<DateTime>(fecha),
      'tipo': serializer.toJson<String>(tipo),
      'nota': serializer.toJson<String?>(nota),
      'numeroCuota': serializer.toJson<int?>(numeroCuota),
      'totalCuotas': serializer.toJson<int?>(totalCuotas),
      'categoriaId': serializer.toJson<int?>(categoriaId),
      'etiquetaId': serializer.toJson<int?>(etiquetaId),
      'transaccionPadreId': serializer.toJson<int?>(transaccionPadreId),
      'medioPagoId': serializer.toJson<int>(medioPagoId),
      'medioPagoDestinoId': serializer.toJson<int?>(medioPagoDestinoId),
    };
  }

  Transaccion copyWith({
    int? id,
    double? monto,
    DateTime? fecha,
    String? tipo,
    Value<String?> nota = const Value.absent(),
    Value<int?> numeroCuota = const Value.absent(),
    Value<int?> totalCuotas = const Value.absent(),
    Value<int?> categoriaId = const Value.absent(),
    Value<int?> etiquetaId = const Value.absent(),
    Value<int?> transaccionPadreId = const Value.absent(),
    int? medioPagoId,
    Value<int?> medioPagoDestinoId = const Value.absent(),
  }) => Transaccion(
    id: id ?? this.id,
    monto: monto ?? this.monto,
    fecha: fecha ?? this.fecha,
    tipo: tipo ?? this.tipo,
    nota: nota.present ? nota.value : this.nota,
    numeroCuota: numeroCuota.present ? numeroCuota.value : this.numeroCuota,
    totalCuotas: totalCuotas.present ? totalCuotas.value : this.totalCuotas,
    categoriaId: categoriaId.present ? categoriaId.value : this.categoriaId,
    etiquetaId: etiquetaId.present ? etiquetaId.value : this.etiquetaId,
    transaccionPadreId: transaccionPadreId.present
        ? transaccionPadreId.value
        : this.transaccionPadreId,
    medioPagoId: medioPagoId ?? this.medioPagoId,
    medioPagoDestinoId: medioPagoDestinoId.present
        ? medioPagoDestinoId.value
        : this.medioPagoDestinoId,
  );
  Transaccion copyWithCompanion(TransaccionesCompanion data) {
    return Transaccion(
      id: data.id.present ? data.id.value : this.id,
      monto: data.monto.present ? data.monto.value : this.monto,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      nota: data.nota.present ? data.nota.value : this.nota,
      numeroCuota: data.numeroCuota.present
          ? data.numeroCuota.value
          : this.numeroCuota,
      totalCuotas: data.totalCuotas.present
          ? data.totalCuotas.value
          : this.totalCuotas,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      etiquetaId: data.etiquetaId.present
          ? data.etiquetaId.value
          : this.etiquetaId,
      transaccionPadreId: data.transaccionPadreId.present
          ? data.transaccionPadreId.value
          : this.transaccionPadreId,
      medioPagoId: data.medioPagoId.present
          ? data.medioPagoId.value
          : this.medioPagoId,
      medioPagoDestinoId: data.medioPagoDestinoId.present
          ? data.medioPagoDestinoId.value
          : this.medioPagoDestinoId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaccion(')
          ..write('id: $id, ')
          ..write('monto: $monto, ')
          ..write('fecha: $fecha, ')
          ..write('tipo: $tipo, ')
          ..write('nota: $nota, ')
          ..write('numeroCuota: $numeroCuota, ')
          ..write('totalCuotas: $totalCuotas, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('etiquetaId: $etiquetaId, ')
          ..write('transaccionPadreId: $transaccionPadreId, ')
          ..write('medioPagoId: $medioPagoId, ')
          ..write('medioPagoDestinoId: $medioPagoDestinoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    monto,
    fecha,
    tipo,
    nota,
    numeroCuota,
    totalCuotas,
    categoriaId,
    etiquetaId,
    transaccionPadreId,
    medioPagoId,
    medioPagoDestinoId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaccion &&
          other.id == this.id &&
          other.monto == this.monto &&
          other.fecha == this.fecha &&
          other.tipo == this.tipo &&
          other.nota == this.nota &&
          other.numeroCuota == this.numeroCuota &&
          other.totalCuotas == this.totalCuotas &&
          other.categoriaId == this.categoriaId &&
          other.etiquetaId == this.etiquetaId &&
          other.transaccionPadreId == this.transaccionPadreId &&
          other.medioPagoId == this.medioPagoId &&
          other.medioPagoDestinoId == this.medioPagoDestinoId);
}

class TransaccionesCompanion extends UpdateCompanion<Transaccion> {
  final Value<int> id;
  final Value<double> monto;
  final Value<DateTime> fecha;
  final Value<String> tipo;
  final Value<String?> nota;
  final Value<int?> numeroCuota;
  final Value<int?> totalCuotas;
  final Value<int?> categoriaId;
  final Value<int?> etiquetaId;
  final Value<int?> transaccionPadreId;
  final Value<int> medioPagoId;
  final Value<int?> medioPagoDestinoId;
  const TransaccionesCompanion({
    this.id = const Value.absent(),
    this.monto = const Value.absent(),
    this.fecha = const Value.absent(),
    this.tipo = const Value.absent(),
    this.nota = const Value.absent(),
    this.numeroCuota = const Value.absent(),
    this.totalCuotas = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.etiquetaId = const Value.absent(),
    this.transaccionPadreId = const Value.absent(),
    this.medioPagoId = const Value.absent(),
    this.medioPagoDestinoId = const Value.absent(),
  });
  TransaccionesCompanion.insert({
    this.id = const Value.absent(),
    required double monto,
    required DateTime fecha,
    this.tipo = const Value.absent(),
    this.nota = const Value.absent(),
    this.numeroCuota = const Value.absent(),
    this.totalCuotas = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.etiquetaId = const Value.absent(),
    this.transaccionPadreId = const Value.absent(),
    required int medioPagoId,
    this.medioPagoDestinoId = const Value.absent(),
  }) : monto = Value(monto),
       fecha = Value(fecha),
       medioPagoId = Value(medioPagoId);
  static Insertable<Transaccion> custom({
    Expression<int>? id,
    Expression<double>? monto,
    Expression<DateTime>? fecha,
    Expression<String>? tipo,
    Expression<String>? nota,
    Expression<int>? numeroCuota,
    Expression<int>? totalCuotas,
    Expression<int>? categoriaId,
    Expression<int>? etiquetaId,
    Expression<int>? transaccionPadreId,
    Expression<int>? medioPagoId,
    Expression<int>? medioPagoDestinoId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (monto != null) 'monto': monto,
      if (fecha != null) 'fecha': fecha,
      if (tipo != null) 'tipo': tipo,
      if (nota != null) 'nota': nota,
      if (numeroCuota != null) 'numero_cuota': numeroCuota,
      if (totalCuotas != null) 'total_cuotas': totalCuotas,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (etiquetaId != null) 'etiqueta_id': etiquetaId,
      if (transaccionPadreId != null)
        'transaccion_padre_id': transaccionPadreId,
      if (medioPagoId != null) 'medio_pago_id': medioPagoId,
      if (medioPagoDestinoId != null)
        'medio_pago_destino_id': medioPagoDestinoId,
    });
  }

  TransaccionesCompanion copyWith({
    Value<int>? id,
    Value<double>? monto,
    Value<DateTime>? fecha,
    Value<String>? tipo,
    Value<String?>? nota,
    Value<int?>? numeroCuota,
    Value<int?>? totalCuotas,
    Value<int?>? categoriaId,
    Value<int?>? etiquetaId,
    Value<int?>? transaccionPadreId,
    Value<int>? medioPagoId,
    Value<int?>? medioPagoDestinoId,
  }) {
    return TransaccionesCompanion(
      id: id ?? this.id,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      tipo: tipo ?? this.tipo,
      nota: nota ?? this.nota,
      numeroCuota: numeroCuota ?? this.numeroCuota,
      totalCuotas: totalCuotas ?? this.totalCuotas,
      categoriaId: categoriaId ?? this.categoriaId,
      etiquetaId: etiquetaId ?? this.etiquetaId,
      transaccionPadreId: transaccionPadreId ?? this.transaccionPadreId,
      medioPagoId: medioPagoId ?? this.medioPagoId,
      medioPagoDestinoId: medioPagoDestinoId ?? this.medioPagoDestinoId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (numeroCuota.present) {
      map['numero_cuota'] = Variable<int>(numeroCuota.value);
    }
    if (totalCuotas.present) {
      map['total_cuotas'] = Variable<int>(totalCuotas.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (etiquetaId.present) {
      map['etiqueta_id'] = Variable<int>(etiquetaId.value);
    }
    if (transaccionPadreId.present) {
      map['transaccion_padre_id'] = Variable<int>(transaccionPadreId.value);
    }
    if (medioPagoId.present) {
      map['medio_pago_id'] = Variable<int>(medioPagoId.value);
    }
    if (medioPagoDestinoId.present) {
      map['medio_pago_destino_id'] = Variable<int>(medioPagoDestinoId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransaccionesCompanion(')
          ..write('id: $id, ')
          ..write('monto: $monto, ')
          ..write('fecha: $fecha, ')
          ..write('tipo: $tipo, ')
          ..write('nota: $nota, ')
          ..write('numeroCuota: $numeroCuota, ')
          ..write('totalCuotas: $totalCuotas, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('etiquetaId: $etiquetaId, ')
          ..write('transaccionPadreId: $transaccionPadreId, ')
          ..write('medioPagoId: $medioPagoId, ')
          ..write('medioPagoDestinoId: $medioPagoDestinoId')
          ..write(')'))
        .toString();
  }
}

class $AppThemesTable extends AppThemes
    with TableInfo<$AppThemesTable, AppThemeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppThemesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _backgroundHexMeta = const VerificationMeta(
    'backgroundHex',
  );
  @override
  late final GeneratedColumn<String> backgroundHex = GeneratedColumn<String>(
    'background_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _surfaceHexMeta = const VerificationMeta(
    'surfaceHex',
  );
  @override
  late final GeneratedColumn<String> surfaceHex = GeneratedColumn<String>(
    'surface_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textHexMeta = const VerificationMeta(
    'textHex',
  );
  @override
  late final GeneratedColumn<String> textHex = GeneratedColumn<String>(
    'text_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accentHexMeta = const VerificationMeta(
    'accentHex',
  );
  @override
  late final GeneratedColumn<String> accentHex = GeneratedColumn<String>(
    'accent_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    backgroundHex,
    surfaceHex,
    textHex,
    accentHex,
    isCustom,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_themes';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppThemeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('background_hex')) {
      context.handle(
        _backgroundHexMeta,
        backgroundHex.isAcceptableOrUnknown(
          data['background_hex']!,
          _backgroundHexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_backgroundHexMeta);
    }
    if (data.containsKey('surface_hex')) {
      context.handle(
        _surfaceHexMeta,
        surfaceHex.isAcceptableOrUnknown(data['surface_hex']!, _surfaceHexMeta),
      );
    } else if (isInserting) {
      context.missing(_surfaceHexMeta);
    }
    if (data.containsKey('text_hex')) {
      context.handle(
        _textHexMeta,
        textHex.isAcceptableOrUnknown(data['text_hex']!, _textHexMeta),
      );
    } else if (isInserting) {
      context.missing(_textHexMeta);
    }
    if (data.containsKey('accent_hex')) {
      context.handle(
        _accentHexMeta,
        accentHex.isAcceptableOrUnknown(data['accent_hex']!, _accentHexMeta),
      );
    } else if (isInserting) {
      context.missing(_accentHexMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppThemeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppThemeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      backgroundHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}background_hex'],
      )!,
      surfaceHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}surface_hex'],
      )!,
      textHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_hex'],
      )!,
      accentHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accent_hex'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
    );
  }

  @override
  $AppThemesTable createAlias(String alias) {
    return $AppThemesTable(attachedDatabase, alias);
  }
}

class AppThemeEntry extends DataClass implements Insertable<AppThemeEntry> {
  final int id;

  /// Nombre único del tema, ej. "Lemon Dark", "Mi Tema Azul".
  final String name;
  final String backgroundHex;
  final String surfaceHex;
  final String textHex;
  final String accentHex;

  /// false = tema de sistema (no se puede borrar). true = creado por el usuario.
  final bool isCustom;
  const AppThemeEntry({
    required this.id,
    required this.name,
    required this.backgroundHex,
    required this.surfaceHex,
    required this.textHex,
    required this.accentHex,
    required this.isCustom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['background_hex'] = Variable<String>(backgroundHex);
    map['surface_hex'] = Variable<String>(surfaceHex);
    map['text_hex'] = Variable<String>(textHex);
    map['accent_hex'] = Variable<String>(accentHex);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  AppThemesCompanion toCompanion(bool nullToAbsent) {
    return AppThemesCompanion(
      id: Value(id),
      name: Value(name),
      backgroundHex: Value(backgroundHex),
      surfaceHex: Value(surfaceHex),
      textHex: Value(textHex),
      accentHex: Value(accentHex),
      isCustom: Value(isCustom),
    );
  }

  factory AppThemeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppThemeEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      backgroundHex: serializer.fromJson<String>(json['backgroundHex']),
      surfaceHex: serializer.fromJson<String>(json['surfaceHex']),
      textHex: serializer.fromJson<String>(json['textHex']),
      accentHex: serializer.fromJson<String>(json['accentHex']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'backgroundHex': serializer.toJson<String>(backgroundHex),
      'surfaceHex': serializer.toJson<String>(surfaceHex),
      'textHex': serializer.toJson<String>(textHex),
      'accentHex': serializer.toJson<String>(accentHex),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  AppThemeEntry copyWith({
    int? id,
    String? name,
    String? backgroundHex,
    String? surfaceHex,
    String? textHex,
    String? accentHex,
    bool? isCustom,
  }) => AppThemeEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    backgroundHex: backgroundHex ?? this.backgroundHex,
    surfaceHex: surfaceHex ?? this.surfaceHex,
    textHex: textHex ?? this.textHex,
    accentHex: accentHex ?? this.accentHex,
    isCustom: isCustom ?? this.isCustom,
  );
  AppThemeEntry copyWithCompanion(AppThemesCompanion data) {
    return AppThemeEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      backgroundHex: data.backgroundHex.present
          ? data.backgroundHex.value
          : this.backgroundHex,
      surfaceHex: data.surfaceHex.present
          ? data.surfaceHex.value
          : this.surfaceHex,
      textHex: data.textHex.present ? data.textHex.value : this.textHex,
      accentHex: data.accentHex.present ? data.accentHex.value : this.accentHex,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppThemeEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('backgroundHex: $backgroundHex, ')
          ..write('surfaceHex: $surfaceHex, ')
          ..write('textHex: $textHex, ')
          ..write('accentHex: $accentHex, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    backgroundHex,
    surfaceHex,
    textHex,
    accentHex,
    isCustom,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppThemeEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.backgroundHex == this.backgroundHex &&
          other.surfaceHex == this.surfaceHex &&
          other.textHex == this.textHex &&
          other.accentHex == this.accentHex &&
          other.isCustom == this.isCustom);
}

class AppThemesCompanion extends UpdateCompanion<AppThemeEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> backgroundHex;
  final Value<String> surfaceHex;
  final Value<String> textHex;
  final Value<String> accentHex;
  final Value<bool> isCustom;
  const AppThemesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.backgroundHex = const Value.absent(),
    this.surfaceHex = const Value.absent(),
    this.textHex = const Value.absent(),
    this.accentHex = const Value.absent(),
    this.isCustom = const Value.absent(),
  });
  AppThemesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String backgroundHex,
    required String surfaceHex,
    required String textHex,
    required String accentHex,
    this.isCustom = const Value.absent(),
  }) : name = Value(name),
       backgroundHex = Value(backgroundHex),
       surfaceHex = Value(surfaceHex),
       textHex = Value(textHex),
       accentHex = Value(accentHex);
  static Insertable<AppThemeEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? backgroundHex,
    Expression<String>? surfaceHex,
    Expression<String>? textHex,
    Expression<String>? accentHex,
    Expression<bool>? isCustom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (backgroundHex != null) 'background_hex': backgroundHex,
      if (surfaceHex != null) 'surface_hex': surfaceHex,
      if (textHex != null) 'text_hex': textHex,
      if (accentHex != null) 'accent_hex': accentHex,
      if (isCustom != null) 'is_custom': isCustom,
    });
  }

  AppThemesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? backgroundHex,
    Value<String>? surfaceHex,
    Value<String>? textHex,
    Value<String>? accentHex,
    Value<bool>? isCustom,
  }) {
    return AppThemesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      backgroundHex: backgroundHex ?? this.backgroundHex,
      surfaceHex: surfaceHex ?? this.surfaceHex,
      textHex: textHex ?? this.textHex,
      accentHex: accentHex ?? this.accentHex,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (backgroundHex.present) {
      map['background_hex'] = Variable<String>(backgroundHex.value);
    }
    if (surfaceHex.present) {
      map['surface_hex'] = Variable<String>(surfaceHex.value);
    }
    if (textHex.present) {
      map['text_hex'] = Variable<String>(textHex.value);
    }
    if (accentHex.present) {
      map['accent_hex'] = Variable<String>(accentHex.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppThemesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('backgroundHex: $backgroundHex, ')
          ..write('surfaceHex: $surfaceHex, ')
          ..write('textHex: $textHex, ')
          ..write('accentHex: $accentHex, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriasTable categorias = $CategoriasTable(this);
  late final $EtiquetasCategoriaTable etiquetasCategoria =
      $EtiquetasCategoriaTable(this);
  late final $MediosPagoTable mediosPago = $MediosPagoTable(this);
  late final $GastosFijosTable gastosFijos = $GastosFijosTable(this);
  late final $TransaccionesTable transacciones = $TransaccionesTable(this);
  late final $AppThemesTable appThemes = $AppThemesTable(this);
  late final TransaccionesDao transaccionesDao = TransaccionesDao(
    this as AppDatabase,
  );
  late final SaldosDao saldosDao = SaldosDao(this as AppDatabase);
  late final ReportesDao reportesDao = ReportesDao(this as AppDatabase);
  late final ThemesDao themesDao = ThemesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categorias,
    etiquetasCategoria,
    mediosPago,
    gastosFijos,
    transacciones,
    appThemes,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'transacciones',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transacciones', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CategoriasTableCreateCompanionBuilder =
    CategoriasCompanion Function({
      Value<int> id,
      required String nombre,
      required String colorHex,
      required String icono,
      Value<int> orden,
      Value<int> orderIndex,
      Value<bool> esPorDefecto,
      Value<double> presupuestoAsignado,
      Value<bool> activo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CategoriasTableUpdateCompanionBuilder =
    CategoriasCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> colorHex,
      Value<String> icono,
      Value<int> orden,
      Value<int> orderIndex,
      Value<bool> esPorDefecto,
      Value<double> presupuestoAsignado,
      Value<bool> activo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CategoriasTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriasTable, Categoria> {
  $$CategoriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EtiquetasCategoriaTable, List<EtiquetaCategoria>>
  _etiquetasCategoriaRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.etiquetasCategoria,
        aliasName: 'categorias__id__etiquetas_categoria__categoria_id',
      );

  $$EtiquetasCategoriaTableProcessedTableManager get etiquetasCategoriaRefs {
    final manager = $$EtiquetasCategoriaTableTableManager(
      $_db,
      $_db.etiquetasCategoria,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _etiquetasCategoriaRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GastosFijosTable, List<GastoFijo>>
  _gastosFijosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gastosFijos,
    aliasName: 'categorias__id__gastos_fijos__categoria_id',
  );

  $$GastosFijosTableProcessedTableManager get gastosFijosRefs {
    final manager = $$GastosFijosTableTableManager(
      $_db,
      $_db.gastosFijos,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gastosFijosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransaccionesTable, List<Transaccion>>
  _transaccionesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transacciones,
    aliasName: 'categorias__id__transacciones__categoria_id',
  );

  $$TransaccionesTableProcessedTableManager get transaccionesRefs {
    final manager = $$TransaccionesTableTableManager(
      $_db,
      $_db.transacciones,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transaccionesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriasTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icono => $composableBuilder(
    column: $table.icono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esPorDefecto => $composableBuilder(
    column: $table.esPorDefecto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get presupuestoAsignado => $composableBuilder(
    column: $table.presupuestoAsignado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> etiquetasCategoriaRefs(
    Expression<bool> Function($$EtiquetasCategoriaTableFilterComposer f) f,
  ) {
    final $$EtiquetasCategoriaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.etiquetasCategoria,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EtiquetasCategoriaTableFilterComposer(
            $db: $db,
            $table: $db.etiquetasCategoria,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> gastosFijosRefs(
    Expression<bool> Function($$GastosFijosTableFilterComposer f) f,
  ) {
    final $$GastosFijosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gastosFijos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GastosFijosTableFilterComposer(
            $db: $db,
            $table: $db.gastosFijos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transaccionesRefs(
    Expression<bool> Function($$TransaccionesTableFilterComposer f) f,
  ) {
    final $$TransaccionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transacciones,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaccionesTableFilterComposer(
            $db: $db,
            $table: $db.transacciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icono => $composableBuilder(
    column: $table.icono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esPorDefecto => $composableBuilder(
    column: $table.esPorDefecto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get presupuestoAsignado => $composableBuilder(
    column: $table.presupuestoAsignado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<String> get icono =>
      $composableBuilder(column: $table.icono, builder: (column) => column);

  GeneratedColumn<int> get orden =>
      $composableBuilder(column: $table.orden, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get esPorDefecto => $composableBuilder(
    column: $table.esPorDefecto,
    builder: (column) => column,
  );

  GeneratedColumn<double> get presupuestoAsignado => $composableBuilder(
    column: $table.presupuestoAsignado,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> etiquetasCategoriaRefs<T extends Object>(
    Expression<T> Function($$EtiquetasCategoriaTableAnnotationComposer a) f,
  ) {
    final $$EtiquetasCategoriaTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.etiquetasCategoria,
          getReferencedColumn: (t) => t.categoriaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EtiquetasCategoriaTableAnnotationComposer(
                $db: $db,
                $table: $db.etiquetasCategoria,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> gastosFijosRefs<T extends Object>(
    Expression<T> Function($$GastosFijosTableAnnotationComposer a) f,
  ) {
    final $$GastosFijosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gastosFijos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GastosFijosTableAnnotationComposer(
            $db: $db,
            $table: $db.gastosFijos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transaccionesRefs<T extends Object>(
    Expression<T> Function($$TransaccionesTableAnnotationComposer a) f,
  ) {
    final $$TransaccionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transacciones,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaccionesTableAnnotationComposer(
            $db: $db,
            $table: $db.transacciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriasTable,
          Categoria,
          $$CategoriasTableFilterComposer,
          $$CategoriasTableOrderingComposer,
          $$CategoriasTableAnnotationComposer,
          $$CategoriasTableCreateCompanionBuilder,
          $$CategoriasTableUpdateCompanionBuilder,
          (Categoria, $$CategoriasTableReferences),
          Categoria,
          PrefetchHooks Function({
            bool etiquetasCategoriaRefs,
            bool gastosFijosRefs,
            bool transaccionesRefs,
          })
        > {
  $$CategoriasTableTableManager(_$AppDatabase db, $CategoriasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<String> icono = const Value.absent(),
                Value<int> orden = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<bool> esPorDefecto = const Value.absent(),
                Value<double> presupuestoAsignado = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CategoriasCompanion(
                id: id,
                nombre: nombre,
                colorHex: colorHex,
                icono: icono,
                orden: orden,
                orderIndex: orderIndex,
                esPorDefecto: esPorDefecto,
                presupuestoAsignado: presupuestoAsignado,
                activo: activo,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String colorHex,
                required String icono,
                Value<int> orden = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<bool> esPorDefecto = const Value.absent(),
                Value<double> presupuestoAsignado = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CategoriasCompanion.insert(
                id: id,
                nombre: nombre,
                colorHex: colorHex,
                icono: icono,
                orden: orden,
                orderIndex: orderIndex,
                esPorDefecto: esPorDefecto,
                presupuestoAsignado: presupuestoAsignado,
                activo: activo,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                etiquetasCategoriaRefs = false,
                gastosFijosRefs = false,
                transaccionesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (etiquetasCategoriaRefs) db.etiquetasCategoria,
                    if (gastosFijosRefs) db.gastosFijos,
                    if (transaccionesRefs) db.transacciones,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (etiquetasCategoriaRefs)
                        await $_getPrefetchedData<
                          Categoria,
                          $CategoriasTable,
                          EtiquetaCategoria
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasTableReferences
                              ._etiquetasCategoriaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasTableReferences(
                                db,
                                table,
                                p0,
                              ).etiquetasCategoriaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoriaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (gastosFijosRefs)
                        await $_getPrefetchedData<
                          Categoria,
                          $CategoriasTable,
                          GastoFijo
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasTableReferences
                              ._gastosFijosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasTableReferences(
                                db,
                                table,
                                p0,
                              ).gastosFijosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoriaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transaccionesRefs)
                        await $_getPrefetchedData<
                          Categoria,
                          $CategoriasTable,
                          Transaccion
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasTableReferences
                              ._transaccionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasTableReferences(
                                db,
                                table,
                                p0,
                              ).transaccionesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoriaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriasTable,
      Categoria,
      $$CategoriasTableFilterComposer,
      $$CategoriasTableOrderingComposer,
      $$CategoriasTableAnnotationComposer,
      $$CategoriasTableCreateCompanionBuilder,
      $$CategoriasTableUpdateCompanionBuilder,
      (Categoria, $$CategoriasTableReferences),
      Categoria,
      PrefetchHooks Function({
        bool etiquetasCategoriaRefs,
        bool gastosFijosRefs,
        bool transaccionesRefs,
      })
    >;
typedef $$EtiquetasCategoriaTableCreateCompanionBuilder =
    EtiquetasCategoriaCompanion Function({
      Value<int> id,
      required String nombre,
      required int categoriaId,
    });
typedef $$EtiquetasCategoriaTableUpdateCompanionBuilder =
    EtiquetasCategoriaCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<int> categoriaId,
    });

final class $$EtiquetasCategoriaTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EtiquetasCategoriaTable,
          EtiquetaCategoria
        > {
  $$EtiquetasCategoriaTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) => db.categorias
      .createAlias('etiquetas_categoria__categoria_id__categorias__id');

  $$CategoriasTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id')!;

    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransaccionesTable, List<Transaccion>>
  _transaccionesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transacciones,
    aliasName: 'etiquetas_categoria__id__transacciones__etiqueta_id',
  );

  $$TransaccionesTableProcessedTableManager get transaccionesRefs {
    final manager = $$TransaccionesTableTableManager(
      $_db,
      $_db.transacciones,
    ).filter((f) => f.etiquetaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transaccionesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EtiquetasCategoriaTableFilterComposer
    extends Composer<_$AppDatabase, $EtiquetasCategoriaTable> {
  $$EtiquetasCategoriaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transaccionesRefs(
    Expression<bool> Function($$TransaccionesTableFilterComposer f) f,
  ) {
    final $$TransaccionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transacciones,
      getReferencedColumn: (t) => t.etiquetaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaccionesTableFilterComposer(
            $db: $db,
            $table: $db.transacciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EtiquetasCategoriaTableOrderingComposer
    extends Composer<_$AppDatabase, $EtiquetasCategoriaTable> {
  $$EtiquetasCategoriaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EtiquetasCategoriaTableAnnotationComposer
    extends Composer<_$AppDatabase, $EtiquetasCategoriaTable> {
  $$EtiquetasCategoriaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transaccionesRefs<T extends Object>(
    Expression<T> Function($$TransaccionesTableAnnotationComposer a) f,
  ) {
    final $$TransaccionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transacciones,
      getReferencedColumn: (t) => t.etiquetaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaccionesTableAnnotationComposer(
            $db: $db,
            $table: $db.transacciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EtiquetasCategoriaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EtiquetasCategoriaTable,
          EtiquetaCategoria,
          $$EtiquetasCategoriaTableFilterComposer,
          $$EtiquetasCategoriaTableOrderingComposer,
          $$EtiquetasCategoriaTableAnnotationComposer,
          $$EtiquetasCategoriaTableCreateCompanionBuilder,
          $$EtiquetasCategoriaTableUpdateCompanionBuilder,
          (EtiquetaCategoria, $$EtiquetasCategoriaTableReferences),
          EtiquetaCategoria,
          PrefetchHooks Function({bool categoriaId, bool transaccionesRefs})
        > {
  $$EtiquetasCategoriaTableTableManager(
    _$AppDatabase db,
    $EtiquetasCategoriaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EtiquetasCategoriaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EtiquetasCategoriaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EtiquetasCategoriaTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int> categoriaId = const Value.absent(),
              }) => EtiquetasCategoriaCompanion(
                id: id,
                nombre: nombre,
                categoriaId: categoriaId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required int categoriaId,
              }) => EtiquetasCategoriaCompanion.insert(
                id: id,
                nombre: nombre,
                categoriaId: categoriaId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EtiquetasCategoriaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoriaId = false, transaccionesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transaccionesRefs) db.transacciones,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoriaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoriaId,
                                    referencedTable:
                                        $$EtiquetasCategoriaTableReferences
                                            ._categoriaIdTable(db),
                                    referencedColumn:
                                        $$EtiquetasCategoriaTableReferences
                                            ._categoriaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transaccionesRefs)
                        await $_getPrefetchedData<
                          EtiquetaCategoria,
                          $EtiquetasCategoriaTable,
                          Transaccion
                        >(
                          currentTable: table,
                          referencedTable: $$EtiquetasCategoriaTableReferences
                              ._transaccionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EtiquetasCategoriaTableReferences(
                                db,
                                table,
                                p0,
                              ).transaccionesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.etiquetaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EtiquetasCategoriaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EtiquetasCategoriaTable,
      EtiquetaCategoria,
      $$EtiquetasCategoriaTableFilterComposer,
      $$EtiquetasCategoriaTableOrderingComposer,
      $$EtiquetasCategoriaTableAnnotationComposer,
      $$EtiquetasCategoriaTableCreateCompanionBuilder,
      $$EtiquetasCategoriaTableUpdateCompanionBuilder,
      (EtiquetaCategoria, $$EtiquetasCategoriaTableReferences),
      EtiquetaCategoria,
      PrefetchHooks Function({bool categoriaId, bool transaccionesRefs})
    >;
typedef $$MediosPagoTableCreateCompanionBuilder =
    MediosPagoCompanion Function({
      Value<int> id,
      required String nombre,
      Value<String?> banco,
      required String tipo,
      Value<double> saldoInicial,
      Value<double?> lineaCredito,
      Value<int?> diaCorte,
      Value<int?> diaPago,
      Value<bool> activo,
    });
typedef $$MediosPagoTableUpdateCompanionBuilder =
    MediosPagoCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String?> banco,
      Value<String> tipo,
      Value<double> saldoInicial,
      Value<double?> lineaCredito,
      Value<int?> diaCorte,
      Value<int?> diaPago,
      Value<bool> activo,
    });

final class $$MediosPagoTableReferences
    extends BaseReferences<_$AppDatabase, $MediosPagoTable, MedioPago> {
  $$MediosPagoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransaccionesTable, List<Transaccion>>
  _transaccionesOrigenTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transacciones,
    aliasName: 'medios_pago__id__transacciones__medio_pago_id',
  );

  $$TransaccionesTableProcessedTableManager get transaccionesOrigen {
    final manager = $$TransaccionesTableTableManager(
      $_db,
      $_db.transacciones,
    ).filter((f) => f.medioPagoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transaccionesOrigenTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransaccionesTable, List<Transaccion>>
  _transaccionesDestinoTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transacciones,
    aliasName: 'medios_pago__id__transacciones__medio_pago_destino_id',
  );

  $$TransaccionesTableProcessedTableManager get transaccionesDestino {
    final manager = $$TransaccionesTableTableManager($_db, $_db.transacciones)
        .filter(
          (f) => f.medioPagoDestinoId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _transaccionesDestinoTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MediosPagoTableFilterComposer
    extends Composer<_$AppDatabase, $MediosPagoTable> {
  $$MediosPagoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get banco => $composableBuilder(
    column: $table.banco,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saldoInicial => $composableBuilder(
    column: $table.saldoInicial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineaCredito => $composableBuilder(
    column: $table.lineaCredito,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diaCorte => $composableBuilder(
    column: $table.diaCorte,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diaPago => $composableBuilder(
    column: $table.diaPago,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transaccionesOrigen(
    Expression<bool> Function($$TransaccionesTableFilterComposer f) f,
  ) {
    final $$TransaccionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transacciones,
      getReferencedColumn: (t) => t.medioPagoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaccionesTableFilterComposer(
            $db: $db,
            $table: $db.transacciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transaccionesDestino(
    Expression<bool> Function($$TransaccionesTableFilterComposer f) f,
  ) {
    final $$TransaccionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transacciones,
      getReferencedColumn: (t) => t.medioPagoDestinoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaccionesTableFilterComposer(
            $db: $db,
            $table: $db.transacciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediosPagoTableOrderingComposer
    extends Composer<_$AppDatabase, $MediosPagoTable> {
  $$MediosPagoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get banco => $composableBuilder(
    column: $table.banco,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saldoInicial => $composableBuilder(
    column: $table.saldoInicial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineaCredito => $composableBuilder(
    column: $table.lineaCredito,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diaCorte => $composableBuilder(
    column: $table.diaCorte,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diaPago => $composableBuilder(
    column: $table.diaPago,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediosPagoTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediosPagoTable> {
  $$MediosPagoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get banco =>
      $composableBuilder(column: $table.banco, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<double> get saldoInicial => $composableBuilder(
    column: $table.saldoInicial,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lineaCredito => $composableBuilder(
    column: $table.lineaCredito,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diaCorte =>
      $composableBuilder(column: $table.diaCorte, builder: (column) => column);

  GeneratedColumn<int> get diaPago =>
      $composableBuilder(column: $table.diaPago, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  Expression<T> transaccionesOrigen<T extends Object>(
    Expression<T> Function($$TransaccionesTableAnnotationComposer a) f,
  ) {
    final $$TransaccionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transacciones,
      getReferencedColumn: (t) => t.medioPagoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaccionesTableAnnotationComposer(
            $db: $db,
            $table: $db.transacciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transaccionesDestino<T extends Object>(
    Expression<T> Function($$TransaccionesTableAnnotationComposer a) f,
  ) {
    final $$TransaccionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transacciones,
      getReferencedColumn: (t) => t.medioPagoDestinoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaccionesTableAnnotationComposer(
            $db: $db,
            $table: $db.transacciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediosPagoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediosPagoTable,
          MedioPago,
          $$MediosPagoTableFilterComposer,
          $$MediosPagoTableOrderingComposer,
          $$MediosPagoTableAnnotationComposer,
          $$MediosPagoTableCreateCompanionBuilder,
          $$MediosPagoTableUpdateCompanionBuilder,
          (MedioPago, $$MediosPagoTableReferences),
          MedioPago,
          PrefetchHooks Function({
            bool transaccionesOrigen,
            bool transaccionesDestino,
          })
        > {
  $$MediosPagoTableTableManager(_$AppDatabase db, $MediosPagoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediosPagoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediosPagoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediosPagoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> banco = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<double> saldoInicial = const Value.absent(),
                Value<double?> lineaCredito = const Value.absent(),
                Value<int?> diaCorte = const Value.absent(),
                Value<int?> diaPago = const Value.absent(),
                Value<bool> activo = const Value.absent(),
              }) => MediosPagoCompanion(
                id: id,
                nombre: nombre,
                banco: banco,
                tipo: tipo,
                saldoInicial: saldoInicial,
                lineaCredito: lineaCredito,
                diaCorte: diaCorte,
                diaPago: diaPago,
                activo: activo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String?> banco = const Value.absent(),
                required String tipo,
                Value<double> saldoInicial = const Value.absent(),
                Value<double?> lineaCredito = const Value.absent(),
                Value<int?> diaCorte = const Value.absent(),
                Value<int?> diaPago = const Value.absent(),
                Value<bool> activo = const Value.absent(),
              }) => MediosPagoCompanion.insert(
                id: id,
                nombre: nombre,
                banco: banco,
                tipo: tipo,
                saldoInicial: saldoInicial,
                lineaCredito: lineaCredito,
                diaCorte: diaCorte,
                diaPago: diaPago,
                activo: activo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MediosPagoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({transaccionesOrigen = false, transaccionesDestino = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transaccionesOrigen) db.transacciones,
                    if (transaccionesDestino) db.transacciones,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transaccionesOrigen)
                        await $_getPrefetchedData<
                          MedioPago,
                          $MediosPagoTable,
                          Transaccion
                        >(
                          currentTable: table,
                          referencedTable: $$MediosPagoTableReferences
                              ._transaccionesOrigenTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediosPagoTableReferences(
                                db,
                                table,
                                p0,
                              ).transaccionesOrigen,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medioPagoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transaccionesDestino)
                        await $_getPrefetchedData<
                          MedioPago,
                          $MediosPagoTable,
                          Transaccion
                        >(
                          currentTable: table,
                          referencedTable: $$MediosPagoTableReferences
                              ._transaccionesDestinoTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediosPagoTableReferences(
                                db,
                                table,
                                p0,
                              ).transaccionesDestino,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medioPagoDestinoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MediosPagoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediosPagoTable,
      MedioPago,
      $$MediosPagoTableFilterComposer,
      $$MediosPagoTableOrderingComposer,
      $$MediosPagoTableAnnotationComposer,
      $$MediosPagoTableCreateCompanionBuilder,
      $$MediosPagoTableUpdateCompanionBuilder,
      (MedioPago, $$MediosPagoTableReferences),
      MedioPago,
      PrefetchHooks Function({
        bool transaccionesOrigen,
        bool transaccionesDestino,
      })
    >;
typedef $$GastosFijosTableCreateCompanionBuilder =
    GastosFijosCompanion Function({
      Value<int> id,
      required String nombre,
      required double monto,
      required int diaCobro,
      Value<bool> esAhorro,
      Value<bool> activo,
      required int categoriaId,
    });
typedef $$GastosFijosTableUpdateCompanionBuilder =
    GastosFijosCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<double> monto,
      Value<int> diaCobro,
      Value<bool> esAhorro,
      Value<bool> activo,
      Value<int> categoriaId,
    });

final class $$GastosFijosTableReferences
    extends BaseReferences<_$AppDatabase, $GastosFijosTable, GastoFijo> {
  $$GastosFijosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) =>
      db.categorias.createAlias('gastos_fijos__categoria_id__categorias__id');

  $$CategoriasTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id')!;

    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GastosFijosTableFilterComposer
    extends Composer<_$AppDatabase, $GastosFijosTable> {
  $$GastosFijosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diaCobro => $composableBuilder(
    column: $table.diaCobro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esAhorro => $composableBuilder(
    column: $table.esAhorro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GastosFijosTableOrderingComposer
    extends Composer<_$AppDatabase, $GastosFijosTable> {
  $$GastosFijosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diaCobro => $composableBuilder(
    column: $table.diaCobro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esAhorro => $composableBuilder(
    column: $table.esAhorro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GastosFijosTableAnnotationComposer
    extends Composer<_$AppDatabase, $GastosFijosTable> {
  $$GastosFijosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<double> get monto =>
      $composableBuilder(column: $table.monto, builder: (column) => column);

  GeneratedColumn<int> get diaCobro =>
      $composableBuilder(column: $table.diaCobro, builder: (column) => column);

  GeneratedColumn<bool> get esAhorro =>
      $composableBuilder(column: $table.esAhorro, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GastosFijosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GastosFijosTable,
          GastoFijo,
          $$GastosFijosTableFilterComposer,
          $$GastosFijosTableOrderingComposer,
          $$GastosFijosTableAnnotationComposer,
          $$GastosFijosTableCreateCompanionBuilder,
          $$GastosFijosTableUpdateCompanionBuilder,
          (GastoFijo, $$GastosFijosTableReferences),
          GastoFijo,
          PrefetchHooks Function({bool categoriaId})
        > {
  $$GastosFijosTableTableManager(_$AppDatabase db, $GastosFijosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GastosFijosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GastosFijosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GastosFijosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<double> monto = const Value.absent(),
                Value<int> diaCobro = const Value.absent(),
                Value<bool> esAhorro = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> categoriaId = const Value.absent(),
              }) => GastosFijosCompanion(
                id: id,
                nombre: nombre,
                monto: monto,
                diaCobro: diaCobro,
                esAhorro: esAhorro,
                activo: activo,
                categoriaId: categoriaId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required double monto,
                required int diaCobro,
                Value<bool> esAhorro = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                required int categoriaId,
              }) => GastosFijosCompanion.insert(
                id: id,
                nombre: nombre,
                monto: monto,
                diaCobro: diaCobro,
                esAhorro: esAhorro,
                activo: activo,
                categoriaId: categoriaId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GastosFijosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoriaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoriaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoriaId,
                                referencedTable: $$GastosFijosTableReferences
                                    ._categoriaIdTable(db),
                                referencedColumn: $$GastosFijosTableReferences
                                    ._categoriaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GastosFijosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GastosFijosTable,
      GastoFijo,
      $$GastosFijosTableFilterComposer,
      $$GastosFijosTableOrderingComposer,
      $$GastosFijosTableAnnotationComposer,
      $$GastosFijosTableCreateCompanionBuilder,
      $$GastosFijosTableUpdateCompanionBuilder,
      (GastoFijo, $$GastosFijosTableReferences),
      GastoFijo,
      PrefetchHooks Function({bool categoriaId})
    >;
typedef $$TransaccionesTableCreateCompanionBuilder =
    TransaccionesCompanion Function({
      Value<int> id,
      required double monto,
      required DateTime fecha,
      Value<String> tipo,
      Value<String?> nota,
      Value<int?> numeroCuota,
      Value<int?> totalCuotas,
      Value<int?> categoriaId,
      Value<int?> etiquetaId,
      Value<int?> transaccionPadreId,
      required int medioPagoId,
      Value<int?> medioPagoDestinoId,
    });
typedef $$TransaccionesTableUpdateCompanionBuilder =
    TransaccionesCompanion Function({
      Value<int> id,
      Value<double> monto,
      Value<DateTime> fecha,
      Value<String> tipo,
      Value<String?> nota,
      Value<int?> numeroCuota,
      Value<int?> totalCuotas,
      Value<int?> categoriaId,
      Value<int?> etiquetaId,
      Value<int?> transaccionPadreId,
      Value<int> medioPagoId,
      Value<int?> medioPagoDestinoId,
    });

final class $$TransaccionesTableReferences
    extends BaseReferences<_$AppDatabase, $TransaccionesTable, Transaccion> {
  $$TransaccionesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) =>
      db.categorias.createAlias('transacciones__categoria_id__categorias__id');

  $$CategoriasTableProcessedTableManager? get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id');
    if ($_column == null) return null;
    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EtiquetasCategoriaTable _etiquetaIdTable(_$AppDatabase db) => db
      .etiquetasCategoria
      .createAlias('transacciones__etiqueta_id__etiquetas_categoria__id');

  $$EtiquetasCategoriaTableProcessedTableManager? get etiquetaId {
    final $_column = $_itemColumn<int>('etiqueta_id');
    if ($_column == null) return null;
    final manager = $$EtiquetasCategoriaTableTableManager(
      $_db,
      $_db.etiquetasCategoria,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_etiquetaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransaccionesTable _transaccionPadreIdTable(_$AppDatabase db) => db
      .transacciones
      .createAlias('transacciones__transaccion_padre_id__transacciones__id');

  $$TransaccionesTableProcessedTableManager? get transaccionPadreId {
    final $_column = $_itemColumn<int>('transaccion_padre_id');
    if ($_column == null) return null;
    final manager = $$TransaccionesTableTableManager(
      $_db,
      $_db.transacciones,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transaccionPadreIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MediosPagoTable _medioPagoIdTable(_$AppDatabase db) => db.mediosPago
      .createAlias('transacciones__medio_pago_id__medios_pago__id');

  $$MediosPagoTableProcessedTableManager get medioPagoId {
    final $_column = $_itemColumn<int>('medio_pago_id')!;

    final manager = $$MediosPagoTableTableManager(
      $_db,
      $_db.mediosPago,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medioPagoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MediosPagoTable _medioPagoDestinoIdTable(_$AppDatabase db) => db
      .mediosPago
      .createAlias('transacciones__medio_pago_destino_id__medios_pago__id');

  $$MediosPagoTableProcessedTableManager? get medioPagoDestinoId {
    final $_column = $_itemColumn<int>('medio_pago_destino_id');
    if ($_column == null) return null;
    final manager = $$MediosPagoTableTableManager(
      $_db,
      $_db.mediosPago,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medioPagoDestinoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransaccionesTableFilterComposer
    extends Composer<_$AppDatabase, $TransaccionesTable> {
  $$TransaccionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numeroCuota => $composableBuilder(
    column: $table.numeroCuota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCuotas => $composableBuilder(
    column: $table.totalCuotas,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EtiquetasCategoriaTableFilterComposer get etiquetaId {
    final $$EtiquetasCategoriaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.etiquetaId,
      referencedTable: $db.etiquetasCategoria,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EtiquetasCategoriaTableFilterComposer(
            $db: $db,
            $table: $db.etiquetasCategoria,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransaccionesTableFilterComposer get transaccionPadreId {
    final $$TransaccionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transaccionPadreId,
      referencedTable: $db.transacciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaccionesTableFilterComposer(
            $db: $db,
            $table: $db.transacciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediosPagoTableFilterComposer get medioPagoId {
    final $$MediosPagoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medioPagoId,
      referencedTable: $db.mediosPago,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediosPagoTableFilterComposer(
            $db: $db,
            $table: $db.mediosPago,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediosPagoTableFilterComposer get medioPagoDestinoId {
    final $$MediosPagoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medioPagoDestinoId,
      referencedTable: $db.mediosPago,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediosPagoTableFilterComposer(
            $db: $db,
            $table: $db.mediosPago,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransaccionesTableOrderingComposer
    extends Composer<_$AppDatabase, $TransaccionesTable> {
  $$TransaccionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numeroCuota => $composableBuilder(
    column: $table.numeroCuota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCuotas => $composableBuilder(
    column: $table.totalCuotas,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EtiquetasCategoriaTableOrderingComposer get etiquetaId {
    final $$EtiquetasCategoriaTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.etiquetaId,
      referencedTable: $db.etiquetasCategoria,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EtiquetasCategoriaTableOrderingComposer(
            $db: $db,
            $table: $db.etiquetasCategoria,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransaccionesTableOrderingComposer get transaccionPadreId {
    final $$TransaccionesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transaccionPadreId,
      referencedTable: $db.transacciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaccionesTableOrderingComposer(
            $db: $db,
            $table: $db.transacciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediosPagoTableOrderingComposer get medioPagoId {
    final $$MediosPagoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medioPagoId,
      referencedTable: $db.mediosPago,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediosPagoTableOrderingComposer(
            $db: $db,
            $table: $db.mediosPago,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediosPagoTableOrderingComposer get medioPagoDestinoId {
    final $$MediosPagoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medioPagoDestinoId,
      referencedTable: $db.mediosPago,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediosPagoTableOrderingComposer(
            $db: $db,
            $table: $db.mediosPago,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransaccionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransaccionesTable> {
  $$TransaccionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get monto =>
      $composableBuilder(column: $table.monto, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  GeneratedColumn<int> get numeroCuota => $composableBuilder(
    column: $table.numeroCuota,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCuotas => $composableBuilder(
    column: $table.totalCuotas,
    builder: (column) => column,
  );

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EtiquetasCategoriaTableAnnotationComposer get etiquetaId {
    final $$EtiquetasCategoriaTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.etiquetaId,
          referencedTable: $db.etiquetasCategoria,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EtiquetasCategoriaTableAnnotationComposer(
                $db: $db,
                $table: $db.etiquetasCategoria,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TransaccionesTableAnnotationComposer get transaccionPadreId {
    final $$TransaccionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transaccionPadreId,
      referencedTable: $db.transacciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaccionesTableAnnotationComposer(
            $db: $db,
            $table: $db.transacciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediosPagoTableAnnotationComposer get medioPagoId {
    final $$MediosPagoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medioPagoId,
      referencedTable: $db.mediosPago,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediosPagoTableAnnotationComposer(
            $db: $db,
            $table: $db.mediosPago,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediosPagoTableAnnotationComposer get medioPagoDestinoId {
    final $$MediosPagoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medioPagoDestinoId,
      referencedTable: $db.mediosPago,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediosPagoTableAnnotationComposer(
            $db: $db,
            $table: $db.mediosPago,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransaccionesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransaccionesTable,
          Transaccion,
          $$TransaccionesTableFilterComposer,
          $$TransaccionesTableOrderingComposer,
          $$TransaccionesTableAnnotationComposer,
          $$TransaccionesTableCreateCompanionBuilder,
          $$TransaccionesTableUpdateCompanionBuilder,
          (Transaccion, $$TransaccionesTableReferences),
          Transaccion,
          PrefetchHooks Function({
            bool categoriaId,
            bool etiquetaId,
            bool transaccionPadreId,
            bool medioPagoId,
            bool medioPagoDestinoId,
          })
        > {
  $$TransaccionesTableTableManager(_$AppDatabase db, $TransaccionesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransaccionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransaccionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransaccionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> monto = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> nota = const Value.absent(),
                Value<int?> numeroCuota = const Value.absent(),
                Value<int?> totalCuotas = const Value.absent(),
                Value<int?> categoriaId = const Value.absent(),
                Value<int?> etiquetaId = const Value.absent(),
                Value<int?> transaccionPadreId = const Value.absent(),
                Value<int> medioPagoId = const Value.absent(),
                Value<int?> medioPagoDestinoId = const Value.absent(),
              }) => TransaccionesCompanion(
                id: id,
                monto: monto,
                fecha: fecha,
                tipo: tipo,
                nota: nota,
                numeroCuota: numeroCuota,
                totalCuotas: totalCuotas,
                categoriaId: categoriaId,
                etiquetaId: etiquetaId,
                transaccionPadreId: transaccionPadreId,
                medioPagoId: medioPagoId,
                medioPagoDestinoId: medioPagoDestinoId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double monto,
                required DateTime fecha,
                Value<String> tipo = const Value.absent(),
                Value<String?> nota = const Value.absent(),
                Value<int?> numeroCuota = const Value.absent(),
                Value<int?> totalCuotas = const Value.absent(),
                Value<int?> categoriaId = const Value.absent(),
                Value<int?> etiquetaId = const Value.absent(),
                Value<int?> transaccionPadreId = const Value.absent(),
                required int medioPagoId,
                Value<int?> medioPagoDestinoId = const Value.absent(),
              }) => TransaccionesCompanion.insert(
                id: id,
                monto: monto,
                fecha: fecha,
                tipo: tipo,
                nota: nota,
                numeroCuota: numeroCuota,
                totalCuotas: totalCuotas,
                categoriaId: categoriaId,
                etiquetaId: etiquetaId,
                transaccionPadreId: transaccionPadreId,
                medioPagoId: medioPagoId,
                medioPagoDestinoId: medioPagoDestinoId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransaccionesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoriaId = false,
                etiquetaId = false,
                transaccionPadreId = false,
                medioPagoId = false,
                medioPagoDestinoId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoriaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoriaId,
                                    referencedTable:
                                        $$TransaccionesTableReferences
                                            ._categoriaIdTable(db),
                                    referencedColumn:
                                        $$TransaccionesTableReferences
                                            ._categoriaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (etiquetaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.etiquetaId,
                                    referencedTable:
                                        $$TransaccionesTableReferences
                                            ._etiquetaIdTable(db),
                                    referencedColumn:
                                        $$TransaccionesTableReferences
                                            ._etiquetaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (transaccionPadreId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.transaccionPadreId,
                                    referencedTable:
                                        $$TransaccionesTableReferences
                                            ._transaccionPadreIdTable(db),
                                    referencedColumn:
                                        $$TransaccionesTableReferences
                                            ._transaccionPadreIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (medioPagoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.medioPagoId,
                                    referencedTable:
                                        $$TransaccionesTableReferences
                                            ._medioPagoIdTable(db),
                                    referencedColumn:
                                        $$TransaccionesTableReferences
                                            ._medioPagoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (medioPagoDestinoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.medioPagoDestinoId,
                                    referencedTable:
                                        $$TransaccionesTableReferences
                                            ._medioPagoDestinoIdTable(db),
                                    referencedColumn:
                                        $$TransaccionesTableReferences
                                            ._medioPagoDestinoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TransaccionesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransaccionesTable,
      Transaccion,
      $$TransaccionesTableFilterComposer,
      $$TransaccionesTableOrderingComposer,
      $$TransaccionesTableAnnotationComposer,
      $$TransaccionesTableCreateCompanionBuilder,
      $$TransaccionesTableUpdateCompanionBuilder,
      (Transaccion, $$TransaccionesTableReferences),
      Transaccion,
      PrefetchHooks Function({
        bool categoriaId,
        bool etiquetaId,
        bool transaccionPadreId,
        bool medioPagoId,
        bool medioPagoDestinoId,
      })
    >;
typedef $$AppThemesTableCreateCompanionBuilder =
    AppThemesCompanion Function({
      Value<int> id,
      required String name,
      required String backgroundHex,
      required String surfaceHex,
      required String textHex,
      required String accentHex,
      Value<bool> isCustom,
    });
typedef $$AppThemesTableUpdateCompanionBuilder =
    AppThemesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> backgroundHex,
      Value<String> surfaceHex,
      Value<String> textHex,
      Value<String> accentHex,
      Value<bool> isCustom,
    });

class $$AppThemesTableFilterComposer
    extends Composer<_$AppDatabase, $AppThemesTable> {
  $$AppThemesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backgroundHex => $composableBuilder(
    column: $table.backgroundHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get surfaceHex => $composableBuilder(
    column: $table.surfaceHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textHex => $composableBuilder(
    column: $table.textHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accentHex => $composableBuilder(
    column: $table.accentHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppThemesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppThemesTable> {
  $$AppThemesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backgroundHex => $composableBuilder(
    column: $table.backgroundHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surfaceHex => $composableBuilder(
    column: $table.surfaceHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textHex => $composableBuilder(
    column: $table.textHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accentHex => $composableBuilder(
    column: $table.accentHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppThemesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppThemesTable> {
  $$AppThemesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get backgroundHex => $composableBuilder(
    column: $table.backgroundHex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get surfaceHex => $composableBuilder(
    column: $table.surfaceHex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textHex =>
      $composableBuilder(column: $table.textHex, builder: (column) => column);

  GeneratedColumn<String> get accentHex =>
      $composableBuilder(column: $table.accentHex, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);
}

class $$AppThemesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppThemesTable,
          AppThemeEntry,
          $$AppThemesTableFilterComposer,
          $$AppThemesTableOrderingComposer,
          $$AppThemesTableAnnotationComposer,
          $$AppThemesTableCreateCompanionBuilder,
          $$AppThemesTableUpdateCompanionBuilder,
          (
            AppThemeEntry,
            BaseReferences<_$AppDatabase, $AppThemesTable, AppThemeEntry>,
          ),
          AppThemeEntry,
          PrefetchHooks Function()
        > {
  $$AppThemesTableTableManager(_$AppDatabase db, $AppThemesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppThemesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppThemesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppThemesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> backgroundHex = const Value.absent(),
                Value<String> surfaceHex = const Value.absent(),
                Value<String> textHex = const Value.absent(),
                Value<String> accentHex = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
              }) => AppThemesCompanion(
                id: id,
                name: name,
                backgroundHex: backgroundHex,
                surfaceHex: surfaceHex,
                textHex: textHex,
                accentHex: accentHex,
                isCustom: isCustom,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String backgroundHex,
                required String surfaceHex,
                required String textHex,
                required String accentHex,
                Value<bool> isCustom = const Value.absent(),
              }) => AppThemesCompanion.insert(
                id: id,
                name: name,
                backgroundHex: backgroundHex,
                surfaceHex: surfaceHex,
                textHex: textHex,
                accentHex: accentHex,
                isCustom: isCustom,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppThemesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppThemesTable,
      AppThemeEntry,
      $$AppThemesTableFilterComposer,
      $$AppThemesTableOrderingComposer,
      $$AppThemesTableAnnotationComposer,
      $$AppThemesTableCreateCompanionBuilder,
      $$AppThemesTableUpdateCompanionBuilder,
      (
        AppThemeEntry,
        BaseReferences<_$AppDatabase, $AppThemesTable, AppThemeEntry>,
      ),
      AppThemeEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db, _db.categorias);
  $$EtiquetasCategoriaTableTableManager get etiquetasCategoria =>
      $$EtiquetasCategoriaTableTableManager(_db, _db.etiquetasCategoria);
  $$MediosPagoTableTableManager get mediosPago =>
      $$MediosPagoTableTableManager(_db, _db.mediosPago);
  $$GastosFijosTableTableManager get gastosFijos =>
      $$GastosFijosTableTableManager(_db, _db.gastosFijos);
  $$TransaccionesTableTableManager get transacciones =>
      $$TransaccionesTableTableManager(_db, _db.transacciones);
  $$AppThemesTableTableManager get appThemes =>
      $$AppThemesTableTableManager(_db, _db.appThemes);
}
