import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/presentation/workout/bloc/workout_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/app_form_field.dart';
import 'package:workout_notebook/presentation/workout/widgets/app_outlined_button.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_list_element.dart';
import 'package:workout_notebook/utils/app_form_validator.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';

class WorkoutCreator extends StatefulWidget {
  const WorkoutCreator({super.key});

  @override
  State<WorkoutCreator> createState() => _WorkoutCreatorState();
}

class _WorkoutCreatorState extends State<WorkoutCreator> {
  final _formKey = GlobalKey<FormState>();
  // TODO move controler and focusnodes to the AppFormField ??
  late final FocusNode nameFocusNode;
  late final FocusNode weightFocusNode;
  late final FocusNode repetitionsFocusNode;
  late final FocusNode setsFocusNode;
  late final TextEditingController nameController;
  late final TextEditingController weightController;
  late final TextEditingController repetitionsController;
  late final TextEditingController setsController;

  @override
  void initState() {
    super.initState();

    nameFocusNode = FocusNode();
    weightFocusNode = FocusNode();
    repetitionsFocusNode = FocusNode();
    setsFocusNode = FocusNode();
    nameController = TextEditingController();
    weightController = TextEditingController();
    repetitionsController = TextEditingController();
    setsController = TextEditingController();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    nameController.dispose();
    weightFocusNode.dispose();
    weightController.dispose();
    repetitionsFocusNode.dispose();
    repetitionsController.dispose();
    setsFocusNode.dispose();
    setsController.dispose();

    super.dispose();
  }

  void _clearFormFields() {
    nameController.text = '';
    weightController.text = '';
    repetitionsController.text = '';
    setsController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final WorkoutBloc workoutBloc = context.watch<WorkoutBloc>();
    return Scaffold(
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
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              height: AppTheme.deviceHeight(context) * 0.80,
              width: AppTheme.deviceWidth(context) * 0.95,
              child: Column(
                children: [
                  Container(
                    height: AppTheme.deviceHeight(context) * 0.7,
                    width: double.infinity,
                    padding: .all(6),
                    decoration: AppTheme.boxDecoration(
                      backgrounColor: Colors.blueGrey.shade200,
                      shadow: kElevationToShadow[8],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: AppTheme.boxDecoration(
                              backgrounColor: Colors.blueGrey.shade100,
                              shadow: kElevationToShadow[8],
                            ),
                            child: BlocBuilder<WorkoutBloc, WorkoutState>(
                              builder: (context, state) {
                                if (state is WorkoutStateSuccess) {
                                  final exercises = state.exercises;
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: List.generate(
                                        exercises.length,
                                        (int index) {
                                          final exercise =
                                              exercises[index] as Exercise;
                                          return ExerciseListElement(
                                            name: exercise.name,
                                            weight: exercise.weight.toString(),
                                            repetitions: exercise.repetitions
                                                .toString(),
                                            sets: exercise.sets.toString(),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }
                                return Text(
                                  'State is WorkoutFailure or other',
                                );
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: .spaceAround,
                          children: [
                            AppOutlinedButton(
                              name: 'Add exercise',
                              backgrounColor: Colors.blueGrey.shade100,
                              onPressed: () {},
                              padding: EdgeInsets.only(top: 8),
                            ),
                            AppOutlinedButton(
                              name: 'Add superset',
                              backgrounColor: Colors.blueGrey.shade100,
                              onPressed: () {},
                              padding: EdgeInsets.only(top: 8),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: AppTheme.deviceWidth(context) * 0.95,
              child: DraggableScrollableSheet(
                snap: true,
                maxChildSize: 0.56,
                minChildSize: 0.08,
                initialChildSize: 0.09,
                builder: (context, scrollController) {
                  return ListView(
                    controller: scrollController,
                    children: [
                      Container(
                        decoration: AppTheme.boxDecoration(
                          backgrounColor: Colors.blueGrey.shade200,
                        ),
                        child: Column(
                          mainAxisAlignment: .spaceEvenly,
                          children: [
                            Icon(Icons.linear_scale_outlined),
                            Container(
                              decoration: AppTheme.boxDecoration(
                                backgrounColor: Colors.blueGrey.shade100,
                              ),
                              margin: .all(4),
                              child: Column(
                                children: [
                                  Text(
                                    'Create exercise',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Form(
                                    key: _formKey,
                                    autovalidateMode: .onUnfocus,
                                    child: Column(
                                      children: [
                                        // TODO if can generate list of the widgets
                                        AppFormField(
                                          controller: nameController,
                                          focusNode: nameFocusNode,
                                          name: 'name',
                                          validator: AppFormValidator
                                              .validateNameField,
                                          nextFocusNode: weightFocusNode,
                                        ),
                                        AppFormField(
                                          controller: weightController,
                                          focusNode: weightFocusNode,
                                          name: 'weight',
                                          validator: AppFormValidator
                                              .validateWeightField,
                                          nextFocusNode: repetitionsFocusNode,
                                          keyboardType: TextInputType.number,
                                        ),
                                        AppFormField(
                                          controller: repetitionsController,
                                          focusNode: repetitionsFocusNode,
                                          name: 'repetitions',
                                          validator: AppFormValidator
                                              .validateRepetitionsField,
                                          nextFocusNode: setsFocusNode,
                                          keyboardType: TextInputType.phone,
                                        ),
                                        AppFormField(
                                          controller: setsController,
                                          focusNode: setsFocusNode,
                                          name: 'sets',
                                          validator: AppFormValidator
                                              .validateSetsField,
                                          keyboardType: TextInputType.number,
                                        ),
                                      ],
                                    ),
                                  ),
                                  AppOutlinedButton(
                                    name: 'Create',
                                    padding: EdgeInsets.only(top: 8, bottom: 8),
                                    backgrounColor: Colors.blueGrey.shade100,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        workoutBloc.add(
                                          WorkoutExerciseCreated(
                                            name: nameController.text,
                                            weight: weightController.text,
                                            repetitions:
                                                repetitionsController.text,
                                            sets: setsController.text,
                                          ),
                                        );
                                        setState(_clearFormFields);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
