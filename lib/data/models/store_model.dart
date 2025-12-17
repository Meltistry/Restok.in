// lib/data/models/store_model.dart

class StoreModel {
  final int? idStore;
  final int? idUser;
  final String storeName;
  final String storeAddress;
  final String? storeEpic; // Store image URL/path
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StoreModel({
    this.idStore,
    this.idUser,
    required this.storeName,
    required this.storeAddress,
    this.storeEpic,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      idStore: json['id_store'] as int?,
      idUser: json['id_user'] as int?,
      storeName: json['store_name'] as String? ?? '',
      storeAddress: json['store_address'] as String? ?? '',
      storeEpic: json['store_epic'] as String?,
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
      if (idStore != null) 'id_store': idStore,
      if (idUser != null) 'id_user': idUser,
      'store_name': storeName,
      'store_address': storeAddress,
      if (storeEpic != null) 'store_epic': storeEpic,
    };
  }

  StoreModel copyWith({
    int? idStore,
    int? idUser,
    String? storeName,
    String? storeAddress,
    String? storeEpic,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreModel(
      idStore: idStore ?? this.idStore,
      idUser: idUser ?? this.idUser,
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      storeEpic: storeEpic ?? this.storeEpic,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
