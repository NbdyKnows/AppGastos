/// Modelo desacoplado para representar métodos de pago en la UI.
class PaymentMethodItem {
  final String id;
  final String name;
  final String bank;
  final String type; // 'debito' | 'credito' | 'efectivo'
  final double usedAmount;
  final double? creditLimit;
  final String? cutoffDate; // Ej: "10/09"
  final String? paymentDate; // Ej: "15/09"

  const PaymentMethodItem({
    required this.id,
    required this.name,
    required this.bank,
    required this.type,
    required this.usedAmount,
    this.creditLimit,
    this.cutoffDate,
    this.paymentDate,
  });

  bool get isCredit => type.toLowerCase() == 'credito';

  static List<PaymentMethodItem> get samplePaymentMethods => [
    const PaymentMethodItem(
      id: 'pm-1',
      name: 'Visa Signature',
      bank: 'Interbank',
      type: 'credito',
      usedAmount: 450.00,
      creditLimit: 6000.00,
      cutoffDate: '10/09',
      paymentDate: '15/09',
    ),
    const PaymentMethodItem(
      id: 'pm-2',
      name: 'Yape / Débito BCP',
      bank: 'BCP',
      type: 'debito',
      usedAmount: 215.00,
    ),
    const PaymentMethodItem(
      id: 'pm-3',
      name: 'Billetera Efectivo',
      bank: 'Efectivo',
      type: 'efectivo',
      usedAmount: 80.00,
    ),
    const PaymentMethodItem(
      id: 'pm-4',
      name: 'Mastercard Black',
      bank: 'BBVA',
      type: 'credito',
      usedAmount: 320.00,
      creditLimit: 4500.00,
      cutoffDate: '20/09',
      paymentDate: '25/09',
    ),
  ];
}
