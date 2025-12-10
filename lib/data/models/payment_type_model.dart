// lib/data/models/payment_type_model.dart

class PaymentType {
  final int id; // id_payment_type
  final String name; // payment_name

  PaymentType({
    required this.id,
    required this.name,
  });

  factory PaymentType.fromMap(Map<String, dynamic> data) {
    return PaymentType(
      id: data['id_payment_type'] as int,
      name: data['payment_name'] as String,
    );
  }
}