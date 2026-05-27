import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/user.dart';
import '../models/address.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── Products ────────────────────────────────────────────────────────

  Stream<List<ZProduct>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => ZProduct.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<ZProduct?> getProductOnce(String id) async {
    final doc = await _db.collection('products').doc(id).get();
    if (!doc.exists) return null;
    return ZProduct.fromFirestore(doc.data()!, doc.id);
  }

  // ─── Cart ────────────────────────────────────────────────────────────

  Stream<List<ZCartItem>> getCart(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots()
        .asyncMap((snapshot) async {
      final items = <ZCartItem>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final productId = data['productId'] as String? ?? '';
        if (productId.isEmpty) continue;
        final productDoc =
            await _db.collection('products').doc(productId).get();
        if (!productDoc.exists) continue;
        final product =
            ZProduct.fromFirestore(productDoc.data()!, productDoc.id);
        items.add(ZCartItem.fromFirestore(data, product, docId: doc.id));
      }
      return items;
    });
  }

  Future<void> addToCart(String userId, ZCartItem item) async {
    final cartRef = _db
        .collection('users')
        .doc(userId)
        .collection('cart');
    final existing = await cartRef
        .where('productId', isEqualTo: item.product.id)
        .where('selectedSize', isEqualTo: item.selectedSize)
        .where('selectedColor', isEqualTo: item.selectedColor)
        .get();

    if (existing.docs.isNotEmpty) {
      final existingDoc = existing.docs.first;
      final currentQty = (existingDoc.data()['quantity'] as int?) ?? 0;
      await existingDoc.reference
          .update({'quantity': currentQty + item.quantity});
    } else {
      await cartRef.add(item.toMap());
    }
  }

  Future<void> removeFromCart(String userId, String cartDocId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(cartDocId)
        .delete();
  }

  Future<void> updateCartItemQuantity(
      String userId, String cartDocId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(userId, cartDocId);
    } else {
      await _db
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartDocId)
          .update({'quantity': quantity});
    }
  }

  Future<void> clearCart(String userId) async {
    final cartDocs = await _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();
    for (final doc in cartDocs.docs) {
      await doc.reference.delete();
    }
  }

  // ─── Orders ──────────────────────────────────────────────────────────

  Future<String> placeOrder(
      String userId, List<ZCartItem> items, double total) async {
    final orderRef =
        await _db.collection('users').doc(userId).collection('orders').add({
      'date': Timestamp.now(),
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'status': 'Pending',
      'estimatedDelivery': '',
    });

    final orderId = 'ZH-${DateTime.now().millisecondsSinceEpoch}';
    await orderRef.update({
      'estimatedDelivery':
          'Expected by ${DateTime.now().add(const Duration(days: 5)).toString().split(' ')[0]}',
    });

    await clearCart(userId);
    return orderRef.id;
  }

  Stream<List<ZOrder>> getUserOrders(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('orders')
        .orderBy('date', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final orders = <ZOrder>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final itemsData = data['items'] as List<dynamic>? ?? [];
        final items = <ZCartItem>[];
        for (final itemData in itemsData) {
          final itemMap = itemData as Map<String, dynamic>;
          final productId = itemMap['productId'] as String? ?? '';
          if (productId.isEmpty) continue;
          final productDoc =
              await _db.collection('products').doc(productId).get();
          if (!productDoc.exists) continue;
          final product =
              ZProduct.fromFirestore(productDoc.data()!, productDoc.id);
          items.add(ZCartItem.fromFirestore(itemMap, product));
        }
        orders.add(
            ZOrder.fromFirestore(data, doc.id, items));
      }
      return orders;
    });
  }

  // ─── Profile ─────────────────────────────────────────────────────────

  Future<void> saveUserProfile(String userId, ZUser user) async {
    await _db.collection('users').doc(userId).set(user.toMap());
  }

  Future<ZUser?> getUserProfile(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    return ZUser.fromFirestore(doc.data()!, doc.id);
  }

  Stream<ZUser?> streamUserProfile(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return ZUser.fromFirestore(snapshot.data()!, snapshot.id);
    });
  }

  // ─── Addresses ───────────────────────────────────────────────────────

  Future<List<ZAddress>> getUserAddresses(String userId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .get();
    return snapshot.docs
        .map((doc) => ZAddress.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<ZAddress?> getDefaultAddress(String userId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .where('isDefault', isEqualTo: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return ZAddress.fromFirestore(
        snapshot.docs.first.data(), snapshot.docs.first.id);
  }
}
