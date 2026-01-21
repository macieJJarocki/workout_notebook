import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_form_dailog.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_list_element.dart';
import 'package:workout_notebook/utils/app_form_validator.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/enums/hive_enums.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';
import 'package:workout_notebook/utils/widgets/app_form_field.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';

class EditWorkoutScreen extends StatefulWidget {
  const EditWorkoutScreen({
    super.key,
    required this.workout,
    required this.date,
  });

  final Workout workout;
  final DateTime date;

  @override
  State<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.workout.name);
  }

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
          onPressed: () => context.goNamed(RouterNames.intro.name),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: SizedBox(
          height: height * 0.8,
          width: width * 0.95,
          child: Card(
            color: Colors.blueGrey.shade200,
            child: Column(
              mainAxisAlignment: .spaceBetween,
              children: [
                // Text(
                //   '${(context.read<NotebookBloc>().state as NotebookSuccess).workoutsAssigned[widget.date.toString()]!.firstWhere(
                //     (e) => e.uuid == widget.workout.uuid,
                //   ).exercises}',
                // ),
                AppFormField(
                  name: AppLocalizations.of(context)!.string_name,
                  focusNode: null,
                  validator: AppFormValidator.validateNameField,
                  controller: nameController,
                  onChange: () =>
                      widget.workout.copyWith(name: nameController.text),
                  padding: .symmetric(horizontal: 8),
                  backgroundColor: Colors.blueGrey.shade100,
                ),
                Expanded(
                  child: Padding(
                    padding: .all(4),
                    child: Card(
                      color: Colors.blueGrey.shade100,
                      child: Stack(
                        children: [
                          BlocBuilder<NotebookBloc, NotebookState>(
                            builder: (context, state) {
                              if (state is NotebookSuccess) {
                                final workout = state
                                    .workoutsAssigned[widget.date.toString()]!
                                    .firstWhere(
                                      (e) => e.uuid == widget.workout.uuid,
                                    );
                                return SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: .max,
                                    children: List.generate(
                                      widget.workout.exercises.length,
                                      (int index) {
                                        return ExerciseListElement(
                                          isNewWorkout: false,
                                          exercise: workout.exercises[index],
                                          workout: workout,
                                          date: widget.date,
                                          index: index,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }
                              return SizedBox();
                            },
                          ),
                          Align(
                            alignment: .bottomRight,
                            child: Column(
                              mainAxisAlignment: .end,
                              children: [
                                widget.workout.exercises.length >= 2
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
                                          workout: widget.workout,
                                          date: widget.date,
                                          title: AppLocalizations.of(
                                            context,
                                          )!.dailog_create_exercise,
                                        );
                                      },
                                    );
                                  },
                                  backgrounColor: Colors.blueGrey.shade100,
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
                                    model: widget.workout,
                                    date: widget.date,
                                  ),
                                );
                                context.goNamed(RouterNames.intro.name);
                              },
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.button_create_workout,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
