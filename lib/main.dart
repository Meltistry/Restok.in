// lib/main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'data/services/supabase_client.dart';
import 'core/config/supabase_config.dart';
import 'package:provider/provider.dart'; // <--- Tambahkan ini
// ...
import 'state/auth_provider.dart'; // <--- Tambahkan import Provider
import 'state/store_provider.dart'; // <--- Tambahkan import Provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with deep link support
  await SupabaseService.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  // Setup auth state listener for deep link redirect
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final event = data.event;
    if (event == AuthChangeEvent.signedIn) {
      debugPrint('User signed in: ${data.session?.user.email}');
    }
  });
  runApp(
    // Bungkus aplikasi dengan MultiProvider
    MultiProvider(
      providers: [
        // 1. Daftarkan AuthProvider
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // 2. Daftarkan StoreProvider (Ini yang hilang dan menyebabkan error!)
        ChangeNotifierProvider(create: (_) => StoreProvider()),
      ],
      child: const RestokInApp(), // Aplikasi utama Anda
    ),
  );

  // runApp(const RestokInApp());
}

final supabase = Supabase.instance.client;
