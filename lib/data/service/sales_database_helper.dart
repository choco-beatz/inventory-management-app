import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new sale
  Future<void> addSale(Map<String, dynamic> saleData) async {
    // ✅ First, save the sale in Firestore
    await _firestore.collection('sales').add(saleData);

    // ✅ Reduce inventory stock for each product in the sale
    for (var item in saleData['items']) {
      DocumentReference productRef =
          _firestore.collection('products').doc(item['id']);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot productSnapshot = await transaction.get(productRef);
        if (productSnapshot.exists) {
          int currentStock = productSnapshot['stock'];
          transaction
              .update(productRef, {'stock': currentStock - item['quantity']});
        }
      });
    }

    
  }
  // ✅ Fetch sales ordered by date
  Stream<QuerySnapshot> getSales() {
    return _firestore.collection('sales').orderBy('date', descending: true).snapshots();
  }
}
