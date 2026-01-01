import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/presentation/workout/widgets/app_form_field.dart';
import 'package:workout_notebook/presentation/workout/widgets/app_outlined_button.dart';
import 'package:workout_notebook/utils/app_form_validator.dart';

class WorkoutDailog extends StatefulWidget {
  final Function(String) rebuildView;
  const WorkoutDailog(
    this.rebuildView, {
    super.key,
  });

  @override
  State<WorkoutDailog> createState() => _WorkoutDailogState();
}

class _WorkoutDailogState extends State<WorkoutDailog> {
  late final TextEditingController nameController = TextEditingController();
  late final FocusNode nameFocusNode;
  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey.shade100,
      title: Text(
        'Enter workout name',
        style: TextStyle(fontWeight: .bold, fontSize: 20),
        textAlign: .center,
      ),
      alignment: .center,
      content: Column(
        mainAxisSize: .min,
        children: [
          AppFormField(
            name: 'name',
            validator: AppFormValidator.validateNameField,
            controller: nameController,
            focusNode: nameFocusNode,
            backgroundColor: Colors.blueGrey.shade200,
          ),
        ],
      ),
      actions: [
        AppOutlinedButton(
          backgrounColor: Colors.blueGrey.shade200,
          padding: .zero,
          onPressed: () {
            widget.rebuildView(nameController.text);
            context.pop();
          },
          child: Text(
            'Create',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
