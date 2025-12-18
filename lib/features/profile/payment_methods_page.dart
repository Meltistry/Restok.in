import 'package:flutter/material.dart';

// Import Model, Service, dan Halaman Add
import 'package:restokin/data/models/payment_model.dart'; // Pastikan nama file model benar
import 'package:restokin/data/services/payment_service.dart';
import 'package:restokin/data/services/supabase_client.dart';
import 'package:restokin/features/profile/add_payment_method_page.dart'; // Import halaman Add

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  // Service & Auth
  final PaymentService _paymentService = PaymentService();
  final _currentUser = SupabaseService.instance.auth.currentUser;

  // State Variables
  List<PaymentMethod> _paymentMethods = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // --- 1. CRUD: READ (Mengambil Data) ---
  Future<void> _fetchData() async {
    if (_currentUser == null) {
      if (mounted) Navigator.pop(context); // Keluar jika tidak login
      return;
    }

    try {
      final methods = await _paymentService.fetchPaymentMethods(_currentUser.email!);
      if (mounted) {
        setState(() {
          _paymentMethods = methods;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat data: $e';
          _isLoading = false;
        });
      }
    }
  }

  // --- 2. CRUD: UPDATE (Set Default) ---
  Future<void> _handleSetDefault(int id) async {
    if (_currentUser == null) return;
    
    // Update lokal (Optimistic)
    setState(() {
      _paymentMethods = _paymentMethods.map((m) {
        return PaymentMethod(
          id: m.id,
          userId: m.userId,
          paymentTypeId: m.paymentTypeId,
          paymentDetails: m.paymentDetails,
          isDefault: m.id == id, // Hanya satu yang true
          paymentName: m.paymentName,
        );
      }).toList();
    });

    try {
      await _paymentService.setDefaultPayment(id, _currentUser.id);
      
      // REFRESH: Ambil data asli dari DB untuk sinkronisasi
      await _fetchData(); 

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Metode pembayaran utama diperbarui!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      _fetchData(); 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengubah default: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // --- 3. CRUD: CREATE (Navigasi ke Halaman Add) ---
  Future<void> _navigateToAddPayment() async {
    // Menggunakan push dan menunggu hasil (result)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPaymentMethodPage()),
    );

    // Jika result == true (berhasil tambah), refresh data list
    if (result == true) {
      _isLoading = true; // Show loading sebentar
      setState(() {}); 
      _fetchData();
    }
  }

  // --- UI WIDGET: KARTU PEMBAYARAN ---
  Widget _buildPaymentCard(PaymentMethod method) {
    final isDefault = method.isDefault;
    
    // Styling sesuai Laravel Blade
    final cardColor = const Color(0xFFc8e9ed);
    final borderColor = isDefault ? const Color(0xFF00687A) : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _handleSetDefault(method.id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2), // Highlight border jika default
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Info Kiri
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    method.paymentName ?? 'Unknown', 
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black, height: 1.2)
                  ),
                  Text(
                    method.paymentDetails, 
                    style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.8))
                  ),
                  // Badge Default
                  if (isDefault)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFF00687A), borderRadius: BorderRadius.circular(4)),
                      child: const Text('Default', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                ],
              ),
              
              // Icon Centang Kanan
              if (isDefault) 
                const Icon(Icons.check_circle, color: Color(0xFF00687A), size: 28),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1a2847),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF5FC0EF))),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, toolbarHeight: 0),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a2847), Color(0xFF0d1829)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // --- BACK BUTTON ---
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 20.0, bottom: 20.0),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF5dd9e8), width: 2)),
                      child: const Icon(Icons.chevron_left, color: Color(0xFF5dd9e8), size: 20),
                    ),
                  ),
                ),
                
                // --- TITLE ---
                const Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0), 
                  child: Text(
                    'Payment Methods', 
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.w700, color: Color(0xFF5FC0EF), height: 1.1)
                  ),
                ),
                
                // --- CONTENT ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Error Message
                      if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                        ),
                        
                      // Empty State
                      if (_paymentMethods.isEmpty && _errorMessage == null)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'Anda belum memiliki metode pembayaran. Silakan tambahkan satu.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),

                      // List Items
                      ..._paymentMethods.map((method) => _buildPaymentCard(method)).toList(),
                      
                      const SizedBox(height: 30), 

                      // --- TOMBOL ADD NEW ---
                      ElevatedButton(
                        onPressed: _navigateToAddPayment, // Panggil fungsi navigasi
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00687A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.add_circle, size: 24),
                            SizedBox(width: 10),
                            Text('Add New Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
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