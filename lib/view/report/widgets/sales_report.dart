import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_app/common/text.dart';
import 'package:inventory_management_app/data/provider/sales_provider.dart';
import 'package:inventory_management_app/data/service/months.dart';
import 'package:inventory_management_app/view/report/widgets/month_selector.dart';
import 'package:inventory_management_app/view/report/widgets/report_summary_card.dart';
import 'package:provider/provider.dart';

class SalesReport extends StatelessWidget {
  const SalesReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MonthYearSelector(),
        const Divider(),
        Consumer<SalesProvider>(
          builder: (context, provider, child) {
            return StreamBuilder<List<QueryDocumentSnapshot>>(
              stream: provider.filteredSalesStream,
              builder: (context,
                  AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var sales = snapshot.data!;
                double totalRevenue = sales.fold(
                    0, (total, sale) => total + (sale['totalAmount'] ?? 0));

                return SummaryCard(title: "Sales Report for ${months[provider.selectedMonth - 1]} ${provider.selectedYear}", subTitle:  "Total Transactions: ${sales.length}", subTitle2:"Total Revenue: ₹${totalRevenue.toStringAsFixed(2)}" ,);
              },
            );
          },
        ),
        const Divider(),
        Expanded(
          child: Consumer<SalesProvider>(builder: (context, provider, child) {
            return StreamBuilder(
                stream: provider.filteredSalesStream,
                builder: (context,
                    AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var sales = snapshot.data!;

                  if (sales.isEmpty) {
                    return const Center(
                        child: Text("No sales recorded for this month."));
                  }

                  return ListView.builder(
                    itemCount: sales.length,
                    itemBuilder: (context, index) {
                      var sale = sales[index];
                      Timestamp timestamp = sale['date'];
                      DateTime date = timestamp.toDate();
                      String formattedDate =
                          DateFormat("d MMMM yyyy").format(date);

                      return Card(
                        child: ExpansionTile(
                            shape: const Border(),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextM16(
                                  text: "Sale ID: ${sale.id}",
                                ),
                                Text16(
                                  text:
                                      "Amount: ₹${sale['totalAmount'].toStringAsFixed(2)}",
                                ),
                              ],
                            ),
                            children: [
                              ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text14(
                                      text:
                                          "Purchased by: ${sale['customerName'] ?? 'Cash sale'}",
                                    ),
                                    Text14(
                                      text: "Date: $formattedDate",
                                    ),
                                  ],
                                ),
                              )
                            ]),
                      );
                    },
                  );
                });
          }),
        ),
      ],
    );
  }
}

