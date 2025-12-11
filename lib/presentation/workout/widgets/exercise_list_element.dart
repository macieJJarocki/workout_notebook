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
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade200,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: .spaceEvenly,
          children: [
            ExerciseDataElement(
              fieldName: 'Weight:',
              fieldValue: weight,
              iconPath: 'lib/utils/icons/weight1.png',
            ),
            // TODO replece icon
            ExerciseDataElement(
              fieldName: 'Repetitions:',
              fieldValue: repetitions,
              iconPath: 'lib/utils/icons/sets.png',
            ),
            ExerciseDataElement(
              fieldName: 'Sets:',
              fieldValue: sets,
              iconPath: 'lib/utils/icons/sets.png',
            ),
          ],
        ),
      ),
    );
  }
}
