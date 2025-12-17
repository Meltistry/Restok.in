import 'package:flutter/material.dart';

import '../data/models/user_model.dart';
import '../data/models/store_model.dart';
import '../data/models/invoice_model.dart';
import '../data/models/payment_model.dart';
import '../data/models/cart_model.dart';

class AppProvider extends ChangeNotifier {
  // ==================== USER STATE ====================

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  String _userRole = '';
  String get userRole => _userRole;

  bool get isLoggedIn => _currentUser != null;

  void setCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void setUserRole(String role) {
    _userRole = role;
    notifyListeners();
  }

  void updateUserProfile(UserModel updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _userRole = '';
    _currentStore = null;
    _userStores.clear();
    _invoices.clear();
    _payments.clear();
    _carts.clear();
    _activeCart = null;
    notifyListeners();
  }

  // ==================== STORE STATE ====================

  StoreModel? _currentStore;
  StoreModel? get currentStore => _currentStore;

  final List<StoreModel> _userStores = [];
  List<StoreModel> get userStores => _userStores;

  void setCurrentStore(StoreModel store) {
    _currentStore = store;
    notifyListeners();
  }

  void loadUserStores(List<StoreModel> stores) {
    _userStores
      ..clear()
      ..addAll(stores);

    if (_currentStore == null && stores.isNotEmpty) {
      _currentStore = stores.first;
    }
    notifyListeners();
  }

  void addStore(StoreModel store) {
    _userStores.add(store);
    notifyListeners();
  }

  // ==================== INVOICE STATE ====================

  final List<InvoiceModel> _invoices = [];
  List<InvoiceModel> get invoices => _invoices;

  void loadInvoices(List<InvoiceModel> invoices) {
    _invoices
      ..clear()
      ..addAll(invoices);
    notifyListeners();
  }

  void addInvoice(InvoiceModel invoice) {
    _invoices.add(invoice);
    notifyListeners();
  }

  /// Update payment status using invoiceNumber
  void updateInvoiceStatus(String invoiceNumber, String newStatus) {
    final index = _invoices.indexWhere(
      (inv) => inv.invoiceNumber == invoiceNumber,
    );

    if (index != -1) {
      _invoices[index].paymentStatus = newStatus;
      notifyListeners();
    }
  }

  List<InvoiceModel> get pendingInvoices {
    return _invoices
        .where(
          (inv) => inv.paymentStatus.toLowerCase() == 'pending',
        )
        .toList();
  }

  List<InvoiceModel> get paidInvoices {
    return _invoices
        .where(
          (inv) => inv.paymentStatus.toLowerCase() == 'paid',
        )
        .toList();
  }

  // ==================== PAYMENT STATE ====================

  final List<PaymentModel> _payments = [];
  List<PaymentModel> get payments => _payments;

  void loadPayments(List<PaymentModel> payments) {
    _payments
      ..clear()
      ..addAll(payments);
    notifyListeners();
  }

  void addPayment(PaymentModel payment) {
    _payments.add(payment);
    notifyListeners();
  }

  List<PaymentModel> get successfulPayments {
    return _payments.where((p) => p.isSuccess).toList();
  }

  // ==================== CART STATE ====================

  final List<CartModel> _carts = [];
  List<CartModel> get carts => _carts;

  CartModel? _activeCart;
  CartModel? get activeCart => _activeCart;

  void loadCarts(List<CartModel> carts) {
    _carts
      ..clear()
      ..addAll(carts);
    notifyListeners();
  }

  void setActiveCart(CartModel cart) {
    _activeCart = cart;
    notifyListeners();
  }

  void addCart(CartModel cart) {
    _carts.add(cart);
    notifyListeners();
  }

  // ==================== RECENT ACTIVITIES ====================

  List<Map<String, dynamic>> getRecentActivities({int limit = 10}) {
    final List<Map<String, dynamic>> activities = [];

    for (final invoice in _invoices) {
      activities.add({
        'type': 'invoice',
        'data': invoice,
        'date': DateTime.tryParse(invoice.date) ?? DateTime.now(),
        'description': 'Invoice ${invoice.invoiceNumber}',
      });
    }

    for (final payment in _payments) {
      activities.add({
        'type': 'payment',
        'data': payment,
        'date': payment.paymentDate,
        'description': 'Payment ${payment.idPayment}',
      });
    }

    activities.sort(
      (a, b) => b['date'].compareTo(a['date']),
    );

    return activities.take(limit).toList();
  }

  // ==================== TOTALS & HELPERS ====================

  int get totalPendingAmount {
    return pendingInvoices.fold(
      0,
      (sum, inv) => sum + inv.totalAmount.toInt(),
    );
  }

  int get totalPaidAmount {
    return paidInvoices.fold(
      0,
      (sum, inv) => sum + inv.totalAmount.toInt(),
    );
  }

  bool get isStoreOwner => _userRole.toLowerCase() == 'store_owner';
  bool get isRestocker => _userRole.toLowerCase() == 'restocker';

  String formatCurrency(int amount) {
    return 'Rp${amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}';
  }

  void clearAllData() {
    _currentUser = null;
    _userRole = '';
    _currentStore = null;
    _userStores.clear();
    _invoices.clear();
    _payments.clear();
    _carts.clear();
    _activeCart = null;
    notifyListeners();
  }
}
