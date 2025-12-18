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

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json["items"];
    final parsedItems = _parseItems(rawItems);

    // If backend already provides a total, inject it as a synthetic item
    // when item-level detail is absent.
    if (parsedItems.isEmpty && json["total_amount"] != null) {
      final total = (json["total_amount"] as num).toDouble();
      parsedItems.add(InvoiceItem(name: "Total", quantity: 1, price: total));
    }

    return InvoiceModel(
      invoiceNumber:
          json["invoice_number"]?.toString() ??
          json["id_invoice"]?.toString() ??
          json["id"]?.toString() ??
          "",
      storeName:
          json["store_name"]?.toString() ??
          json["store"]?.toString() ??
          "Unknown Store",
      date: json["date"]?.toString() ?? json["created_at"]?.toString() ?? "N/A",
      items: parsedItems,
      paymentStatus:
          json["payment_status"]?.toString() ??
          json["status"]?.toString() ??
          "unpaid",
    );
  }

  static List<InvoiceItem> _parseItems(dynamic rawItems) {
    if (rawItems is List) {
      return rawItems
          .map((item) {
            if (item is Map<String, dynamic>) {
              final quantity = item["quantity"] ?? 1;
              final price = item["price"] ?? item["unit_price"] ?? 0;
              return InvoiceItem(
                name: item["name"]?.toString() ?? "Item",
                quantity: quantity is int
                    ? quantity
                    : int.tryParse("$quantity") ?? 1,
                price: price is num
                    ? price.toDouble()
                    : double.tryParse("$price") ?? 0,
              );
            }
            return null;
          })
          .whereType<InvoiceItem>()
          .toList();
    }
    return [];
  }
}
