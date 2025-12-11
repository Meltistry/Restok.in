// lib/data/services/supabase_client.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();
  
  static SupabaseClient? _instance;
  
  static SupabaseClient get instance {
    if (_instance == null) {
      throw Exception(
        'Supabase belum diinisialisasi. Panggil SupabaseService.initialize() di main.dart'
      );
    }
    return _instance!;
  }
  
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
    _instance = Supabase.instance.client;
  }
}
