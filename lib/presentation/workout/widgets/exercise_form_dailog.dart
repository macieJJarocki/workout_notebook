import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/presentation/workout/bloc/workout_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/app_form_field.dart';
import 'package:workout_notebook/presentation/workout/widgets/app_outlined_button.dart';
import 'package:workout_notebook/utils/app_form_validator.dart';
import 'package:workout_notebook/utils/app_theme.dart';

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
      title: Text(widget.title),

      backgroundColor: Colors.blueGrey.shade100,
      content: Container(
        decoration: AppTheme.boxDecoration(
          backgrounColor: Colors.blueGrey.shade200,
        ),
        padding: EdgeInsets.all(4),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppFormField(
                controller: nameController,
                focusNode: nameFocusNode,
                name: 'name',
                validator: AppFormValidator.validateNameField,
                nextFocusNode: weightFocusNode,
                backgroundColor: Colors.blueGrey.shade100,
              ),
              AppFormField(
                controller: weightController,
                focusNode: weightFocusNode,
                name: 'weight',
                validator: AppFormValidator.validateWeightField,
                nextFocusNode: repetitionsFocusNode,
                keyboardType: TextInputType.number,
                backgroundColor: Colors.blueGrey.shade100,
              ),
              AppFormField(
                controller: repetitionsController,
                focusNode: repetitionsFocusNode,
                name: 'repetitions',
                validator: AppFormValidator.validateRepetitionsField,
                nextFocusNode: setsFocusNode,
                keyboardType: TextInputType.phone,
                backgroundColor: Colors.blueGrey.shade100,
              ),
              AppFormField(
                controller: setsController,
                focusNode: setsFocusNode,
                name: 'sets',
                validator: AppFormValidator.validateSetsField,
                keyboardType: TextInputType.number,
                backgroundColor: Colors.blueGrey.shade100,
              ),
              AppOutlinedButton(
                padding: EdgeInsetsGeometry.only(top: 4),
                name: widget.exercise == null ? 'Create' : 'Edit',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<WorkoutBloc>().add(
                      widget.exercise == null
                          ? WorkoutExerciseCreated(
                              name: nameController.text,
                              weight: weightController.text,
                              repetitions: repetitionsController.text,
                              sets: setsController.text,
                            )
                          : WorkoutExerciseEdited(
                              id: widget.exercise!.id,
                              modyfiedExerciseData: {
                                'name': nameController.text,
                                'weight': weightController.text,
                                'repetitions': repetitionsController.text,
                                'sets': setsController.text,
                              },
                            ),
                    );
                    context.pop();
                  }
                },
                backgrounColor: Colors.blueGrey.shade100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
