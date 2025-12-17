// lib/app.dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/profile/create_profile_page.dart';
import 'features/payment/select_payment_page.dart';
import 'features/payment/input_payment_page.dart';
import 'features/payment/payment_success_page.dart';
import 'features/role/role_selection_page.dart';
import 'features/store_owner/my_store_page.dart';

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
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/create-profile': (_) => const CreateProfilePage(),
        '/select-payment': (_) => const SelectPaymentPage(),
        '/input-payment': (_) => const InputPaymentPage(),
        '/payment-success': (_) => const PaymentSuccessPage(),
        '/role-selection': (_) => const RoleSelectionPage(),
        '/my-store': (_) => const MyStorePage(),
      },
    );
  }
}
