import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/workout_list_view_element.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';

class WorkoutsListView extends StatelessWidget {
  const WorkoutsListView({
    super.key,
    required this.itemCount,
    required this.workouts,
    required this.height,
  });
  final int itemCount;
  final List<Workout> workouts;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: ListView.builder(
        itemCount: itemCount + 1,
        scrollDirection: .horizontal,
        itemBuilder: (context, index) {
          if (index < itemCount) {
            return WorkoutListViewElement(
              workout: workouts[index],
              onTap: () {},              
            );
          }
          // Change width to fill more viewport
          return WorkoutListViewElement(
            onTap: () => context.goNamed(
              RouterNames.creator.name,
              extra: (context.read<NotebookBloc>().state as NotebookSuccess)
                  .unsavedWorkoutName,
            ),
          );
        },
      ),
    );
  }
}
