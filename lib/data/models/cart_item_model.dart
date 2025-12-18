// lib/data/models/cart_item_model.dart

class CartItemModel {
  final int idCartItem;
  final int idCart;
  final int idItem;
  final int quantity;
  final int subTotal;

  CartItemModel({
    required this.idCartItem,
    required this.idCart,
    required this.idItem,
    required this.quantity,
    required this.subTotal,
  });

  // Create CartItemModel from JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      idCartItem: json['idCartItem'] ?? 0,
      idCart: json['idCart'] ?? 0,
      idItem: json['idItem'] ?? 0,
      quantity: json['quantity'] ?? 0,
      subTotal: json['subTotal'] ?? 0,
    );
  }

  // Convert CartItemModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'idCartItem': idCartItem,
      'idCart': idCart,
      'idItem': idItem,
      'quantity': quantity,
      'subTotal': subTotal,
    };
  }

  // Create a copy with modified fields
  CartItemModel copyWith({
    int? idCartItem,
    int? idCart,
    int? idItem,
    int? quantity,
    int? subTotal,
  }) {
    return CartItemModel(
      idCartItem: idCartItem ?? this.idCartItem,
      idCart: idCart ?? this.idCart,
      idItem: idItem ?? this.idItem,
      quantity: quantity ?? this.quantity,
      subTotal: subTotal ?? this.subTotal,
    );
  }

  // Format subtotal as currency (IDR)
  String get formattedSubTotal {
    return 'Rp${subTotal.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  @override
  String toString() {
    return 'CartItemModel(idCartItem: $idCartItem, idCart: $idCart, idItem: $idItem, quantity: $quantity, subTotal: $subTotal)';
  }
}