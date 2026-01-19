import 'package:flutter/material.dart';
import 'package:workout_notebook/utils/app_theme.dart';

class ExerciseDataElement extends StatelessWidget {
  const ExerciseDataElement({
    super.key,
    required this.fieldName,
    required this.fieldValue,
    required this.iconPath,
    required this.isNewWorkout,
  });

  final String fieldName;
  final dynamic fieldValue;
  final String iconPath;
  final bool isNewWorkout;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppTheme.deviceWidth(context) * 0.27,
      height: AppTheme.deviceHeight(context) * 0.13,
      child: Card(
        color: Colors.blueGrey.shade100,
        child: Column(
          mainAxisAlignment: .spaceEvenly,
          children: [
            Padding(
              padding: .only(top: 2),
              child: Container(
                width: AppTheme.deviceWidth(context) * 0.1,
                padding: .all(6),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade200,
                  borderRadius: .circular(100),
                  boxShadow: kElevationToShadow[6],
                ),
                child: Image.asset(
                  color: Colors.black.withValues(alpha: 0.7),
                  iconPath,
                ),
              ),
            ),
            fieldValue == null
                ? SizedBox()
                : Text(
                    fieldValue.toString(),
                    style: TextStyle(
                      fontWeight: .bold,
                      overflow: .ellipsis,
                      fontSize: 16,
                    ),
                  ),
            Text(
              fieldName,
              style: TextStyle(
                fontSize: 12,
                fontStyle: .italic,
                color: Colors.blueGrey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
