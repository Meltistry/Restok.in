import "package:restokin/data/models/invoice_model.dart";
import "package:restokin/data/services/supabase_client.dart";
import "package:supabase_flutter/supabase_flutter.dart";

/// Data access layer for invoices.
///
/// Uses Supabase when available. Adjust table/column names in [_Table] constants.
class InvoiceService {
  InvoiceService({SupabaseClient? supabase})
      : _supabase = supabase ?? SupabaseService.instance;

  final SupabaseClient _supabase;

  Future<List<InvoiceModel>> fetchInvoicesForUser({required String userId}) async {
    try {
      final response = await _supabase
          .from(_Table.invoices)
          .select("*")
          // TODO: Adjust filters to payer/payee/type once schema is known.
          .or("payer_id.eq.$userId,payee_id.eq.$userId");

      if (response is! List) {
        throw Exception("Unexpected response when fetching invoices");
      }

      return response
          .map((row) => _mapRow(row))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch invoices: $e");
    }
  }

  Future<InvoiceModel> fetchInvoiceById(String invoiceId) async {
    try {
      final response = await _supabase
          .from(_Table.invoices)
          .select("*")
          .eq(_Columns.invoiceId, invoiceId)
          .maybeSingle();

      if (response == null) {
        throw Exception("Invoice not found");
      }

      return _mapRow(response);
    } catch (e) {
      throw Exception("Failed to fetch invoice: $e");
    }
  }

  Future<void> updateInvoiceStatus({
    required String invoiceId,
    required String status,
    String? proofImageUrl,
    DateTime? paidAt,
  }) async {
    try {
      final payload = <String, dynamic>{
        _Columns.status: status,
        if (proofImageUrl != null) _Columns.proofImageUrl: proofImageUrl,
        if (paidAt != null) _Columns.paidAt: paidAt.toIso8601String(),
      };

      final response = await _supabase
          .from(_Table.invoices)
          .update(payload)
          .eq(_Columns.invoiceId, invoiceId);

      // Supabase returns List for update by default; we do not require the rows here.
      if (response == null) {
        throw Exception("Failed to update invoice status");
      }
    } catch (e) {
      throw Exception("Failed to update invoice status: $e");
    }
  }

  Future<List<InvoiceModel>> fetchIncomingInvoices(String userId) {
    // TODO: Replace with payee-based filter once schema is clear.
    return fetchInvoicesForUser(userId: userId);
  }

  Future<List<InvoiceModel>> fetchOutgoingInvoices(String userId) {
    // TODO: Replace with payer-based filter once schema is clear.
    return fetchInvoicesForUser(userId: userId);
  }

  InvoiceModel _mapRow(dynamic row) {
    if (row is Map<String, dynamic>) {
      return InvoiceModel.fromJson(row);
    }
    return InvoiceModel.fromJson(Map<String, dynamic>.from(row as Map));
  }
}

/// Table and column name placeholders.
/// TODO: Align with actual Supabase schema.
class _Table {
  static const String invoices = "invoices";
}

class _Columns {
  static const String invoiceId = "invoice_number"; // TODO: Map to actual id column.
  static const String status = "payment_status"; // TODO: Map to actual status column.
  static const String proofImageUrl = "proof_image_url"; // TODO: Map to actual proof field.
  static const String paidAt = "paid_at"; // TODO: Map to actual paid timestamp field.
}
