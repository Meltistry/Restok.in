import "package:restokin/data/models/invoice_model.dart";
import "package:restokin/data/models/payment_model.dart";
import "package:restokin/data/services/invoice_service.dart";
import "package:restokin/data/services/payment_service.dart";

/// Repository orchestrating invoice and payment operations.
class InvoiceRepository {
  InvoiceRepository({
    required InvoiceService invoiceService,
    required PaymentService paymentService,
  })  : _invoiceService = invoiceService,
        _paymentService = paymentService;

  final InvoiceService _invoiceService;
  final PaymentService _paymentService;

  Future<List<InvoiceModel>> getInvoicesForUser(String userId) {
    return _invoiceService.fetchInvoicesForUser(userId: userId);
  }

  Future<InvoiceModel> getInvoiceDetail(String invoiceId) {
    return _invoiceService.fetchInvoiceById(invoiceId);
  }

  Future<PaymentModel> payInvoiceAndMarkPaid({
    required String invoiceId,
    required String payerId,
    required String payeeId,
    required double amount,
    String? proofImageUrl,
    String? paymentTypeId,
  }) async {
    // 1) Create payment
    final payment = await _paymentService.payInvoice(
      invoiceId: invoiceId,
      payerId: payerId,
      payeeId: payeeId,
      amount: amount,
      proofImageUrl: proofImageUrl,
      paymentTypeId: paymentTypeId,
    );

    // 2) Update invoice status to Paid
    try {
      await _invoiceService.updateInvoiceStatus(
        invoiceId: invoiceId,
        status: "Paid",
        proofImageUrl: proofImageUrl,
        paidAt: payment.paidAt ?? DateTime.now(),
      );
    } catch (e) {
      // TODO: Add compensation/rollback if invoice update fails after payment creation.
      throw Exception("Payment recorded but failed to mark invoice as paid: $e");
    }

    return payment;
  }
}
