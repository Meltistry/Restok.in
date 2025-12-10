import 'package:flutter/material.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  // Widget untuk menampilkan kartu pembayaran (Menggantikan .payment-card)
  Widget _buildPaymentCard(String name, String number, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        // Menggantikan background-color: #c8e9ed, border-radius: 12px
        decoration: BoxDecoration(
          color: const Color(0xFFc8e9ed), // #c8e9ed
          borderRadius: BorderRadius.circular(12),
        ),
        // Menggantikan padding: 15px 20px
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Menggantikan .method-name
                Text(
                  name, 
                  style: const TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.2
                  )
                ),
                // Menggantikan .method-number
                Text(
                  number, 
                  style: TextStyle(
                    fontSize: 14, 
                    color: Colors.black.withOpacity(0.8),
                  )
                ),
              ],
            ),
            if (isChecked) 
              // Menggantikan .check-icon
              const Icon(
                Icons.check_circle, // Ikon yang benar untuk fill
                color: Color(0xFF00687A), // #00687A
                size: 24
              ),
          ],
        ),
      ),
    );
  }

  // Widget untuk Tombol Add New Payment Method (Menggantikan .add-payment-btn)
  Widget _buildAddPaymentButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Logika navigasi ke halaman tambah metode pembayaran
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Go to Add Payment Method page')),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00687A), // #00687A
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), // border-radius: 50px
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          // Ikon plus kustom
          Icon(Icons.add_circle, size: 24), // Menggantikan .add-icon-lg
          SizedBox(width: 10),
          Text(
            'Add New Payment Method',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hapus AppBar default dan gunakan custom design
      body: Container(
        // Linear Gradient (Background)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a2847), // #1a2847
              Color(0xFF0d1829), // #0d1829
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // --- BACK BUTTON ---
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 20.0, bottom: 20.0), // pt-4, pb-4
                  child: InkWell( // Menggantikan .back-btn
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF5dd9e8), width: 2), 
                      ),
                      child: const Icon(
                        Icons.chevron_left, 
                        color: Color(0xFF5dd9e8), 
                        size: 20
                      ),
                    ),
                  ),
                ),
                
                // --- TITLE ---
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0), 
                  child: const Text(
                    'Payment Methods',
                    // Menggantikan .page-title
                    style: TextStyle(
                      fontSize: 42, 
                      fontWeight: FontWeight.w700, 
                      color: Color(0xFF5FC0EF), // #5FC0EF
                      height: 1.1
                    ),
                  ),
                ),
                
                // --- CONTENT ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0), // px-3
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Daftar Metode Pembayaran
                      _buildPaymentCard('Gopay', '0812xxxxxxxx244', true),
                      
                      const SizedBox(height: 30), 

                      // Tombol Add New Payment Method
                      _buildAddPaymentButton(context),
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