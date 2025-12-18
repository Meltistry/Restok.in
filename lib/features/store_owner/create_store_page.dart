// lib/features/store_owner/create_store_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../state/store_provider.dart';

class CreateStorePage extends StatefulWidget {
  const CreateStorePage({super.key});

  @override
  State<CreateStorePage> createState() => _CreateStorePageState();
}

class _CreateStorePageState extends State<CreateStorePage> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _storeAddressController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeAddressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _createStore() async {
    if (!_formKey.currentState!.validate()) return;

    // ===============================================
    // START: HARDCODED USER ID = 1 UNTUK TESTING

    // dan konversi String ke Int dihilangkan sementara.
    // ===============================================

    // Definisikan User ID hardcoded
    const int userIdInt = 1;

    // ===============================================
    // END: HARDCODED USER ID
    // ===============================================

    final storeProvider = context.read<StoreProvider>();

    final success = await storeProvider.createStore(
      // Gunakan ID yang di-hardcode
      userId: userIdInt,
      storeName: _storeNameController.text.trim(),
      storeAddress: _storeAddressController.text.trim(),
      storeImagePath: _selectedImage?.path,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Store created successfully!')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(storeProvider.error ?? 'Failed to create store'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  //final create store
  // Future<void> _createStore() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   final authProvider = context.read<AuthProvider>();
  //   final String? userIdString = authProvider.user?.id;
  //   if (userIdString == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Error: User not authenticated')),
  //     );
  //     return;
  //   }
  //   // Konversi String ke int (jika FK di DB Anda INT)
  //   final int? userIdInt = int.tryParse(userIdString);

  //   if (userIdInt == null) {
  //     // Jika konversi gagal (jarang, tapi mungkin)
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Error: Invalid User ID format')),
  //     );
  //     return;
  //   }

  //   final storeProvider = context.read<StoreProvider>();

  //   final success = await storeProvider.createStore(
  //     userId: userIdInt,
  //     storeName: _storeNameController.text.trim(),
  //     storeAddress: _storeAddressController.text.trim(),
  //     storeImagePath: _selectedImage?.path,
  //   );

  //   if (!mounted) return;

  //   if (success) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Store created successfully!')),
  //     );
  //     Navigator.pop(context, true);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(storeProvider.error ?? 'Failed to create store'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A3A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB8E6E6)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Let's set up\nyour store!",
                style: TextStyle(
                  color: Color(0xFFB8E6E6),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 48),

              // Image Picker
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8E6E6),
                      shape: BoxShape.circle,
                    ),
                    child: _selectedImage != null
                        ? ClipOval(
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.add,
                            size: 48,
                            color: Color(0xFF0A1A3A),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Store Name
              const Text(
                'Store Name',
                style: TextStyle(
                  color: Color(0xFFB8E6E6),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _storeNameController,
                style: const TextStyle(color: Color(0xFF0A1A3A)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFB8E6E6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter store name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Store Address
              const Text(
                'Store Address',
                style: TextStyle(
                  color: Color(0xFFB8E6E6),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _storeAddressController,
                style: const TextStyle(color: Color(0xFF0A1A3A)),
                maxLines: 4,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFB8E6E6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter store address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 48),

              // Next Button
              Consumer<StoreProvider>(
                builder: (context, storeProvider, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: storeProvider.isLoading ? null : _createStore,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E7B7B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: storeProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
