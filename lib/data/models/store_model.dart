// lib/data/models/store_model.dart

class StoreModel {
  final int idStore;
  final int idUser;
  final String storeName;
  final String storeAddress;
  final String storeEpic;

  StoreModel({
    required this.idStore,
    required this.idUser,
    required this.storeName,
    required this.storeAddress,
    required this.storeEpic,
  });

  // Create StoreModel from JSON
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      idStore: json['idStore'] ?? 0,
      idUser: json['idUser'] ?? 0,
      storeName: json['storeName'] ?? '',
      storeAddress: json['storeAddress'] ?? '',
      storeEpic: json['storeEpic'] ?? '',
    );
  }

  // Convert StoreModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'idStore': idStore,
      'idUser': idUser,
      'storeName': storeName,
      'storeAddress': storeAddress,
      'storeEpic': storeEpic,
    };
  }

  // Create a copy with modified fields
  StoreModel copyWith({
    int? idStore,
    int? idUser,
    String? storeName,
    String? storeAddress,
    String? storeEpic,
  }) {
    return StoreModel(
      idStore: idStore ?? this.idStore,
      idUser: idUser ?? this.idUser,
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      storeEpic: storeEpic ?? this.storeEpic,
    );
  }

  @override
  String toString() {
    return 'StoreModel(idStore: $idStore, storeName: $storeName, idUser: $idUser)';
  }
}