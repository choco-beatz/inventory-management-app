import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';
import 'package:inventory_management_app/common/text.dart';
import 'package:inventory_management_app/data/provider/sales_provider.dart';
import 'package:inventory_management_app/view/report/widgets/month_selector.dart';
import 'package:provider/provider.dart';

class ItemReport extends StatelessWidget {
  const ItemReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MonthYearSelector(),
        const Divider(),
        Expanded(
          child: Consumer<SalesProvider>(
            builder: (context, provider, child) {
              return StreamBuilder<Map<String, Map<String, dynamic>>>(
                stream: provider.itemReportStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var itemReport = snapshot.data!;

                  if (itemReport.isEmpty) {
                    return const Center(
                        child: Text("No sales recorded for this month."));
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      border: TableBorder.all(
                          color: mainColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      columnSpacing: 40,
                      columns: const [
                        DataColumn(
                          label: TextM18(text: "Product"),
                        ),
                        DataColumn(label: TextM18(text: "Sold")),
                        DataColumn(label: TextM18(text: "Revenue")),
                      ],
                      rows: itemReport.entries.map((entry) {
                        return DataRow(cells: [
                          DataCell(Text16(text: entry.key)),
                          DataCell(Text16(text: "${entry.value['totalQty']}")),
                          DataCell(Text16(
                              text:
                                  "₹${entry.value['totalRevenue'].toStringAsFixed(2)}")),
                        ]);
                      }).toList(),
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
