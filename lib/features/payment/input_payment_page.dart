// lib/features/payment/input_payment_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../state/payment_provider.dart';

class InputPaymentPage extends StatefulWidget {
  const InputPaymentPage({super.key});

  @override
  State<InputPaymentPage> createState() => _InputPaymentPageState();
}

class _InputPaymentPageState extends State<InputPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();
  String? _paymentType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && _paymentType == null) {
      _paymentType = args['paymentType'] as String?;
    }
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;

    // Get current authenticated user
    final authUser = Supabase.instance.client.auth.currentUser;
    if (authUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not authenticated'), backgroundColor: Colors.red),
      );
      return;
    }

    // Get id_user from public.users table using email
    final userResponse = await Supabase.instance.client
        .from('users')
        .select('id_user')
        .eq('email', authUser.email!)
        .maybeSingle();

    if (!mounted) return;

    if (userResponse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found'), backgroundColor: Colors.red),
      );
      return;
    }

    final userId = userResponse['id_user'] as int;

    final paymentProvider = context.read<PaymentProvider>();
    
    final success = await paymentProvider.addPaymentMethod(
      userId: userId,
      paymentType: _paymentType ?? 'gopay',
      accountNumber: _accountNumberController.text.trim(),
      accountName: _accountNameController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      // Navigate to success page
      Navigator.pushNamed(context, '/payment-success');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(paymentProvider.error ?? 'Failed to add payment method'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentProvider>();
    
    // Map payment type values to display names
    final paymentLabels = {
      'dana': 'Dana',
      'gopay': 'Gopay',
      'ovo': 'OVO',
      'shopeepay': 'ShopeePay',
      'bank_mandiri': 'Bank Mandiri',
      'bca': 'BCA',
      'bni': 'BNI',
      'bri': 'BRI',
      'bsi': 'BSI',
    };
    
    final paymentLabel = paymentLabels[_paymentType] ?? _paymentType ?? 'Payment';
    final isBank = ['bank_mandiri', 'bca', 'bni', 'bri', 'bsi'].contains(_paymentType);
    final numberLabel = isBank ? 'Account Number' : 'Phone Number';
    
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB8E6E6)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create a\nPayment Method',
                  style: TextStyle(
                    color: Color(0xFFB8E6E6),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Please input your $paymentLabel Number',
                  style: const TextStyle(
                    color: Color(0xFFB8E6E6),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 48),
                
                // Account Name Field
                const Text(
                  'Account Name',
                  style: TextStyle(
                    color: Color(0xFFB8E6E6),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _accountNameController,
                  style: const TextStyle(color: Color(0xFF0A1A3A)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFB8E6E6),
                    hintText: 'Enter account name',
                    hintStyle: TextStyle(
                      color: const Color(0xFF0A1A3A).withValues(alpha: 0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter account name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Account Number Field
                Text(
                  numberLabel,
                  style: const TextStyle(
                    color: Color(0xFFB8E6E6),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _accountNumberController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Color(0xFF0A1A3A)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFB8E6E6),
                    hintText: isBank ? 'Enter account number' : 'Enter phone number',
                    hintStyle: TextStyle(
                      color: const Color(0xFF0A1A3A).withValues(alpha: 0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter ${isBank ? 'account' : 'phone'} number';
                    }
                    if (value.length < 8) {
                      return 'Number must be at least 8 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Make sure the number you input is correct',
                  style: TextStyle(
                    color: const Color(0xFFB8E6E6).withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 48),
                
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: paymentProvider.isLoading ? null : _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E7B7B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: paymentProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
