// lib/state/app_provider.dart

import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/models/store_model.dart';
import '../data/models/invoice_model.dart';
import '../data/models/payment_model.dart';
import '../data/models/cart_model.dart';

class AppProvider extends ChangeNotifier {
  // ==================== USER STATE ====================
  
  // Current active user
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // User role (store_owner, restocker, admin, etc.)
  String _userRole = '';
  String get userRole => _userRole;

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  // Set current user
  void setCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  // Set user role
  void setUserRole(String role) {
    _userRole = role;
    notifyListeners();
  }

  // Update user profile
  void updateUserProfile(UserModel updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }

  // Logout
  void logout() {
    _currentUser = null;
    _userRole = '';
    _currentStore = null;
    _invoices.clear();
    _payments.clear();
    _carts.clear();
    notifyListeners();
  }

  // ==================== STORE STATE ====================
  
  // Current active store (for store owners)
  StoreModel? _currentStore;
  StoreModel? get currentStore => _currentStore;

  // List of user's stores
  List<StoreModel> _userStores = [];
  List<StoreModel> get userStores => _userStores;

  // Set current store
  void setCurrentStore(StoreModel store) {
    _currentStore = store;
    notifyListeners();
  }

  // Load user stores
  void loadUserStores(List<StoreModel> stores) {
    _userStores = stores;
    if (stores.isNotEmpty && _currentStore == null) {
      _currentStore = stores.first;
    }
    notifyListeners();
  }

  // Add new store
  void addStore(StoreModel store) {
    _userStores.add(store);
    notifyListeners();
  }

  // ==================== INVOICE STATE ====================
  
  // All invoices
  List<InvoiceModel> _invoices = [];
  List<InvoiceModel> get invoices => _invoices;

  // Load invoices
  void loadInvoices(List<InvoiceModel> invoices) {
    _invoices = invoices;
    notifyListeners();
  }

  // Add new invoice
  void addInvoice(InvoiceModel invoice) {
    _invoices.add(invoice);
    notifyListeners();
  }

  // Update invoice status
  void updateInvoiceStatus(int idInvoice, String newStatus) {
    final index = _invoices.indexWhere((inv) => inv.idInvoice == idInvoice);
    if (index != -1) {
      _invoices[index] = _invoices[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  // Get invoices by status
  List<InvoiceModel> getInvoicesByStatus(String status) {
    return _invoices.where((invoice) => invoice.status.toLowerCase() == status.toLowerCase()).toList();
  }

  // Get pending invoices
  List<InvoiceModel> get pendingInvoices {
    return _invoices.where((invoice) => invoice.isPending).toList();
  }

  // Get paid invoices
  List<InvoiceModel> get paidInvoices {
    return _invoices.where((invoice) => invoice.isPaid).toList();
  }

  // Get incoming invoices (where current user is store owner)
  List<InvoiceModel> get incomingInvoices {
    if (_currentUser == null) return [];
    return _invoices.where((invoice) => invoice.idStoreOwner == _currentUser!.idUser).toList();
  }

  // Get outgoing invoices (where current user is restocker)
  List<InvoiceModel> get outgoingInvoices {
    if (_currentUser == null) return [];
    return _invoices.where((invoice) => invoice.idRestocker == _currentUser!.idUser).toList();
  }

  // ==================== PAYMENT STATE ====================
  
  // All payments
  List<PaymentModel> _payments = [];
  List<PaymentModel> get payments => _payments;

  // Load payments
  void loadPayments(List<PaymentModel> payments) {
    _payments = payments;
    notifyListeners();
  }

  // Add new payment
  void addPayment(PaymentModel payment) {
    _payments.add(payment);
    notifyListeners();
  }

  // Get payments by invoice
  List<PaymentModel> getPaymentsByInvoice(int idInvoice) {
    return _payments.where((payment) => payment.idInvoice == idInvoice).toList();
  }

  // Get successful payments
  List<PaymentModel> get successfulPayments {
    return _payments.where((payment) => payment.isSuccess).toList();
  }

  // ==================== CART STATE ====================
  
  // All carts
  List<CartModel> _carts = [];
  List<CartModel> get carts => _carts;

  // Current active cart
  CartModel? _activeCart;
  CartModel? get activeCart => _activeCart;

  // Load carts
  void loadCarts(List<CartModel> carts) {
    _carts = carts;
    notifyListeners();
  }

  // Set active cart
  void setActiveCart(CartModel cart) {
    _activeCart = cart;
    notifyListeners();
  }

  // Add cart
  void addCart(CartModel cart) {
    _carts.add(cart);
    notifyListeners();
  }

  // ==================== RECENT ACTIVITIES ====================
  
  // Get recent activities (combined from invoices and payments)
  List<Map<String, dynamic>> getRecentActivities({int limit = 10}) {
    List<Map<String, dynamic>> activities = [];

    // Add invoice activities
    for (var invoice in _invoices) {
      activities.add({
        'type': 'invoice',
        'data': invoice,
        'date': invoice.invoiceDate,
        'description': 'Invoice #${invoice.idInvoice}',
      });
    }

    // Add payment activities
    for (var payment in _payments) {
      activities.add({
        'type': 'payment',
        'data': payment,
        'date': payment.paymentDate,
        'description': 'Payment #${payment.idPayment}',
      });
    }

    // Sort by date (newest first)
    activities.sort((a, b) => b['date'].compareTo(a['date']));

    // Return limited number of activities
    return activities.take(limit).toList();
  }

  // ==================== HELPER METHODS ====================
  
  // Check if user is store owner
  bool get isStoreOwner => _userRole.toLowerCase() == 'store_owner';

  // Check if user is restocker
  bool get isRestocker => _userRole.toLowerCase() == 'restocker';

  // Get total pending amount (for store owners)
  int get totalPendingAmount {
    return pendingInvoices.fold(0, (sum, invoice) => sum + invoice.totalAmount);
  }

  // Get total paid amount
  int get totalPaidAmount {
    return paidInvoices.fold(0, (sum, invoice) => sum + invoice.totalAmount);
  }

  // Format currency
  String formatCurrency(int amount) {
    return 'Rp${amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  // Clear all data
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