import 'package:flutter/material.dart';
import 'package:workout_notebook/utils/app_theme.dart';

class AppOutlinedButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Color backgrounColor;
  final EdgeInsetsGeometry padding;
  final void Function() onPressed;
  final Widget child;
  const AppOutlinedButton({
    super.key,
    this.width,
    this.height,
    required this.backgrounColor,
    required this.padding,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: padding,
        child: Container(
          width: width,
          height: height,
          decoration: AppTheme.boxDecoration(
            backgrounColor: backgrounColor,
            shadow: kElevationToShadow[2],
          ),
          child: Padding(
            padding: const .all(4),
            child: child,
          ),
        ),
      ),
    );
  }
}
