// lib/data/repositories/auth_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:restokin/data/services/auth_service.dart';

/// Repository pattern untuk authentication
/// Memisahkan business logic dari data layer
class AuthRepository {
  final AuthService _authService = AuthService();

  /// Sign in dengan email dan password
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      return response.user;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign up dengan email dan password
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );
      return response.user;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in dengan Google OAuth
  Future<bool> signInWithGoogle() async {
    try {
      return await _authService.signInWithGoogle();
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user
  User? getCurrentUser() {
    return _authService.currentUser;
  }

  /// Stream auth state changes
  Stream<AuthState> get authStateChanges {
    return _authService.authStateChanges;
  }

  /// Check if user is authenticated
  bool get isAuthenticated {
    return _authService.currentUser != null;
  }
}
