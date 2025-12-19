import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/presentation/workout/bloc/workout_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_form_dailog.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_data_element.dart';
import 'package:workout_notebook/utils/app_theme.dart';

class ExerciseListElement extends StatelessWidget {
  final Exercise exercise;

  const ExerciseListElement({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    final workoutBloc = context.watch<WorkoutBloc>();
    return Container(
      // change .all(8) ??
      margin: .only(top: 8, left: 4, right: 4),
      decoration: AppTheme.boxDecoration(
        backgrounColor: Colors.blueGrey.shade200,
        shadow: kElevationToShadow[4],
      ),
      child: ListTile(
        contentPadding: .symmetric(horizontal: 4),
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
                      exercise.name,
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
                        padding: .zero,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ExerciseFormDailog(
                              exercise: exercise,
                              title:
                                  'Adjust the exercise to suit your preferences.',
                            ),
                          );
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
                        padding: .zero,
                        onPressed: () => workoutBloc.add(
                          WorkoutExerciseDeleted(exercise: exercise),
                        ),
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
              fieldValue: exercise.weight,
              iconPath: 'lib/utils/icons/weight1.png',
            ),
            ExerciseDataElement(
              fieldName: 'Reps:',
              fieldValue: exercise.repetitions,
              iconPath: 'lib/utils/icons/rep2.png',
            ),
            ExerciseDataElement(
              fieldName: 'Sets:',
              fieldValue: exercise.sets,
              iconPath: 'lib/utils/icons/sets.png',
            ),
          ],
        ),
      ),
    );
  }
}
