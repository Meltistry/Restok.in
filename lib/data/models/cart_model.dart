// lib/data/models/cart_model.dart

class CartModel {
  final int idCart;
  final int idUser;
  final int idStore;
  final String date;
  final String status;
  final String restockProof;

  CartModel({
    required this.idCart,
    required this.idUser,
    required this.idStore,
    required this.date,
    required this.status,
    required this.restockProof,
  });

  // Create CartModel from JSON
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      idCart: json['idCart'] ?? 0,
      idUser: json['idUser'] ?? 0,
      idStore: json['idStore'] ?? 0,
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      restockProof: json['restockProof'] ?? '',
    );
  }

  // Convert CartModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'idCart': idCart,
      'idUser': idUser,
      'idStore': idStore,
      'date': date,
      'status': status,
      'restockProof': restockProof,
    };
  }

  // Create a copy with modified fields
  CartModel copyWith({
    int? idCart,
    int? idUser,
    int? idStore,
    String? date,
    String? status,
    String? restockProof,
  }) {
    return CartModel(
      idCart: idCart ?? this.idCart,
      idUser: idUser ?? this.idUser,
      idStore: idStore ?? this.idStore,
      date: date ?? this.date,
      status: status ?? this.status,
      restockProof: restockProof ?? this.restockProof,
    );
  }

  @override
  String toString() {
    return 'CartModel(idCart: $idCart, idUser: $idUser, idStore: $idStore, status: $status)';
  }
}