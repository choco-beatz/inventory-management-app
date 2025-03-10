import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/data/service/customer_database_helper.dart';
import 'package:inventory_management_app/data/service/product_database_helper.dart';
import 'package:inventory_management_app/data/service/sales_database_helper.dart';

class SalesProvider extends ChangeNotifier {
  // ========== PROPERTIES ==========
  final SalesDatabaseHelper salesDatabaseHelper = SalesDatabaseHelper();
  final CustomerDatabaseHelper customerDatabaseHelper = CustomerDatabaseHelper();
  final ProductDatabaseHelper productDatabaseHelper = ProductDatabaseHelper();
  
  // Cart state
  List<Map<String, dynamic>> cart = [];
  Map<String, int> productQuantities = {}; // Stores quantity for each product
  
  // Customer state
  String _selectedCustomerPhoneno = '';
  String _selectedCustomerName = 'Cash Sale';
  
  // Date filtering
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  // ========== GETTERS ==========
  List<Map<String, dynamic>> get carts => cart;
  String get selectedCustomerPhoneno => _selectedCustomerPhoneno;
  String get selectedCustomerName => _selectedCustomerName;
  int get selectedMonth => _selectedMonth;
  int get selectedYear => _selectedYear;
  
  // Database streams
  Stream<QuerySnapshot> get salesStream => salesDatabaseHelper.getSales();
  Stream<QuerySnapshot> get customerStream => customerDatabaseHelper.getCustomers();
  Stream<QuerySnapshot> get productStream => productDatabaseHelper.getProducts();

  // Filtered streams
  Stream<Map<String, Map<String, dynamic>>> get itemReportStream {
    return salesStream.map((snapshot) {
      Map<String, Map<String, dynamic>> itemReport = {};

      for (var sale in snapshot.docs) {
        Timestamp timestamp = sale['date'];
        DateTime saleDate = timestamp.toDate();

        // Filter by selected month and year
        if (saleDate.month == _selectedMonth && saleDate.year == _selectedYear) {
          List<dynamic> items = sale['items'];

          for (var item in items) {
            String productName = item['productName'];
            int quantity = item['quantity'];
            double totalPrice = item['totalPrice'];

            if (!itemReport.containsKey(productName)) {
              itemReport[productName] = {
                'totalQty': 0,
                'totalRevenue': 0.0,
              };
            }

            itemReport[productName]!['totalQty'] += quantity;
            itemReport[productName]!['totalRevenue'] += totalPrice;
          }
        }
      }

      return itemReport;
    });
  }

  Stream<List<QueryDocumentSnapshot>> get filteredSalesStream {
    return salesDatabaseHelper.getSales().map((querySnapshot) {
      return querySnapshot.docs.where((sale) {
        Timestamp timestamp = sale['date'];
        DateTime saleDate = timestamp.toDate();
        return saleDate.month == _selectedMonth && saleDate.year == _selectedYear;
      }).toList();
    });
  }

  // ========== DATE METHODS ==========
  void updateMonthYear(int month, int year) {
    _selectedMonth = month;
    _selectedYear = year;
    notifyListeners(); 
  }

  // ========== CUSTOMER METHODS ==========
  void updateSelectedCustomer(String phoneno, String name) {
    _selectedCustomerPhoneno = phoneno;
    _selectedCustomerName = name;
    notifyListeners();
  }

  void selectCustomer(String phoneno, String customerName) {
    _selectedCustomerPhoneno = phoneno.isNotEmpty ? phoneno : '';
    _selectedCustomerName = customerName;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // ========== CART METHODS ==========
  // Get quantity for a product (default 0 if not set)
  int getQuantity(String id) {
    return productQuantities[id] ?? 0;
  }

  // Increase product quantity
  void increaseQuantity(String id) {
    productQuantities[id] = getQuantity(id) + 1;
    notifyListeners();
  }

  // Decrease product quantity
  void decreaseQuantity(String id) {
    if (getQuantity(id) > 1) {
      productQuantities[id] = getQuantity(id) - 1;
      notifyListeners();
    }
  }

  // Add product to cart
  void addToCart(Map<String, dynamic> product) {
    // Convert numeric ID to string if needed
    String id = product['id'].toString();
    log("Adding to cart: $id");

    int quantity = getQuantity(id);
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

  // ========== SALE COMPLETION ==========
  // Complete sale and reduce stock
  Future<void> completeSale(BuildContext context) async {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty')),
      );
      return;
    }

    // Check stock availability before proceeding
    for (var item in cart) {
      String productId = item['id'];
      log("Checking product: ${productQuantities[productId]}");

      int quantity = productQuantities[productId] ?? item['quantity'];
      log("Checking Product: $productId | Quantity: $quantity");

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

        if (currentStock < quantity) {
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

    // Ensure all prices are numbers
    double totalAmount = cart.fold(0.0, (total, item) {
      double itemTotal = double.tryParse(item['totalPrice'].toString()) ?? 0.0;
      return total + itemTotal;
    });

    Map<String, dynamic> saleData = {
      'customerPhoneno': _selectedCustomerPhoneno.isNotEmpty ? _selectedCustomerPhoneno : null,
      'customerName': _selectedCustomerPhoneno.isNotEmpty ? _selectedCustomerName : 'Cash Sale',
      'items': cart,
      'totalAmount': totalAmount,
      'date': Timestamp.now(),
      'soldBy': 'adminId',
    };

    try {
      await salesDatabaseHelper.addSale(saleData);

      // Update stock for each item
      for (var item in cart) {
        String productId = item['id'];
        int quantity = item['quantity'];

        QuerySnapshot productQuery = await FirebaseFirestore.instance
            .collection('products')
            .where('id', isEqualTo: int.parse(productId))
            .limit(1)
            .get();

        if (productQuery.docs.isNotEmpty) {
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