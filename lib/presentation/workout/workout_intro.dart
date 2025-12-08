import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/presentation/workout/bloc/workout_bloc.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';

class WorkoutIntro extends StatelessWidget {
  const WorkoutIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final WorkoutBloc workoutBloc = context.read<WorkoutBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Intro',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          // TODO Create getters for width and height of the screen
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.red.shade200,
            border: .all(
              color: Colors.black,
            ),
            boxShadow: kElevationToShadow[24],
            borderRadius: .all(
              .circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlocBuilder<WorkoutBloc, WorkoutState>(
                builder: (context, state) {
                  if (state is WorkoutStateSuccess) {
                    return Text(state.workouts.length.toString());
                  }
                  return Text(state.runtimeType.toString());
                },
              ),
              Text(
                'Add your first workout plan here.',
                style: TextStyle(
                  fontSize: 48,
                ),
              ),
              OutlinedButton(
                onPressed: () => context.goNamed(RouterNames.creator.name),
                child: Text(
                  'Create plan',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
