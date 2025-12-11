import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/store_model.dart';
import '../models/item_model.dart';

class StoreService {
  final SupabaseClient _client = Supabase.instance.client;

  // Mengambil semua toko
  Future<List<StoreModel>> getStores() async {
    try {
      final response = await _client.from('stores').select();
      final data = response as List<dynamic>;
      return data.map((json) => StoreModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data toko: $e');
    }
  }

  // Mengambil item berdasarkan ID Toko
  Future<List<ItemModel>> getItemsByStore(int storeId) async {
    try {
      final response = await _client
          .from('items')
          .select()
          .eq('id_store', storeId);

      final data = response as List<dynamic>;
      return data.map((json) => ItemModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil barang: $e');
    }
  }
}
