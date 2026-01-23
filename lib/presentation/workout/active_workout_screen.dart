import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_data_element.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';

class ActiveWorkout extends StatelessWidget {
  const ActiveWorkout({super.key, required this.date, required this.uuid});
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
          height: height * 0.8,
          width: width * 0.95,
          child: Column(
            mainAxisAlignment: .spaceBetween,
            children: [
              BlocBuilder<NotebookBloc, NotebookState>(
                builder: (context, state) {
                  if (state is NotebookSuccess) {
                    final workout = state.workoutsAssigned[date.toString()]!
                        .firstWhere((e) => e.uuid == uuid);
                    final exercises = workout.exercises;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          return Card(
                            color: Colors.blueGrey.shade200,
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
                                    mainAxisAlignment: .spaceBetween,
                                    children: [
                                      ExerciseDataElement(
                                        fieldName: AppLocalizations.of(
                                          context,
                                        )!.string_weight,
                                        fieldValue: exercise.weight,
                                        iconPath: 'lib/utils/icons/weight1.png',
                                        isNewWorkout: false,
                                      ),
                                      ExerciseDataElement(
                                        fieldName: AppLocalizations.of(
                                          context,
                                        )!.string_repetitions,
                                        fieldValue: exercise.repetitions,
                                        iconPath: 'lib/utils/icons/rep2.png',
                                        isNewWorkout: false,
                                      ),
                                      ExerciseDataElement(
                                        fieldName: AppLocalizations.of(
                                          context,
                                        )!.string_sets,
                                        fieldValue: exercise.sets,
                                        iconPath: 'lib/utils/icons/sets.png',
                                        isNewWorkout: false,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: .only(right: width * 0.2),
                                    child: Row(
                                      mainAxisAlignment: .spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.string_exercise_done,
                                        ),
                                        Checkbox.adaptive(
                                          value: workout
                                              .exercises[index]
                                              .isCompleted,
                                          onChanged: (value) {
                                            final exercisesEdited = workout
                                                .exercises
                                                .map(
                                                  (e) {
                                                    if (workout
                                                            .exercises[index]
                                                            .uuid ==
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
                    );
                  }
                  return SizedBox();
                },
              ),
              AppOutlinedButton(
                width: width * 0.8,
                backgrounColor: Colors.blueGrey.shade200,
                padding: .all(8),
                onPressed: () {
                  context.goNamed(RouterNames.workout.name);
                },
                child: Text(
                  AppLocalizations.of(context)!.button_end,
                  textAlign: .center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
