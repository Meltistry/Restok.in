// lib/data/models/item_model.dart

class ItemModel {
  final int idItem;
  final int idStore;
  final String itemName;
  final int itemPrice;

  ItemModel({
    required this.idItem,
    required this.idStore,
    required this.itemName,
    required this.itemPrice,
  });

  // Create ItemModel from JSON
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      idItem: json['idItem'] ?? 0,
      idStore: json['idStore'] ?? 0,
      itemName: json['itemName'] ?? '',
      itemPrice: json['itemPrice'] ?? 0,
    );
  }

  // Convert ItemModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'idItem': idItem,
      'idStore': idStore,
      'itemName': itemName,
      'itemPrice': itemPrice,
    };
  }

  // Create a copy with modified fields
  ItemModel copyWith({
    int? idItem,
    int? idStore,
    String? itemName,
    int? itemPrice,
  }) {
    return ItemModel(
      idItem: idItem ?? this.idItem,
      idStore: idStore ?? this.idStore,
      itemName: itemName ?? this.itemName,
      itemPrice: itemPrice ?? this.itemPrice,
    );
  }

  // Format price as currency (IDR)
  String get formattedPrice {
    return 'Rp${itemPrice.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  @override
  String toString() {
    return 'ItemModel(idItem: $idItem, itemName: $itemName, itemPrice: $itemPrice)';
  }
}