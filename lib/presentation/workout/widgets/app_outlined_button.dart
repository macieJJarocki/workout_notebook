import 'package:flutter/material.dart';
import 'package:workout_notebook/utils/app_theme.dart';

class AppOutlinedButton extends StatelessWidget {
  final String name;
  final Color backgrounColor;
  final void Function() onPressed;
  EdgeInsetsGeometry padding;
  AppOutlinedButton({
    super.key,
    required this.padding,
    required this.name,
    required this.onPressed,
    required this.backgrounColor,
  });

  @override
  Widget build(BuildContext context) {
    //   return Padding(
    //     padding: const EdgeInsets.only(top: 4),
    //     child: OutlinedButton(
    //       onPressed: onPressed,
    //       style: AppTheme.buttonBorder,
    //       child: Text(
    //         name,
    //         style: TextStyle(fontSize: 14, color: Colors.black),
    //       ),
    //     ),
    //   );
    // }
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: padding,
        child: Container(
          decoration: AppTheme.boxDecoration(
            backgrounColor: backgrounColor,
            shadow: kElevationToShadow[2],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
