import 'package:flutter/material.dart';
import 'package:workout_notebook/utils/app_theme.dart';

class ExerciseDataElement extends StatelessWidget {
  const ExerciseDataElement({
    super.key,
    required this.fieldName,
    required this.fieldValue,
    required this.iconPath,
    required this.isNewWorkout,
    required this.color,
  });

  final String fieldName;
  final dynamic fieldValue;
  final String iconPath;
  final bool isNewWorkout;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppTheme.deviceWidth(context) * 0.27,
      height: AppTheme.deviceHeight(context) * 0.13,
      child: Card(
        color: color,
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
            fieldValue != null
                ? Text(
                    _convertDoubleToString(fieldValue),
                    style: TextStyle(
                      fontWeight: .bold,
                      overflow: .ellipsis,
                      fontSize: 16,
                    ),
                  )
                : SizedBox(),
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

String _convertDoubleToString(num value) {
  final String valuAsString = value.toString();
  if (value is double) {
    return valuAsString[valuAsString.length - 1] == '0' &&
            valuAsString[valuAsString.length - 2] == '.'
        ? value.toInt().toString()
        : valuAsString;
  }
  return valuAsString;
}
