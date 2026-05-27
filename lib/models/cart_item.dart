import 'product.dart';

class ZCartItem {
  final ZProduct product;
  final String selectedSize;
  final String selectedColor;
  int quantity;
  final String docId;

  ZCartItem({
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    required this.quantity,
    this.docId = '',
  });

  factory ZCartItem.fromFirestore(
      Map<String, dynamic> map, ZProduct product,
      {String docId = ''}) {
    return ZCartItem(
      product: product,
      selectedSize: map['selectedSize'] as String? ?? '',
      selectedColor: map['selectedColor'] as String? ?? '',
      quantity: (map['quantity'] as int?) ?? 1,
      docId: docId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'quantity': quantity,
    };
  }
}
