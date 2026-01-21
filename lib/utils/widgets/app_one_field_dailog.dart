import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/utils/app_form_validator.dart';
import 'package:workout_notebook/utils/widgets/app_dailog.dart';
import 'package:workout_notebook/utils/widgets/app_form_field.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';

class AppOneFieldDailog extends StatefulWidget {
  const AppOneFieldDailog({
    super.key,
    required this.onPressed,
    required this.title,
    this.model,
  });
  final String title;
  final Function(String) onPressed;
  final Model? model;

  @override
  State<AppOneFieldDailog> createState() => _AppOneFieldDailogState();
}

class _AppOneFieldDailogState extends State<AppOneFieldDailog> {
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.model?.name ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDailog(
      title: widget.title,
      content: Column(
        mainAxisSize: .min,
        children: [
          AppFormField(
            name: AppLocalizations.of(context)!.string_name,
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
            // TODO inspect that
            widget.onPressed(nameController.text);
            context.pop();
            nameController.text = '';
          },
          child: Text(
            AppLocalizations.of(context)!.button_create,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
