import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';
import 'package:inventory_management_app/common/widgets/custom_appbar.dart';
import 'package:inventory_management_app/data/provider/customer_provider.dart';
import 'package:inventory_management_app/view/customers/screens/add_customer_screen.dart';
import 'package:inventory_management_app/view/customers/widgets/customer_card.dart';
import 'package:provider/provider.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppBar(
          title: "Customers",
          actionsList: [
           
            IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddCustomer())),
              icon: const Icon(
                Icons.add,
                size: 30,
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: customerProvider.customers,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: mainColor,
              ));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No customers added'));
            }

            var customers = snapshot.data!.docs;

            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                var customer = customers[index];

                return CustomerCard(customer: customer, customerProvider: customerProvider);
              },
            );
          },
        ),
      ),
    );
  }
}
