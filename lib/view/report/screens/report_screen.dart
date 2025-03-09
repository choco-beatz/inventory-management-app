import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/dropdown_decoration.dart';
import 'package:inventory_management_app/common/space.dart';
import 'package:inventory_management_app/common/widgets/custom_appbar.dart';
import 'package:inventory_management_app/data/provider/report_provider.dart';
import 'package:inventory_management_app/view/report/widgets/customer_ledger.dart';
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
                onPressed: () {},
                icon: const Icon(
                  Icons.share,
                ))
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
