import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';
import 'package:inventory_management_app/common/text.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actionsList;
  const CustomAppBar({super.key, required this.title, this.actionsList});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text28(title: title),
        backgroundColor: mainColor,
        foregroundColor: white,
        actions: actionsList);
  }
}
