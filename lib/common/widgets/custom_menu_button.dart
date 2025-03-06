import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';
import 'package:inventory_management_app/common/space.dart';
import 'package:inventory_management_app/common/text.dart';

class MenuButton extends StatelessWidget {
  final String text;
  final Widget page;
  const MenuButton({
    super.key,
    required this.text, required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
                color: mainColor, borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: TextW22(
                text: text,
              ),
            ),
          ),
        ),
        space
      ],
    );
  }
}
