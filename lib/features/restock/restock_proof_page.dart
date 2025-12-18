import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/store_model.dart';
import '../../data/models/item_model.dart';
import 'restock_invoice_preview_page.dart'; // Navigasi ke Preview

class RestockProofPage extends StatefulWidget {
  final Map<ItemModel, int> cart;
  final StoreModel store;

  const RestockProofPage({super.key, required this.cart, required this.store});

  @override
  State<RestockProofPage> createState() => _RestockProofPageState();
}

class _RestockProofPageState extends State<RestockProofPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  void _onContinue() {
    if (_image == null) return;

    // Pindah ke halaman Preview Invoice membawa data
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => RestockInvoicePreviewPage(
        cart: widget.cart,
        store: widget.store,
        proofImage: _image!,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d1829),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text("Add Proof", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Preview Box
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
                ),
                child: _image == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.camera_alt, size: 80, color: Color(0xFF1a7a8a)),
                        const SizedBox(height: 10),
                        Text("Take a picture of proof\nor add from gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        )
                      ],
                    )
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        ),
                        Positioned(
                          right: 10, top: 10,
                          child: GestureDetector(
                            onTap: () => setState(() => _image = null),
                            child: const CircleAvatar(backgroundColor: Colors.red, radius: 18, child: Icon(Icons.close, color: Colors.white)),
                          ),
                        )
                      ],
                    ),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text("Add From Gallery"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1a7a8a),
                minimumSize: const Size(double.infinity, 50),
                shape: const StadiumBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _image == null ? null : _onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1a7a8a),
                disabledBackgroundColor: Colors.grey,
                minimumSize: const Size(double.infinity, 50),
                shape: const StadiumBorder(),
              ),
              child: const Text("Continue", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
