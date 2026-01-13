import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/presentation/notebook/widgets/workout_calendar.dart';
import 'package:workout_notebook/presentation/notebook/widgets/workout_list_view.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/date_service.dart';

class NotebookHomeScreen extends StatelessWidget {
  const NotebookHomeScreen({super.key});

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
                  Text('Platform local name: ${Platform.localeName}'),
                  WorkoutsCalendar(
                    height: height * 0.45,
                    dateService: DateService(dateNow: DateTime.now()),
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
