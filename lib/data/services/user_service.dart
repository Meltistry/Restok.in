// lib/data/services/user_service.dart

import 'dart:io';
import 'package:flutter/foundation.dart'; // ✅ Perbaikan Error debugPrint
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:restokin/data/models/user_model.dart';
import 'supabase_client.dart';

class ProfileService {
  final SupabaseClient _supabase = SupabaseService.instance;

  // ----------------------------------------------------
  // UPLOAD AVATAR
  // ----------------------------------------------------
  Future<String> uploadProfilePicture(File file, String email) async {
    final fileExtension = file.path.split('.').last;
    // Menggunakan user ID sebagai nama file untuk menimpa file lama
    final fileName = 'avatar/$email.$fileExtension'; 
    
    try {
      // Upload file ke Supabase Storage (Bucket 'avatars')
      await _supabase.storage.from('avatars').upload(
            fileName,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      // Dapatkan URL publik
      final publicUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);
      return publicUrl;
    } on StorageException catch (e) {
      debugPrint('Storage Upload Error: ${e.message}');
      rethrow;
    }
  }

  // ----------------------------------------------------
  // CREATE/UPDATE PROFILE (CRUD - C dan U)
  // ----------------------------------------------------
  Future<void> updateOrCreateProfile({
    required String userId,
    required String nickname,
    required String description,
    required String email,
    required String username,
    String? profilePic, // Nama sesuai kolom DB
  }) async {
    try {
      // Data yang akan di-update atau di-insert
      final dataToSave = {
        'nickname': nickname,
        'description': description,
        'profile_image_url': profilePic, // Menggunakan nama kolom DB
      };
      
      // Update/Insert data di tabel 'users' menggunakan id_user
      await _supabase.from('users')
          .update(dataToSave)
          .eq('email', email); 
      
    } on PostgrestException catch (e) {
      debugPrint('Database Update Profile Error: ${e.message}');
      rethrow;
    }
  }

  // ----------------------------------------------------
  // READ PROFILE (CRUD - R)
  // ----------------------------------------------------
  Future<UserProfile?> fetchProfile(String email) async { // Gunakan email sebagai pencari
    try {
      final response = await _supabase
          .from('users')
          .select('id_user, email, username, nickname, description, profile_image_url')
          .eq('email', email) // Cari berdasarkan email yang bertipe String/Varchar
          .maybeSingle();

      if (response == null) return null;
      return UserProfile.fromMap(response);
    } catch (e) {
      debugPrint('Error fetchProfile: $e');
      rethrow;
    }
  }
}