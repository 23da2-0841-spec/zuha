import 'package:flutter/material.dart';
import 'dart:async';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../services/firestore_service.dart';

class CartProvider extends ChangeNotifier {
  final List<ZCartItem> _items = [];
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription? _cartSubscription;

  List<ZCartItem> get items => _items;
  String? _lastUserId;

  void ensureInitialized(String userId) {
    if (_lastUserId != userId) {
      _lastUserId = userId;
      _init(userId);
    }
  }

  void _init(String userId) {
    _cartSubscription?.cancel();
    _cartSubscription = _firestoreService.getCart(userId).listen((cartItems) {
      _items
        ..clear()
        ..addAll(cartItems);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    super.dispose();
  }

  Future<void> addItem(ZProduct product, String size, String color,
      {int quantity = 1}) async {
    final userId = _lastUserId;
    if (userId == null) return;
    final item = ZCartItem(
      product: product,
      selectedSize: size,
      selectedColor: color,
      quantity: quantity,
    );
    await _firestoreService.addToCart(userId, item);
  }

  Future<void> removeItem(String docId) async {
    final userId = _lastUserId;
    if (userId == null || docId.isEmpty) return;
    await _firestoreService.removeFromCart(userId, docId);
  }

  Future<void> updateQuantity(String docId, int qty) async {
    final userId = _lastUserId;
    if (userId == null || docId.isEmpty) return;
    await _firestoreService.updateCartItemQuantity(userId, docId, qty);
  }

  Future<void> clearCart() async {
    final userId = _lastUserId;
    if (userId == null) return;
    await _firestoreService.clearCart(userId);
  }

  double get subtotal {
    return _items.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  double get total {
    final shipping = subtotal > 0 ? 500.0 : 0.0;
    return subtotal + shipping;
  }

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }
}
