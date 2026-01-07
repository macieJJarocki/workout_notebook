import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/presentation/widgets/app_form_field.dart';
import 'package:workout_notebook/presentation/widgets/app_outlined_button.dart';
import 'package:workout_notebook/utils/app_form_validator.dart';

class ExerciseFormDailog extends StatefulWidget {
  final Exercise? exercise;
  final String title;
  const ExerciseFormDailog({
    super.key,
    this.exercise,
    required this.title,
  });

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

    nameFocusNode = FocusNode();
    weightFocusNode = FocusNode();
    repetitionsFocusNode = FocusNode();
    setsFocusNode = FocusNode();
    nameController = TextEditingController(text: widget.exercise?.name);
    weightController = TextEditingController(
      text: widget.exercise?.weight.toString(),
    );
    repetitionsController = TextEditingController(
      text: widget.exercise?.repetitions.toString(),
    );
    setsController = TextEditingController(
      text: widget.exercise?.sets.toString(),
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
      title: Center(child: Text(widget.title)),
      backgroundColor: Colors.blueGrey.shade100,
      contentPadding: .all(4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppFormField(
                  controller: nameController,
                  padding: .symmetric(horizontal: 8, vertical: 4),
                  focusNode: nameFocusNode,
                  name: 'name',
                  validator: AppFormValidator.validateNameField,
                  nextFocusNode: weightFocusNode,
                  backgroundColor: Colors.blueGrey.shade200,
                ),
                AppFormField(
                  controller: weightController,
                  padding: .symmetric(horizontal: 8, vertical: 4),
                  focusNode: weightFocusNode,
                  name: 'weight',
                  validator: AppFormValidator.validateWeightField,
                  nextFocusNode: repetitionsFocusNode,
                  keyboardType: TextInputType.number,
                  backgroundColor: Colors.blueGrey.shade200,
                ),
                AppFormField(
                  controller: repetitionsController,
                  padding: .symmetric(horizontal: 8, vertical: 4),
                  focusNode: repetitionsFocusNode,
                  name: 'repetitions',
                  validator: AppFormValidator.validateRepetitionsField,
                  nextFocusNode: setsFocusNode,
                  keyboardType: TextInputType.phone,
                  backgroundColor: Colors.blueGrey.shade200,
                ),
                AppFormField(
                  controller: setsController,
                  padding: .symmetric(horizontal: 8, vertical: 4),
                  focusNode: setsFocusNode,
                  name: 'sets',
                  validator: AppFormValidator.validateSetsField,
                  keyboardType: TextInputType.number,
                  backgroundColor: Colors.blueGrey.shade200,
                ),
              ],
            ),
          ),
          AppOutlinedButton(
            padding: EdgeInsetsGeometry.symmetric(vertical: 4),
            backgrounColor: Colors.blueGrey.shade200,
            child: Text(
              widget.exercise == null ? 'Create' : 'Edit',
              style: TextStyle(fontSize: 20),
              textAlign: .center,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<NotebookBloc>().add(
                  widget.exercise == null
                      ? NotebookExerciseCreated(
                          name: nameController.text,
                          weight: weightController.text,
                          repetitions: repetitionsController.text,
                          sets: setsController.text,
                        )
                      : NotebookExerciseEdited(
                          exercise: widget.exercise!.copyWith(
                            name: nameController.text,
                            // TODO ???
                            weight: double.tryParse(weightController.text),
                            repetitions: int.tryParse(
                              repetitionsController.text,
                            ),
                            sets: int.tryParse(setsController.text),
                          ),
                        ),
                );
                context.pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
