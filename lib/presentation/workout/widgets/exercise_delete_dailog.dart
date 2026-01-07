import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/presentation/widgets/app_outlined_button.dart';

class ExerciseDeleteDailog extends StatelessWidget {
  final Workout? workout;
  final Exercise exercise;

  const ExerciseDeleteDailog({
    super.key,
    this.workout,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey.shade100,
      title: Center(
        child: Text('Are you sure, you want to delete this exercise?'),
      ),
      actions: [
        AppOutlinedButton(
          padding: EdgeInsetsGeometry.zero,
          backgrounColor: Colors.blueGrey.shade200,
          onPressed: () {
            context.read<NotebookBloc>().add(
              NotebookExerciseDeleted(id: exercise.id),
            );
            context.pop();
          },
          child: Text(
            'Delete',
            style: TextStyle(fontSize: 20),
            textAlign: .center,
          ),
        ),
      ],
    );
  }
}
