import 'package:flutter/material.dart';
import 'package:workout_notebook/utils/app_theme.dart';

class AppFormField extends StatelessWidget {
  final String name;
  final String? Function(String? value) validator;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final Function()? onChange;

  const AppFormField({
    super.key,
    required this.name,
    required this.validator,
    required this.controller,
    required this.focusNode,
    this.padding,
    this.keyboardType,
    this.nextFocusNode,
    this.backgroundColor,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? .symmetric(vertical: 2, horizontal: 4),
      child: TextFormField(
        scrollPadding: .all(50),
        focusNode: focusNode,
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        onChanged: (value) {
          controller.text = value;
          if (onChange != null) {
            onChange!();
          }
        },
        onFieldSubmitted: (newValue) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
        decoration: InputDecoration(
          label: Text(name, style: TextStyle(fontSize: 14)),
          border: AppTheme.inputBorder,
          filled: true,
          fillColor: backgroundColor,
        ),
      ),
    );
  }
}
