// lib/features/payment/select_payment_page.dart

import 'package:flutter/material.dart';
import '../../core/widgets/gradient_scaffold.dart';

class SelectPaymentPage extends StatefulWidget {
  const SelectPaymentPage({super.key});

  @override
  State<SelectPaymentPage> createState() => _SelectPaymentPageState();
}

class _SelectPaymentPageState extends State<SelectPaymentPage> {
  String? _selectedPayment;

  // E-Wallet payment methods (alphabetically sorted)
  final List<Map<String, String>> _ewalletMethods = [
    {'name': 'Dana', 'value': 'dana', 'image': 'assets/images/Dana.png'},
    {'name': 'Gopay', 'value': 'gopay', 'image': 'assets/images/Gopay.png'},
    {'name': 'OVO', 'value': 'ovo', 'image': 'assets/images/OVO.png'},
    {'name': 'ShopeePay', 'value': 'shopeepay', 'image': 'assets/images/ShopeePay.png'},
  ];

  // Bank payment methods (alphabetically sorted)
  final List<Map<String, String>> _bankMethods = [
    {'name': 'Bank Mandiri', 'value': 'bank_mandiri', 'image': 'assets/images/Bank Mandiri.png'},
    {'name': 'BCA', 'value': 'bca', 'image': 'assets/images/BCA.png'},
    {'name': 'BNI', 'value': 'bni', 'image': 'assets/images/BNI.png'},
    {'name': 'BRI', 'value': 'bri', 'image': 'assets/images/BRI.png'},
    {'name': 'BSI', 'value': 'bsi', 'image': 'assets/images/BSI.png'},
  ];

  void _handleContinue() {
    if (_selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/input-payment',
      arguments: {'paymentType': _selectedPayment},
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Create a\nPayment Method',
                style: TextStyle(
                  color: Color(0xFFB8E6E6),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              
              // E-Wallet Section
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      'E-Wallet',
                      style: TextStyle(
                        color: Color(0xFFB8E6E6),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._ewalletMethods.map((method) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPaymentOption(
                        imagePath: method['image']!,
                        label: method['name']!,
                        value: method['value']!,
                      ),
                    )),
                    
                    const SizedBox(height: 24),
                    
                    // Bank Section
                    const Text(
                      'Bank',
                      style: TextStyle(
                        color: Color(0xFFB8E6E6),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._bankMethods.map((method) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPaymentOption(
                        imagePath: method['image']!,
                        label: method['name']!,
                        value: method['value']!,
                      ),
                    )),
                  ],
                ),
              ),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E7B7B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String imagePath,
    required String label,
    required String value,
  }) {
    final isSelected = _selectedPayment == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPayment = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFB8E6E6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E7B7B) : Colors.transparent,
            width: 3,
          ),
        ),
        child: Row(
          children: [
            // Square 1:1 logo container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF0A1A3A),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF1E7B7B),
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
