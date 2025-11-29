import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  // Widget untuk TextFormField kustom (Menggantikan .custom-input)
  Widget _buildCustomInputField({
    required String label, 
    required String initialValue, 
    int maxLines = 1,
    required String id,
  }) {
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
          initialValue: initialValue,
          maxLines: maxLines, // Untuk textarea
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
              borderSide: BorderSide.none, // Menghilangkan border default
            ),
            // Menggantikan custom-input:focus shadow
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
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
                  padding: const EdgeInsets.only(left: 15.0, top: 20.0, bottom: 30.0), // pt-4, pb-4
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

                // --- HEADER EDIT PROFILE ---
                // Padding sesuai web: px-3, mb-5
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 40.0), 
                  child: Row( // Menggantikan .profile-edit-header
                    children: <Widget>[
                      // Profile Image
                      const CircleAvatar(
                        radius: 45, // Untuk 90px width
                        backgroundImage: AssetImage('images/avatardefault.png'), 
                      ),
                      const SizedBox(width: 15),
                      // Edit Title (Menggantikan .edit-title)
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 42, 
                            fontWeight: FontWeight.w700, 
                            height: 1.1,
                            fontFamily: 'Roboto', // Asumsi font bawaan
                          ),
                          children: <TextSpan>[
                            // .edit-text
                            TextSpan(
                              text: 'Edit\n', 
                              style: TextStyle(color: Color(0xFF5FC0EF)), // #5FC0EF
                            ),
                            // .profile-text
                            TextSpan(
                              text: 'Profile', 
                              style: TextStyle(color: Color(0xFF00687A)), // #00687A
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // --- FORM ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0), // px-3
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Input Nickname (mb-4)
                        _buildCustomInputField(
                          label: 'Nickname', 
                          initialValue: 'Carlos', 
                          id: 'nickname'
                        ),
                        const SizedBox(height: 25), 

                        // Input Description (mb-5)
                        _buildCustomInputField(
                          label: 'Description', 
                          initialValue: 'Owner of IS Store', 
                          maxLines: 4, 
                          id: 'description'
                        ),
                        const SizedBox(height: 50), // Jarak mb-5

                        // Tombol Confirm (Menggantikan .confirm-btn)
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profile updated!')),
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