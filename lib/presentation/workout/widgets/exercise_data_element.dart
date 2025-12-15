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
      decoration: AppTheme.boxDecoration(
        backgrounColor: Colors.blueGrey.shade100,
        shadow: kElevationToShadow[2],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(fieldName),
                    Image.asset(
                      iconPath,
                      width: AppTheme.deviceWidth(context) * 0.08,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .center,
                  children: [
                    Text(
                      fieldValue.toString(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
