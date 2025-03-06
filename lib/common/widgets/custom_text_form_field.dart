import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';
import 'package:inventory_management_app/common/space.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.number = false,
    this.multiline = false,
    required this.controller,
    required this.hint,
    required this.label,
  });

  final TextEditingController controller;
  final String hint;
  final String label;
  final bool number;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          maxLength: multiline ? 200 : null,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              labelText: label,
              labelStyle: const TextStyle(color: mainColor, fontSize: 18),
              hintText: hint),
        ),
        space
      ],
    );
  }
}
