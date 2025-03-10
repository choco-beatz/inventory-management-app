import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/data/service/product_database_helper.dart';

class ProductProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Stream<QuerySnapshot> get products => ProductDatabaseHelper().getProducts();

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> deleteProduct(String id, BuildContext context) async {
    try {
      await ProductDatabaseHelper().deleteProduct(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product Deleted Successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting product: $e')),
      );
    }
  }

  Future<void> addProduct(
      Map<String, dynamic> productData, BuildContext context) async {
    if (productData['name'].isEmpty ||
        productData['description'].isEmpty ||
        productData['stock'] == null ||
        productData['price'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await ProductDatabaseHelper().addProduct(productData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product Added Successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding product: $e')),
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProduct(
      String id, Map<String, dynamic> updatedData, BuildContext context) async {
    try {
      await ProductDatabaseHelper().updateProduct(id, updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product Updated Successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating product: $e')),
      );
    }
  }
}
