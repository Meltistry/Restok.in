// lib/data/repositories/profile_repository.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile_model.dart';

class ProfileRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Create user profile
  Future<UserProfileModel?> createProfile({
    required int userId,
    required String nickname,
    String? description,
    String? profileImageUrl,
    String? role,
  }) async {
    try {
      final data = {
        'nickname': nickname,
        if (description != null) 'description': description,
        if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
        if (role != null) 'role': role,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('users')
          .update(data)
          .eq('id_user', userId)
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      debugPrint('Error creating profile: $e');
      return null;
    }
  }

  /// Get user profile
  Future<UserProfileModel?> getUserProfile(int userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id_user', userId)
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      return null;
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    required int userId,
    String? nickname,
    String? description,
    String? profileImageUrl,
    String? role,
  }) async {
    try {
      final data = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (nickname != null) data['nickname'] = nickname;
      if (description != null) data['description'] = description;
      if (profileImageUrl != null) data['profile_image_url'] = profileImageUrl;
      if (role != null) data['role'] = role;

      await _supabase
          .from('users')
          .update(data)
          .eq('id_user', userId);

      return true;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }

  /// Upload profile image to Supabase Storage
  Future<String?> uploadProfileImage(String userId, String filePath) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'profile_${userId}_$timestamp.jpg';
      
      // Read file as bytes immediately to prevent deletion
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      
      await _supabase.storage
          .from('profile-images')
          .uploadBinary(fileName, bytes);

      final imageUrl = _supabase.storage
          .from('profile-images')
          .getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading profile image: $e');
      return null;
    }
  }
}
