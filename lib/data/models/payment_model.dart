<<<<<<< HEAD
class PaymentModel {
  PaymentModel({
    required this.id,
    required this.invoiceId,
    required this.payerId,
    required this.payeeId,
    required this.amount,
    this.proofImageUrl,
    this.paymentTypeId,
    this.status,
    this.paidAt,
  });

  final String id;
  final String invoiceId;
  final String payerId;
  final String payeeId;
  final double amount;
  final String? proofImageUrl;
  final String? paymentTypeId;
  final String? status;
  final DateTime? paidAt;

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    final paidAtRaw = json["paid_at"] ?? json["paidAt"];
    return PaymentModel(
      id: (json["id"] ?? "").toString(),
      invoiceId: (json["invoice_id"] ?? json["invoiceId"] ?? "").toString(),
      payerId: (json["payer_id"] ?? json["payerId"] ?? "").toString(),
      payeeId: (json["payee_id"] ?? json["payeeId"] ?? "").toString(),
      amount: (json["amount"] as num?)?.toDouble() ?? 0,
      proofImageUrl: json["proof_image_url"]?.toString() ?? json["proofImageUrl"]?.toString(),
      paymentTypeId: json["payment_type_id"]?.toString() ?? json["paymentTypeId"]?.toString(),
      status: json["status"]?.toString(),
      paidAt: paidAtRaw != null ? DateTime.tryParse(paidAtRaw.toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "invoice_id": invoiceId,
      "payer_id": payerId,
      "payee_id": payeeId,
      "amount": amount,
      if (proofImageUrl != null) "proof_image_url": proofImageUrl,
      if (paymentTypeId != null) "payment_type_id": paymentTypeId,
      if (status != null) "status": status,
      if (paidAt != null) "paid_at": paidAt!.toIso8601String(),
    };
  }
}
=======
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
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
