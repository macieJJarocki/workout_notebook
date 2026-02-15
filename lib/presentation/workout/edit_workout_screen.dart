import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/data/models/superset.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/superset_list_element.dart';
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
  List<Model> supersetExercises = [];

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
                      .firstWhere((e) => e.uuid == widget.uuid);
                  return Column(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(workout.name, style: TextStyle(fontSize: 20)),

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
                                        final model = workout.exercises[index];
                                        late final Widget renderWidget;
                                        switch (model.runtimeType) {
                                          case == Exercise:
                                            model as Exercise;
                                            renderWidget = ExerciseListElement(
                                              workout: workout,
                                              exercise: model,
                                              modelExerciseIdx: index,
                                              date: widget.date,
                                              isSupersetMode: isSupersetMode,
                                              isNewWorkout: false,
                                              isSupersetElement:
                                                  supersetExercises.contains(
                                                    model,
                                                  ),
                                              onTap: () {
                                                if (!supersetExercises.contains(
                                                      model,
                                                    ) &&
                                                    isSupersetMode) {
                                                  supersetExercises.add(model);
                                                } else {
                                                  supersetExercises.remove(
                                                    model,
                                                  );
                                                }
                                                setState(() {});
                                              },
                                            );
                                          case == Superset:
                                            model as Superset;
                                            renderWidget = GestureDetector(
                                              onTap: () {
                                                if (!supersetExercises.contains(
                                                      model,
                                                    ) &&
                                                    isSupersetMode) {
                                                  supersetExercises.add(model);
                                                } else {
                                                  supersetExercises.remove(
                                                    model,
                                                  );
                                                }
                                              },
                                              child: SupersetListElement(
                                                superset: model,
                                                workout: workout,
                                                date: widget.date,
                                                modelExerciseIdx: index,
                                                isSupersetMode: isSupersetMode,
                                                isNewWorkout: false,
                                                isSupersetElement:
                                                    supersetExercises.contains(
                                                      model,
                                                    ),
                                                onTap: () {
                                                  !supersetExercises.contains(
                                                            model,
                                                          ) &&
                                                          isSupersetMode
                                                      ? supersetExercises.add(
                                                          model,
                                                        )
                                                      : supersetExercises
                                                            .remove(model);
                                                  setState(() {});
                                                },
                                              ),
                                            );
                                        }
                                        return renderWidget;
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
                                                // Reset models assigned as potencial Supereset exercises
                                                setState(() {
                                                  isSupersetMode =
                                                      !isSupersetMode;
                                                  if (isSupersetMode == false) {
                                                    supersetExercises = [];
                                                  }
                                                });
                                              },
                                              backgrounColor: isSupersetMode
                                                  ? Colors.yellowAccent
                                                  : Colors.blueGrey.shade100,
                                              child: Image.asset(
                                                'lib/utils/icons/power.png',
                                                color: isSupersetMode
                                                    ? Colors.redAccent
                                                    : null,
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
                                          // Create new exercise with all necessary infromations
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ExerciseFormDailog(
                                                isNewExercise: true,
                                                model: workout,
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
                      Align(
                        alignment: .bottomCenter,
                        child: AppOutlinedButton(
                          width: width * 0.8,
                          backgrounColor: Colors.blueGrey.shade100,
                          padding: .all(8),
                          onPressed: () {
                            if (isSupersetMode &&
                                supersetExercises.length >= 2) {
                              context.read<NotebookBloc>().add(
                                NotebookSupersetCreated(
                                  supersetExercises: supersetExercises,
                                  date: widget.date,
                                  workout: workout,
                                  // Check position of the first exercise stored in supersetExercises
                                  // TODO In supersetMode error occure when [Exercise] ia added before [Superset] into supersetExercises
                                  supersetPosition: state.unsavedExercises
                                      .indexOf(supersetExercises.first),
                                ),
                              );
                              setState(() {
                                supersetExercises = [];
                                isSupersetMode = !isSupersetMode;
                              });
                            } else {
                              _isWorkoutReadyToStart(workout.exercises)
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
                            }
                          },
                          child: Text(
                            isSupersetMode && supersetExercises.length >= 2
                                ? AppLocalizations.of(
                                    context,
                                  )!.button_create_superset
                                : AppLocalizations.of(
                                    context,
                                  )!.button_start_workout,
                            style: TextStyle(fontSize: 20, color: Colors.black),
                            textAlign: .center,
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

bool _isWorkoutReadyToStart(List<Model> list) {
  List<bool> isExveryWorkoutElementFullyFilled = [];
  for (var model in list) {
    switch (model.runtimeType) {
      case == Exercise:
        model as Exercise;
        isExveryWorkoutElementFullyFilled.add(_isExerciseFullyFiled(model));
      case == Superset:
        model as Superset;
        model.exercises.map(
          (e) =>
              isExveryWorkoutElementFullyFilled.add(_isExerciseFullyFiled(e)),
        );
    }
  }
  return isExveryWorkoutElementFullyFilled.every(
    (element) => element == true,
  );
}

bool _isExerciseFullyFiled(Exercise exercise) {
  return [
    exercise.weight,
    exercise.sets,
    exercise.repetitions,
  ].every((e) => e != null);
}
