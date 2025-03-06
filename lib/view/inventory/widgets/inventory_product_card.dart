import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';
import 'package:inventory_management_app/common/text.dart';
import 'package:inventory_management_app/common/widgets/custom_dialog_button.dart';
import 'package:inventory_management_app/data/provider/product_provider.dart';
import 'package:inventory_management_app/view/inventory/screens/edit_products_screen.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.productProvider,
  });

  final QueryDocumentSnapshot<Object?> product;
  final ProductProvider productProvider;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text22(
              text: product['name'],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProducts(
                                  description: product['description'],
                                  name: product['name'],
                                  price: product['price'],
                                  stock: product['stock'],
                                  id: product.id,
                                )));
                  },
                  icon: const Icon(Icons.edit_outlined, size: 30, color: black),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: mainColor,
                          title: const TextW22(
                            text: "Confirm Deletion",
                          ),
                          content: const TextW16(
                            text: '''Are you sure you want to delete?''',
                          ),
                          actions: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child:
                                    const CustomDialogButton(text: 'Cancel')),
                            GestureDetector(
                                onTap: () {
                                  productProvider.deleteProduct(
                                      product.id, context);
                                  Navigator.of(context).pop();
                                },
                                child: const CustomDialogButton(
                                    text: 'Delete', imp: true)),
                          ],
                        );
                      },
                    );
                  },
                  icon:
                      const Icon(Icons.delete_outline, size: 30, color: black),
                ),
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text16(text: product['description']),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextM16(text: 'Stock: ${product['stock']}'),
                TextM16(text: 'Price: ₹${product['price']}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
