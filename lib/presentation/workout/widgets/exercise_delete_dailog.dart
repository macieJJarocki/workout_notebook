import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/presentation/workout/bloc/workout_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/app_outlined_button.dart';

class ExerciseDeleteDailog extends StatelessWidget {
  final Exercise exercise;
  const ExerciseDeleteDailog({super.key, required this.exercise});

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
          name: 'Delete',
          onPressed: () {
            context.read<WorkoutBloc>().add(
              WorkoutExerciseDeleted(exercise: exercise),
            );
            context.pop();
          },
          backgrounColor: Colors.blueGrey.shade200,
        ),
      ],
    );
  }
}
