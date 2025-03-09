import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/dropdown_decoration.dart';
import 'package:inventory_management_app/common/space.dart';
import 'package:inventory_management_app/data/provider/sales_provider.dart';
import 'package:provider/provider.dart';

class MonthYearSelector extends StatelessWidget {
  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  MonthYearSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final salesProvider = Provider.of<SalesProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: dropdownDecoration,
            value: salesProvider.selectedMonth,
            onChanged: (newMonth) {
              salesProvider.updateMonthYear(
                  newMonth!, salesProvider.selectedYear);
            },
            items: List.generate(
                12,
                (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text(months[index]),
                    )),
          ),
        ),
        vSpace,
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: dropdownDecoration,
            value: salesProvider.selectedYear,
            onChanged: (newYear) {
              salesProvider.updateMonthYear(
                  newYear!, salesProvider.selectedYear);
            },
            items: List.generate(
                5,
                (index) => DropdownMenuItem(
                      value: DateTime.now().year - index,
                      child: Text((DateTime.now().year - index).toString()),
                    )),
          ),
        ),
      ],
    );
  }
}
