// lib/data/models/invoice_model.dart

class InvoiceModel {
  final int idInvoice;
  final int idCart;
  final int idRestocker;
  final int idStoreOwner;
  final String invoiceDate;
  final int totalAmount;
  final String status;

  InvoiceModel({
    required this.idInvoice,
    required this.idCart,
    required this.idRestocker,
    required this.idStoreOwner,
    required this.invoiceDate,
    required this.totalAmount,
    required this.status,
  });

  // Create InvoiceModel from JSON
  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      idInvoice: json['idInvoice'] ?? 0,
      idCart: json['idCart'] ?? 0,
      idRestocker: json['idRestocker'] ?? 0,
      idStoreOwner: json['idStoreOwner'] ?? 0,
      invoiceDate: json['invoiceDate'] ?? '',
      totalAmount: json['totalAmount'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  // Convert InvoiceModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'idInvoice': idInvoice,
      'idCart': idCart,
      'idRestocker': idRestocker,
      'idStoreOwner': idStoreOwner,
      'invoiceDate': invoiceDate,
      'totalAmount': totalAmount,
      'status': status,
    };
  }

  // Create a copy with modified fields
  InvoiceModel copyWith({
    int? idInvoice,
    int? idCart,
    int? idRestocker,
    int? idStoreOwner,
    String? invoiceDate,
    int? totalAmount,
    String? status,
  }) {
    return InvoiceModel(
      idInvoice: idInvoice ?? this.idInvoice,
      idCart: idCart ?? this.idCart,
      idRestocker: idRestocker ?? this.idRestocker,
      idStoreOwner: idStoreOwner ?? this.idStoreOwner,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
    );
  }

  // Format total amount as currency (IDR)
  String get formattedTotalAmount {
    return 'Rp${totalAmount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  // Check if invoice is paid
  bool get isPaid => status.toLowerCase() == 'paid';

  // Check if invoice is pending
  bool get isPending => status.toLowerCase() == 'pending';

  @override
  String toString() {
    return 'InvoiceModel(idInvoice: $idInvoice, totalAmount: $totalAmount, status: $status)';
  }
}