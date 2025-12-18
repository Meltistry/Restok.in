import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/store_model.dart';
import '../../data/models/item_model.dart';
import '../../data/services/cart_service.dart';

class RestockInvoicePreviewPage extends StatefulWidget {
  final Map<ItemModel, int> cart;
  final StoreModel store;
  final File proofImage;

  const RestockInvoicePreviewPage({
    super.key,
    required this.cart,
    required this.store,
    required this.proofImage
  });

  @override
  State<RestockInvoicePreviewPage> createState() => _RestockInvoicePreviewPageState();
}

class _RestockInvoicePreviewPageState extends State<RestockInvoicePreviewPage> {
  final CartService _cartService = CartService();
  bool _isLoading = false;

  double get _totalPrice {
    double total = 0;
    widget.cart.forEach((item, qty) {
      total += item.itemPrice * qty;
    });
    return total;
  }

  Future<void> _submitRestock() async {
    setState(() => _isLoading = true);
    try {
      await _cartService.submitRestock(
        storeId: widget.store.idStore ?? 0,
        cartItems: widget.cart,
        proofImage: widget.proofImage,
      );

      if (mounted) {
        // Tampilkan Sukses dan kembali ke home atau halaman lain
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Restock Request Submitted Successfully!')));
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFF1a2847),
      appBar: AppBar(
        title: const Text('Preview Invoice', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Store Info
                  Row(
                    children: [
                      const Icon(Icons.store, color: Color(0xFF1a7a8a)),
                      const SizedBox(width: 10),
                      Text(widget.store.storeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const Divider(height: 30),

                  // Items List
                  const Text("Items:", style: TextStyle(color: Colors.grey)),
                  ...widget.cart.entries.map((entry) {
                    final item = entry.key;
                    final qty = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text("${item.itemName} x$qty")),
                          Text(currencyFormat.format(item.itemPrice * qty)),
                        ],
                      ),
                    );
                  }),

                  const Divider(height: 30),

                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(currencyFormat.format(_totalPrice), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1a7a8a))),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Text("Proof:", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(widget.proofImage, height: 150, width: double.infinity, fit: BoxFit.cover),
                  ),
                ],
              ),
            ),
          ),

          // Submit Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitRestock,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5dd9e8),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: const StadiumBorder(),
                ),
                child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text("Confirm & Submit", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
