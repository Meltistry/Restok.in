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
class PaymentTypeModel {
  final int idPaymentType;
  final String paymentName;

  PaymentTypeModel({
    required this.idPaymentType,
    required this.paymentName,
  });

  // Create PaymentTypeModel from JSON
  factory PaymentTypeModel.fromJson(Map<String, dynamic> json) {
    return PaymentTypeModel(
      idPaymentType: json['idPaymentType'] ?? 0,
      paymentName: json['paymentName'] ?? '',
    );
  }

  // Convert PaymentTypeModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'idPaymentType': idPaymentType,
      'paymentName': paymentName,
    };
  }

  // Create a copy with modified fields
  PaymentTypeModel copyWith({
    int? idPaymentType,
    String? paymentName,
  }) {
    return PaymentTypeModel(
      idPaymentType: idPaymentType ?? this.idPaymentType,
      paymentName: paymentName ?? this.paymentName,
    );
  }

  @override
  String toString() {
    return 'PaymentTypeModel(idPaymentType: $idPaymentType, paymentName: $paymentName)';
  }
}