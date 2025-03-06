import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/widgets/custom_appbar.dart';
import 'package:inventory_management_app/common/widgets/custom_menu_button.dart';
import 'package:inventory_management_app/view/sales/screens/new_sales_screen.dart';
import 'package:inventory_management_app/view/sales/screens/sales_history_screen.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          title: "Sales",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MenuButton(
                page: NewSales(),
                text: 'NEW SALE',
              ),
              MenuButton(
                page: SalesHistory(),
                text: 'SALES HISTORY',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
