import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_form_dailog.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_list_element.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/consts.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';

class EditWorkoutScreen extends StatelessWidget {
  EditWorkoutScreen({
    super.key,
    required this.uuid,
    required this.date,
  });

  final String uuid;
  final DateTime date;
  late Workout workout;

  @override
  Widget build(BuildContext context) {
    final width = AppTheme.deviceWidth(context);
    final height = AppTheme.deviceHeight(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.string_workout_creator,
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
          child: Card(
            color: Colors.blueGrey.shade200,
            child: BlocBuilder<NotebookBloc, NotebookState>(
              builder: (context, state) {
                if (state is NotebookSuccess) {
                  workout = state.workoutsAssigned[date.toString()]!.firstWhere(
                    (e) => e.uuid == uuid,
                  );
                  return Column(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        workout.name,
                        style: TextStyle(fontSize: 20),
                      ),

                      Expanded(
                        child: Padding(
                          padding: .all(4),
                          child: Card(
                            color: Colors.blueGrey.shade100,
                            child: Stack(
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: .max,
                                    children: List.generate(
                                      workout.exercises.length,
                                      (int index) {
                                        return ExerciseListElement(
                                          isNewWorkout: false,
                                          exercise: workout.exercises[index],
                                          workout: workout,
                                          date: date,
                                          index: index,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: .bottomRight,
                                  child: Column(
                                    mainAxisAlignment: .end,
                                    children: [
                                      workout.exercises.length >= 2
                                          ? AppOutlinedButton(
                                              width: width * 0.12,
                                              height: width * 0.12,
                                              padding: .only(right: 4),
                                              onPressed: () {},
                                              backgrounColor:
                                                  Colors.blueGrey.shade100,
                                              child: Image.asset(
                                                'lib/utils/icons/power.png',
                                              ),
                                            )
                                          : SizedBox(),
                                      AppOutlinedButton(
                                        width: width * 0.12,
                                        height: width * 0.12,
                                        padding: .only(
                                          top: 4,
                                          bottom: 70,
                                          right: 4,
                                        ),
                                        onPressed: () {
                                          // Create new exercise
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ExerciseFormDailog(
                                                isNewExercise: true,
                                                workout: workout,
                                                date: date,
                                                title: AppLocalizations.of(
                                                  context,
                                                )!.dailog_create_exercise,
                                              );
                                            },
                                          );
                                        },
                                        backgrounColor:
                                            Colors.blueGrey.shade100,
                                        child: Image.asset(
                                          'lib/utils/icons/plus.png',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentGeometry.bottomCenter,
                                  child: AppOutlinedButton(
                                    width: width * 0.8,
                                    backgrounColor: Colors.blueGrey.shade100,
                                    padding: .all(8),
                                    onPressed: () {
                                      context.read<NotebookBloc>().add(
                                        NotebookEntityEdited(
                                          model: workout,
                                          date: date,
                                        ),
                                      );
                                      context.goNamed(RouterNames.workout.name);
                                    },
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.button_edit,
                                      style: TextStyle(fontSize: 20),
                                      textAlign: .center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AppOutlinedButton(
                        width: width * 0.8,
                        backgrounColor: Colors.blueGrey.shade100,
                        padding: .all(8),
                        onPressed: () {
                          _workoutCanStart(workout.exercises)
                              ? context.goNamed(
                                  RouterNames.active.name,
                                  extra: [workout.uuid, date],
                                )
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.snack_bar_set_exercises_data,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: .bold,
                                        color: Colors.black,
                                      ),
                                      textAlign: .center,
                                    ),
                                    backgroundColor: Colors.white,
                                    duration: snackBarsDuration,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadiusGeometry.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                );
                        },
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.button_start_workout,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          textAlign: .center,
                        ),
                      ),
                    ],
                  );
                }
                // TODO Shimmer widget
                return SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}

bool _workoutCanStart(List<Exercise> list) => list
    .map((e) {
      return [e.weight, e.sets, e.repetitions].every((p) => p != null);
    })
    .every((e) => e == true);
