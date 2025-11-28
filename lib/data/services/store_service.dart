// lib/data/services/store_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/store_model.dart';
import '../models/item_model.dart';
import 'dart:typed_data';

class StoreService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all stores for current user
  Future<List<StoreModel>> getUserStores(int userId) async {
    try {
      final response = await _supabase
          .from('Store')
          .select()
          .eq('idUser(FK)', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => StoreModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch stores: $e');
    }
  }

  // Get single store by ID
  Future<StoreModel> getStoreById(int storeId) async {
    try {
      final response = await _supabase
          .from('Store')
          .select()
          .eq('idStore(PK)', storeId)
          .single();

      return StoreModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch store: $e');
    }
  }

  // Create new store
  Future<StoreModel> createStore(StoreModel store) async {
    try {
      final response = await _supabase
          .from('Store')
          .insert(store.toJson())
          .select()
          .single();

      return StoreModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create store: $e');
    }
  }

  // Update store
  Future<StoreModel> updateStore(StoreModel store) async {
    try {
      final response = await _supabase
          .from('Store')
          .update(store.toJson())
          .eq('idStore(PK)', store.idStore!)
          .select()
          .single();

      return StoreModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update store: $e');
    }
  }

  // Delete store
  Future<void> deleteStore(int storeId) async {
    try {
      await _supabase.from('Store').delete().eq('idStore(PK)', storeId);
    } catch (e) {
      throw Exception('Failed to delete store: $e');
    }
  }

  // ==================== ITEM METHODS ====================

  // Get all items for a store
  Future<List<ItemModel>> getStoreItems(int storeId) async {
    try {
      final response = await _supabase
          .from('Item')
          .select()
          .eq('idStore(FK)', storeId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ItemModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch items: $e');
    }
  }

  // Create new item
  Future<ItemModel> createItem(ItemModel item) async {
    try {
      final response = await _supabase
          .from('Item')
          .insert(item.toJson())
          .select()
          .single();

      return ItemModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create item: $e');
    }
  }

  // Update item
  Future<ItemModel> updateItem(ItemModel item) async {
    try {
      final response = await _supabase
          .from('Item')
          .update(item.toJson())
          .eq('idItem(PK)', item.idItem!)
          .select()
          .single();

      return ItemModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  // Delete item
  Future<void> deleteItem(int itemId) async {
    try {
      await _supabase.from('Item').delete().eq('idItem(PK)', itemId);
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }

  // Upload store image to Supabase Storage
  Future<String?> uploadStoreImage(String filePath, String fileName) async {
    try {
      final Uint8List bytes = await _readFileAsBytes(filePath);

      final path =
          'store_images/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      await _supabase.storage.from('stores').uploadBinary(path, bytes);

      final url = _supabase.storage.from('stores').getPublicUrl(path);

      return url;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<Uint8List> _readFileAsBytes(String filePath) async {
    // Implement file reading based on your platform
    // This is a placeholder/example for mobile (using dart:io)
    /*
        import 'dart:io';
        final file = File(filePath);
        return file.readAsBytes();
        */
    throw UnimplementedError('Implement file reading based on platform');
  }
}
