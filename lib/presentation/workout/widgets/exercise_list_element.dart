import 'package:flutter/material.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_data_element.dart';

class ExerciseListElement extends StatelessWidget {
  final String name;
  final String weight;
  final String repetitions;
  final String sets;

  const ExerciseListElement({
    super.key,
    required this.name,
    required this.weight,
    required this.repetitions,
    required this.sets,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(4),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade200,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(7),
          topRight: Radius.circular(7),
        ),
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          ExerciseDataElement(
            fieldName: 'Weight:',
            fieldValue: weight,
            iconPath: 'lib/utils/icons/weight1.png',
          ),
          ExerciseDataElement(
            fieldName: 'Reps:',
            fieldValue: repetitions,
            iconPath: 'lib/utils/icons/rep2.png',
          ),
          ExerciseDataElement(
            fieldName: 'Sets:',
            fieldValue: sets,
            iconPath: 'lib/utils/icons/sets.png',
          ),
        ],
      ),
    );
  }
}
