import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static double deviceWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static OutlineInputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  );

  static Decoration boxDecoration({
    required Color backgrounColor,
    bool hasBorder = true,
    List<BoxShadow>? shadow,
  }) {
    return BoxDecoration(
      border: hasBorder ? BoxBorder.all(color: Colors.black) : null,
      color: backgrounColor,
      boxShadow: shadow,
      borderRadius: BorderRadius.circular(8),
    );
  }
}
