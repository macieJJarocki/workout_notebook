import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_notebook/presentation/workout/bloc/workout_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/app_outlined_button.dart';

class WorkoutPlanDailog extends StatelessWidget {
  const WorkoutPlanDailog({super.key});

  @override
  Widget build(BuildContext context) {
    final workouts =
        (context.read<WorkoutBloc>().state as WorkoutStateSuccess).workouts;
    return AlertDialog(
      backgroundColor: Colors.blueGrey.shade100,
      content: Column(
        mainAxisSize: .min,
        children: [
          Text(
            'Choose workout',
            style: TextStyle(fontSize: 24),
          ),
          Container(
            color: Colors.blueGrey.shade200,
            margin: .only(top: 20),
            child: DropdownMenu(
              label: Text('workouts'),
              dropdownMenuEntries: List.from(
                workouts.map(
                  (e) => DropdownMenuEntry(value: e.id, label: e.id.toString()),
                ),
              ),
              menuStyle: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Colors.blueGrey.shade200,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        AppOutlinedButton(
          backgrounColor: Colors.blueGrey.shade200,
          padding: .zero,
          onPressed: () {},
          child: Text('Save'),
        ),
      ],
    );
  }
}
