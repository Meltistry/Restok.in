// lib/features/auth/register_page.dart
import 'package:flutter/material.dart';
import 'package:restokin/core/widgets/primary_button.dart';
import 'package:restokin/core/widgets/text_field.dart';
import 'package:restokin/data/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailC = TextEditingController();
  final _usernameC = TextEditingController();
  final _passwordC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailC.dispose();
    _usernameC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    
    try {
      // Actual registration with Supabase
      final authService = AuthService();
      final response = await authService.signUpWithEmail(
        email: _emailC.text.trim(),
        password: _passwordC.text,
      );

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      if (response.user != null) {
        // Check if user session is active (email confirmation may be required)
        if (response.session != null) {
          // Session active, user is authenticated - navigate to create profile
          Navigator.pushNamed(
            context,
            '/create-profile',
            arguments: {
              'username': _usernameC.text.trim(),
              'email': _emailC.text.trim(),
            },
          );
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful! Please complete your profile.')),
          );
        } else {
          // Session not active - email confirmation required
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Please check your email to confirm your account, then login.'),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Go back to login page
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _goToLogin() {
    Navigator.pop(context);
  }

  Future<void> _handleGoogleSignUp() async {
    try {
      setState(() => _isSubmitting = true);
      
      // Implementasi Google Sign Up
      final authService = AuthService();
      final success = await authService.signInWithGoogle();
      
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      
      if (success) {
        // Get user info and navigate to create profile
        final user = authService.currentUser;
        if (user != null) {
          Navigator.pushNamed(
            context,
            '/create-profile',
            arguments: {
              'email': user.email ?? '',
              'username': user.userMetadata?['name'] ?? user.email?.split('@')[0] ?? '',
              'isGoogleSignUp': true,
            },
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google Sign Up gagal atau dibatalkan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
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
                    // Logo centered
                    Center(
                      child: Image.asset(
                        'assets/icons/Logo ReStock.in.png',
                        height: 140,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.store,
                          size: 100,
                          color: Color(0xFF008B8B),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Create Account 🚀',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign up to start managing your stores and invoices.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppTextField(
                      labelText: 'Email',
                      hintText: 'example@email.com',
                      controller: _emailC,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      labelText: 'Username',
                      hintText: 'Choose a username',
                      controller: _usernameC,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Username is required';
                        }
                        if (value.length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      labelText: 'Password',
                      hintText: 'At least 6 characters',
                      controller: _passwordC,
                      obscureText: _obscure,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() => _obscure = !_obscure);
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      text: 'Register',
                      isLoading: _isSubmitting,
                      onPressed: _isSubmitting ? null : _handleRegister,
                    ),
                    const SizedBox(height: 24),
                    // Divider with "Or"
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Colors.white38,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Colors.white38,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Google Sign Up Button
                    OutlinedButton.icon(
                      onPressed: _handleGoogleSignUp,
                      icon: Image.asset(
                        'assets/icons/Logo Google.png',
                        height: 24,
                        width: 24,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.g_mobiledata,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      label: const Text('Sign up with Google'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white38, width: 1.5),
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        textStyle: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: _goToLogin,
                          child: Text(
                            'Login',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
