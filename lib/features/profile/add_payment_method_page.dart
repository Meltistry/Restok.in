// lib/features/profile/add_payment_method_page.dart

import 'package:flutter/material.dart';

// Import Service & Model
import 'package:restokin/data/services/payment_service.dart';
import 'package:restokin/data/models/payment_type_model.dart';
import 'package:restokin/data/services/supabase_client.dart';

class AddPaymentMethodPage extends StatefulWidget {
  const AddPaymentMethodPage({super.key});

  @override
  State<AddPaymentMethodPage> createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  final PaymentService _paymentService = PaymentService();
  final _currentUser = SupabaseService.instance.auth.currentUser;
  
  final _paymentDetailsC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // State Data
  List<PaymentType> _availableTypes = [];
  int? _selectedTypeId; // ID tipe pembayaran yang dipilih
  bool _isLoadingTypes = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPaymentTypes();
  }

  @override
  void dispose() {
    _paymentDetailsC.dispose();
    super.dispose();
  }

  // --- LOGIKA FETCH TYPES (READ) ---
  Future<void> _fetchPaymentTypes() async {
    try {
      final types = await _paymentService.fetchAvailablePaymentTypes();
      if (mounted) {
        setState(() {
          _availableTypes = types;
          // Set default selected ke item pertama jika ada
          if (types.isNotEmpty) {
            _selectedTypeId = types.first.id;
          }
          _isLoadingTypes = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat tipe pembayaran: $e';
          _isLoadingTypes = false;
        });
      }
    }
  }

  // --- LOGIKA SUBMIT (CREATE) ---
  Future<void> _handleAddPayment() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTypeId == null || _currentUser == null) return;

    setState(() => _isSubmitting = true);

    try {
      await _paymentService.addPaymentMethod(
        userUuid: _currentUser.id, // Ganti nama parameter menjadi userUuid jika di service diubah
        paymentTypeId: _selectedTypeId!,
        paymentDetails: _paymentDetailsC.text.trim(),
      );

      if (!mounted) return;

      // Sukses: Tampilkan pesan & kembali ke halaman sebelumnya dengan nilai true (untuk refresh)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Metode pembayaran berhasil ditambahkan!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true); 

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambah pembayaran: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  // --- WIDGET PILIHAN TIPE PEMBAYARAN ---
  Widget _buildPaymentTypeCard(PaymentType type) {
    final isSelected = _selectedTypeId == type.id;
    final cardColor = const Color(0xFFc8e9ed);
    final borderColor = isSelected ? const Color(0xFF00687A) : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTypeId = type.id;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  const Text(
                    'Klik untuk memilih',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Color(0xFF00687A), size: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan Loading Awal
    if (_isLoadingTypes) {
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
              children: [
                // Back Button
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

                // Title "Add New Payment Method"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.1, fontFamily: 'Roboto'),
                      children: [
                        TextSpan(text: 'Add New\n', style: TextStyle(color: Colors.white)),
                        TextSpan(text: 'Payment Method', style: TextStyle(color: Color(0xFF5FC0EF))),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),

                // Content (Form & Selection)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_errorMessage != null)
                          Text(_errorMessage!, style: const TextStyle(color: Colors.red)),

                        // List Tipe Pembayaran (Radio Style)
                        if (_availableTypes.isNotEmpty)
                          ..._availableTypes.map((type) => _buildPaymentTypeCard(type)).toList()
                        else
                          const Text('Tidak ada tipe pembayaran tersedia.', style: TextStyle(color: Colors.white70)),

                        const SizedBox(height: 30),

                        // Input Detail Pembayaran
                        const Text(
                          'Nomor Akun / Detail Pembayaran',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _paymentDetailsC,
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Contoh: 0812xxxxxxxx',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Detail pembayaran wajib diisi';
                            return null;
                          },
                        ),

                        const SizedBox(height: 40),

                        // Tombol Add Payment
                        ElevatedButton(
                          onPressed: _isSubmitting ? null : _handleAddPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00687A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            elevation: 0,
                          ),
                          child: _isSubmitting
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Add Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(height: 30),
                      ],
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