import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/dropdown_decoration.dart';
import 'package:inventory_management_app/common/space.dart';
import 'package:inventory_management_app/common/widgets/custom_appbar.dart';
import 'package:inventory_management_app/data/provider/report_provider.dart';
import 'package:inventory_management_app/data/provider/sales_provider.dart';
import 'package:inventory_management_app/view/report/widgets/customer_ledger.dart';
import 'package:inventory_management_app/view/report/widgets/export_option_bottom_sheet.dart';
import 'package:inventory_management_app/view/report/widgets/item_report.dart';
import 'package:inventory_management_app/view/report/widgets/sales_report.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportsProvider reportsProvider =
        Provider.of<ReportsProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppBar(
          title: "Reports",
          actionsList: [
            IconButton(
              onPressed: () async {
                String reportType = reportsProvider.selectedReport;
                dynamic reportData;

                //Get the selected customer's phone number from the provider
                String selectedCustomerPhoneno =
                    Provider.of<SalesProvider>(context, listen: false)
                        .selectedCustomerPhoneno;

                QuerySnapshot snapshot =
                    await Provider.of<SalesProvider>(context, listen: false)
                        .salesStream
                        .first;

                //If it's a Customer Ledger, filter sales by the selected customer
                if (reportType == "Customer Ledger") {
                  reportData = snapshot.docs
                      .where((sale) =>
                          sale['customerPhoneno'] == selectedCustomerPhoneno)
                      .toList();
                } else {
                  reportData = snapshot.docs;
                }

                if (reportType == "Items Report") {
                  QuerySnapshot snapshot =
                      await Provider.of<SalesProvider>(context, listen: false)
                          .salesStream
                          .first;

                  //Transform sales data into a product-wise summary
                  Map<String, Map<String, dynamic>> productSummary = {};

                  for (var sale in snapshot.docs) {
                    List<dynamic> items = sale['items'] ?? [];

                    for (var item in items) {
                      String productName = item['productName'];
                      int quantity = item['quantity'];
                      double totalRevenue = item['totalPrice'];

                      //If product already exists, update quantity & revenue
                      if (productSummary.containsKey(productName)) {
                        productSummary[productName]!['totalQty'] += quantity;
                        productSummary[productName]!['totalRevenue'] +=
                            totalRevenue;
                      } else {
                        //If new product, initialize values
                        productSummary[productName] = {
                          'totalQty': quantity,
                          'totalRevenue': totalRevenue,
                        };
                      }
                    }
                  }

                  reportData =
                      productSummary; //Now it's in the correct format
                }

                //Pass the filtered data
                showExportOptions(context, reportType, reportData);
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                decoration: dropdownDecoration,
                value: reportsProvider.selectedReport,
                hint: const Text('Select Report Type'),
                onChanged: (value) {
                  reportsProvider.changeReport(value!);
                },
                items: ["Sales Report", "Items Report", "Customer Ledger"]
                    .map((report) => DropdownMenuItem(
                          value: report,
                          child: Text(report),
                        ))
                    .toList(),
              ),
              space,
              Expanded(
                child: reportsProvider.selectedReport == "Sales Report"
                    ? const SalesReport()
                    : reportsProvider.selectedReport == "Items Report"
                        ? const ItemReport()
                        : const CustomerLedger(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
