import 'package:restokin/data/models/invoice_model.dart';

class InvoiceService {
  static List<InvoiceModel> getIncomingInvoices() => _dummyInvoices();

  static List<InvoiceModel> getOutgoingInvoices() => _dummyInvoices();

  static List<InvoiceModel> _dummyInvoices() {
    return [
      InvoiceModel(
        invoiceNumber: 'INV-001',
        storeName: 'Demo Store',
        date: '2024-05-01',
        paymentStatus: 'Not Paid',
        items: [
          InvoiceItem(name: 'Item A', quantity: 2, price: 10.0),
          InvoiceItem(name: 'Item B', quantity: 1, price: 15.0),
        ],
      ),
      InvoiceModel(
        invoiceNumber: 'INV-002',
        storeName: 'Another Store',
        date: '2024-05-05',
        paymentStatus: 'Paid',
        items: [
          InvoiceItem(name: 'Item C', quantity: 3, price: 8.0),
        ],
      ),
    ];
  }
}
