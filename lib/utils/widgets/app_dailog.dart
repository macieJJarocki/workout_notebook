import 'package:flutter/material.dart';

class AppDailog extends StatelessWidget {
  const AppDailog({
    super.key,
    required this.title,
    required this.actions,
    this.content,
    this.onPressed,
    this.controllers,
    this.focusNodes,
    this.extra,
  });
  final String title;
  final Widget? content;
  final List<Widget> actions;
  final VoidCallback? onPressed;
  final List<String>? controllers;
  final List<FocusNode>? focusNodes;
  final Object? extra;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey.shade100,
      alignment: .center,
      title: Text(
        title,
        textAlign: .center,
      ),
      content: content,
      actions: actions,
    );
  }
}
