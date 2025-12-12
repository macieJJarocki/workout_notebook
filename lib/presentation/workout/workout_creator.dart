import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/presentation/workout/bloc/workout_bloc.dart';
import 'package:workout_notebook/presentation/workout/widgets/app_form_field.dart';
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

  @override
  Widget build(BuildContext context) {
    final WorkoutBloc workoutBloc = context.watch<WorkoutBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Creator',
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
          margin: .only(top: 12),
          height: AppTheme.deviceHeight(context) * 0.95,
          width: AppTheme.deviceWidth(context) * 0.95,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: AppTheme.deviceHeight(context) * 0.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade200,
                  boxShadow: kElevationToShadow[8],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
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
                                        return Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: ExerciseListElement(
                                            name: exercise.name,
                                            weight: exercise.weight.toString(),
                                            repetitions: exercise.repetitions
                                                .toString(),
                                            sets: exercise.sets.toString(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }
                              return Text('State is WorkoutFailure or other');
                            },
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: .spaceAround,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          style: AppTheme.buttonBorder(),
                          child: Text(
                            'Add exercise',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: AppTheme.buttonBorder(),
                          child: Text(
                            'Add superset',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DraggableScrollableSheet(
                  maxChildSize: 0.99,
                  minChildSize: 0.19,
                  initialChildSize: 0.2,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade200,

                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: .spaceEvenly,
                          children: [
                            Icon(Icons.linear_scale_outlined),
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
                                  AppFormField(
                                    controller: nameController,
                                    focusNode: nameFocusNode,
                                    name: 'name',
                                    validator:
                                        AppFormValidator.validateNameField,
                                    nextFocusNode: weightFocusNode,
                                  ),
                                  AppFormField(
                                    controller: weightController,
                                    focusNode: weightFocusNode,
                                    name: 'weight',
                                    validator:
                                        AppFormValidator.validateWeightField,
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
                                    validator:
                                        AppFormValidator.validateSetsField,
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                workoutBloc.add(
                                  WorkoutExerciseCreated(
                                    name: nameController.text,
                                    weight: weightController.text,
                                    repetitions: repetitionsController.text,
                                    sets: setsController.text,
                                  ),
                                );
                              },
                              style: AppTheme.buttonBorder(),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
