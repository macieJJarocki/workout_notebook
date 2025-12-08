import 'package:flutter/material.dart';

class ExerciseFormField extends StatefulWidget {
  // TODO stateful widget is necessary?
  const ExerciseFormField({
    super.key,
    required this.name,
    this.keyboardType,
    // TODO add validator
    // required this.validator,
  });

  final String name;
  // TODO add validator
  // final String? Function(String? value) validator;
  final TextInputType? keyboardType;
  @override
  State<ExerciseFormField> createState() => _ExerciseFormFieldState();
}

class _ExerciseFormFieldState extends State<ExerciseFormField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
      child: TextFormField(
        controller: _controller,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          label: Text(widget.name),
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
