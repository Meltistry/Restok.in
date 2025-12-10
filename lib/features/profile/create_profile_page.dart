// lib/features/profile/create_profile_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import widget custom Anda
import 'package:restokin/core/widgets/primary_button.dart';
import 'package:restokin/core/widgets/text_field.dart';

// Import service Supabase Anda
import 'package:restokin/data/services/user_service.dart'; 
import 'package:restokin/data/services/supabase_client.dart'; 

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _nicknameC = TextEditingController();
  final _descriptionC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // Instance service
  final _userService = ProfileService();

  bool _isSubmitting = false;
  File? _profileImage;
  String? _email;
  String? _usernameFromArgs; 
  bool _isGoogleSignUp = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['username'] != null) {
        _usernameFromArgs = args['username'];
        if (_nicknameC.text.isEmpty) {
          _nicknameC.text = args['username'];
        }
      }
      if (args['email'] != null) {
        _email = args['email'];
      }
      if (args['isGoogleSignUp'] != null) {
        _isGoogleSignUp = args['isGoogleSignUp'];
      }
    }
  }

  @override
  void dispose() {
    _nicknameC.dispose();
    _descriptionC.dispose();
    super.dispose();
  }
  
  // --- UTILITY METHODS ---

  void _showSnackbar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  // --- 1. LOGIKA PICK IMAGE ---
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (!mounted) return;

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    } else {
      _showSnackbar('Pemilihan gambar dibatalkan.', Colors.orange);
    }
  }

  // --- 2. LOGIKA CREATE PROFILE (UPLOAD & UPDATE/INSERT CRUD) ---
  Future<void> _handleNext() async {
    if (!_formKey.currentState!.validate()) return;
    
    final currentUser = SupabaseService.instance.auth.currentUser;
    final currentUserId = currentUser?.id;
    
    if (currentUserId == null || currentUser?.email == null) {
      if (!mounted) return;
      _showSnackbar('Error: Sesi pengguna tidak valid.', Colors.red);
      return;
    }
    
    setState(() => _isSubmitting = true);
    
    String? profilePicUrl;

    try {
      // 1. UPLOAD FOTO PROFIL (Jika ada)
      if (_profileImage != null) {
        _showSnackbar('Mengunggah foto profil...', Colors.blue);
        profilePicUrl = await _userService.uploadProfilePicture(
          _profileImage!,
          currentUserId,
        );
      }

      // 2. SIMPAN/UPDATE DATA PROFIL KE TABEL 'users'
      await _userService.updateOrCreateProfile(
        userId: currentUserId,
        nickname: _nicknameC.text.trim(),
        email: currentUser!.email!,
        description: _descriptionC.text.trim(),
        username: _usernameFromArgs ?? _nicknameC.text.trim(),
        profilePic: profilePicUrl, 
      );

      if (!mounted) return;
      
      // 3. SUKSES: Navigasi ke halaman profile utama
      _showSnackbar('Profil berhasil dibuat!', Colors.green);
      Navigator.pushReplacementNamed(context, '/profile'); 
      
    } on StorageException catch (e) {
      _showSnackbar('Gagal Unggah Foto: ${e.message}', Colors.red);
    } on PostgrestException catch (e) {
      _showSnackbar('Gagal Simpan Data: ${e.message}', Colors.red);
    } catch (e) {
      _showSnackbar('Error Umum: ${e.toString()}', Colors.red);
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Gradient Background
    const gradientDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF02173A), Color(0xFF032352)],
      ),
    );
    
    return Scaffold(
      body: Container(
        decoration: gradientDecoration,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Title
                    Text('Create Profile', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF00C6FB))),
                    const SizedBox(height: 8),
                    
                    // Welcome Message
                    if (_isGoogleSignUp || _email != null)
                      Text(
                        _isGoogleSignUp ? 'Complete your profile setup' : 'Welcome, ${_email?.split('@')[0] ?? 'User'}!',
                        style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.75)),
                      ),
                    const SizedBox(height: 32),
                    
                    // --- PROFILE PICTURE (IMAGE PICKER) ---
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: colorScheme.primary,
                              backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                              child: _profileImage == null ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
                            ),
                            // Tombol Kamera
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00C6FB),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF02173A), width: 3),
                                ),
                                child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // --- NICKNAME INPUT ---
                    AppTextField(
                      labelText: 'Nickname', hintText: 'Your display name', controller: _nicknameC,
                      validator: (value) => (value == null || value.length < 3) ? 'Nickname must be at least 3 characters' : null,
                    ),
                    
                    if (_isGoogleSignUp)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'From your Google account',
                          style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF00C6FB), fontStyle: FontStyle.italic),
                        ),
                      ),
                      
                    const SizedBox(height: 16),
                    
                    // --- DESCRIPTION INPUT ---
                    AppTextField(
                      labelText: 'Description', hintText: 'Tell us about yourself', controller: _descriptionC, maxLines: 4,
                      validator: (value) => null, // Optional
                    ),
                    const SizedBox(height: 32),
                    
                    // --- NEXT BUTTON (Submit CRUD) ---
                    PrimaryButton(
                      text: 'Next',
                      isLoading: _isSubmitting,
                      onPressed: _isSubmitting ? null : _handleNext,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}