// lib/app.dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';

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

      initialRoute: AppRouter.login,
      onGenerateRoute: AppRouter.generateRoute,
      routes: AppRouter.routes,
    );
  }
}
