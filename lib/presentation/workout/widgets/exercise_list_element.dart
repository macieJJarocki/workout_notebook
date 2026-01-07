import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_form_dailog.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_data_element.dart';
import 'package:workout_notebook/utils/widgets/app_dailog.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';

class ExerciseListElement extends StatelessWidget {
  final Exercise exercise;

  const ExerciseListElement({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AppDailog(
            title: 'Are you sure, you want to delete this exercise?',
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
          ),
        );
      },
      onTap: () => showDialog(
        context: context,
        builder: (context) => ExerciseFormDailog(
          exercise: exercise,
          title: 'Adjust the exercise to suit your preferences.',
        ),
      ),
      child: Card(
        color: exercise.isCompleted
            ? Colors.lightGreen
            : Colors.blueGrey.shade200,
        child: ListTile(
          isThreeLine: true,
          contentPadding: .symmetric(horizontal: 4),
          title: Column(
            children: [
              Text(
                '${exercise.name} id${exercise.id}',
                textAlign: .center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: .bold,
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Exercise',
                style: TextStyle(
                  color: Colors.blueGrey.shade600,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          subtitle: Column(
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  ExerciseDataElement(
                    fieldName: 'Weight',
                    fieldValue: exercise.weight,
                    iconPath: 'lib/utils/icons/weight1.png',
                  ),
                  ExerciseDataElement(
                    fieldName: 'Reps',
                    fieldValue: exercise.repetitions,
                    iconPath: 'lib/utils/icons/rep2.png',
                  ),
                  ExerciseDataElement(
                    fieldName: 'Sets',
                    fieldValue: exercise.sets,
                    iconPath: 'lib/utils/icons/sets.png',
                  ),
                ],
              ),
              BlocBuilder<NotebookBloc, NotebookState>(
                builder: (context, state) {
                  return ListTile(
                    title: Text('Exercise done?'),
                    trailing: Checkbox(
                      value: exercise.isCompleted,
                      onChanged: (value) {
                        context.read<NotebookBloc>().add(
                          NotebookExerciseEdited(
                            exercise: exercise.copyWith(isCompleted: value),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
