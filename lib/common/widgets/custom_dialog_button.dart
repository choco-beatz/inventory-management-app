import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';

class CustomDialogButton extends StatelessWidget {
  final String text;
  final bool imp;

  const CustomDialogButton({super.key, required this.text, this.imp = false});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 60,
      width: width * 0.32,
      decoration: BoxDecoration(
          color: imp ? red : mainColor,
          borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              color: white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
