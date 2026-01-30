import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/exercise.dart';
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
    this.date,
    this.index,
    this.menuItems,
    this.onTap,
    required this.exercise,
    required this.isNewWorkout,
    required this.isSupersetMode,
  });
  final Exercise exercise;
  final bool isNewWorkout;
  final Workout? workout;
  final DateTime? date;
  final int? index;
  final List<PopupMenuItem>? menuItems;
  final bool isSupersetMode;
  final void Function()? onTap;

  @override
  State<ExerciseListElement> createState() => _ExerciseListElementState();
}

class _ExerciseListElementState extends State<ExerciseListElement> {
  bool isSupersetElement = false;

  @override
  Widget build(BuildContext context) {
    final width = AppTheme.deviceWidth(context);
    final List<PopupMenuItem> dafaultMenuItems = [
      PopupMenuItem(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => widget.isNewWorkout
                // called in CreateWorkoutScreen
                ? AppOneFieldDailog(
                    title: AppLocalizations.of(context)!.dailog_edit_exercise,
                    model: widget.exercise,
                    onPressed: (String name) =>
                        context.read<NotebookBloc>().add(
                          NotebookEntityEdited(
                            model: widget.exercise.copyWith(name: name),
                          ),
                        ),
                  )
                // called in EditWorkoutScreen
                : ExerciseFormDailog(
                    isNewExercise: false,
                    exercise: widget.exercise,
                    workout: widget.workout,
                    date: widget.date,
                    title: AppLocalizations.of(context)!.dailog_edit_exercise,
                  ),
          );
        },
        child: ListTile(
          title: Text(
            'Edit',
            textAlign: .center,
            style: TextStyle(fontSize: 18, color: Colors.blue),
          ),
          contentPadding: .zero,
        ),
      ),

      PopupMenuItem(
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
                    if (widget.workout != null) {
                      context.read<NotebookBloc>().add(
                        NotebookEntityEdited(
                          model: widget.workout!,
                          date: widget.date,
                          exerciseIdx: widget.index,
                        ),
                      );
                    } else {
                      context.read<NotebookBloc>().add(
                        NotebookEntityDeleted(model: widget.exercise),
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
        child: ListTile(
          title: Text(
            'Delete',
            textAlign: .center,
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
          contentPadding: .zero,
        ),
      ),
    ];

    return BlocBuilder<NotebookBloc, NotebookState>(
      builder: (context, state) {
        if (state is NotebookSuccess) {
          return GestureDetector(
            onTap: () {
              widget.isSupersetMode
                  ? setState(() {
                      isSupersetElement = !isSupersetElement;
                    })
                  : null;
              widget.onTap != null ? widget.onTap!() : null;
            },
            child: Card(
              color: _getExerciseColor(
                isSupersetElement,
                widget.exercise.isCompleted,
              ),
              child: ListTile(
                contentPadding: .symmetric(horizontal: 4),
                title: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: .only(
                          left: width * .12,
                        ),
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
                          itemBuilder: (context) => dafaultMenuItems,
                        ),
                      ],
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    ExerciseDataElement(
                      fieldName: AppLocalizations.of(
                        context,
                      )!.string_weight,
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
                      fieldName: AppLocalizations.of(
                        context,
                      )!.string_sets,
                      fieldValue: widget.exercise.sets,
                      iconPath: 'lib/utils/icons/sets.png',
                      isNewWorkout: widget.isNewWorkout,
                      color: Colors.blueGrey.shade100,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          // TODO shimmer widget
          return Container(
            color: Colors.blueGrey.shade200,
            child: Text(
              'Mock Exercise List Element',
              textAlign: .center,
            ),
          );
        }
      },
    );
  }
}

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
