// lib/data/services/payment_service.dart

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Sesuaikan import ini dengan lokasi file model Anda
import 'package:restokin/data/models/payment_model.dart';
import 'package:restokin/data/services/supabase_client.dart';
import 'package:restokin/data/models/payment_type_model.dart';


class PaymentService {
  final SupabaseClient _supabase = SupabaseService.instance;

  // READ: Ambil semua metode pembayaran milik user
  Future<List<PaymentMethod>> fetchPaymentMethods(String email) async {
  try {
    // 1. Ambil ID User (angka) berdasarkan email dari tabel users
    final userResponse = await _supabase
        .from('users')
        .select('id_user')
        .eq('email', email)
        .single();

    final int userIdInt = userResponse['id_user'];

    // 2. Ambil data payment menggunakan ID angka tadi
    // Gunakan join 'payment_types(name)' jika ingin mengambil nama banknya
    final response = await _supabase
        .from('user_payment_types')
        .select('*, payment_types(payment_name)') 
        .eq('id_user', userIdInt);

    return (response as List).map((data) {
      return PaymentMethod.fromMap({
        ...data,
        'payment_name': data['payment_types']?['payment_name'] ?? 'Unknown',
      });
    }).toList();
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}

  // UPDATE: Set Default Payment Method
  // Logika: Set semua milik user jadi false, lalu set yang dipilih jadi true
  // lib/data/services/payment_service.dart

    Future<void> setDefaultPayment(int uniquePaymentId, String userUuid) async {
    try {
      // 1. Ambil ID numerik user agar tidak kena error bigint
      final userRes = await _supabase
          .from('users')
          .select('id_user')
          .eq('email', _supabase.auth.currentUser?.email ?? '')
          .single();

      final int userIdInt = userRes['id_user'];

      // 2. RESET: Set semua milik user ini menjadi false
      await _supabase
          .from('user_payment_types')
          .update({'is_default': false})
          .eq('id_user', userIdInt);

      // 3. SET DEFAULT: Gunakan ID unik baris (Primary Key), bukan ID tipe
      await _supabase
          .from('user_payment_types')
          .update({'is_default': true})
          .eq('id_user_payment_type', uniquePaymentId) // Pastikan 'id' adalah nama kolom Primary Key Anda
          .eq('id_user', userIdInt);
          
    } catch (e) {
      debugPrint('Error setDefault: $e');
      rethrow;
    }
  }

  Future<List<PaymentType>> fetchAvailablePaymentTypes() async {
    try {
      final response = await _supabase
          .from('payment_types')
          .select('id_payment_type, payment_name');

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => PaymentType.fromMap(json)).toList();
    } catch (e) {
      debugPrint('Error fetching payment types: $e');
      rethrow;
    }
  }

  // lib/data/services/payment_service.dart

  // lib/data/services/payment_service.dart

  Future<void> addPaymentMethod({
    required String userUuid, // Kita terima UUID dari UI
    required int paymentTypeId,
    required String paymentDetails,
  }) async {
    try {
      // 1. Ambil ID numerik (BigInt) berdasarkan email user yang sedang login
      final userRes = await _supabase
          .from('users')
          .select('id_user')
          .eq('email', _supabase.auth.currentUser?.email ?? '')
          .single();

      final int userIdInt = userRes['id_user'];

      // 2. Masukkan data ke tabel menggunakan ID angka (userIdInt)
      await _supabase.from('user_payment_types').insert({
        'id_user': userIdInt, // SEKARANG MENGGUNAKAN INT, BUKAN UUID STRING
        'id_payment_type': paymentTypeId,
        'payment_details': paymentDetails,
        'is_default': false,
      });
    } catch (e) {
      debugPrint('Error adding payment method: $e');
      rethrow;
    }
  }
}