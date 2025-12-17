import "package:flutter/foundation.dart";
import "package:restokin/data/models/invoice_model.dart";
import "package:restokin/data/repositories/invoice_repository.dart";
import "package:restokin/data/services/invoice_service.dart";
import "package:restokin/data/services/payment_service.dart";

/// State management for invoices list, detail, and payment.
class InvoiceProvider extends ChangeNotifier {
  InvoiceProvider({
    InvoiceRepository? repository,
  }) : _repository = repository ??
            InvoiceRepository(
              invoiceService: InvoiceService(),
              paymentService: PaymentService(),
            );

  final InvoiceRepository _repository;

  // State
  final List<InvoiceModel> _invoices = [];
  final Map<String, InvoiceModel> _details = {};

  bool _isLoadingList = false;
  bool _isLoadingDetail = false;
  bool _isPaying = false;

  String? _listError;
  String? _detailError;
  String? _payError;

  // Getters
  List<InvoiceModel> get invoices => List.unmodifiable(_invoices);
  bool get isLoadingList => _isLoadingList;
  bool get isLoadingDetail => _isLoadingDetail;
  bool get isPaying => _isPaying;
  String? get listError => _listError;
  String? get detailError => _detailError;
  String? get payError => _payError;

  // Filtering helpers (TODO: adjust logic once payer/payee/type fields are known)
  List<InvoiceModel> incomingInvoices(String userId) =>
      _invoices.where((inv) => _isIncoming(inv, userId)).toList();

  List<InvoiceModel> outgoingInvoices(String userId) =>
      _invoices.where((inv) => !_isIncoming(inv, userId)).toList();

  InvoiceModel? getDetail(String invoiceId) => _details[invoiceId];

  Future<void> loadInvoices({required String userId, bool forceRefresh = false}) async {
    if (_isLoadingList) return;
    if (!forceRefresh && _invoices.isNotEmpty) return;

    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final fetched = await _repository.getInvoicesForUser(userId);
      _invoices
        ..clear()
        ..addAll(fetched);
    } catch (e) {
      _listError = e.toString();
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  Future<void> refreshInvoices(String userId) {
    return loadInvoices(userId: userId, forceRefresh: true);
  }

  Future<InvoiceModel?> loadInvoiceDetail(String invoiceId) async {
    if (_details.containsKey(invoiceId)) {
      return _details[invoiceId];
    }

    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();

    try {
      final invoice = await _repository.getInvoiceDetail(invoiceId);
      _details[invoiceId] = invoice;
      // Keep list in sync if present.
      final index = _invoices.indexWhere((inv) => inv.invoiceNumber == invoiceId);
      if (index != -1) {
        _invoices[index] = invoice;
      }
      return invoice;
    } catch (e) {
      _detailError = e.toString();
      return null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> payInvoice({
    required String invoiceId,
    required String payerId,
    required String payeeId,
    required double amount,
    String? proofImageUrl,
    String? paymentTypeId,
  }) async {
    _isPaying = true;
    _payError = null;
    notifyListeners();

    try {
      final payment = await _repository.payInvoiceAndMarkPaid(
        invoiceId: invoiceId,
        payerId: payerId,
        payeeId: payeeId,
        amount: amount,
        proofImageUrl: proofImageUrl,
        paymentTypeId: paymentTypeId,
      );

      _markPaid(invoiceId, payment.paidAt);
      return true;
    } catch (e) {
      _payError = e.toString();
      return false;
    } finally {
      _isPaying = false;
      notifyListeners();
    }
  }

  void _markPaid(String invoiceId, DateTime? paidAt) {
    void updateModel(InvoiceModel inv) {
      inv.paymentStatus = "Paid";
      // TODO: map paidAt to model field when available.
    }

    final detail = _details[invoiceId];
    if (detail != null) updateModel(detail);

    for (var i = 0; i < _invoices.length; i++) {
      if (_invoices[i].invoiceNumber == invoiceId) {
        updateModel(_invoices[i]);
      }
    }
  }

  bool _isIncoming(InvoiceModel invoice, String userId) {
    // TODO: Replace with payer/payee/type-based logic when InvoiceModel has fields.
    return invoice.paymentStatus.toLowerCase() != "paid";
  }
}
