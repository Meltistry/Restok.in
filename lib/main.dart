// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/config/supabase_config.dart';
import 'data/services/supabase_client.dart';
import 'state/auth_provider.dart';
import 'state/store_provider.dart';
import 'state/payment_provider.dart';
import 'state/profile_provider.dart';
import 'state/app_provider.dart'; // Your AppProvider

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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()), // Add your AppProvider here
      ],
      child: const RestokInApp(), // Use RestokInApp (from app.dart)
    ),
  );
}

// Remove MainApp class - it's duplicate and not needed
// Use RestokInApp from app.dart instead