import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/data/service/sales_database_helper.dart';

class SalesProvider extends ChangeNotifier {
  List<Map<String, dynamic>> cart = [];
  Map<String, int> productQuantities = {}; // Stores quantity for each product
  String _selectedCustomerPhoneno = '';
  String _selectedCustomerName = 'Cash Sale';

  List<Map<String, dynamic>> get carts => cart;
  String get selectedCustomerPhoneno => _selectedCustomerPhoneno;
  String get selectedCustomerName => _selectedCustomerName;

  // ✅ Get quantity for a product (default 0 if not set)
  int getQuantity(String id) {
    return productQuantities[id] ?? 0;
  }

  // ✅ Increase product quantity
  void increaseQuantity(String id) {
    productQuantities[id] = getQuantity(id) + 1;
    notifyListeners();
  }

  // ✅ Decrease product quantity
  void decreaseQuantity(String id) {
    if (getQuantity(id) > 1) {
      productQuantities[id] = getQuantity(id) - 1;
      notifyListeners();
    }
  }

  // ✅ Add product to cart
  void addToCart(Map<String, dynamic> product) {
    // Convert numeric ID to string if needed
    String id = product['id'].toString();
    log("Adding to cart: $id");
    
    int quantity = getQuantity(id);
    if (quantity == 0) quantity = 1; // Set default quantity to 1 if not already set
    
    double price = double.tryParse(product['price'].toString()) ?? 0.0;
    
    var existingProduct = cart.firstWhere(
      (item) => item['id'] == id,
      orElse: () => {},
    );
    
    if (existingProduct.isNotEmpty) {
      cart.removeWhere((item) => item['id'] == id);
    }
    
    cart.add({
      'id': id,
      'productName': product['name'],
      'quantity': quantity,
      'pricePerItem': price,
      'totalPrice': price * quantity,
    });
    
    notifyListeners();
  }

  // ✅ Select customer
  void selectCustomer(String phoneno, String customerName) {
    _selectedCustomerPhoneno = phoneno.isNotEmpty ? phoneno : '';
    _selectedCustomerName = customerName;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // ✅ Complete sale and reduce stock
  Future<void> completeSale(BuildContext context) async {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty')),
      );
      return;
    }
    
    // ✅ Check stock availability before proceeding
    for (var item in cart) {
      String productId = item['id'];
      log("Checking product: $productId");
      
      try {
        // Query by ID field instead of document ID
        QuerySnapshot productQuery = await FirebaseFirestore.instance
            .collection('products')
            .where('id', isEqualTo: int.parse(productId))
            .limit(1)
            .get();
            
        if (productQuery.docs.isEmpty) {
          log("Product not found with ID: $productId");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product ${item['productName']} not found!')),
          );
          return;
        }
        
        DocumentSnapshot productSnapshot = productQuery.docs.first;
        int currentStock = int.parse(productSnapshot['stock'].toString());
        
        if (currentStock < item['quantity']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Not enough stock for ${item['productName']}')),
          );
          return;
        }
      } catch (e) {
        log("Error checking product: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error checking product: ${e.toString()}')),
        );
        return;
      }
    }
    
    // ✅ Ensure all prices are numbers
    double totalAmount = cart.fold(0.0, (total, item) {
      double itemTotal = double.tryParse(item['totalPrice'].toString()) ?? 0.0;
      return total + itemTotal;
    });
    
    Map<String, dynamic> saleData = {
      'customerPhoneno': 
          _selectedCustomerPhoneno.isNotEmpty ? _selectedCustomerPhoneno : null,
      'customerName': _selectedCustomerPhoneno.isNotEmpty
          ? _selectedCustomerName
          : 'Cash Sale',
      'items': cart,
      'totalAmount': totalAmount,
      'date': Timestamp.now(),
      'soldBy': 'adminId',
    };
    
    try {
      await DatabaseHelper().addSale(saleData);
      
      // Update stock for each item
      for (var item in cart) {
        String productId = item['id'];
        int quantity = item['quantity'];
        
        QuerySnapshot productQuery = await FirebaseFirestore.instance
            .collection('products')
            .where('id', isEqualTo: int.parse(productId))
            .limit(1)
            .get();
            
        if (!productQuery.docs.isEmpty) {
          DocumentReference productRef = productQuery.docs.first.reference;
          DocumentSnapshot productSnapshot = await productRef.get();
          int currentStock = int.parse(productSnapshot['stock'].toString());
          await productRef.update({'stock': (currentStock - quantity).toString()});
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sale recorded successfully')),
      );
      
      cart.clear();
      productQuantities.clear();
      notifyListeners();
      Navigator.pop(context);
    } catch (e) {
      log("Error completing sale: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error completing sale: ${e.toString()}')),
      );
    }
  }
}