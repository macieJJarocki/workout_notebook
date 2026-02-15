import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/widgets/app_one_field_dailog.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_form_dailog.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_data_element.dart';
import 'package:workout_notebook/utils/widgets/app_dailog.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';

class ExerciseListElement extends StatefulWidget {
  const ExerciseListElement({
    super.key,
    this.workout,
    this.model,
    this.date,
    this.modelExerciseIdx,
    this.supersetExerciseIdx,
    this.isSupersetElement,
    required this.onTap,
    required this.exercise,
    required this.isNewWorkout,
    required this.isSupersetMode,
  });
  final Workout? workout;
  final Model? model;
  final DateTime? date;
  final int? modelExerciseIdx;
  final int? supersetExerciseIdx;
  final bool? isSupersetElement;
  final Exercise exercise;
  final bool isNewWorkout;
  final bool isSupersetMode;
  final void Function() onTap;

  @override
  State<ExerciseListElement> createState() => _ExerciseListElementState();
}

class _ExerciseListElementState extends State<ExerciseListElement> {
  @override
  Widget build(BuildContext context) {
    final width = AppTheme.deviceWidth(context);

    return BlocBuilder<NotebookBloc, NotebookState>(
      builder: (context, state) {
        if (state is NotebookSuccess) {
          return GestureDetector(
            onTap: () {
              if (widget.isSupersetMode) {
                widget.onTap();
                setState(() {});
              }
            },

            child: SizedBox(
              width: width * 0.86,
              child: Card(
                color: _getExerciseColor(
                  widget.isSupersetElement ?? false,
                  widget.exercise.isCompleted,
                ),
                child: ListTile(
                  contentPadding: .symmetric(horizontal: 4),
                  title: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: .only(left: width * .12),
                          child: Column(
                            children: [
                              Text(
                                widget.exercise.name,
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
                        ),
                      ),
                      Column(
                        children: [
                          PopupMenuButton(
                            itemBuilder: (context) => _popupMenuItems(
                              context,
                              widget.supersetExerciseIdx,
                              widget.modelExerciseIdx,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      ExerciseDataElement(
                        fieldName: AppLocalizations.of(context)!.string_weight,
                        fieldValue: widget.exercise.weight,
                        iconPath: 'lib/utils/icons/weight1.png',
                        isNewWorkout: widget.isNewWorkout,
                        color: Colors.blueGrey.shade100,
                      ),
                      ExerciseDataElement(
                        fieldName: AppLocalizations.of(
                          context,
                        )!.string_repetitions,
                        fieldValue: widget.exercise.repetitions,
                        iconPath: 'lib/utils/icons/rep2.png',
                        isNewWorkout: widget.isNewWorkout,
                        color: Colors.blueGrey.shade100,
                      ),
                      ExerciseDataElement(
                        fieldName: AppLocalizations.of(context)!.string_sets,
                        fieldValue: widget.exercise.sets,
                        iconPath: 'lib/utils/icons/sets.png',
                        isNewWorkout: widget.isNewWorkout,
                        color: Colors.blueGrey.shade100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          // TODO shimmer widget
          return Container(
            color: Colors.blueGrey.shade200,
            child: Text('Mock Exercise List Element', textAlign: .center),
          );
        }
      },
    );
  }

  List<PopupMenuItem> _popupMenuItems(
    BuildContext context,
    int? supersetExerciseIdx,
    int? modelExerciseIdx,
  ) => [
    PopupMenuItem(
      child: ListTile(
        title: Text(
          AppLocalizations.of(context)!.button_edit,
          textAlign: .center,
          style: TextStyle(fontSize: 18, color: Colors.blue),
        ),
        contentPadding: .zero,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return widget.isNewWorkout
                // called in CreateWorkoutScreen
                ? AppOneFieldDailog(
                    title: AppLocalizations.of(context)!.dailog_edit_exercise,
                    model: widget.exercise,
                    onPressed: (String name) {
                      context.read<NotebookBloc>().add(
                        NotebookEntityEdited(
                          model: widget.exercise.copyWith(name: name),
                          supersetExerciseIdx: supersetExerciseIdx,
                          modelExercisesIdx: modelExerciseIdx,
                        ),
                      );
                    },
                  )
                // called in EditWorkoutScreen
                : ExerciseFormDailog(
                    //TODO This model produce error but workout no
                    // model: widget.model,
                    model: widget.workout,
                    exercise: widget.exercise,
                    date: widget.date,
                    supersetExerciseIdx: supersetExerciseIdx,
                    modelExerciseIdx: modelExerciseIdx,
                    isNewExercise: false,
                    title: AppLocalizations.of(context)!.dailog_edit_exercise,
                  );
          },
        );
      },
    ),
    PopupMenuItem(
      child: ListTile(
        title: Text(
          AppLocalizations.of(context)!.button_delete,
          textAlign: .center,
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
        contentPadding: .zero,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AppDailog(
            title: AppLocalizations.of(context)!.dailog_delete_exercise,
            actions: [
              AppOutlinedButton(
                padding: EdgeInsetsGeometry.zero,
                backgrounColor: Colors.blueGrey.shade200,
                onPressed: () {
                  context.read<NotebookBloc>().add(
                    NotebookEntityDeleted(
                      model: widget.model ?? widget.exercise,
                      workout: widget.workout,
                      date: widget.date,
                      modelExerciseIdx: widget.modelExerciseIdx,
                      supersetExerciseIdx: widget.supersetExerciseIdx,
                    ),
                  );
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
    ),
  ];
  // TODO extract this as helper function
  Color _getExerciseColor(bool isSupersetElement, bool isExerciseCompleted) {
    final Color color;
    if (isSupersetElement) {
      color = Colors.orangeAccent;
    } else {
      isExerciseCompleted
          ? color = Colors.green
          : color = Colors.blueGrey.shade200;
    }
    return color;
  }
}
