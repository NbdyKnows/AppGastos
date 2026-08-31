import 'package:drift/drift.dart';
import 'database.dart';

/// Inserta datos iniciales de arranque si la base de datos se encuentra vacía.
Future<void> seedInitialData(AppDatabase db) async {
  // 1. Verificar si la base de datos ya contiene información
  final countCategorias = await db.categorias.count().getSingle();
  if (countCategorias > 0) {
    return; // Base de datos ya inicializada
  }

  await db.transaction(() async {
    // 2. Insertar Medios de Pago Iniciales
    await db.into(db.mediosPago).insert(
      MediosPagoCompanion.insert(
        nombre: 'Cuenta Sueldo',
        banco: const Value('Interbank'),
        tipo: 'débito',
        saldoInicial: const Value(2500.00),
        activo: const Value(true),
      ),
    );

    final idTarjetaEstrategica = await db.into(db.mediosPago).insert(
      MediosPagoCompanion.insert(
        nombre: 'Tarjeta Estratégica',
        banco: const Value('Interbank'),
        tipo: 'crédito',
        saldoInicial: const Value(0.0),
        lineaCredito: const Value(6000.00),
        diaCorte: const Value(10),
        diaPago: const Value(15),
        activo: const Value(true),
      ),
    );

    final idBilletera = await db.into(db.mediosPago).insert(
      MediosPagoCompanion.insert(
        nombre: 'Billetera',
        banco: const Value('Yape'),
        tipo: 'efectivo',
        saldoInicial: const Value(200.00),
        activo: const Value(true),
      ),
    );

    // 3. Insertar Categorías y Etiquetas
    final idCatMascotas = await db.into(db.categorias).insert(
      CategoriasCompanion.insert(
        nombre: 'Mascotas',
        colorHex: '#FF9800',
        icono: 'pets',
        orden: const Value(1),
        esPorDefecto: const Value(true),
        activo: const Value(true),
      ),
    );

    final idEtqBonny = await db.into(db.etiquetasCategoria).insert(
      EtiquetasCategoriaCompanion.insert(
        nombre: 'Bonny',
        categoriaId: idCatMascotas,
      ),
    );

    final idCatTransporte = await db.into(db.categorias).insert(
      CategoriasCompanion.insert(
        nombre: 'Transporte',
        colorHex: '#2196F3',
        icono: 'directions_bus',
        orden: const Value(2),
        esPorDefecto: const Value(true),
        activo: const Value(true),
      ),
    );

    final idEtqChosica = await db.into(db.etiquetasCategoria).insert(
      EtiquetasCategoriaCompanion.insert(
        nombre: 'Ruta Chosica-Ate',
        categoriaId: idCatTransporte,
      ),
    );

    final idCatComidas = await db.into(db.categorias).insert(
      CategoriasCompanion.insert(
        nombre: 'Comidas',
        colorHex: '#4CAF50',
        icono: 'restaurant',
        orden: const Value(3),
        esPorDefecto: const Value(true),
        activo: const Value(true),
      ),
    );

    final idEtqLlamafood = await db.into(db.etiquetasCategoria).insert(
      EtiquetasCategoriaCompanion.insert(
        nombre: 'Llamafood',
        categoriaId: idCatComidas,
      ),
    );

    // 4. Insertar Transacciones Iniciales
    final now = DateTime.now();

    // Transacción 1: Gasto en Comidas con Tarjeta de Crédito (S/ 450.00)
    await db.into(db.transacciones).insert(
      TransaccionesCompanion.insert(
        monto: 450.00,
        fecha: now.subtract(const Duration(hours: 4)),
        tipo: const Value('gasto'),
        nota: const Value('Almuerzo con el equipo'),
        numeroCuota: const Value(1),
        totalCuotas: const Value(1),
        categoriaId: Value(idCatComidas),
        etiquetaId: Value(idEtqLlamafood),
        medioPagoId: idTarjetaEstrategica,
      ),
    );

    // Transacción 2: Gasto en Mascotas con Billetera (S/ 65.00)
    await db.into(db.transacciones).insert(
      TransaccionesCompanion.insert(
        monto: 65.00,
        fecha: now.subtract(const Duration(days: 2)),
        tipo: const Value('gasto'),
        nota: const Value('Veterinaria Bonny'),
        numeroCuota: const Value(1),
        totalCuotas: const Value(1),
        categoriaId: Value(idCatMascotas),
        etiquetaId: Value(idEtqBonny),
        medioPagoId: idBilletera,
      ),
    );

    // Transacción 3: Gasto en Transporte con Billetera (S/ 15.00)
    await db.into(db.transacciones).insert(
      TransaccionesCompanion.insert(
        monto: 15.00,
        fecha: now.subtract(const Duration(days: 3)),
        tipo: const Value('gasto'),
        nota: const Value('Pasaje Chosica'),
        numeroCuota: const Value(1),
        totalCuotas: const Value(1),
        categoriaId: Value(idCatTransporte),
        etiquetaId: Value(idEtqChosica),
        medioPagoId: idBilletera,
      ),
    );
  });
}
