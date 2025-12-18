// lib/state/store_provider.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/item_model.dart';

class StoreProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool isLoading = false;
  String? error;

  List<ItemModel> currentStoreItems = [];

  // ================= LOAD ITEMS =================
  Future<void> loadStoreItems(int storeId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _supabase
          .from('items')
          .select()
          .eq('id_store', storeId)
          .order('created_at');

      currentStoreItems =
          response.map<ItemModel>((e) => ItemModel.fromJson(e)).toList();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= ADD ITEM =================
  Future<bool> addItem({
    required int storeId,
    required String itemName,
    required int itemPrice,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _supabase.from('items').insert({
        'id_store': storeId,
        'item_name': itemName,
        'item_price': itemPrice,
      });

      await loadStoreItems(storeId);
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= UPDATE ITEM =================
  Future<bool> updateItem({
    required int itemId,
    required String itemName,
    required int itemPrice,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _supabase.from('items').update({
        'item_name': itemName,
        'item_price': itemPrice,
      }).eq('id_item', itemId);

      final storeId = currentStoreItems.first.idStore!;
      await loadStoreItems(storeId);
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= DELETE ITEM =================
  Future<bool> deleteItem(int itemId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _supabase
          .from('items')
          .delete()
          .eq('id_item', itemId);

      final storeId = currentStoreItems.first.idStore!;
      await loadStoreItems(storeId);
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
