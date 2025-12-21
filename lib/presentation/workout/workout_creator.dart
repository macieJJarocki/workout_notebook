import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/presentation/workout/bloc/workout_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/app_outlined_button.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_form_dailog.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_list_element.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';

class WorkoutCreator extends StatelessWidget {
  const WorkoutCreator({super.key});

  @override
  Widget build(BuildContext context) {
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
              if (state.exercises.isNotEmpty) {
                return SizedBox(
                  height: AppTheme.deviceHeight(context) * 0.8,
                  width: AppTheme.deviceWidth(context) * 0.95,
                  child: Card(
                    color: Colors.blueGrey.shade200,
                    child: Column(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: .all(4),
                            child: Card(
                              margin: .all(4),
                              color: Colors.blueGrey.shade100,
                              child: Stack(
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: .max,
                                      children: List.generate(
                                        state.exercises.length,
                                        (int index) {
                                          return ExerciseListElement(
                                            exercise: state.exercises[index],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: .bottomRight,
                                    child: Container(
                                      margin: .only(bottom: 4, right: 4),
                                      width:
                                          AppTheme.deviceWidth(context) * 0.13,
                                      height:
                                          AppTheme.deviceWidth(context) * 0.13,
                                      decoration: BoxDecoration(
                                        border: BoxBorder.all(
                                          color: Colors.deepOrange,
                                        ),
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.circular(
                                          8,
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          print('Superset creator');
                                        },
                                        child: Image.asset(
                                          'lib/utils/icons/superset.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        AppOutlinedButton(
                          name: 'Add exercise',
                          backgrounColor: Colors.blueGrey.shade100,
                          padding: .symmetric(vertical: 4),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) {
                              return ExerciseFormDailog(
                                title: 'Create new Exercise',
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox(
                  width: AppTheme.deviceWidth(context) * 0.95,
                  height: AppTheme.deviceHeight(context) * 0.5,
                  child: Card(
                    color: Colors.blueGrey.shade200,
                    child: Column(
                      mainAxisAlignment: .spaceAround,
                      children: [
                        Text(
                          "Don't waste time - create your workout here!",
                          textAlign: .center,
                          style: TextStyle(fontSize: 26, fontWeight: .bold),
                        ),
                        AppOutlinedButton(
                          name: 'Add exercise',
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
