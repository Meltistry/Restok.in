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
      idItem: json['idItem(PK)'] as int?,
      idStore: json['idStore(FK)'] as int?,
      itemName: json['itemName'] as String? ?? '',
      itemPrice: json['itemPrice'] as int? ?? 0,
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
      if (idItem != null) 'idItem(PK)': idItem,
      if (idStore != null) 'idStore(FK)': idStore,
      'itemName': itemName,
      'itemPrice': itemPrice,
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
