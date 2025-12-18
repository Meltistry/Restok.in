import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/item_model.dart';

class CartService {
  final SupabaseClient _client = Supabase.instance.client;

  // Fungsi untuk Submit Restock (Upload Bukti -> Buat Cart -> Masukkan Items)
  Future<void> submitRestock({
    required int storeId,
    required Map<ItemModel, int> cartItems, // Item : Quantity
    required File proofImage,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    try {
      // 1. Upload Gambar Bukti ke Supabase Storage
      // Pastikan Anda sudah membuat bucket bernama 'restock_proofs' di dashboard Supabase
      final fileExt = proofImage.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${user.id}.$fileExt';

      await _client.storage.from('restock_proofs').upload(
        fileName,
        proofImage,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      // Dapatkan Public URL gambar
      final imageUrl = _client.storage.from('restock_proofs').getPublicUrl(fileName);

      // 2. Insert ke tabel 'carts'
      final cartResponse = await _client.from('carts').insert({
        'id_user': user.id, // Pastikan tipe data kolom id_user di DB cocok (int atau uuid)
        'id_store': storeId,
        'cart_date': DateTime.now().toIso8601String(),
        'status': 'Pending',
        'restock_proof': imageUrl, // Simpan URL bukti
      }).select().single();

      final int newCartId = cartResponse['id_cart'];

      // 3. Insert ke tabel 'cart_items' (Batch Insert)
      final List<Map<String, dynamic>> itemsPayload = [];

      cartItems.forEach((item, qty) {
        itemsPayload.add({
          'id_cart': newCartId,
          'id_item': item.idItem,
          'quantity': qty,
          'sub_total': item.itemPrice * qty,
        });
      });

      if (itemsPayload.isNotEmpty) {
        await _client.from('cart_items').insert(itemsPayload);
      }

    } catch (e) {
      throw Exception('Gagal melakukan restock: $e');
    }
  }
}
