import 'package:flutter/material.dart';
import 'package:workout_notebook/data/models/superset.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_list_element.dart';

class SupersetListElement extends StatelessWidget {
  const SupersetListElement({
    super.key,
    required this.superset,
    required this.isSupersetMode,
    required this.width,
  });
  final Superset superset;
  final bool isSupersetMode;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orangeAccent,
      child: Column(
        children: superset.exercises.map(
          (e) {
            return ExerciseListElement(
              exercise: e,
              isNewWorkout: true,
              isSupersetMode: isSupersetMode,
            );
          },
        ).toList(),
      ),
    );
  }
}
