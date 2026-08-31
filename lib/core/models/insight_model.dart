import 'package:flutter/material.dart';

/// Modelo para las tarjetas de Smart Insights en el módulo de Reportes
class InsightItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String categoryTag;

  const InsightItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.categoryTag,
  });

  static List<InsightItem> get sampleInsights => const [
    InsightItem(
      id: 'in-1',
      title: 'Hábitos de Consumo',
      description:
          'Este mes destinaste S/ 180 a Llamafood Delivery. Es tu segunda categoría más alta.',
      icon: Icons.trending_down_rounded,
      categoryTag: 'Delivery & Comida',
    ),
    InsightItem(
      id: 'in-2',
      title: 'Salud Totalera',
      description:
          'Liquidez retenida: Tienes S/ 500 trabajando para ti mientras financias a cuotas sin intereses.',
      icon: Icons.speed_rounded,
      categoryTag: 'Estrategia Crédito',
    ),
    InsightItem(
      id: 'in-3',
      title: 'Proyección de Ahorro',
      description:
          'Tasa de Ahorro: Te quedan S/ 1,000 libres para tu meta de ahorro (Depa 30).',
      icon: Icons.trending_up_rounded,
      categoryTag: 'Metas 2026',
    ),
  ];
}
