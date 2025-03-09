import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';
import 'package:inventory_management_app/common/text.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.subTitle2,
  });

  final String title;
  final String subTitle;
  final String subTitle2;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: mainColor,
      child: ListTile(
        title: TextW22(
          text: title,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextW16(text: subTitle),
            TextW16(text: subTitle2),
          ],
        ),
      ),
    );
  }
}
