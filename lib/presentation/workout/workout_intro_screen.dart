import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_notebook/presentation/workout/bloc/workout_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/workouts_calendar.dart';
import 'package:workout_notebook/presentation/workout/widgets/workouts_list_view.dart';
import 'package:workout_notebook/utils/app_theme.dart';

class WorkoutIntro extends StatelessWidget {
  const WorkoutIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final height = AppTheme.deviceHeight(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: SafeArea(
        
        child: BlocBuilder<WorkoutBloc, WorkoutState>(
          builder: (context, state) {
            if (state is WorkoutStateSuccess) {
              return Column(
                mainAxisAlignment: .spaceEvenly,
                children: [
                  WorkoutsCalendar(
                    height: height * 0.45,
                  ),
                  WorkoutsListView(
                    height: height * 0.3,
                    itemCount: state.workouts.length,
                    workouts: state.workouts,
                  ),
                ],
              );
            }
            return Text('Error state o other');
          },
        ),
      ),
    );
  }
}
