import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_app/data/provider/sales_provider.dart';
import 'package:provider/provider.dart';

class SalesReport extends StatelessWidget {
  const SalesReport({super.key});

  @override
  Widget build(BuildContext context) {
    final salesProvider = Provider.of<SalesProvider>(context);

    return StreamBuilder(
        stream: salesProvider.salesStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var sales = snapshot.data!.docs;

          if (sales.isEmpty) {
            return const Center(child: Text("No sales recorded yet."));
          }

          return ListView.builder(
            itemCount: sales.length,
            itemBuilder: (context, index) {
              var sale = sales[index];
              Timestamp timestamp = sale['date'];
              DateTime date = timestamp.toDate();
              String formattedDate =
                  DateFormat("d MMMM yyyy").format(date); // 3 March 2025

              return Card(
                child: ListTile(
                  title: Text("🛒 Sale ID: ${sale.id}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "👤 Customer: ${sale['customerName'] ?? 'Cash Sale'}"),
                      Text("📅 Date: $formattedDate"),
                      Text(
                          "💰 Amount: ₹${sale['totalAmount'].toStringAsFixed(2)}"),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
