// lib/state/profile_provider.dart

import 'package:flutter/material.dart';
import '../data/models/user_profile_model.dart';
import '../data/repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();

  UserProfileModel? _profile;
  bool _isLoading = false;
  String? _error;

  UserProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load user profile
  Future<void> loadProfile(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _repository.getUserProfile(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create profile
  Future<bool> createProfile({
    required int userId,
    required String nickname,
    String? description,
    String? profileImagePath,
    String? role,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Upload image if provided
      String? imageUrl;
      if (profileImagePath != null) {
        imageUrl = await _repository.uploadProfileImage(
          userId.toString(),
          profileImagePath,
        );
      }

      // Create profile
      _profile = await _repository.createProfile(
        userId: userId,
        nickname: nickname,
        description: description,
        profileImageUrl: imageUrl,
        role: role,
      );

      _isLoading = false;
      notifyListeners();
      return _profile != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update profile
  Future<bool> updateProfile({
    required int userId,
    String? nickname,
    String? description,
    String? profileImagePath,
    String? role,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Upload image if provided
      String? imageUrl;
      if (profileImagePath != null) {
        imageUrl = await _repository.uploadProfileImage(
          userId.toString(),
          profileImagePath,
        );
      }

      // Update profile
      final success = await _repository.updateProfile(
        userId: userId,
        nickname: nickname,
        description: description,
        profileImageUrl: imageUrl,
        role: role,
      );

      if (success) {
        // Reload profile
        await loadProfile(userId);
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
