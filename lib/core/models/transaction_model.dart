/// Modelo desacoplado para representar transacciones en la UI.
/// Permite reemplazar los mocks directamente por los DAOs de Drift en el futuro.
class TransactionItem {
  final String id;
  final String title;
  final String category;
  final double amount;
  final bool isExpense;
  final DateTime date;
  final String paymentMethod;
  final String? notes;
  final int installments;

  const TransactionItem({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.isExpense,
    required this.date,
    required this.paymentMethod,
    this.notes,
    this.installments = 1,
  });

  TransactionItem copyWith({
    String? id,
    String? title,
    String? category,
    double? amount,
    bool? isExpense,
    DateTime? date,
    String? paymentMethod,
    String? notes,
    int? installments,
  }) {
    return TransactionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      isExpense: isExpense ?? this.isExpense,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      installments: installments ?? this.installments,
    );
  }

  /// Mocks iniciales según especificación
  static List<TransactionItem> get sampleTransactions => [
    TransactionItem(
      id: 'tx-1',
      title: 'Kuro Kuma',
      category: 'Comida',
      amount: 120.00,
      isExpense: true,
      date: DateTime.now(),
      paymentMethod: 'Interbank Crédito',
      notes: 'Almuerzo con el equipo',
      installments: 1,
    ),
    TransactionItem(
      id: 'tx-2',
      title: 'Plin',
      category: 'Transferencia',
      amount: 15.00,
      isExpense: true,
      date: DateTime.now(),
      paymentMethod: 'Yape / Plin',
      notes: 'Pago taxi corto',
      installments: 1,
    ),
    TransactionItem(
      id: 'tx-3',
      title: 'Steam Games',
      category: 'Entretenimiento',
      amount: 89.90,
      isExpense: true,
      date: DateTime.now().subtract(const Duration(days: 1)),
      paymentMethod: 'Interbank Crédito',
      notes: 'Oferta de invierno',
      installments: 3,
    ),
    TransactionItem(
      id: 'tx-4',
      title: 'Depósito Nómina',
      category: 'Salario',
      amount: 3500.00,
      isExpense: false,
      date: DateTime.now().subtract(const Duration(days: 2)),
      paymentMethod: 'Interbank Débito',
      notes: 'Quincena',
      installments: 1,
    ),
    TransactionItem(
      id: 'tx-5',
      title: 'Ruta Chosica',
      category: 'Transporte',
      amount: 4.50,
      isExpense: true,
      date: DateTime.now().subtract(const Duration(days: 3)),
      paymentMethod: 'Efectivo',
      notes: 'Pasaje',
      installments: 1,
    ),
    TransactionItem(
      id: 'tx-6',
      title: 'Bonny Veterinaria',
      category: 'Mascotas',
      amount: 65.00,
      isExpense: true,
      date: DateTime.now().subtract(const Duration(days: 5)),
      paymentMethod: 'Yape / Plin',
      notes: 'Vacuna anual Bonny',
      installments: 1,
    ),
  ];
}
