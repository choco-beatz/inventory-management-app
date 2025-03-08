import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/widgets/custom_appbar.dart';
import 'package:inventory_management_app/data/provider/sales_provider.dart';
import 'package:inventory_management_app/view/sales/widgets/sales_list.dart';
import 'package:provider/provider.dart';

class SalesHistory extends StatelessWidget {
  const SalesHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final salesProvider = Provider.of<SalesProvider>(context);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          title: "Sales History",
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(5),
          child: StreamBuilder(
              stream: salesProvider.salesStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var sales = snapshot.data!.docs;

                if (sales.isEmpty) {
                  return const Center(child: Text("No sales recorded yet."));
                }

                return ListView.builder(
                  itemCount: sales.length,
                  itemBuilder: (context, index) {
                    var sale = sales[index];
                    return SalesList(sale: sale);
                  },
                );
              })),
    );
  }
}
