import 'package:flutter/material.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_data_element.dart';
import 'package:workout_notebook/utils/app_theme.dart';

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
      // change .all(8) ??
      margin: .only(top: 8, left: 4, right: 4, bottom: 8),
      decoration: AppTheme.boxDecoration(
        backgrounColor: Colors.blueGrey.shade200,
        shadow: kElevationToShadow[4],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(2),
        title: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: .only(left: 8, bottom: 4),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.black,
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
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    SizedBox(
                      height: AppTheme.deviceWidth(context) * 0.05,
                      width: AppTheme.deviceWidth(context) * 0.05,
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        padding: .all(0),
                        onPressed: () {
                          print('edit clicked');
                        },
                      ),
                    ),
                    SizedBox(
                      width: AppTheme.deviceWidth(context) * 0.05,
                    ),
                    SizedBox(
                      height: AppTheme.deviceWidth(context) * 0.05,
                      width: AppTheme.deviceWidth(context) * 0.05,
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        padding: .all(0),
                        onPressed: () {
                          print('delete clicked');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        subtitle: Row(
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
      ),
    );
  }
}
