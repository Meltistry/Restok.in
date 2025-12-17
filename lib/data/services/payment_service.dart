import "package:restokin/data/models/payment_model.dart";
import "package:restokin/data/services/invoice_service.dart";
import "package:restokin/data/services/supabase_client.dart";
import "package:supabase_flutter/supabase_flutter.dart";

/// Payment transaction service for paying an invoice.
class PaymentService {
  PaymentService({
    SupabaseClient? supabase,
    InvoiceService? invoiceService,
  })  : _supabase = supabase ?? SupabaseService.instance,
        _invoiceService = invoiceService ?? InvoiceService();

  final SupabaseClient _supabase;
  final InvoiceService _invoiceService;

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
      _Columns.status: "Paid", // TODO: align with backend status enum
      _Columns.paidAt: paidAt.toIso8601String(),
      if (proofImageUrl != null) _Columns.proofImageUrl: proofImageUrl,
      if (paymentTypeId != null) _Columns.paymentTypeId: paymentTypeId,
    };

    try {
      final response = await _supabase
          .from(_Table.payments)
          .insert(payload)
          .select()
          .maybeSingle();

      if (response == null) {
        throw Exception("Payment insert returned empty response");
      }

      // Update invoice status to Paid.
      await _invoiceService.updateInvoiceStatus(
        invoiceId: invoiceId,
        status: "Paid",
        proofImageUrl: proofImageUrl,
        paidAt: paidAt,
      );

      return PaymentModel.fromJson(_asJson(response));
    } catch (e) {
      throw Exception("Failed to pay invoice: $e");
    }
  }

  Future<PaymentModel?> getPaymentByInvoiceId(String invoiceId) async {
    try {
      final response = await _supabase
          .from(_Table.payments)
          .select()
          .eq(_Columns.invoiceId, invoiceId)
          .maybeSingle();

      if (response == null) return null;
      return PaymentModel.fromJson(_asJson(response));
    } catch (e) {
      throw Exception("Failed to fetch payment for invoice: $e");
    }
  }

  Map<String, dynamic> _asJson(dynamic row) {
    if (row is Map<String, dynamic>) return row;
    return Map<String, dynamic>.from(row as Map);
  }
}

/// Table/column constants. Adjust to actual schema.
class _Table {
  static const String payments = "payments"; // TODO: confirm table name
}

class _Columns {
  static const String invoiceId = "invoice_id"; // TODO: map to actual column
  static const String payerId = "payer_id"; // TODO: map to actual column
  static const String payeeId = "payee_id"; // TODO: map to actual column
  static const String amount = "amount"; // TODO: map to actual column
  static const String proofImageUrl = "proof_image_url"; // TODO: map to actual column
  static const String paymentTypeId = "payment_type_id"; // TODO: map to actual column
  static const String status = "status"; // TODO: map to actual column
  static const String paidAt = "paid_at"; // TODO: map to actual column
}
