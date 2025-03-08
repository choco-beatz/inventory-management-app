import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/widgets/custom_appbar.dart';
import 'package:inventory_management_app/common/widgets/custom_menu_button.dart';
import 'package:inventory_management_app/view/customers/screens/customer_screen.dart';
import 'package:inventory_management_app/view/inventory/screens/inventory_screen.dart';
import 'package:inventory_management_app/view/report/screens/report_screen.dart';
import 'package:inventory_management_app/view/sales/screens/sales_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          title: "Dashboard",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MenuButton(
                page: InventoryScreen(),
                text: 'INVENTORY',
              ),
              MenuButton(
                page: CustomerScreen(),
                text: 'CUSTOMERS',
              ),
              MenuButton(
                page: SalesScreen(),
                text: 'SALES',
              ),
              MenuButton(
                page: ReportScreen(),
                text: 'REPORTS',
              )
            ],
          ),
        ),
      ),
    );
  }
}
