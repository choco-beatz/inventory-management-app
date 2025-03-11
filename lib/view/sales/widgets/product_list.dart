import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/text.dart';
import 'package:inventory_management_app/common/widgets/custom_dialog_button.dart';
import 'package:inventory_management_app/data/provider/sales_provider.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.product,
  });

  final QueryDocumentSnapshot<Object?> product;

  @override
  Widget build(BuildContext context) {
    String id = product.id;
    final salesProvider = Provider.of<SalesProvider>(context);

    return Card(
      child: ListTile(
        title: TextM18(text: product['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text16(text: 'Stock: ${product['stock']}'),
            TextM16(text: 'Price: ₹${product['price']}'),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    salesProvider.decreaseQuantity(id);
                  },
                ),
                Consumer<SalesProvider>(
                  builder: (context, provider, child) {
                    return TextM16(text: '${provider.getQuantity(id)}');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    salesProvider.increaseQuantity(id);
                  },
                ),
              ],
            ),
          ],
        ),
        trailing: InkWell(
          onTap: () {
            int selectedQuantity = salesProvider.getQuantity(id);
            log(salesProvider.getQuantity(id).toString());
            salesProvider.addToCart(product.data() as Map<String, dynamic>, selectedQuantity);
          },
          child: const CustomDialogButton(text: 'ADD'),
        ),
      ),
    );
  }
}
