// lib/data/repositories/payment_repository.dart

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/payment_method_model.dart';

class PaymentRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Create payment method
  Future<PaymentMethodModel?> createPaymentMethod({
    required int userId,
    required String paymentType,
    required String accountNumber,
    required String accountName,
  }) async {
    try {
      // Get payment_type id from payment_types table
      final paymentTypeResponse = await _supabase
          .from('payment_types')
          .select('id_payment_type')
          .ilike('payment_name', paymentType)
          .maybeSingle();

      if (paymentTypeResponse == null) {
        debugPrint('Payment type "$paymentType" not found');
        return null;
      }

      final paymentTypeId = paymentTypeResponse['id_payment_type'] as int;

      // Store account details as JSON in payment_details
      final paymentDetails = '{"account_number": "$accountNumber", "account_name": "$accountName"}';

      final data = {
        'id_user': userId,
        'id_payment_type': paymentTypeId,
        'payment_details': paymentDetails,
      };

      final response = await _supabase
          .from('user_payment_types')
          .insert(data)
          .select('*, payment_types(payment_name)')
          .single();

      return PaymentMethodModel.fromJson(response);
    } catch (e) {
      debugPrint('Error creating payment method: $e');
      return null;
    }
  }

  /// Get user payment methods
  Future<List<PaymentMethodModel>> getUserPaymentMethods(int userId) async {
    try {
      final response = await _supabase
          .from('user_payment_types')
          .select('*, payment_types(payment_name)')
          .eq('id_user', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => PaymentMethodModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetching payment methods: $e');
      return [];
    }
  }

  /// Update payment method
  Future<bool> updatePaymentMethod({
    required int paymentMethodId,
    String? accountNumber,
    String? accountName,
  }) async {
    try {
      // If updating payment details, reconstruct JSON
      if (accountNumber != null || accountName != null) {
        // Get current details first
        final current = await _supabase
            .from('user_payment_types')
            .select('payment_details')
            .eq('id_user_payment_type', paymentMethodId)
            .single();

        final currentDetails = current['payment_details'] as String?;
        String newDetails;
        
        if (currentDetails != null && currentDetails.isNotEmpty) {
          // Parse existing JSON and update fields
          final regex = RegExp(r'"account_number":\s*"([^"]*)",\s*"account_name":\s*"([^"]*)"');
          final match = regex.firstMatch(currentDetails);
          final currentNumber = match?.group(1) ?? '';
          final currentName = match?.group(2) ?? '';
          
          newDetails = '{"account_number": "${accountNumber ?? currentNumber}", "account_name": "${accountName ?? currentName}"}';
        } else {
          newDetails = '{"account_number": "${accountNumber ?? ''}", "account_name": "${accountName ?? ''}"}';
        }

        await _supabase
            .from('user_payment_types')
            .update({'payment_details': newDetails})
            .eq('id_user_payment_type', paymentMethodId);
      }

      return true;
    } catch (e) {
      debugPrint('Error updating payment method: $e');
      return false;
    }
  }

  /// Delete payment method
  Future<bool> deletePaymentMethod(int paymentMethodId) async {
    try {
      await _supabase
          .from('user_payment_types')
          .delete()
          .eq('id_user_payment_type', paymentMethodId);

      return true;
    } catch (e) {
      debugPrint('Error deleting payment method: $e');
      return false;
    }
  }
}
