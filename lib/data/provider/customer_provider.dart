import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/data/service/customer_database_helper.dart';

class CustomerProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

   Stream<QuerySnapshot> get customers => CustomerDatabaseHelper().getCustomers();


  Future<void> addCustomer(Map<String, dynamic> customerData, BuildContext context) async {
    if (customerData['name'].isEmpty || customerData['phoneno'].isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')),
        );
      }
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Check if phone number already exists
      bool phoneExists = await CustomerDatabaseHelper().isPhoneNumberExists(customerData['phoneno']);

      if (phoneExists) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phone number already exists!')),
          );
        }
      } else {
        await CustomerDatabaseHelper().addCustomer(customerData);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Customer Added Successfully')),
          );
          Navigator.pop(context); // Go back to customer list
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding customer: $e')),
        );
      }
    }

    _isLoading = false;
    notifyListeners();
  }


}
