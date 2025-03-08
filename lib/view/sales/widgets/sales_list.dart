import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_app/common/text.dart';

class SalesList extends StatelessWidget {
  final QueryDocumentSnapshot sale;
  const SalesList({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    List<dynamic> items = sale['items']; // Get items sold
    Timestamp timestamp = sale['date'];
    DateTime date = timestamp.toDate();
    String formattedDate = DateFormat("d MMMM yyyy").format(date);

    return Card(
      child: ExpansionTile(
        shape: const Border(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextM18(
                  text: sale['customerName'] ?? 'Cash Sale',
                ),
                TextM18(
                  text: "₹${sale['totalAmount'].toStringAsFixed(2)}",
                ),
              ],
            ),
            Text16(
              text: formattedDate,
            ),
          ],
        ),
        children: items.map((item) {
          return ListTile(
            title: Text16(text: "${item['productName']} x${item['quantity']}"),
            trailing:
                TextM16(text: "₹${item['totalPrice'].toStringAsFixed(2)}"),
          );
        }).toList(),
      ),
    );
  }
}
