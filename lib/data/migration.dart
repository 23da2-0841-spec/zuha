import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import 'mock_data.dart';

Future<void> migrateProductsToFirestore() async {
  final db = FirebaseFirestore.instance;
  final batch = db.batch();

  for (final product in MockData.products) {
    final docRef = db.collection('products').doc(product.id);
    batch.set(docRef, product.toMap());
  }

  await batch.commit();
  // ignore: avoid_print
  print('Migration complete');
}
