import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_data_element.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';
import 'package:workout_notebook/utils/widgets/app_dailog.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';

class ActiveWorkoutScreen extends StatelessWidget {
  const ActiveWorkoutScreen({
    super.key,
    required this.date,
    required this.uuid,
  });
  final DateTime date;
  final String uuid;

  @override
  Widget build(BuildContext context) {
    final double height = AppTheme.deviceHeight(context);
    final double width = AppTheme.deviceWidth(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.string_workout_active,
          style: TextStyle(fontWeight: .bold, fontSize: 30),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.goNamed(RouterNames.workout.name),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: SizedBox(
          height: height * 0.85,
          width: width * 0.95,
          child: Card(
            color: Colors.blueGrey.shade200,
            child: BlocBuilder<NotebookBloc, NotebookState>(
              builder: (context, state) {
                if (state is NotebookSuccess) {
                  final workout = state.workoutsAssigned[date.toString()]!
                      .firstWhere((e) => e.uuid == uuid);
                  final exercises = workout.exercises;
                  return Column(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      SizedBox(
                        height: height * 0.7,
                        width: width * 0.9,
                        child: ListView.builder(
                          itemCount: exercises.length,
                          itemBuilder: (context, index) {
                            final exercise = exercises[index] as Exercise;
                            return Card(
                              color: Colors.blueGrey.shade100,
                              child: ListTile(
                                contentPadding: .symmetric(horizontal: 8),
                                title: Text(
                                  exercise.name,
                                  textAlign: .center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: .bold,
                                  ),
                                ),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: .spaceEvenly,
                                      children: [
                                        ExerciseDataElement(
                                          fieldName: AppLocalizations.of(
                                            context,
                                          )!.string_weight,
                                          fieldValue: exercise.weight,
                                          color: Colors.blueGrey.shade200,
                                          iconPath:
                                              'lib/utils/icons/weight1.png',
                                          isNewWorkout: false,
                                        ),
                                        ExerciseDataElement(
                                          fieldName: AppLocalizations.of(
                                            context,
                                          )!.string_repetitions,
                                          fieldValue: exercise.repetitions,
                                          iconPath: 'lib/utils/icons/rep2.png',
                                          isNewWorkout: false,
                                          color: Colors.blueGrey.shade200,
                                        ),
                                        ExerciseDataElement(
                                          fieldName: AppLocalizations.of(
                                            context,
                                          )!.string_sets,
                                          fieldValue: exercise.sets,
                                          iconPath: 'lib/utils/icons/sets.png',
                                          isNewWorkout: false,
                                          color: Colors.blueGrey.shade200,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: .only(
                                        left: 5,
                                        right: width * 0.1,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: .spaceBetween,
                                        children: [
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.string_exercise_done,
                                          ),
                                          Checkbox.adaptive(
                                            value: exercise.isCompleted,
                                            onChanged: (value) {
                                              final exercisesEdited = workout
                                                  .exercises
                                                  .map<Exercise>(
                                                    (e) {
                                                      e as Exercise;
                                                      if (exercise.uuid ==
                                                          e.uuid) {
                                                        e = e.copyWith(
                                                          isCompleted: value,
                                                        );
                                                      }
                                                      return e;
                                                    },
                                                  )
                                                  .toList();

                                              context.read<NotebookBloc>().add(
                                                NotebookEntityEdited(
                                                  date: date,
                                                  model: workout.copyWith(
                                                    exercises: exercisesEdited,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      AppOutlinedButton(
                        width: width * 0.8,
                        backgrounColor: Colors.blueGrey.shade200,
                        padding: .all(8),
                        onPressed: () {
                          if (exercises.every(
                            (e) {
                              e as Exercise;
                              return e.isCompleted == true;
                            },
                          )) {
                            context.goNamed(RouterNames.workout.name);
                            context.read<NotebookBloc>().add(
                              NotebookEntityEdited(
                                date: date,
                                model: workout.copyWith(
                                  isCompleted: true,
                                ),
                              ),
                            );
                          }
                          showDialog(
                            context: context,
                            builder: (context) => AppDailog(
                              title: AppLocalizations.of(
                                context,
                              )!.dailog_workout_done,
                              content: Text(
                                textAlign: .center,
                                AppLocalizations.of(
                                  context,
                                )!.string_workout_not_completed,
                                style: TextStyle(fontSize: 16),
                              ),
                              actions: [
                                AppOutlinedButton(
                                  backgrounColor: Colors.blueGrey.shade200,
                                  padding: .zero,
                                  onPressed: () {
                                    context.read<NotebookBloc>().add(
                                      NotebookEntityEdited(
                                        date: date,
                                        model: workout.copyWith(
                                          isCompleted: true,
                                        ),
                                      ),
                                    );
                                    context.goNamed(
                                      RouterNames.workout.name,
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.button_end,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.button_end,
                          textAlign: .center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                // TODO shimmer widget
                return SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}
