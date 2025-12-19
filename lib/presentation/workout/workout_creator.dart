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
        child: Container(
          height: AppTheme.deviceHeight(context) * 0.8,

          width: AppTheme.deviceWidth(context) * 0.95,
          padding: .all(6),
          decoration: AppTheme.boxDecoration(
            backgrounColor: Colors.blueGrey.shade200,
            shadow: kElevationToShadow[8],
          ),
          child: BlocBuilder<WorkoutBloc, WorkoutState>(
            builder: (context, state) {
              if (state is WorkoutStateSuccess) {
                if (state.exercises.isNotEmpty) {
                  return Column(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(
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
                                width: AppTheme.deviceWidth(context) * 0.13,
                                height: AppTheme.deviceWidth(context) * 0.13,
                                // margin: .only(bottom: 5),
                                decoration: AppTheme.boxDecoration(
                                  backgrounColor: Colors.blueGrey.shade100,
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
                      AppOutlinedButton(
                        name: 'Add exercise',
                        backgrounColor: Colors.blueGrey.shade100,
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) {
                            return ExerciseFormDailog(
                              title: 'Create new Exercise',
                            );
                          },
                        ),
                        padding: EdgeInsets.only(top: 8),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Text('dont waist time create your workaout here'),
                      AppOutlinedButton(
                        name: 'Add exercise',
                        backgrounColor: Colors.blueGrey.shade100,
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) {
                            return ExerciseFormDailog(
                              title: 'Create new Exercise',
                            );
                          },
                        ),
                        padding: EdgeInsets.only(top: 8),
                      ),
                    ],
                  );
                }
              }
              // TODO add shimmer widget
              return Text('Error or other state');
            },
          ),
        ),
      ),
    );
  }
}
