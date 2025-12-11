// lib/features/auth/login_page.dart
import 'package:flutter/material.dart';
import 'package:restokin/core/widgets/primary_button.dart';
import 'package:restokin/core/widgets/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isSubmitting = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login berhasil (dummy). Implement auth!')),
    );
    // Navigator.pushReplacementNamed(context, '/home');
  }

  void _goToRegister() {
    // Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ReStok.in',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome back 👋',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to manage your stores and restock invoices.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: .75),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    labelText: 'Email',
                    hintText: 'Enter your email',
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
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    controller: _passwordC,
                    obscureText: _obscure,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: colorScheme.onSurface.withValues(alpha: .7),
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
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                      },
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Login',
                    isLoading: _isSubmitting,
                    onPressed: _isSubmitting ? null : _handleLogin,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: theme.textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: _goToRegister,
                        child: Text(
                          'Sign up',
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
    );
  }
}
