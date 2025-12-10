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
  Future<List<PaymentMethod>> fetchPaymentMethods(String userId) async {
    try {
      // Kita melakukan select pada user_payment_types
      // Dan melakukan JOIN ke payment_types untuk mengambil payment_name
      final response = await _supabase
          .from('user_payment_types')
          .select('*, payment_types(payment_name)') 
          .eq('id_user', userId)
          .order('id_user_payment_type', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => PaymentMethod.fromMap(json)).toList();
    } catch (e) {
      debugPrint('Error fetching payments: $e');
      rethrow;
    }
  }

  // UPDATE: Set Default Payment Method
  // Logika: Set semua milik user jadi false, lalu set yang dipilih jadi true
  Future<void> setDefaultPayment(int userPaymentId, String userId) async {
    try {
      // 1. Reset semua payment method user ini menjadi non-default (false)
      await _supabase
          .from('user_payment_types')
          .update({'is_default': false})
          .eq('id_user', userId);

      // 2. Set payment method yang dipilih menjadi default (true)
      await _supabase
          .from('user_payment_types')
          .update({'is_default': true})
          .eq('id_user_payment_type', userPaymentId);
          
    } catch (e) {
      debugPrint('Error setting default payment: $e');
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

  Future<void> addPaymentMethod({
    required String userId,
    required int paymentTypeId,
    required String paymentDetails,
  }) async {
    try {
      await _supabase.from('user_payment_types').insert({
        'id_user': userId,
        'id_payment_type': paymentTypeId,
        'payment_details': paymentDetails,
        'is_default': false, // Default false saat baru dibuat
      });
    } catch (e) {
      debugPrint('Error adding payment method: $e');
      rethrow;
    }
  }
}