import 'package:flutter/material.dart';
import 'package:restokin/data/models/invoice_model.dart';

class InvoiceDetailPage extends StatelessWidget {
  final InvoiceModel invoice;

  InvoiceDetailPage({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice - ${invoice.invoiceNumber}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invoice Number & Store Name
            Text('Invoice Number: #${invoice.invoiceNumber}', 
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 8),
            Text('Store: ${invoice.storeName}', 
                style: Theme.of(context).textTheme.subtitle1),
            SizedBox(height: 8),
            Text('Date: ${invoice.date}', 
                style: Theme.of(context).textTheme.subtitle2),
            SizedBox(height: 16),

            // Product List
            Text('Items:', style: Theme.of(context).textTheme.subtitle1),
            Divider(),
            Column(
              children: invoice.items.map((item) {
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Quantity: ${item.quantity}, Price: ${item.price}'),
                  trailing: Text('Rp${item.totalPrice}'),
                );
              }).toList(),
            ),

            SizedBox(height: 16),

            // Total Amount
            Divider(),
            Text('Total: Rp${invoice.totalAmount}', 
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 16),

            // Payment Status
            Text('Payment Status: ${invoice.paymentStatus}', 
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getPaymentStatusColor(invoice.paymentStatus),
                )),
            SizedBox(height: 16),

            // Payment Button if invoice is "Not Paid"
            if (invoice.paymentStatus == 'Not Paid') 
              ElevatedButton(
                onPressed: () {
                  // Simulate payment logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Processing payment for Invoice #${invoice.invoiceNumber}')),
                  );
                  // Update payment status (for example purposes)
                  invoice.paymentStatus = 'Paid';
                  // Optionally, update this in the service/database
                },
                child: Text('Pay Invoice'),
              ),
          ],
        ),
      ),
    );
  }

  // Get color based on payment status
  Color _getPaymentStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return Colors.green;
      case 'Not Paid':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
