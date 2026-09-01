import 'package:flutter/material.dart';

/// Catálogo y utilidades de íconos para Categorías en Kip.
class CategoryIconItem {
  final String key;
  final String label;
  final IconData icon;

  const CategoryIconItem({
    required this.key,
    required this.label,
    required this.icon,
  });
}

class CategoryIcons {
  /// Lista de íconos curados disponibles para asignación a categorías.
  static const List<CategoryIconItem> availableIcons = [
    CategoryIconItem(key: 'restaurant', label: 'Comida', icon: Icons.restaurant_rounded),
    CategoryIconItem(key: 'directions_bus', label: 'Transporte', icon: Icons.directions_bus_rounded),
    CategoryIconItem(key: 'pets', label: 'Mascotas', icon: Icons.pets_rounded),
    CategoryIconItem(key: 'shopping_bag', label: 'Compras', icon: Icons.shopping_bag_rounded),
    CategoryIconItem(key: 'home', label: 'Hogar', icon: Icons.home_rounded),
    CategoryIconItem(key: 'local_hospital', label: 'Salud', icon: Icons.local_hospital_rounded),
    CategoryIconItem(key: 'school', label: 'Educación', icon: Icons.school_rounded),
    CategoryIconItem(key: 'sports_esports', label: 'Ocio', icon: Icons.sports_esports_rounded),
    CategoryIconItem(key: 'fitness_center', label: 'Gym', icon: Icons.fitness_center_rounded),
    CategoryIconItem(key: 'flight', label: 'Viajes', icon: Icons.flight_rounded),
    CategoryIconItem(key: 'work', label: 'Trabajo', icon: Icons.work_rounded),
    CategoryIconItem(key: 'receipt_long', label: 'Servicios', icon: Icons.receipt_long_rounded),
    CategoryIconItem(key: 'coffee', label: 'Café', icon: Icons.coffee_rounded),
    CategoryIconItem(key: 'savings', label: 'Ahorro', icon: Icons.savings_rounded),
    CategoryIconItem(key: 'local_gas_station', label: 'Gasolina', icon: Icons.local_gas_station_rounded),
    CategoryIconItem(key: 'build', label: 'Arreglos', icon: Icons.build_rounded),
  ];

  /// Obtiene el IconData asociado a la clave guardada en SQLite, con fallback elegante.
  static IconData getIcon(String? iconKey) {
    if (iconKey == null || iconKey.isEmpty) return Icons.category_rounded;
    final item = availableIcons.firstWhere(
      (i) => i.key.toLowerCase() == iconKey.toLowerCase(),
      orElse: () => const CategoryIconItem(
        key: 'category',
        label: 'Categoría',
        icon: Icons.category_rounded,
      ),
    );
    return item.icon;
  }
}
