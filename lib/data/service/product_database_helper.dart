import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Create Product
  Future<void> addProduct(Map<String, dynamic> data) async {
    await _firestore.collection('products').add(data);
  }

  //Read Products
  Stream<QuerySnapshot> getProducts() {
    return _firestore.collection('products').snapshots();
  }

  //Update Product
  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await _firestore.collection('products').doc(id).update(data);
  }

  //Delete Product
  Future<void> deleteProduct(String id) async {
    await _firestore.collection('products').doc(id).delete();
  }
}
