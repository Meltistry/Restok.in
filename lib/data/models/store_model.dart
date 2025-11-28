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
      idStore: json['idStore(PK)'] as int?,
      idUser: json['idUser(FK)'] as int?,
      storeName: json['storeName'] as String? ?? '',
      storeAddress: json['storeAddress'] as String? ?? '',
      storeEpic: json['storeEpic'] as String?,
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
      if (idStore != null) 'idStore(PK)': idStore,
      if (idUser != null) 'idUser(FK)': idUser,
      'storeName': storeName,
      'storeAddress': storeAddress,
      if (storeEpic != null) 'storeEpic': storeEpic,
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
