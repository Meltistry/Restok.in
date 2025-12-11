// lib/app.dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_page.dart';

//store
import 'features/browse_store/stores_list_page.dart';

class RestokInApp extends StatelessWidget {
  const RestokInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReStok.in',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const LoginPage(),
      routes: {

        //store
        '/stores': (_) => const StoresListPage(),
      }
    );
  }
}
