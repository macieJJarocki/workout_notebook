import 'package:flutter/material.dart';

// TODO stateful widget is necessary?
class AppFormField extends StatelessWidget {
  final String name;
  final String? Function(String? value) validator;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;

  const AppFormField({
    super.key,
    required this.name,
    required this.validator,
    required this.controller,
    required this.focusNode,
    this.keyboardType,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // TODO padding?
      padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        onChanged: (value) {
          controller.text = value;
        },
        decoration: InputDecoration(
          // TODO add FormFieldState.errorText
          label: Text(name),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(7),
              topRight: Radius.circular(7),
            ),
          ),
        ),
        onFieldSubmitted: (newValue) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
      ),
    );
  }
}
