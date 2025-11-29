// lib/data/models/payment_type_model.dart

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