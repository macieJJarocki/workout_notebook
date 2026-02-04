import 'package:flutter/material.dart';
import 'package:workout_notebook/utils/consts.dart';

class AppSnackBar {
  AppSnackBar._();
  static SnackBar build({required String message}) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 20, fontWeight: .bold, color: Colors.black),
        textAlign: .center,
      ),
      duration: snackBarDuration,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.black,
        ),
        borderRadius: BorderRadiusGeometry.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}
