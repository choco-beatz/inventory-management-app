import 'package:flutter/material.dart';

class ReportsProvider extends ChangeNotifier {
  String _selectedReport = "Sales Report";

  String get selectedReport => _selectedReport;

  void changeReport(String newReport) {
    _selectedReport = newReport;
    notifyListeners();
  }
}
