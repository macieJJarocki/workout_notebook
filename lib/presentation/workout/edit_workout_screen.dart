import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/utils/widgets/app_snack_bar.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_form_dailog.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_list_element.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';

class EditWorkoutScreen extends StatefulWidget {
  const EditWorkoutScreen({
    super.key,
    required this.uuid,
    required this.date,
  });

  final String uuid;
  final DateTime date;

  @override
  State<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  late Workout workout;

  bool isSupersetMode = false;

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
                  workout = state.workoutsAssigned[widget.date.toString()]!
                      .firstWhere(
                        (e) => e.uuid == widget.uuid,
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
                                          isSupersetMode: isSupersetMode,
                                          isNewWorkout: false,
                                          exercise:
                                              (workout.exercises
                                                  as List<Exercise>)[index],
                                          workout: workout,
                                          date: widget.date,
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
                                              onPressed: () {
                                                setState(() {
                                                  isSupersetMode =
                                                      !isSupersetMode;
                                                });
                                              },
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
                                                date: widget.date,
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
                          _workoutCanEditOrStart(
                                workout.exercises as List<Exercise>,
                              )
                              ? context.goNamed(
                                  RouterNames.active.name,
                                  extra: [workout.uuid, widget.date],
                                )
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  AppSnackBar.build(
                                    message: AppLocalizations.of(
                                      context,
                                    )!.snack_bar_empty_exercise,
                                  ),
                                );
                        },
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.button_start_workout,
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

bool _workoutCanEditOrStart(List<Exercise> list) => list
    .map((e) {
      return [e.weight, e.sets, e.repetitions].every((p) => p != null);
    })
    .every((e) => e == true);
