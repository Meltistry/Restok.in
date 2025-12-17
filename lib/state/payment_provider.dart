// lib/state/payment_provider.dart

import 'package:flutter/material.dart';
import '../data/models/payment_method_model.dart';
import '../data/repositories/payment_repository.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentRepository _repository = PaymentRepository();

  List<PaymentMethodModel> _paymentMethods = [];
  bool _isLoading = false;
  String? _error;

  List<PaymentMethodModel> get paymentMethods => _paymentMethods;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load user payment methods
  Future<void> loadPaymentMethods(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _paymentMethods = await _repository.getUserPaymentMethods(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add payment method
  Future<bool> addPaymentMethod({
    required int userId,
    required String paymentType,
    required String accountNumber,
    required String accountName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final paymentMethod = await _repository.createPaymentMethod(
        userId: userId,
        paymentType: paymentType,
        accountNumber: accountNumber,
        accountName: accountName,
      );

      if (paymentMethod != null) {
        _paymentMethods.insert(0, paymentMethod);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to create payment method';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update payment method
  Future<bool> updatePaymentMethod({
    required int paymentMethodId,
    String? accountNumber,
    String? accountName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _repository.updatePaymentMethod(
        paymentMethodId: paymentMethodId,
        accountNumber: accountNumber,
        accountName: accountName,
      );

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete payment method
  Future<bool> deletePaymentMethod(int paymentMethodId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _repository.deletePaymentMethod(paymentMethodId);

      if (success) {
        _paymentMethods.removeWhere((pm) => pm.id == paymentMethodId);
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
