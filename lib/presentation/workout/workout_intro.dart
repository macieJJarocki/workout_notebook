import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/presentation/workout/bloc/workout_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/app_outlined_button.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';

class WorkoutIntro extends StatelessWidget {
  const WorkoutIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final WorkoutBloc workoutBloc = context.watch<WorkoutBloc>();

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
          width: AppTheme.deviceWidth(context) * 0.8,
          height: AppTheme.deviceHeight(context) * 0.8,
          decoration: AppTheme.boxDecoration(
            backgrounColor: Colors.blueGrey.shade200,
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
              AppOutlinedButton(
                padding: EdgeInsetsGeometry.zero,
                name: 'Create workout',
                onPressed: () => context.goNamed(RouterNames.creator.name),
                backgrounColor: Colors.blueGrey.shade100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
