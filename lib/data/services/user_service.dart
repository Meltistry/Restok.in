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
  Future<String> uploadProfilePicture(File file, String userId) async {
    final fileExtension = file.path.split('.').last;
    // Menggunakan user ID sebagai nama file untuk menimpa file lama
    final fileName = 'avatar/$userId.$fileExtension'; 
    
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
        'email': email,
        'username': username,
        'profilepic': profilePic, // Menggunakan nama kolom DB
      };
      
      // Update/Insert data di tabel 'users' menggunakan id_user
      await _supabase.from('users')
          .update(dataToSave)
          .eq('id_user', userId); 
      
    } on PostgrestException catch (e) {
      debugPrint('Database Update Profile Error: ${e.message}');
      rethrow;
    }
  }

  // ----------------------------------------------------
  // READ PROFILE (CRUD - R)
  // ----------------------------------------------------
  Future<UserProfile?> fetchProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select('id_user, email, username, nickname, description, profilepic') // Pilih semua kolom
          .eq('id_user', userId)
          .single();

      // Konversi Map respons ke objek UserProfile
      return UserProfile.fromMap(response);

    } on PostgrestException catch (e) {
      // Error 406 (PGRST116) berarti data tidak ditemukan (misal: user baru belum buat profil)
      if (e.code == 'PGRST116' || e.message.contains('rows found')) {
        return null;
      }
      debugPrint('Error fetchProfile: ${e.message}');
      rethrow;
    }
  }
}