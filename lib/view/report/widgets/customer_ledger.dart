import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_app/common/dropdown_decoration.dart';
import 'package:inventory_management_app/common/space.dart';
import 'package:inventory_management_app/common/text.dart';
import 'package:inventory_management_app/data/provider/sales_provider.dart';
import 'package:inventory_management_app/view/report/widgets/month_selector.dart';
import 'package:inventory_management_app/view/report/widgets/report_summary_card.dart';
import 'package:provider/provider.dart';

class CustomerLedger extends StatelessWidget {
  const CustomerLedger({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MonthYearSelector(),
        space,
        Consumer<SalesProvider>(
          builder: (context, provider, child) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('customers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                var customers = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  decoration: dropdownDecoration,
                  value: provider.selectedCustomerPhoneno.isNotEmpty
                      ? provider.selectedCustomerPhoneno
                      : null,
                  onChanged: (String? phoneno) {
                    if (phoneno != null) {
                      var selectedCustomer = customers.firstWhere(
                        (customer) => customer['phoneno'] == phoneno,
                      );
                      provider.updateSelectedCustomer(
                          selectedCustomer['phoneno'],
                          selectedCustomer['name']);
                    }
                  },
                  items: customers.map((customer) {
                    return DropdownMenuItem<String>(
                      value: customer['phoneno'],
                      child:
                          Text("${customer['name']} (${customer['phoneno']})"),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
        space,
        const Divider(),
        Consumer<SalesProvider>(
          builder: (context, provider, child) {
            // Single collection fetch without complex queries
            return StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('sales').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var allSales = snapshot.data!.docs;

                // Filter client-side instead of in the query
                var sales = allSales
                    .where((sale) =>
                        sale['customerPhoneno'] ==
                        provider.selectedCustomerPhoneno)
                    .toList();

                // Sort client-side
                sales.sort((a, b) {
                  Timestamp aDate = a['date'];
                  Timestamp bDate = b['date'];
                  return bDate.compareTo(aDate); // Descending order
                });

                if (sales.isEmpty) {
                  return const Center(
                      child: Text("No transactions for this customer."));
                }

                double totalPaid = sales.fold(
                    0, (total, sale) => total + (sale['totalAmount'] ?? 0));

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SummaryCard(
                        title:
                            "Customer Ledger for ${provider.selectedCustomerName}",
                        subTitle: "Total Transactions: ${sales.length}",
                        subTitle2:
                            "Total Paid: ₹${totalPaid.toStringAsFixed(2)}"),
                    const Divider(),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: sales.length,
                        itemBuilder: (context, index) {
                          var sale = sales[index];
                          Timestamp timestamp = sale['date'];
                          DateTime date = timestamp.toDate();
                          String formattedDate =
                              DateFormat("d MMM yyyy").format(date);

                          return Card(
                            child: ListTile(
                              title: TextM16(text: "Sale ID: ${sale.id}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text14(text: "Date: $formattedDate"),
                                  Text14(
                                      text:
                                          "Amount: ₹${sale['totalAmount'].toStringAsFixed(2)}"),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
