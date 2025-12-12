import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static double deviceWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static ButtonStyle buttonBorder() => OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(18),
        topRight: Radius.circular(18),
      ),
    ),
  );
}
