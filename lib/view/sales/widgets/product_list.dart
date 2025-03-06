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
        title: Text16(text: product['name']),
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
                TextM16(text: '${salesProvider.getQuantity(id)}'),
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
            salesProvider.addToCart(product.data() as Map<String, dynamic>);
          },
          child: const CustomDialogButton(text: 'ADD'),
        ),
      ),
    );
  }
}
