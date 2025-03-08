import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';
import 'package:inventory_management_app/data/provider/customer_provider.dart';
import 'package:inventory_management_app/data/provider/login_provider.dart';
import 'package:inventory_management_app/data/provider/product_provider.dart';
import 'package:inventory_management_app/data/provider/report_provider.dart';
import 'package:inventory_management_app/data/provider/sales_provider.dart';
import 'package:inventory_management_app/view/dashboard_screen.dart';
import 'package:inventory_management_app/view/login_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CustomerProvider()),
        ChangeNotifierProvider(create: (context) => SalesProvider()),
        ChangeNotifierProvider(create: (context) => ReportsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "RUBIK",
          colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
          useMaterial3: true,
        ),
        home: const Authorised(),
      ),
    );
  }
}

class Authorised extends StatelessWidget {
  const Authorised({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<LoginProvider>(context);
    if (authProvider.user != null) {
      return const DashboardScreen();
    }
    return const LoginScreen();
  }
}
