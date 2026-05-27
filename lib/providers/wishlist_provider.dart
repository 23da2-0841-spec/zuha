import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  final List<String> _productIds = [];

  List<String> get productIds => _productIds;

  void toggle(String productId) {
    if (_productIds.contains(productId)) {
      _productIds.remove(productId);
    } else {
      _productIds.add(productId);
    }
    notifyListeners();
  }

  bool isWishlisted(String productId) {
    return _productIds.contains(productId);
  }
}
