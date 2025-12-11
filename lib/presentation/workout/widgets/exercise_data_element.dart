import 'package:flutter/material.dart';
import 'package:workout_notebook/utils/app_theme.dart';

class ExerciseDataElement extends StatelessWidget {
  final String fieldName;
  final dynamic fieldValue;
  final String iconPath;
  const ExerciseDataElement({
    super.key,
    required this.fieldName,
    required this.fieldValue,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppTheme.width(context) * 0.25,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(fieldName),
            ],
          ),
          Row(
            mainAxisAlignment: .spaceAround,
            children: [
              Text(fieldValue.toString()),
              Image.asset(
                iconPath,
                width: AppTheme.width(context) * 0.08,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
