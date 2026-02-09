import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/superset.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_list_element.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/widgets/app_dailog.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';

class SupersetListElement extends StatefulWidget {
  const SupersetListElement({
    super.key,
    this.date,
    this.workout,
    this.modelExerciseIdx,
    required this.superset,
    required this.isSupersetMode,
    required this.isSupersetElement,
    required this.isNewWorkout,
    required this.onTap,
  });
  final Superset superset;
  final bool isSupersetMode;
  final bool isSupersetElement;
  final bool isNewWorkout;
  final Workout? workout;
  final DateTime? date;
  final int? modelExerciseIdx;
  final Function() onTap;

  @override
  State<SupersetListElement> createState() => _SupersetListElementState();
}

class _SupersetListElementState extends State<SupersetListElement> {
  @override
  Widget build(BuildContext context) {
    final width = AppTheme.deviceWidth(context);
    // TODO superset.exercises.length > 1 ? SupersetListElement : ExerciseListElement

    return Card(
      color: widget.isSupersetElement ? Colors.red : Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: .only(left: width * .14),
                  child: Text(
                    widget.superset.name,
                    textAlign: .center,
                  ),
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
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
                          title: AppLocalizations.of(
                            context,
                          )!.dailog_delete_exercise,
                          actions: [
                            AppOutlinedButton(
                              padding: EdgeInsetsGeometry.zero,
                              backgrounColor: Colors.blueGrey.shade200,
                              onPressed: () {
                                context.read<NotebookBloc>().add(
                                  NotebookEntityDeleted(
                                    model: widget.superset,
                                    date: widget.date,
                                    workout: widget.workout,
                                    modelExerciseIdx: widget.modelExerciseIdx,
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
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: widget.superset.exercises.map(
                  (e) {
                    final idx = widget.superset.exercises.indexOf(e);
                    return ExerciseListElement(
                      exercise: e,
                      model: widget.superset,
                      workout: widget.workout,
                      date: widget.date,
                      isNewWorkout: widget.isNewWorkout,
                      isSupersetMode: widget.isSupersetMode,
                      modelExerciseIdx: widget.modelExerciseIdx,
                      supersetExerciseIdx: idx,
                      isSupersetElement: widget.isSupersetElement,
                      onTap: widget.onTap,
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
