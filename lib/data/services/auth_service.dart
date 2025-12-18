// lib/data/services/auth_service.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseService.instance;

  // Email/Password Login
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Email/Password Register
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.restokin://login-callback',
      );
      return true;
    } catch (e) {
      debugPrint('Google Sign In Error: $e');
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Auth state stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<void> changePassword({
    required String currentEmail,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      // 1. Verifikasi Password Lama dengan cara mencoba login ulang (Re-authentication)
      // Ini memastikan orang yang mengganti password benar-benar pemilik akun
      await _supabase.auth.signInWithPassword(
        email: currentEmail,
        password: oldPassword,
      );

      // 2. Jika login berhasil, update password baru
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      
    } on AuthException catch (e) {
      // Tangkap error spesifik dari Supabase
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Gagal mengganti password: $e');
    }
  }
}
