import 'package:flutter/material.dart';
import 'package:restokin/data/services/auth_service.dart';
import 'package:restokin/data/services/supabase_client.dart'; // Pastikan path ini benar

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // Controllers
  final _oldPasswordC = TextEditingController();
  final _newPasswordC = TextEditingController();
  final _confirmPasswordC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Service
  final AuthService _authService = AuthService();

  // State Variables
  bool _isLoading = false;
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordC.dispose();
    _newPasswordC.dispose();
    _confirmPasswordC.dispose();
    super.dispose();
  }

  // --- LOGIKA UPDATE PASSWORD ---
  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = SupabaseService.instance.auth.currentUser;
    if (currentUser == null || currentUser.email == null) {
      _showSnackbar('User tidak ditemukan. Silakan login ulang.', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Panggil fungsi dari AuthService
      await _authService.changePassword(
        currentEmail: currentUser.email!,
        oldPassword: _oldPasswordC.text,
        newPassword: _newPasswordC.text,
      );

      if (!mounted) return;

      _showSnackbar('Password berhasil diubah!', Colors.green);
      
      // Opsional: Kembali ke menu profil setelah sukses
      Navigator.pop(context);

    } catch (e) {
      // Menangani error (misal: password lama salah)
      String message = e.toString();
      // Bersihkan pesan error agar lebih rapi (menghapus "Exception: ")
      if (message.startsWith("Exception: ")) {
        message = message.substring(11);
      }
      _showSnackbar(message, Colors.red);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  // --- WIDGET INPUT PASSWORD KUSTOM ---
  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            fillColor: const Color(0xFFD6F6FB),
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
            // Tombol Mata (Visibility Toggle)
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.black54,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
          validator: validator,
        ),
        const SizedBox(height: 25),
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
                  padding: const EdgeInsets.only(left: 15.0, top: 20.0, bottom: 20.0),
                  child: InkWell(
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
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // --- HEADER TITLE ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5FC0EF),
                    ),
                  ),
                ),

                // --- FORM ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 10),

                        // Old Password
                        _buildPasswordField(
                          label: 'Old Password',
                          controller: _oldPasswordC,
                          obscureText: _obscureOld,
                          onToggleVisibility: () => setState(() => _obscureOld = !_obscureOld),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Masukkan password lama';
                            return null;
                          },
                        ),

                        // New Password
                        _buildPasswordField(
                          label: 'New Password',
                          controller: _newPasswordC,
                          obscureText: _obscureNew,
                          onToggleVisibility: () => setState(() => _obscureNew = !_obscureNew),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Masukkan password baru';
                            if (value.length < 6) return 'Password minimal 6 karakter';
                            return null;
                          },
                        ),

                        // Confirm Password
                        _buildPasswordField(
                          label: 'New Password Confirmation',
                          controller: _confirmPasswordC,
                          obscureText: _obscureConfirm,
                          onToggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Konfirmasi password baru';
                            if (value != _newPasswordC.text) return 'Password tidak cocok';
                            return null;
                          },
                        ),

                        const SizedBox(height: 30),

                        // Tombol Confirm
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleChangePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00687A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Confirm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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