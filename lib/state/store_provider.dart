// lib/state/store_provider.dart

import 'package:flutter/material.dart';
import '../data/models/store_model.dart';
import '../data/models/item_model.dart';
import '../data/repositories/store_repository.dart';

class StoreProvider extends ChangeNotifier {
  final StoreRepository _repository = StoreRepository();

  List<StoreModel> _stores = [];
  List<ItemModel> _currentStoreItems = [];
  StoreModel? _selectedStore;

  bool _isLoading = false;
  String? _error;

  // Getters
  List<StoreModel> get stores => _stores;
  List<ItemModel> get currentStoreItems => _currentStoreItems;
  StoreModel? get selectedStore => _selectedStore;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load user stores
  Future<void> loadUserStores(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stores = await _repository.getUserStores(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create store
  Future<bool> createStore({
    required int userId,
    required String storeName,
    required String storeAddress,
    String? storeImagePath,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newStore = await _repository.createStore(
        userId: userId,
        storeName: storeName,
        storeAddress: storeAddress,
        storeImagePath: storeImagePath,
      );

      _stores.insert(0, newStore);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update store
  Future<bool> updateStore({
    required int storeId,
    required String storeName,
    required String storeAddress,
    String? storeImagePath,
    String? existingImageUrl,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedStore = await _repository.updateStore(
        storeId: storeId,
        storeName: storeName,
        storeAddress: storeAddress,
        storeImagePath: storeImagePath,
        existingImageUrl: existingImageUrl,
      );

      final index = _stores.indexWhere((s) => s.idStore == storeId);
      if (index != -1) {
        _stores[index] = updatedStore;
      }

      if (_selectedStore?.idStore == storeId) {
        _selectedStore = updatedStore;
      }

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete store
  Future<bool> deleteStore(int storeId) async {
    try {
      await _repository.deleteStore(storeId);
      _stores.removeWhere((s) => s.idStore == storeId);

      if (_selectedStore?.idStore == storeId) {
        _selectedStore = null;
        _currentStoreItems = [];
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Select store and load items
  Future<void> selectStore(StoreModel store) async {
    _selectedStore = store;
    await loadStoreItems(store.idStore!);
  }

  // Load store items
  Future<void> loadStoreItems(int storeId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentStoreItems = await _repository.getStoreItems(storeId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add item
  Future<bool> addItem({
    required int storeId,
    required String itemName,
    required int itemPrice,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newItem = await _repository.createItem(
        storeId: storeId,
        itemName: itemName,
        itemPrice: itemPrice,
      );

      _currentStoreItems.insert(0, newItem);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update item
  Future<bool> updateItem({
    required int itemId,
    required String itemName,
    required int itemPrice,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedItem = await _repository.updateItem(
        itemId: itemId,
        itemName: itemName,
        itemPrice: itemPrice,
      );

      final index = _currentStoreItems.indexWhere((i) => i.idItem == itemId);
      if (index != -1) {
        _currentStoreItems[index] = updatedItem;
      }

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete item
  Future<bool> deleteItem(int itemId) async {
    try {
      await _repository.deleteItem(itemId);
      _currentStoreItems.removeWhere((i) => i.idItem == itemId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
