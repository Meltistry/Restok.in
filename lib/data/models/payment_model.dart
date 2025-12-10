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