import 'package:flutter/material.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String invoiceNumber;
  final String paymentDate;
  final String totalAmount;
  final String sourceWalletName;
  final String sourceWalletNumber;
  final String receivingWalletName;
  final String receivingWalletNumber;

  PaymentSuccessPage({
    required this.invoiceNumber,
    required this.paymentDate,
    required this.totalAmount,
    required this.sourceWalletName,
    required this.sourceWalletNumber,
    required this.receivingWalletName,
    required this.receivingWalletNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Successful'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Message and Payment Date
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 20),
            Text(
              'Invoice has been successfully paid!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Payment Date: $paymentDate',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),

            // Payment Details
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount: $totalAmount',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ref No: #$invoiceNumber',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Wallet Info
            Text(
              'Source Wallet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            _buildWalletInfo(
              name: sourceWalletName,
              number: sourceWalletNumber,
            ),
            SizedBox(height: 16),
            Text(
              'Receiving Wallet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            _buildWalletInfo(
              name: receivingWalletName,
              number: receivingWalletNumber,
            ),
            SizedBox(height: 40),

            // Success Confirmation Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to another screen (optional)
                  Navigator.pop(context);
                },
                child: Text('Done'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletInfo({required String name, required String number}) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.account_circle, color: Colors.white),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Phone: $number',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
