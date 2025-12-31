import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/presentation/workout/bloc/workout_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/app_outlined_button.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_form_dailog.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_list_element.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';

class WorkoutCreator extends StatefulWidget {
  const WorkoutCreator({super.key});

  @override
  State<WorkoutCreator> createState() => _WorkoutCreatorState();
}

class _WorkoutCreatorState extends State<WorkoutCreator> {
  final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();
  bool isSupersetMode = false;

  @override
  Widget build(BuildContext context) {
    final width = AppTheme.deviceWidth(context);
    final height = AppTheme.deviceHeight(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Workout Creator',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.goNamed(RouterNames.intro.name),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: BlocBuilder<WorkoutBloc, WorkoutState>(
          builder: (context, state) {
            if (state is WorkoutStateSuccess) {
              if (state.unsavedExercises.isNotEmpty) {
                return SizedBox(
                  height: height * 0.8,
                  width: width * 0.95,
                  child: Card(
                    color: Colors.blueGrey.shade200,
                    child: Column(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          'e:${state.exercises.length} w: ${state.workouts.length} u: ${state.unsavedExercises.length}',
                        ),
                        Expanded(
                          child: Padding(
                            padding: .all(4),
                            child: Card(
                              color: Colors.blueGrey.shade100,
                              child: Stack(
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: .max,
                                      children: List.generate(
                                        state.unsavedExercises.length,
                                        (int index) {
                                          return ExerciseListElement(
                                            exercise:
                                                state.unsavedExercises[index],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: .bottomRight,
                                    child: Column(
                                      mainAxisAlignment: .end,
                                      children: [
                                        state.unsavedExercises.length >= 2
                                            ? AppOutlinedButton(
                                                width: width * 0.12,
                                                height: width * 0.12,
                                                padding: .only(right: 4),
                                                onPressed: () {},
                                                backgrounColor:
                                                    Colors.blueGrey.shade100,
                                                child: Image.asset(
                                                  'lib/utils/icons/power.png',
                                                ),
                                              )
                                            : SizedBox(),
                                        AppOutlinedButton(
                                          width: width * 0.12,
                                          height: width * 0.12,
                                          padding: .only(
                                            top: 4,
                                            bottom: 70,
                                            right: 4,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return ExerciseFormDailog(
                                                  title: 'Create new Exercise',
                                                );
                                              },
                                            );
                                          },
                                          backgrounColor:
                                              Colors.blueGrey.shade100,
                                          child: Image.asset(
                                            'lib/utils/icons/plus.png',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentGeometry.bottomCenter,
                                    child: AppOutlinedButton(
                                      width: width * 0.8,
                                      backgrounColor: Colors.blueGrey.shade100,
                                      padding: .all(8),
                                      onPressed: () {
                                        context.read<WorkoutBloc>().add(
                                          WorkoutCreated(
                                            exercises: state.unsavedExercises,
                                          ),
                                        );
                                        context.goNamed(RouterNames.intro.name);
                                      },
                                      child: Text(
                                        'Create workout',
                                        style: TextStyle(fontSize: 20),
                                        textAlign: .center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox(
                  width: width * 0.95,
                  height: height * 0.5,
                  child: Card(
                    color: Colors.blueGrey.shade200,
                    child: Column(
                      mainAxisAlignment: .spaceAround,
                      children: [
                        Text(
                          'e:${state.exercises.length} w: ${state.workouts.length} u: ${state.unsavedExercises.length}',
                        ),
                        Text(
                          "Don't waste time - create your workout here!",
                          textAlign: .center,
                          style: TextStyle(fontSize: 26, fontWeight: .bold),
                        ),
                        AppOutlinedButton(
                          backgrounColor: Colors.blueGrey.shade100,
                          padding: EdgeInsets.only(top: 8),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) {
                              return ExerciseFormDailog(
                                title: 'Create new Exercise',
                              );
                            },
                          ),
                          child: Text(
                            'Add exercise',
                            style: TextStyle(fontSize: 20),
                            textAlign: .center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
            // TODO add shimmer widget
            return Text('Error or other state');
          },
        ),
      ),
    );
  }
}
