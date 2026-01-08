import 'package:flutter/material.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/utils/app_theme.dart';

class WorkoutListViewElement extends StatelessWidget {
  const WorkoutListViewElement({
    super.key,
    this.workout,
    this.onLongPress,
    required this.onTap,
  });
  final Workout? workout;
  final void Function() onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: .all(4),
        width: AppTheme.deviceWidth(context) * 0.85,
        decoration: AppTheme.boxDecoration(
          backgrounColor: Colors.blueGrey.shade200,
        ),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: workout != null
              ? [Text(workout.toString())]
              : [Text('Add workout')],
        ),
      ),
    );
  }
}
