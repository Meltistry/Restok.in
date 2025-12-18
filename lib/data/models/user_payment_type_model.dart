// lib/data/models/user_payment_type_model.dart

class UserPaymentTypeModel {
  final int idUserPaymentType;
  final int idUser;
  final int idPaymentType;
  final String paymentDetails;

  UserPaymentTypeModel({
    required this.idUserPaymentType,
    required this.idUser,
    required this.idPaymentType,
    required this.paymentDetails,
  });

  // Create UserPaymentTypeModel from JSON
  factory UserPaymentTypeModel.fromJson(Map<String, dynamic> json) {
    return UserPaymentTypeModel(
      idUserPaymentType: json['idUserPaymentType'] ?? 0,
      idUser: json['idUser'] ?? 0,
      idPaymentType: json['idPaymentType'] ?? 0,
      paymentDetails: json['paymentDetails'] ?? '',
    );
  }

  // Convert UserPaymentTypeModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'idUserPaymentType': idUserPaymentType,
      'idUser': idUser,
      'idPaymentType': idPaymentType,
      'paymentDetails': paymentDetails,
    };
  }

  // Create a copy with modified fields
  UserPaymentTypeModel copyWith({
    int? idUserPaymentType,
    int? idUser,
    int? idPaymentType,
    String? paymentDetails,
  }) {
    return UserPaymentTypeModel(
      idUserPaymentType: idUserPaymentType ?? this.idUserPaymentType,
      idUser: idUser ?? this.idUser,
      idPaymentType: idPaymentType ?? this.idPaymentType,
      paymentDetails: paymentDetails ?? this.paymentDetails,
    );
  }

  @override
  String toString() {
    return 'UserPaymentTypeModel(idUserPaymentType: $idUserPaymentType, idUser: $idUser, idPaymentType: $idPaymentType)';
  }
}