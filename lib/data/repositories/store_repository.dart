// lib/data/repositories/store_repository.dart

import '../models/store_model.dart';
import '../models/item_model.dart';
import '../services/store_service.dart';

class StoreRepository {
  final StoreService _storeService = StoreService();

  // Store methods
  Future<List<StoreModel>> getUserStores(int userId) async {
    return await _storeService.getUserStores(userId);
  }

  Future<StoreModel> getStoreById(int storeId) async {
    return await _storeService.getStoreById(storeId);
  }

  Future<StoreModel> createStore({
    required int userId,
    required String storeName,
    required String storeAddress,
    String? storeImagePath,
  }) async {
    String? imageUrl;

    if (storeImagePath != null) {
      imageUrl = await _storeService.uploadStoreImage(
        storeImagePath,
        storeName.replaceAll(' ', '_'),
      );
    }

    final store = StoreModel(
      idUser: userId,
      storeName: storeName,
      storeAddress: storeAddress,
      storeEpic: imageUrl,
    );

    return await _storeService.createStore(store);
  }

  Future<StoreModel> updateStore({
    required int storeId,
    required String storeName,
    required String storeAddress,
    String? storeImagePath,
    String? existingImageUrl,
  }) async {
    String? imageUrl = existingImageUrl;

    if (storeImagePath != null) {
      imageUrl = await _storeService.uploadStoreImage(
        storeImagePath,
        storeName.replaceAll(' ', '_'),
      );
    }

    final store = StoreModel(
      idStore: storeId,
      storeName: storeName,
      storeAddress: storeAddress,
      storeEpic: imageUrl,
    );

    return await _storeService.updateStore(store);
  }

  Future<void> deleteStore(int storeId) async {
    return await _storeService.deleteStore(storeId);
  }

  // Item methods
  Future<List<ItemModel>> getStoreItems(int storeId) async {
    return await _storeService.getStoreItems(storeId);
  }

  Future<ItemModel> createItem({
    required int storeId,
    required String itemName,
    required int itemPrice,
  }) async {
    final item = ItemModel(
      idStore: storeId,
      itemName: itemName,
      itemPrice: itemPrice,
    );

    return await _storeService.createItem(item);
  }

  Future<ItemModel> updateItem({
    required int itemId,
    required String itemName,
    required int itemPrice,
  }) async {
    final item = ItemModel(
      idItem: itemId,
      itemName: itemName,
      itemPrice: itemPrice,
    );

    return await _storeService.updateItem(item);
  }

  Future<void> deleteItem(int itemId) async {
    return await _storeService.deleteItem(itemId);
  }
}
