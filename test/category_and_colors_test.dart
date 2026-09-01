import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_appgastos/core/database/database.dart';
import 'package:flutter_appgastos/core/theme/app_theme.dart';

void main() {
  group('AppColors: Ingreso (Verde) vs Gasto (Rojo) Contrast Tests', () {
    test('Ingreso siempre tiene matiz verde (Hue ~145°) sin importar el acento del tema', () {
      // Caso 1: Tema Indigo (acento azul/índigo ~240°)
      final themeIndigo = AppThemeEntry(
        id: 1,
        name: 'Indigo',
        backgroundHex: '#0B0F19',
        surfaceHex: '#111827',
        textHex: '#F9FAFB',
        accentHex: '#6366F1', // Azul - no debe convertir ingreso a rojo
        isCustom: false,
      );
      final colorsIndigo = AppColors.fromDbTheme(themeIndigo);
      final hslIngresoIndigo = HSLColor.fromColor(colorsIndigo.ingreso);
      final hslGastoIndigo = HSLColor.fromColor(colorsIndigo.gasto);

      // Ingreso debe ser VERDE (Hue entre 140° y 150°)
      expect(hslIngresoIndigo.hue, closeTo(145.0, 5.0));
      // Gasto debe ser ROJO (Hue ~4°)
      expect(hslGastoIndigo.hue, closeTo(4.0, 2.0));

      // Caso 2: Tema Lemon Light (superficie clara)
      final themeLight = AppThemeEntry(
        id: 2,
        name: 'Lemon Light',
        backgroundHex: '#F4F5F7',
        surfaceHex: '#FFFFFF',
        textHex: '#0C1821',
        accentHex: '#F4D144',
        isCustom: false,
      );
      final colorsLight = AppColors.fromDbTheme(themeLight);
      final hslIngresoLight = HSLColor.fromColor(colorsLight.ingreso);

      expect(hslIngresoLight.hue, closeTo(145.0, 5.0));
      // En modo claro la luminosidad debe ser más baja para contrastar con blanco
      expect(hslIngresoLight.lightness, lessThan(0.5));
    });
  });

  group('CategoriasDao CRUD & Referential Integrity Tests', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('Crear, actualizar, ordenar prioridad y eliminar categoría', () async {
      final dao = db.categoriasDao;

      // 1. Insertar categoría nueva
      final catId = await dao.insertCategoria(
        CategoriasCompanion.insert(
          nombre: 'Gimnasio',
          colorHex: '#FF5722',
          icono: 'fitness_center',
          orderIndex: const Value(2),
          presupuestoAsignado: const Value(150.0),
        ),
      );
      expect(catId, isPositive);

      // 2. Comprobar que aparece en el stream
      var list = await dao.watchCategorias().first;
      expect(list.any((c) => c.id == catId && c.nombre == 'Gimnasio'), isTrue);

      // 3. Actualizar prioridad a 1 (primera)
      await dao.updatePriority(catId, 1);
      list = await dao.watchCategorias().first;
      final updated = list.firstWhere((c) => c.id == catId);
      expect(updated.orderIndex, 1);

      // 4. Eliminar físicamente (sin transacciones)
      final deleted = await dao.deleteOrDeactivateCategoria(catId);
      expect(deleted, isTrue);

      list = await dao.watchCategorias().first;
      expect(list.any((c) => c.id == catId), isFalse);
    });

    test('Desactivar categoría (soft-delete) si tiene transacciones registradas', () async {
      final dao = db.categoriasDao;

      // Crear categoría
      final catId = await dao.insertCategoria(
        CategoriasCompanion.insert(
          nombre: 'Supermercado',
          colorHex: '#4CAF50',
          icono: 'shopping_bag',
        ),
      );

      // Crear medio de pago
      final medioId = await db.into(db.mediosPago).insert(
        MediosPagoCompanion.insert(
          nombre: 'Efectivo',
          tipo: 'efectivo',
        ),
      );

      // Crear transacción asociada a la categoría
      await db.into(db.transacciones).insert(
        TransaccionesCompanion.insert(
          monto: 85.0,
          fecha: DateTime.now(),
          medioPagoId: medioId,
          categoriaId: Value(catId),
        ),
      );

      // Intentar eliminar: debe realizar soft-delete (activo = false)
      final physicallyDeleted = await dao.deleteOrDeactivateCategoria(catId);
      expect(physicallyDeleted, isFalse);

      // No debe aparecer en categorías activas
      final activeList = await dao.watchCategorias(onlyActive: true).first;
      expect(activeList.any((c) => c.id == catId), isFalse);

      // Debe seguir existiendo en todas las categorías como inactiva
      final allList = await dao.watchCategorias(onlyActive: false).first;
      final archivedCat = allList.firstWhere((c) => c.id == catId);
      expect(archivedCat.activo, isFalse);

      // Reactivar categoría
      await dao.reactivateCategoria(catId);
      final reactivatedList = await dao.watchCategorias(onlyActive: true).first;
      expect(reactivatedList.any((c) => c.id == catId), isTrue);
    });
  });
}
