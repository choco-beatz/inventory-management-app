import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';

const dropdownDecoration = InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        labelStyle: TextStyle(color: mainColor, fontSize: 18),
      );