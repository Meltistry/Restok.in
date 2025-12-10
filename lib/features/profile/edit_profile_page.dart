import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Import service dan model
import 'package:restokin/data/models/user_model.dart'; 
import 'package:restokin/data/services/user_service.dart';
import 'package:restokin/data/services/supabase_client.dart'; 

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controllers
  final _nicknameC = TextEditingController();
  final _descriptionC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Instance Service
  final ProfileService _userService = ProfileService();
  final _currentUser = SupabaseService.instance.auth.currentUser;

  // State
  UserProfile? _initialProfile;
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;
  final String _defaultAvatarPath = 'images/avatardefault.png';

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  @override
  void dispose() {
    _nicknameC.dispose();
    _descriptionC.dispose();
    super.dispose();
  }

  // --- LOGIKA READ (Mengisi data awal) ---
  Future<void> _fetchProfileData() async {
    // Check 1: Pastikan user login
    if (_currentUser == null) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Sesi pengguna tidak ditemukan.';
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final profile = await _userService.fetchProfile(_currentUser.id);
      
      if (mounted) {
        setState(() {
          _initialProfile = profile;
          _nicknameC.text = profile?.nickname ?? '';
          _descriptionC.text = profile?.description ?? '';
          _isLoading = false;
        });
        if (profile == null) {
          _showSnackbar('Profil tidak ditemukan. Data akan di-insert baru.', Colors.orange);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat data: ${e.toString()}';
          _isLoading = false;
        });
      }
      _showSnackbar(_errorMessage!, Colors.red);
    }
  }

  // --- LOGIKA UPDATE (Menyimpan perubahan) ---
  Future<void> _handleConfirmUpdate() async {
    if (!_formKey.currentState!.validate() || _currentUser == null) return;

    setState(() => _isSubmitting = true);
    
    try {
      // Panggil fungsi Update dari Service
      await _userService.updateOrCreateProfile(
        userId: _currentUser.id,
        nickname: _nicknameC.text.trim(),
        description: _descriptionC.text.trim(),
        email: _currentUser.email!,
        username: _initialProfile?.username ?? _nicknameC.text.trim(), // Pertahankan username lama atau gunakan nickname
        profilePic: _initialProfile?.profilePic, // Pertahankan foto lama (Logika upload foto akan ditambahkan di sini jika ada Image Picker)
      );

      if (mounted) {
        _showSnackbar('Profil berhasil diperbarui!', Colors.green);
        // Kembali ke halaman Profile Menu setelah update
        Navigator.pop(context, true); 
      }
    } on PostgrestException catch (e) {
      _showSnackbar('Gagal Update: ${e.message}', Colors.red);
    } catch (e) {
      _showSnackbar('Error Umum: ${e.toString()}', Colors.red);
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
  
  // --- UTILITY ---
  void _showSnackbar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  // --- WIDGET CUSTOM INPUT (Dipertahankan dari kode Anda) ---
  Widget _buildCustomInputField({
    required String label, 
    required TextEditingController controller, // Ubah menjadi controller
    int maxLines = 1,
    required String id,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label, 
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)
          ),
        ),
        TextFormField(
          key: ValueKey(id),
          controller: controller, // Gunakan controller
          maxLines: maxLines,
          style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
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
          ),
          validator: (value) {
            if (id == 'nickname' && (value == null || value.isEmpty)) {
              return 'Nickname tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan Loading
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1a2847),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF5FC0EF))),
      );
    }

    // Tentukan avatar
    final avatarUrl = _initialProfile?.profilePic;
    final ImageProvider avatarImage = avatarUrl != null && avatarUrl.isNotEmpty
      ? CachedNetworkImageProvider(avatarUrl) as ImageProvider
      : AssetImage(_defaultAvatarPath);

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
                  padding: const EdgeInsets.only(left: 15.0, top: 20.0, bottom: 30.0),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF5dd9e8), width: 2)),
                      child: const Icon(Icons.chevron_left, color: Color(0xFF5dd9e8), size: 20),
                    ),
                  ),
                ),

                // --- HEADER EDIT PROFILE ---
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 40.0), 
                  child: Row(
                    children: <Widget>[
                      // Profile Image
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: avatarImage, // Gambar dari DB
                      ),
                      const SizedBox(width: 15),
                      // Edit Title
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 42, fontWeight: FontWeight.w700, height: 1.1, fontFamily: 'Roboto'),
                          children: <TextSpan>[
                            TextSpan(text: 'Edit\n', style: TextStyle(color: Color(0xFF5FC0EF))),
                            TextSpan(text: 'Profile', style: TextStyle(color: Color(0xFF00687A))),
                          ],
                        ),
                      ),
                    ],
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
                        // Input Nickname
                        _buildCustomInputField(
                          label: 'Nickname', 
                          controller: _nicknameC, 
                          id: 'nickname'
                        ),
                        const SizedBox(height: 25), 

                        // Input Description
                        _buildCustomInputField(
                          label: 'Description', 
                          controller: _descriptionC, 
                          maxLines: 4, 
                          id: 'description'
                        ),
                        const SizedBox(height: 50),

                        // Tombol Confirm
                        ElevatedButton(
                          onPressed: _isSubmitting ? null : _handleConfirmUpdate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00687A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            elevation: 0,
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
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