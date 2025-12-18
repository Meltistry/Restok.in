// lib/app.dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/profile/create_profile_page.dart';

//profile
import 'features/profile/profile_menu_page.dart';
import 'features/profile/edit_profile_page.dart';
import 'features/profile/change_password_page.dart';
import 'features/profile/payment_methods_page.dart';
import 'features/profile/add_payment_method_page.dart';
import 'features/payment/select_payment_page.dart';
import 'features/payment/input_payment_page.dart';
import 'features/payment/payment_success_page.dart';
import 'features/role/role_selection_page.dart';
import 'features/store_owner/my_store_page.dart';
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
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/create-profile': (_) => const CreateProfilePage(),

        //profileScreens
        '/profile': (_) => const ProfilePage(), 
        '/profile/edit': (_) => const EditProfilePage(),
        '/profile/changepassword': (_) => const ChangePasswordPage(),
        '/profile/paymentmethods': (_) => const PaymentMethodsPage(),
        '/payment/add': (context) => const AddPaymentMethodPage(),
        '/select-payment': (_) => const SelectPaymentPage(),
        '/input-payment': (_) => const InputPaymentPage(),
        '/payment-success': (_) => const PaymentSuccessPage(),
        '/role-selection': (_) => const RoleSelectionPage(),
        '/my-store': (_) => const MyStorePage(),
         '/browse-stores': (_) => const StoresListPage(),
      },
    );
  }
}
