import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/utils/widgets/app_one_field_dailog.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_form_dailog.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_data_element.dart';
import 'package:workout_notebook/utils/widgets/app_dailog.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';

class ExerciseListElement extends StatelessWidget {
  const ExerciseListElement({
    super.key,
    this.workout,
    this.date,
    this.index,
    required this.exercise,
    required this.isNewWorkout,
  });
  final Exercise exercise;
  final bool isNewWorkout;
  final Workout? workout;
  final DateTime? date;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AppDailog(
            title: AppLocalizations.of(context)!.dailog_delete_exercise,
            actions: [
              AppOutlinedButton(
                padding: EdgeInsetsGeometry.zero,
                backgrounColor: Colors.blueGrey.shade200,
                onPressed: () {
                  if (workout != null) {
                    context.read<NotebookBloc>().add(
                      NotebookEntityEdited(
                        model: workout!,
                        date: date,
                        exerciseIdx: index,
                      ),
                    );
                  } else {
                    context.read<NotebookBloc>().add(
                      NotebookEntityDeleted(model: exercise),
                    );
                  }

                  context.pop();
                },
                child: Text(
                  AppLocalizations.of(context)!.button_delete,
                  style: TextStyle(fontSize: 20),
                  textAlign: .center,
                ),
              ),
            ],
          ),
        );
      },
      onTap: () => showDialog(
        context: context,
        builder: (context) => isNewWorkout
            // called in CreateWorkoutScreen
            ? AppOneFieldDailog(
                title: AppLocalizations.of(context)!.dailog_edit_exercise,
                model: exercise,
                onPressed: (String name) => context.read<NotebookBloc>().add(
                  NotebookEntityEdited(model: exercise.copyWith(name: name)),
                ),
              )
            // called in EditWorkoutScreen
            : ExerciseFormDailog(
                isNewExercise: false,
                exercise: exercise,
                workout: workout,
                date: date,
                title: AppLocalizations.of(context)!.dailog_edit_exercise,
              ),
      ),
      child: BlocBuilder<NotebookBloc, NotebookState>(
        builder: (context, state) {
          if (state is NotebookSuccess) {
            return Card(
              color: exercise.isCompleted
                  ? Colors.lightGreen
                  : Colors.blueGrey.shade200,
              child: ListTile(
                isThreeLine: !isNewWorkout,
                contentPadding: .symmetric(horizontal: 4),
                title: Column(
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
                      AppLocalizations.of(context)!.string_exercise,
                      style: TextStyle(
                        color: Colors.blueGrey.shade600,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        ExerciseDataElement(
                          fieldName: AppLocalizations.of(
                            context,
                          )!.string_weight,
                          fieldValue: exercise.weight,
                          iconPath: 'lib/utils/icons/weight1.png',
                          isNewWorkout: isNewWorkout,
                        ),
                        ExerciseDataElement(
                          fieldName: AppLocalizations.of(
                            context,
                          )!.string_repetitions,
                          fieldValue: exercise.repetitions,
                          iconPath: 'lib/utils/icons/rep2.png',
                          isNewWorkout: isNewWorkout,
                        ),
                        ExerciseDataElement(
                          fieldName: AppLocalizations.of(context)!.string_sets,
                          fieldValue: exercise.sets,
                          iconPath: 'lib/utils/icons/sets.png',
                          isNewWorkout: isNewWorkout,
                        ),
                      ],
                    ),
                    !isNewWorkout
                        ? ListTile(
                            title: Text(
                              AppLocalizations.of(
                                context,
                              )!.string_exercise_done,
                            ),
                            trailing: Checkbox.adaptive(
                              value: exercise.isCompleted,
                              onChanged: (value) =>
                                  context.read<NotebookBloc>().add(
                                    NotebookEntityEdited(
                                      model: workout!,
                                      date: date!,
                                    ),
                                  ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              color: Colors.blueGrey.shade200,
              child: Text(
                'Mock Exercise List Element',
                textAlign: .center,
              ),
            );
          }
        },
      ),
    );
  }
}
