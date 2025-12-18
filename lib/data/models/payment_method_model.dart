// lib/data/models/payment_method_model.dart

class PaymentMethodModel {
  final int? id;
  final int userId;
  final String paymentType; // 'gopay' or 'shopeepay'
  final String accountNumber;
  final String accountName;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentMethodModel({
    this.id,
    required this.userId,
    required this.paymentType,
    required this.accountNumber,
    required this.accountName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    // Parse payment_details JSON string
    String accountNumber = '';
    String accountName = '';
    
    final paymentDetails = json['payment_details'] as String?;
    if (paymentDetails != null && paymentDetails.isNotEmpty) {
      final regex = RegExp(r'"account_number":\s*"([^"]*)",\s*"account_name":\s*"([^"]*)"');
      final match = regex.firstMatch(paymentDetails);
      if (match != null) {
        accountNumber = match.group(1) ?? '';
        accountName = match.group(2) ?? '';
      }
    }

    // Get payment_name from joined payment_types table
    String paymentType = 'Unknown';
    if (json['payment_types'] != null) {
      final paymentTypesData = json['payment_types'] as Map<String, dynamic>;
      paymentType = paymentTypesData['payment_name'] as String? ?? 'Unknown';
    }

    return PaymentMethodModel(
      id: json['id_user_payment_type'] as int?,
      userId: json['id_user'] as int,
      paymentType: paymentType,
      accountNumber: accountNumber,
      accountName: accountName,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id_user_payment_type': id,
      'id_user': userId,
      'payment_type': paymentType,
      'account_number': accountNumber,
      'account_name': accountName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  PaymentMethodModel copyWith({
    int? id,
    int? userId,
    String? paymentType,
    String? accountNumber,
    String? accountName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      paymentType: paymentType ?? this.paymentType,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
