import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/workouts_calendar.dart';
import 'package:workout_notebook/presentation/workout/widgets/workouts_list_view.dart';
import 'package:workout_notebook/utils/app_theme.dart';

class WorkoutIntro extends StatelessWidget {
  const WorkoutIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final height = AppTheme.deviceHeight(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueGrey.shade100,
      body: SafeArea(
        child: BlocBuilder<NotebookBloc, NotebookState>(
          builder: (context, state) {
            if (state is NotebookSuccess) {
              return Column(
                mainAxisAlignment: .spaceEvenly,
                children: [
                  WorkoutsCalendar(
                    height: height * 0.45,
                  ),
                  WorkoutsListView(
                    height: height * 0.3,
                    itemCount: state.savedWorkouts.length,
                    workouts: state.savedWorkouts,
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
