// lib/app.dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/profile/create_profile_page.dart';

//profileScreens
import 'profileScreens/profilepage.dart';
import 'profileScreens/editprofilepage.dart';
import 'profileScreens/changepasswordpage.dart';
import 'profileScreens/paymentmethodspage.dart';

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
      initialRoute: '/profile',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/create-profile': (_) => const CreateProfilePage(),

        //profileScreens
        '/profile': (_) => const ProfilePage(), 
        '/profile/edit': (_) => const EditProfilePage(),
        '/profile/changepassword': (_) => const ChangePasswordPage(),
        '/profile/paymentmethods': (_) => const PaymentMethodsPage(),
      },
    );
  }
}
