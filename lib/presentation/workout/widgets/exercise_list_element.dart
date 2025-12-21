import 'package:flutter/material.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_delete_dailog.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_form_dailog.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_data_element.dart';

class ExerciseListElement extends StatelessWidget {
  final Exercise exercise;

  const ExerciseListElement({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => ExerciseDeleteDailog(
            exercise: exercise,
          ),
        );
      },
      onTap: () => showDialog(
        context: context,
        builder: (context) => ExerciseFormDailog(
          exercise: exercise,
          title: 'Adjust the exercise to suit your preferences.',
        ),
      ),
      child: Card(
        color: Colors.blueGrey.shade200,
        child: ListTile(
          contentPadding: .symmetric(horizontal: 4),
          title: Container(
            padding: .only(left: 8),
            child: Column(
              // crossAxisAlignment: .start,
              children: [
                Text(
                  exercise.name,
                  textAlign: .center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: .bold,
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Exercise',
                  style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              ExerciseDataElement(
                fieldName: 'Weight',
                fieldValue: exercise.weight,
                iconPath: 'lib/utils/icons/weight1.png',
              ),
              ExerciseDataElement(
                fieldName: 'Reps',
                fieldValue: exercise.repetitions,
                iconPath: 'lib/utils/icons/rep2.png',
              ),
              ExerciseDataElement(
                fieldName: 'Sets',
                fieldValue: exercise.sets,
                iconPath: 'lib/utils/icons/sets.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
