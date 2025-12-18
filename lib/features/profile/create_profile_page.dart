// lib/features/profile/create_profile_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:restokin/core/widgets/primary_button.dart';
import 'package:restokin/core/widgets/text_field.dart';
import '../../state/profile_provider.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _nicknameC = TextEditingController();
  final _descriptionC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _profileImage;
  String? _email;
  bool _isGoogleSignUp = false;
  bool _isLoading = true;
  bool _hasExistingProfile = false;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    final authUser = Supabase.instance.client.auth.currentUser;
    if (authUser == null) return;

    try {
      final userResponse = await Supabase.instance.client
          .from('users')
          .select('nickname, description, profile_image_url')
          .eq('email', authUser.email!)
          .maybeSingle();

      if (!mounted) return;

      if (userResponse != null && userResponse['nickname'] != null) {
        setState(() {
          _nicknameC.text = userResponse['nickname'] ?? '';
          _descriptionC.text = userResponse['description'] ?? '';
          _hasExistingProfile = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

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
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleNext() async {
    if (!_formKey.currentState!.validate()) return;

    // Get current authenticated user
    final authUser = Supabase.instance.client.auth.currentUser;
    if (authUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not authenticated'), backgroundColor: Colors.red),
      );
      return;
    }

    // Get id_user from public.users table using email (simpler than UUID)
    final userResponse = await Supabase.instance.client
        .from('users')
        .select('id_user')
        .eq('email', authUser.email!)
        .maybeSingle();

    if (!mounted) return;

    if (userResponse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not found: ${authUser.email}'), backgroundColor: Colors.red),
      );
      return;
    }

    final userId = userResponse['id_user'] as int;

    final profileProvider = context.read<ProfileProvider>();
    
    final success = await profileProvider.createProfile(
      userId: userId,
      nickname: _nicknameC.text.trim(),
      description: _descriptionC.text.trim().isEmpty 
          ? null 
          : _descriptionC.text.trim(),
      profileImagePath: _profileImage?.path,
    );

    if (!mounted) return;

    if (success) {
      // Navigate to payment method selection
      Navigator.pushNamed(context, '/select-payment');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(profileProvider.error ?? 'Failed to create profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
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
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF00C6FB),
                  ),
                )
              : Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      _hasExistingProfile ? 'Your Profile' : 'Create Profile',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00C6FB),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_hasExistingProfile)
                      Text(
                        'You can update your profile or skip to continue',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.75),
                        ),
                      ),
                    if (!_hasExistingProfile && _isGoogleSignUp)
                      Text(
                        'Complete your profile setup',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.75),
                        ),
                      ),
                    if (!_hasExistingProfile && !_isGoogleSignUp && _email != null)
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
                    Consumer<ProfileProvider>(
                      builder: (context, profileProvider, child) {
                        return Column(
                          children: [
                            PrimaryButton(
                              text: _hasExistingProfile ? 'Update Profile' : 'Next',
                              isLoading: profileProvider.isLoading,
                              onPressed: profileProvider.isLoading ? null : _handleNext,
                            ),
                            if (_hasExistingProfile) ...[
                              const SizedBox(height: 12),
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/role-selection');
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF00C6FB),
                                  side: const BorderSide(color: Color(0xFF00C6FB)),
                                  minimumSize: const Size(double.infinity, 56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Skip to Role Selection',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
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