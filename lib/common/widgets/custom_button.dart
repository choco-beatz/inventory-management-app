import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;

  const CustomButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
          color: mainColor, borderRadius: BorderRadius.circular(15)),
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
