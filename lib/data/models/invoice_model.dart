class InvoiceItem {
  final String name;
  final int quantity;
  final double price;

  InvoiceItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  double get totalPrice => quantity * price;
}

class InvoiceModel {
  final String invoiceNumber;
  final String storeName;
  final String date;
  final List<InvoiceItem> items;
  String paymentStatus;

  InvoiceModel({
    required this.invoiceNumber,
    required this.storeName,
    required this.date,
    required this.items,
    required this.paymentStatus,
  });

  double get totalAmount =>
      items.fold(0, (sum, item) => sum + item.totalPrice);
}
