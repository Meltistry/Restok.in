// lib/data/models/item_model.dart

class ItemModel {
  final int? idItem;
  final int? idStore;
  final String itemName;
  final int itemPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ItemModel({
    this.idItem,
    this.idStore,
    required this.itemName,
    required this.itemPrice,
    this.createdAt,
    this.updatedAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      idItem: json['id_item'] as int?,
      idStore: json['id_store'] as int?,
      itemName: json['item_name'] as String? ?? '',
      itemPrice: json['item_price'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idItem != null) 'id_item': idItem,
      if (idStore != null) 'id_store': idStore,
      'item_name': itemName,
      'item_price': itemPrice,
    };
  }

  ItemModel copyWith({
    int? idItem,
    int? idStore,
    String? itemName,
    int? itemPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ItemModel(
      idItem: idItem ?? this.idItem,
      idStore: idStore ?? this.idStore,
      itemName: itemName ?? this.itemName,
      itemPrice: itemPrice ?? this.itemPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get formattedPrice {
    return 'Rp. ${itemPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
