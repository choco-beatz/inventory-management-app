import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerDatabaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Check if phone no already exist
  Future<bool> isPhoneNumberExists(String phoneno) async {
    QuerySnapshot query = await _firestore
        .collection('customers')
        .where('phoneno', isEqualTo: phoneno)
        .limit(1)
        .get();
    return query.docs.isNotEmpty; // Returns true if phone exists
  }

  //Create customer
  Future<void> addCustomer(Map<String, dynamic> data) async {
    await _firestore.collection('customers').add(data);
  }

  //Read customers
  Stream<QuerySnapshot> getCustomers() {
    return _firestore.collection('customers').snapshots();
  }
}
