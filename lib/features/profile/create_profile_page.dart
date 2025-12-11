// lib/features/profile/create_profile_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restokin/core/widgets/primary_button.dart';
import 'package:restokin/core/widgets/text_field.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _nicknameC = TextEditingController();
  final _descriptionC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;
  File? _profileImage;
  String? _email;
  bool _isGoogleSignUp = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get data from register or Google sign up
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['username'] != null && _nicknameC.text.isEmpty) {
        _nicknameC.text = args['username'];
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

  Future<void> _pickImage() async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image picker akan diimplementasi. Install image_picker package.'),
      ),
    );
  }

  Future<void> _handleNext() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isSubmitting = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile created! (dummy)')),
    );
    // Navigator.pushReplacementNamed(context, '/role-selection');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF02173A), // navy
              Color(0xFF032352), // darker navy
            ],
          ),
        ),
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
                    Text(
                      'Create Profile',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00C6FB),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_isGoogleSignUp)
                      Text(
                        'Complete your profile setup',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.75),
                        ),
                      ),
                    if (!_isGoogleSignUp && _email != null)
                      Text(
                        'Welcome, ${_email?.split('@')[0] ?? 'User'}!',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.75),
                        ),
                      ),
                    const SizedBox(height: 32),
                    // Profile Picture
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: colorScheme.primary,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : null,
                              child: _profileImage == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00C6FB),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF02173A),
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppTextField(
                      labelText: 'Nickname',
                      hintText: 'Your display name',
                      controller: _nicknameC,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nickname is required';
                        }
                        if (value.length < 3) {
                          return 'Nickname must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    if (_isGoogleSignUp)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'From your Google account',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF00C6FB),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    AppTextField(
                      labelText: 'Description',
                      hintText: 'Tell us about yourself',
                      controller: _descriptionC,
                      maxLines: 4,
                      validator: (value) {
                        // Description is optional
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
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