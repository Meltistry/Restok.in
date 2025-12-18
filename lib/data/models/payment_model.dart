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

  /// Backward-compatible helpers for legacy code.
  bool get isSuccess => (status ?? "").toLowerCase() == "success" || (status ?? "").toLowerCase() == "paid";
  bool get isPending => (status ?? "").toLowerCase() == "pending";
  bool get isFailed => (status ?? "").toLowerCase() == "failed";
  String get paymentDate => paidAt?.toIso8601String() ?? "";
  String get idPayment => id;

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    final paidAtRaw = json["paid_at"] ?? json["paidAt"];
    return PaymentModel(
      id: (json["id"] ?? json["id_payment"] ?? "").toString(),
      invoiceId: (json["invoice_id"] ?? json["id_invoice"] ?? json["invoiceId"] ?? "").toString(),
      payerId: (json["payer_id"] ?? json["payerId"] ?? "").toString(),
      payeeId: (json["payee_id"] ?? json["payeeId"] ?? "").toString(),
      amount: _toDouble(json["amount"]),
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

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? "") ?? 0;
  }
}
