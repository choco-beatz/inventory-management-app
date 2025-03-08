import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/widgets/custom_appbar.dart';
import 'package:inventory_management_app/common/widgets/custom_button.dart';
import 'package:inventory_management_app/data/provider/product_provider.dart';
import 'package:inventory_management_app/data/provider/sales_provider.dart';
import 'package:inventory_management_app/view/sales/widgets/customer_drop_down.dart';
import 'package:inventory_management_app/view/sales/widgets/product_list.dart';
import 'package:provider/provider.dart';

class NewSales extends StatelessWidget {
  const NewSales({super.key});

  @override
  Widget build(BuildContext context) {
    final salesProvider = Provider.of<SalesProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(title: "New Sales")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Customer Selection Dropdown
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('customers').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return DropDownForm(
                  salesProvider: salesProvider,
                  snapshot: snapshot,
                );
              },
            ),
            Expanded(
              child: StreamBuilder(
                stream: productProvider.products,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var products = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];

                      return ProductList(
                          product: product);
                    },
                  );
                },
              ),
            ),

            InkWell(
              onTap: () {
                salesProvider.completeSale(context);
              },
              child: const CustomButton(text: 'CONFIRM SALES'),
            ),
          ],
        ),
      ),
    );
  }
}
