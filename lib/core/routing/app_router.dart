// lib/core/routing/app_router.dart
import 'package:flutter/material.dart';
import 'package:restokin/features/auth/login_page.dart';
import 'package:restokin/features/auth/register_page.dart';
import 'package:restokin/features/profile/create_profile_page.dart';
import 'package:restokin/features/store_owner/my_store_page.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String createProfile = '/create-profile';
  static const String home = '/home';
  static const String roleSelection = '/role-selection';
  static const String myStore = '/my-store';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case createProfile:
        return MaterialPageRoute(
          builder: (_) => const CreateProfilePage(),
          settings: settings,
        );

      case myStore:
        // Implement MyStorePage route
        return MaterialPageRoute(
          builder: (_) => const MyStorePage(),
          settings: settings,
        );

      // Add more routes here as features are developed
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    createProfile: (context) => const CreateProfilePage(),
    myStore: (context) => const MyStorePage(),
  };
}
