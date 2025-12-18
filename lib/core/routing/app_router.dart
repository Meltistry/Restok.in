// lib/core/routing/app_router.dart
import 'package:flutter/material.dart';

import 'package:restokin/features/auth/login_page.dart';
import 'package:restokin/features/auth/register_page.dart';
import 'package:restokin/features/profile/create_profile_page.dart';
import 'package:restokin/features/payment/select_payment_page.dart';
import 'package:restokin/features/payment/input_payment_page.dart';
import 'package:restokin/features/payment/payment_success_page.dart';
import 'package:restokin/features/role/role_selection_page.dart';
import 'package:restokin/features/store_owner/my_store_page.dart';
import 'package:restokin/features/home/home_page.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String createProfile = '/create-profile';
  static const String selectPayment = '/select-payment';
  static const String inputPayment = '/input-payment';
  static const String paymentSuccess = '/payment-success';
  static const String roleSelection = '/role-selection';
  static const String home = '/home';
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

      case selectPayment:
        return MaterialPageRoute(builder: (_) => const SelectPaymentPage());

      case inputPayment:
        return MaterialPageRoute(
          builder: (_) => const InputPaymentPage(),
          settings: settings,
        );

      case paymentSuccess:
        return MaterialPageRoute(builder: (_) => const PaymentSuccessPage());

      case roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionPage());

      case myStore:
        return MaterialPageRoute(builder: (_) => const MyStorePage());

      case home: // ✅ FIX
        return MaterialPageRoute(builder: (_) => const HomePage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginPage(),
        register: (_) => const RegisterPage(),
        createProfile: (_) => const CreateProfilePage(),
        selectPayment: (_) => const SelectPaymentPage(),
        inputPayment: (_) => const InputPaymentPage(),
        paymentSuccess: (_) => const PaymentSuccessPage(),
        roleSelection: (_) => const RoleSelectionPage(),
        myStore: (_) => const MyStorePage(),
        home: (_) => const HomePage(), // ✅ FIX
      };
}
