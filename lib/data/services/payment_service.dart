import 'package:restokin/data/models/payment_model.dart';
import 'package:restokin/data/services/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Simplified payment service: fetch and insert payments.
class PaymentService {
  PaymentService({SupabaseClient? supabase})
    : _supabase = supabase ?? SupabaseService.instance;

  final SupabaseClient _supabase;

  Future<PaymentModel> payInvoice({
    required String invoiceId,
    required String payerId,
    required String payeeId,
    required double amount,
    String? proofImageUrl,
    String? paymentTypeId,
  }) async {
    final paidAt = DateTime.now();
    final payload = <String, dynamic>{
      _Columns.invoiceId: invoiceId,
      _Columns.payerId: payerId,
      _Columns.payeeId: payeeId,
      _Columns.amount: amount,
      _Columns.status: "paid",
      _Columns.paidAt: paidAt.toIso8601String(),
      if (proofImageUrl != null) _Columns.proofImageUrl: proofImageUrl,
      if (paymentTypeId != null) _Columns.paymentTypeId: paymentTypeId,
    };

    final response = await _supabase
        .from(_Table.payments)
        .insert(payload)
        .select()
        .maybeSingle();

    if (response == null) {
      throw Exception("Payment insert returned empty response");
    }

    return PaymentModel.fromJson(_asJson(response));
  }

  Future<PaymentModel?> getPaymentByInvoiceId(String invoiceId) async {
    final response = await _supabase
        .from(_Table.payments)
        .select()
        .eq(_Columns.invoiceId, invoiceId)
        .maybeSingle();

    if (response == null) return null;
    return PaymentModel.fromJson(_asJson(response));
  }

  Map<String, dynamic> _asJson(dynamic row) {
    if (row is Map<String, dynamic>) return row;
    return Map<String, dynamic>.from(row as Map);
  }
}

/// Table/column constants. Adjust to actual schema.
class _Table {
  static const String payments = "payments";
}

class _Columns {
  static const String invoiceId = "id_invoice";
  static const String payerId = "payer_id"; // TODO: map when schema known
  static const String payeeId = "payee_id"; // TODO: map when schema known
  static const String amount = "amount";
  static const String proofImageUrl = "proof_image_url";
  static const String paymentTypeId = "payment_type_id";
  static const String status = "status";
  static const String paidAt = "paid_at";
}
