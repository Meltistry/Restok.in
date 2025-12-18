// lib/data/models/payment_model.dart

class PaymentMethod {
  final int id; // id_user_payment_type
  final int userId; // id_user
  final int paymentTypeId; // id_payment_type
  final String paymentDetails; // payment_details (nomor, dll)
  final bool isDefault; // status default (kita bisa tambahkan kolom ini di DB atau logika lain)
  final String? paymentName; // Nama metode (misal: Gopay, OVO - diambil dari relasi payment_types)

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.paymentTypeId,
    required this.paymentDetails,
    this.isDefault = false,
    this.paymentName,
  });

  factory PaymentMethod.fromMap(Map<String, dynamic> data) {
    return PaymentMethod(
      id: data['id_user_payment_type'] as int,
      userId: data['id_user'] as int,
      paymentTypeId: data['id_payment_type'] as int,
      paymentDetails: data['payment_details'] as String,
      // Asumsi ada kolom is_default boolean di tabel user_payment_types
      // Jika tidak ada, Anda perlu menambahkannya di Supabase atau menggunakan logika lain
      isDefault: data['is_default'] ?? false, 
      // Mengambil nama dari relasi tabel payment_types (perlu query join)
      paymentName: data['payment_types'] != null 
          ? data['payment_types']['payment_name'] 
          : 'Unknown',
    );
  }
}
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