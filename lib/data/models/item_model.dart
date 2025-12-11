class ItemModel {
  final int idItem;
  final int idStore;
  final String itemName;
  final double itemPrice;

  ItemModel({
    required this.idItem,
    required this.idStore,
    required this.itemName,
    required this.itemPrice,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      idItem: json['id_item'],
      idStore: json['id_store'],
      itemName: json['item_name'] ?? 'Unknown Item',
      itemPrice: (json['item_price'] ?? 0).toDouble(),
    );
  }
}
