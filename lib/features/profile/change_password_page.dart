import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  // Widget untuk TextFormField password kustom (Menggantikan .custom-input)
  Widget _buildPasswordField(String label, String id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Menggantikan .input-label
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label, 
            style: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w600, 
              color: Colors.white // Label berwarna putih
            )
          ),
        ),
        TextFormField(
          key: ValueKey(id), 
          obscureText: true, 
          style: const TextStyle(
            fontSize: 18, 
            color: Colors.black, // Warna teks di dalam input hitam
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            // Menggantikan background-color: #D6F6FB, border-radius: 12px, padding: 12px 15px
            fillColor: const Color(0xFFD6F6FB), // #D6F6FB
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required.';
            }
            return null;
          },
        ),
        const SizedBox(height: 25), // Jarak mb-4/mb-5
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, 
      ),
      body: Container(
        // Linear Gradient (Background)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a2847), 
              Color(0xFF0d1829), 
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

                // --- FORM ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0), // px-3
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 20), // Jarak dari back button

                        _buildPasswordField('Old Password', 'oldPassword'),
                        _buildPasswordField('New Password', 'newPassword'),
                        _buildPasswordField('New Password Confirmation', 'confirmPassword'),
                        
                        const SizedBox(height: 30),

                        // Tombol Confirm (Menggantikan .confirm-btn)
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Password changed successfully!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00687A), // #00687A
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), // border-radius: 50px
                            elevation: 0,
                          ),
                          child: const Text('Confirm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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