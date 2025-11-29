// lib/data/models/payment_model.dart

class PaymentModel {
  final int idPayment;
  final int idInvoice;
  final int idUserPaymentType;
  final int amount;
  final String paymentDate;
  final String status;

  PaymentModel({
    required this.idPayment,
    required this.idInvoice,
    required this.idUserPaymentType,
    required this.amount,
    required this.paymentDate,
    required this.status,
  });

  // Create PaymentModel from JSON
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      idPayment: json['idPayment'] ?? 0,
      idInvoice: json['idInvoice'] ?? 0,
      idUserPaymentType: json['idUserPaymentType'] ?? 0,
      amount: json['amount'] ?? 0,
      paymentDate: json['paymentDate'] ?? '',
      status: json['status'] ?? '',
    );
  }

  // Convert PaymentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'idPayment': idPayment,
      'idInvoice': idInvoice,
      'idUserPaymentType': idUserPaymentType,
      'amount': amount,
      'paymentDate': paymentDate,
      'status': status,
    };
  }

  // Create a copy with modified fields
  PaymentModel copyWith({
    int? idPayment,
    int? idInvoice,
    int? idUserPaymentType,
    int? amount,
    String? paymentDate,
    String? status,
  }) {
    return PaymentModel(
      idPayment: idPayment ?? this.idPayment,
      idInvoice: idInvoice ?? this.idInvoice,
      idUserPaymentType: idUserPaymentType ?? this.idUserPaymentType,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      status: status ?? this.status,
    );
  }

  // Format amount as currency (IDR)
  String get formattedAmount {
    return 'Rp${amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  // Check if payment is successful
  bool get isSuccess => status.toLowerCase() == 'success';

  // Check if payment is pending
  bool get isPending => status.toLowerCase() == 'pending';

  // Check if payment is failed
  bool get isFailed => status.toLowerCase() == 'failed';

  @override
  String toString() {
    return 'PaymentModel(idPayment: $idPayment, amount: $amount, status: $status)';
  }
}