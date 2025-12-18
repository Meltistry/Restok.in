import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/item_model.dart';

class CartService {
  final SupabaseClient _client = Supabase.instance.client;

  // Fungsi untuk Submit Restock (Upload Bukti -> Buat Cart -> Masukkan Items)
  Future<void> submitRestock({
    required int storeId,
    required Map<ItemModel, int> cartItems, // Item : Quantity
    required int storeOwnerId,
    File? proofImage,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    final int userIdNumeric = await _resolveInternalUserId(user.id);

    try {
      // 1. Upload Gambar Bukti ke Supabase Storage
      // Pastikan Anda sudah membuat bucket bernama 'restock_proofs' di dashboard Supabase
      String? imageUrl;
      if (proofImage != null) {
        final fileExt = proofImage.path.split('.').last;
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${user.id}.$fileExt';

        await _client.storage
            .from('restock_proofs')
            .upload(
              fileName,
              proofImage,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
            );

        // Dapatkan Public URL gambar
        imageUrl = _client.storage
            .from('restock_proofs')
            .getPublicUrl(fileName);
      }

      // 2. Insert ke tabel 'carts'
      final cartResponse = await _client
          .from('carts')
          .insert({
            'id_user':
                userIdNumeric, // bigint-compatible; TODO: align schema to auth UUID if possible.
            'id_store': storeId,
            'cart_date': DateTime.now().toIso8601String(),
            'status':
                'active', // match enum constraint: active|checkout|abandoned
            'restock_proof': imageUrl, // Simpan URL bukti (nullable)
          })
          .select()
          .single();

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

      // 4. Insert invoice entry
      final totalAmount = itemsPayload.fold<double>(
        0,
        (sum, item) => sum + ((item['sub_total'] as num?)?.toDouble() ?? 0),
      );
      await _client.from('invoices').insert({
        'id_cart': newCartId,
        'id_restocker': userIdNumeric,
        'id_store_owner': storeOwnerId,
        'invoice_date': DateTime.now().toIso8601String(),
        'total_amount': totalAmount,
        'status': 'unpaid',
      });
    } catch (e) {
      throw Exception('Gagal melakukan restock: $e');
    }
  }

  Future<int> _resolveInternalUserId(String authUserId) async {
    final data = await _client
        .from('users')
        .select('id_user')
        .eq('auth_user_id', authUserId)
        .maybeSingle();

    if (data == null) {
      throw Exception('User mapping not found for auth user');
    }

    final raw = data['id_user'];
    if (raw is num) return raw.toInt();
    final parsed = int.tryParse(raw.toString());
    if (parsed == null) {
      throw Exception('Invalid internal user id');
    }
    return parsed;
  }
}
