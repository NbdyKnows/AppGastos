import 'package:drift/drift.dart';
import 'database.dart';

/// Inserta datos iniciales de arranque si la base de datos se encuentra vacía.
Future<void> seedInitialData(AppDatabase db) async {
  // 1. Seed de Categorías y Medios de Pago (solo si la BD está vacía)
  final countCategorias = await db.categorias.count().getSingle();
  if (countCategorias == 0) {
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

      // 3. Insertar Categorías con orderIndex
      final idCatMascotas = await db.into(db.categorias).insert(
        CategoriasCompanion.insert(
          nombre: 'Mascotas',
          colorHex: '#FF9800',
          icono: 'pets',
          orden: const Value(1),
          orderIndex: const Value(1),
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
          orderIndex: const Value(2),
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
          orderIndex: const Value(3),
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
      // Garantizar que las transacciones queden en el mes actual aun si el test
      // o la app se ejecutan el día 1, 2 o 3 del mes.
      final fecha1 = now.subtract(const Duration(hours: 4));
      final fecha2 = now.day > 2
          ? now.subtract(const Duration(days: 2))
          : now.subtract(const Duration(hours: 2));
      final fecha3 = now.day > 3
          ? now.subtract(const Duration(days: 3))
          : now.subtract(const Duration(hours: 1));

      await db.into(db.transacciones).insert(
        TransaccionesCompanion.insert(
          monto: 450.00,
          fecha: fecha1,
          tipo: const Value('gasto'),
          nota: const Value('Almuerzo con el equipo'),
          numeroCuota: const Value(1),
          totalCuotas: const Value(1),
          categoriaId: Value(idCatComidas),
          etiquetaId: Value(idEtqLlamafood),
          medioPagoId: idTarjetaEstrategica,
        ),
      );

      await db.into(db.transacciones).insert(
        TransaccionesCompanion.insert(
          monto: 65.00,
          fecha: fecha2,
          tipo: const Value('gasto'),
          nota: const Value('Veterinaria Bonny'),
          numeroCuota: const Value(1),
          totalCuotas: const Value(1),
          categoriaId: Value(idCatMascotas),
          etiquetaId: Value(idEtqBonny),
          medioPagoId: idBilletera,
        ),
      );

      await db.into(db.transacciones).insert(
        TransaccionesCompanion.insert(
          monto: 15.00,
          fecha: fecha3,
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

  // 5. Seed de Temas del Sistema (independiente del seed de categorías).
  // Se ejecuta siempre que la tabla de temas esté vacía.
  final countTemas = await db.themesDao.countThemes();
  if (countTemas == 0) {
    final systemThemes = [
      ('Lemon Dark',  '#0C1821', '#1B2A41', '#FFFFFF', '#FFF3B0'),
      ('Lemon Light', '#F4F5F7', '#FFFFFF', '#0C1821', '#F4D144'),
      ('Dracula Dark',  '#1E1F29', '#282A36', '#F8F8F2', '#FF79C6'),
      ('Dracula Light', '#F5F5FA', '#FFFFFF', '#282A36', '#BD93F9'),
      ('Emerald Dark',  '#0A1915', '#122C24', '#ECFDF5', '#34D399'),
      ('Emerald Light', '#F0FDF4', '#FFFFFF', '#064E3B', '#10B981'),
      ('Indigo Dark',   '#0F172A', '#1E293B', '#F8FAFC', '#818CF8'),
      ('Indigo Light',  '#F8FAFC', '#FFFFFF', '#0F172A', '#6366F1'),
    ];

    for (final t in systemThemes) {
      await db.themesDao.insertTheme(
        AppThemesCompanion.insert(
          name: t.$1,
          backgroundHex: t.$2,
          surfaceHex: t.$3,
          textHex: t.$4,
          accentHex: t.$5,
          isCustom: const Value(false),
        ),
      );
    }
  }
}
