class StoreModel {
  final int idStore;
  final String storeName;
  final String storeAddress;
  final String? storeEpic; // Sesuai kolom di DB 'store_epic'
  final String? storePic;

  StoreModel({
    required this.idStore,
    required this.storeName,
    required this.storeAddress,
    this.storeEpic,
    this.storePic,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      idStore: json['id_store'],
      storeName: json['store_name'] ?? 'Unknown Store',
      storeAddress: json['store_address'] ?? '-',
      storeEpic: json['store_epic'],
      // Logic handling gambar jika null
      storePic: json['profilepic'],
    );
  }
}
