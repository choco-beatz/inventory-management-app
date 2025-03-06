import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/text.dart';
import 'package:inventory_management_app/data/provider/customer_provider.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({
    super.key,
    required this.customer,
    required this.customerProvider,
  });

  final QueryDocumentSnapshot<Object?> customer;
  final CustomerProvider customerProvider;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text22(
          text: customer['name'],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text16(text: customer['address']),
            TextM16(text: 'Phone no: ${customer['phoneno']}'),
          ],
        ),
      ),
    );
  }
}
