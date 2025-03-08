import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/dropdown_decoration.dart';
import 'package:inventory_management_app/data/provider/sales_provider.dart';

class DropDownForm extends StatelessWidget {
  const DropDownForm({
    super.key,
    required this.salesProvider,
    required this.snapshot,
  });
  final SalesProvider salesProvider;
  final AsyncSnapshot<QuerySnapshot> snapshot;
  @override
  Widget build(BuildContext context) {
    var customers = snapshot.data!.docs;
    // Ensure selected customer exists in the dropdown list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!customers.any((customer) =>
          customer['phoneno'] == salesProvider.selectedCustomerPhoneno)) {
        salesProvider.selectCustomer('', 'Cash Sale');
      }
    });
    return DropdownButtonFormField<String>(
      decoration: dropdownDecoration,
      value: salesProvider.selectedCustomerPhoneno.isNotEmpty
          ? salesProvider.selectedCustomerPhoneno
          : null,
      hint: const Text('Select Customer (Optional)'),
      onChanged: (value) {
        if (value != null) {
          // Fixed approach - avoid type mismatch in orElse
          QueryDocumentSnapshot? selectedCustomer;
          try {
            if (customers.isNotEmpty) {
              selectedCustomer = customers.firstWhere(
                (customer) => customer['phoneno'] == value,
              );
            }
          } catch (e) {
            // If no match is found, don't set a default
            selectedCustomer = null;
          }
          
          if (selectedCustomer != null) {
            salesProvider.selectCustomer(
                selectedCustomer['phoneno'], selectedCustomer['name']);
          }
        }
      },
      items: snapshot.data!.docs.map((customer) {
        return DropdownMenuItem<String>(
          value: customer['phoneno'], // Use phoneno as value to match correctly
          child: Text(customer['name']),
        );
      }).toList(),
    );
  }
}