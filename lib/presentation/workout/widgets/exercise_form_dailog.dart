import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/utils/widgets/app_form_field.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';
import 'package:workout_notebook/utils/app_form_validator.dart';

class ExerciseFormDailog extends StatefulWidget {
  const ExerciseFormDailog({
    super.key,
    this.exercise,
    this.workout,
    this.date,
    required this.isNewExercise,
    required this.title,
  });
  final Exercise? exercise;
  final String title;
  final Workout? workout;
  final DateTime? date;

  final bool isNewExercise;

  @override
  State<ExerciseFormDailog> createState() => _ExerciseFormDailogState();
}

class _ExerciseFormDailogState extends State<ExerciseFormDailog> {
  final _formKey = GlobalKey<FormState>();
  late final FocusNode nameFocusNode;
  late final FocusNode weightFocusNode;
  late final FocusNode repetitionsFocusNode;
  late final FocusNode setsFocusNode;
  late final TextEditingController nameController;
  late final TextEditingController weightController;
  late final TextEditingController repetitionsController;
  late final TextEditingController setsController;

  @override
  void initState() {
    super.initState();
    // TODO in future init controllers wit assignedWorkouts[date][index], where index is the index of the workout that needs to be edited
    nameFocusNode = FocusNode();
    weightFocusNode = FocusNode();
    repetitionsFocusNode = FocusNode();
    setsFocusNode = FocusNode();
    nameController = TextEditingController(text: widget.exercise?.name);
    weightController = TextEditingController(
      text: widget.exercise?.weight != null
          ? widget.exercise?.weight.toString()
          : '',
    );
    repetitionsController = TextEditingController(
      text: widget.exercise?.weight != null
          ? widget.exercise?.repetitions.toString()
          : '',
    );
    setsController = TextEditingController(
      text: widget.exercise?.weight != null
          ? widget.exercise?.sets.toString()
          : '',
    );
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    nameController.dispose();
    weightFocusNode.dispose();
    weightController.dispose();
    repetitionsFocusNode.dispose();
    repetitionsController.dispose();
    setsFocusNode.dispose();
    setsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title, textAlign: .center),
      backgroundColor: Colors.blueGrey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8),
      ),
      content: ListView(
        shrinkWrap: true,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppFormField(
                  controller: nameController,
                  padding: .symmetric(horizontal: 8, vertical: 4),
                  focusNode: nameFocusNode,
                  name: AppLocalizations.of(context)!.string_name,
                  validator: AppFormValidator.validateNameField,
                  nextFocusNode: weightFocusNode,
                  backgroundColor: Colors.blueGrey.shade200,
                ),
                AppFormField(
                  controller: weightController,
                  padding: .symmetric(horizontal: 8, vertical: 4),
                  focusNode: weightFocusNode,
                  name: AppLocalizations.of(context)!.string_weight,
                  validator: AppFormValidator.validateWeightField,
                  nextFocusNode: repetitionsFocusNode,
                  keyboardType: TextInputType.number,
                  backgroundColor: Colors.blueGrey.shade200,
                ),
                AppFormField(
                  controller: repetitionsController,
                  padding: .symmetric(horizontal: 8, vertical: 4),
                  focusNode: repetitionsFocusNode,
                  name: AppLocalizations.of(context)!.string_repetitions,
                  validator: AppFormValidator.validateRepetitionsField,
                  nextFocusNode: setsFocusNode,
                  keyboardType: TextInputType.phone,
                  backgroundColor: Colors.blueGrey.shade200,
                ),
                AppFormField(
                  controller: setsController,
                  padding: .symmetric(horizontal: 8, vertical: 4),
                  focusNode: setsFocusNode,
                  name: AppLocalizations.of(context)!.string_sets,
                  validator: AppFormValidator.validateSetsField,
                  keyboardType: TextInputType.number,
                  backgroundColor: Colors.blueGrey.shade200,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        AppOutlinedButton(
          padding: EdgeInsetsGeometry.symmetric(vertical: 4),
          backgrounColor: Colors.blueGrey.shade200,
          child: Text(
            widget.exercise == null
                ? AppLocalizations.of(context)!.button_create
                : AppLocalizations.of(context)!.button_edit,
            style: TextStyle(fontSize: 20),
            textAlign: .center,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (widget.isNewExercise) {
                context.read<NotebookBloc>().add(
                  NotebookPlanExerciseAdded(
                    workout: widget.workout!,
                    date: widget.date!,
                    name: nameController.text,
                    weight: weightController.text,
                    repetitions: repetitionsController.text,
                    sets: setsController.text,
                  ),
                );
              } else {
                final exercises = widget.workout!.exercises;
                final editedExercises = exercises.map(
                  (e) {
                    if (e.uuid == widget.exercise!.uuid) {
                      return widget.exercise!.copyWith(
                        name: nameController.text,
                        weight: double.tryParse(weightController.text),
                        repetitions: int.tryParse(repetitionsController.text),
                        sets: int.tryParse(setsController.text),
                      );
                    }
                    return e;
                  },
                ).toList();
                context.read<NotebookBloc>().add(
                  NotebookEntityEdited(
                    date: widget.date as DateTime,
                    model: widget.workout!.copyWith(
                      exercises: editedExercises,
                    ),
                  ),
                );
              }
              context.pop();
            }
          },
        ),
      ],
    );
  }
}
