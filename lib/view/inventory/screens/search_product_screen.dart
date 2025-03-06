import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';
import 'package:inventory_management_app/common/widgets/custom_appbar.dart';
import 'package:inventory_management_app/data/provider/product_provider.dart';
import 'package:inventory_management_app/view/inventory/widgets/inventory_product_card.dart';
import 'package:provider/provider.dart';

class SearchProducts extends StatefulWidget {
  const SearchProducts({super.key});

  @override
  State<SearchProducts> createState() => _SearchProductsState();
}

class _SearchProductsState extends State<SearchProducts> {
  TextEditingController searchController = TextEditingController();
  List<QueryDocumentSnapshot> searchResults = [];

  void searchProducts(String query, ProductProvider productProvider) {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    productProvider.products.listen((snapshot) {
      var filteredProducts = snapshot.docs.where((product) {
        String name = product['name'].toLowerCase();
        String description = product['description'].toLowerCase();
        return name.contains(query.toLowerCase()) ||
            description.contains(query.toLowerCase());
      }).toList();

      setState(() => searchResults = filteredProducts);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(title: "Search Products"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (value) => searchProducts(value, productProvider),
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 30,
                      color: mainColor,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: searchResults.isEmpty
                      ? const Center(child: Text('Nothing here'))
                      : ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            var product = searchResults[index];

                            return ProductCard(
                                product: product,
                                productProvider: productProvider);
                          },
                        ),
                ),
              ],
            )));
  }
}
