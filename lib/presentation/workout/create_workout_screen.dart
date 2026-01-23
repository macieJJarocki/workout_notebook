import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/utils/enums/hive_enums.dart';
import 'package:workout_notebook/utils/widgets/app_one_field_dailog.dart';
import 'package:workout_notebook/utils/widgets/app_form_field.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';
import 'package:workout_notebook/presentation/workout/widgets/exercise_list_element.dart';
import 'package:workout_notebook/utils/app_form_validator.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';

class CreateWorkoutScreen extends StatefulWidget {
  CreateWorkoutScreen({this.workoutName, super.key});
  String? workoutName;

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode exerciseNameFocusNode = FocusNode();
  bool isSupersetMode = false;

  @override
  void dispose() {
    nameController.dispose();
    nameFocusNode.dispose();
    exerciseNameFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    try {
      nameController.text =
          widget.workoutName ??
          (context.read<NotebookBloc>().state as NotebookSuccess)
              .unsavedWorkoutName;
    } catch (e) {
      nameController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = AppTheme.deviceWidth(context);
    final height = AppTheme.deviceHeight(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.string_workout_creator,
          style: TextStyle(fontWeight: .bold, fontSize: 30),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.goNamed(RouterNames.workout.name),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: BlocConsumer<NotebookBloc, NotebookState>(
          listener: (context, state) {
            if (state is NotebookSuccess) {
              nameController.text = state.unsavedWorkoutName;
            }
          },
          builder: (context, state) {
            if (state is NotebookSuccess) {
              if (state.unsavedWorkoutName.isNotEmpty) {
                return SizedBox(
                  height: height * 0.8,
                  width: width * 0.95,
                  child: Card(
                    color: Colors.blueGrey.shade200,
                    child: Column(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        AppFormField(
                          name: AppLocalizations.of(context)!.string_name,
                          focusNode: null,
                          validator: AppFormValidator.validateNameField,
                          controller: nameController,
                          onChange: () {
                            widget.workoutName = nameController.text;
                          },
                          padding: .symmetric(horizontal: 8),
                          backgroundColor: Colors.blueGrey.shade100,
                        ),
                        Expanded(
                          child: Padding(
                            padding: .all(4),
                            child: Card(
                              color: Colors.blueGrey.shade100,
                              child: Stack(
                                children: [
                                  BlocBuilder<NotebookBloc, NotebookState>(
                                    builder: (context, state) {
                                      if (state is NotebookSuccess) {
                                        return SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: .max,
                                            children: List.generate(
                                              state.unsavedExercises.length,
                                              (int index) {
                                                return ExerciseListElement(
                                                  isNewWorkout: true,
                                                  exercise: state
                                                      .unsavedExercises[index],
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                      // TODO shimmer widget
                                      return Text(
                                        'State other than NotebookSuccess',
                                      );
                                    },
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
                                                return AppOneFieldDailog(
                                                  title: AppLocalizations.of(
                                                    context,
                                                  )!.dailog_create_exercise,
                                                  onPressed: (String name) =>
                                                      context
                                                          .read<NotebookBloc>()
                                                          .add(
                                                            NotebookEntityCreated(
                                                              name: name,
                                                              key: DataBoxKeys
                                                                  .exercises,
                                                            ),
                                                          ),
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
                                        context.read<NotebookBloc>().add(
                                          NotebookEntityCreated(
                                            name: nameController.text,
                                            key: DataBoxKeys.workouts,
                                          ),
                                        );
                                        context.goNamed(RouterNames.workout.name);
                                      },
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.button_create_workout,
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
                          AppLocalizations.of(
                            context,
                          )!.string_dont_waste_time_etc,
                          textAlign: .center,
                          style: TextStyle(fontSize: 26, fontWeight: .bold),
                        ),
                        AppOutlinedButton(
                          backgrounColor: Colors.blueGrey.shade100,
                          padding: EdgeInsets.only(top: 8),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AppOneFieldDailog(
                                onPressed: (String name) =>
                                    context.read<NotebookBloc>().add(
                                      NotebookWorkoutNameRequested(name),
                                    ),
                                title: AppLocalizations.of(
                                  context,
                                )!.dailog_create_workout,
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.button_create,
                            style: TextStyle(fontSize: 20),
                            textAlign: .center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else if (state is NotebookLoading) {
              return CircularProgressIndicator.adaptive();
            } else {
              return Text('Error or Initial state');
            }
          },
        ),
      ),
    );
  }
}
