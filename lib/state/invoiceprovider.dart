import 'package:flutter/foundation.dart';
import 'package:restokin/data/models/invoice_model.dart';
import 'package:restokin/data/services/invoice_service.dart';

class InvoiceProvider extends ChangeNotifier {
  final List<InvoiceModel> incomingInvoices = InvoiceService.getIncomingInvoices();
  final List<InvoiceModel> outgoingInvoices = InvoiceService.getOutgoingInvoices();

  void markAsPaid(InvoiceModel invoice) {
    invoice.paymentStatus = 'Paid';
    notifyListeners();
  }
}
