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
      padding: .symmetric(horizontal: 6),
      width: AppTheme.deviceWidth(context) * 0.27,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(7),
          topRight: Radius.circular(7),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Column(
                children: [
                  Text(fieldName),
                  Image.asset(
                    iconPath,
                    width: AppTheme.deviceWidth(context) * 0.08,
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    fieldValue.toString(),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.aspectRatio,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
