import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/data/services/date_service.dart';
import 'package:workout_notebook/utils/enums/hive_enums.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';
import 'package:workout_notebook/utils/widgets/app_dailog.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';

class CalendarElement extends StatefulWidget {
  CalendarElement({
    super.key,
    required this.date,
  });

  final DateTime date;
  final DateService dateService = DateService(dateNow: DateTime.now());

  @override
  State<CalendarElement> createState() => _CalendarElementState();
}

class _CalendarElementState extends State<CalendarElement> {
  Workout? dropdownMenuSecection;

  @override
  Widget build(BuildContext context) {
    final String dateAsString = widget.date.toString();

    final workoutsAssigned =
        (context.watch<NotebookBloc>().state as NotebookSuccess)
            .workoutsAssigned;

    final workouts =
        (context.watch<NotebookBloc>().state as NotebookSuccess).savedWorkouts;

    final List<DropdownMenuEntry> dropdownMenuItems = workouts
        .map((e) => DropdownMenuEntry(value: e, label: e.name))
        .toList();

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => workouts.isNotEmpty
            ? AppDailog(
                title: AppLocalizations.of(
                  context,
                )!.dailog_choose_workout,
                content: Column(
                  mainAxisSize: .min,
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    // TODO inject locale
                    Text(
                      widget.dateService.dateAsString(
                        pattern: 'MMMMEEEEd',
                        locale: 'pl',
                        date: widget.date,
                      ),
                    ),
                    workoutsAssigned.containsKey(dateAsString)
                        ? Container(
                            margin: .only(top: 8),
                            height: AppTheme.deviceHeight(context) * 0.3,
                            decoration: AppTheme.boxDecoration(
                              backgrounColor: Colors.blueGrey.shade200,
                            ),
                            child: ListView.builder(
                              itemCount: workoutsAssigned[dateAsString]!.length,
                              itemBuilder: (context, index) {
                                return BlocBuilder<NotebookBloc, NotebookState>(
                                  builder: (context, state) {
                                    final workout =
                                        workoutsAssigned[dateAsString]![index];
                                    return Container(
                                      margin: .only(top: 8, right: 8, left: 8),
                                      decoration: AppTheme.boxDecoration(
                                        backgrounColor:
                                            Colors.blueGrey.shade100,
                                      ),
                                      child: GestureDetector(
                                        onLongPress: () {
                                          context.read<NotebookBloc>().add(
                                            NotebookEntityDeleted(
                                              model: workout,
                                              date: widget.date,
                                            ),
                                          );
                                          context.pop();
                                        },
                                        onTap: () => context.goNamed(
                                          RouterNames.creator.name,
                                          extra: [workout, widget.date],
                                        ),
                                        child: ListTile(
                                          contentPadding: .zero,
                                          title: Row(
                                            mainAxisAlignment: .spaceAround,
                                            children: [
                                              Text(
                                                '${AppLocalizations.of(context)!.string_name}: ${workout.name}',
                                                textAlign: .center,
                                              ),
                                            ],
                                          ),
                                          subtitle: Row(
                                            mainAxisAlignment: .center,
                                            children: [
                                              Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.string_workout_done,
                                              ),
                                              Checkbox.adaptive(
                                                value: workout.isCompleted,
                                                onChanged: (value) => context
                                                    .read<NotebookBloc>()
                                                    .add(
                                                      NotebookEntityEdited(
                                                        date: widget.date,
                                                        model: workout.copyWith(
                                                          isCompleted: value,
                                                        ),
                                                      ),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        : SizedBox(),
                    Container(
                      margin: .only(top: 8),
                      color: Colors.blueGrey.shade200,
                      child: DropdownMenu(
                        label: Text(
                          AppLocalizations.of(context)!.string_workouts,
                        ),
                        dropdownMenuEntries: dropdownMenuItems,
                        menuStyle: MenuStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.blueGrey.shade200,
                          ),
                        ),
                        onSelected: (value) {
                          setState(() {
                            dropdownMenuSecection = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                actions: [
                  AppOutlinedButton(
                    backgrounColor: Colors.blueGrey.shade200,
                    padding: .zero,
                    onPressed: () {
                      if (dropdownMenuSecection != null) {
                        context.read<NotebookBloc>().add(
                          NotebookEntityCreated(
                            key: DataBoxKeys.other,
                            workout: dropdownMenuSecection,
                            date: widget.date,
                            // TODO this looks bad(name is not needed)
                            name: '',
                          ),
                        );
                        context.pop();
                      } else {
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(
                                context,
                              )!.snack_bar_assign_workout,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: .bold,
                                color: Colors.black,
                              ),
                              textAlign: .center,
                            ),
                            backgroundColor: Colors.white,
                            duration: Duration(seconds: 1),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadiusGeometry.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.button_save,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              )
            : AppDailog(
                title: AppLocalizations.of(
                  context,
                )!.dailog_first_create_workout,
                actions: [
                  AppOutlinedButton(
                    backgrounColor: Colors.blueGrey.shade200,
                    padding: .zero,
                    onPressed: () {
                      context.goNamed(RouterNames.creator.name);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.button_add,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
      ),
      child: Container(
        margin: _getMargin(widget.date.day),
        decoration: AppTheme.boxDecoration(
          backgrounColor: _getColor2(workoutsAssigned, widget.date),
        ),
        child: Center(
          child: Text(
            '${widget.date.day}',
            style: TextStyle(fontWeight: .bold),
          ),
        ),
      ),
    );
  }
}

EdgeInsetsGeometry _getMargin(int index) {
  if (index % 7 == 1) {
    return .only(top: 2, bottom: 2, left: 6, right: 2);
  } else if (index % 7 == 0) {
    return .only(top: 2, bottom: 2, left: 2, right: 6);
  }
  return .all(2);
}

Color _getColor2(Map<String, List<Workout>> workoutAssigned, DateTime date) {
  late Color color;
  switch (workoutAssigned.containsKey(date.toString())) {
    case true:
      if ((workoutAssigned[date.toString()] as List<Workout>).every(
        (e) => e.isCompleted,
      )) {
        color = Colors.green;
      } else {
        color = Colors.orangeAccent;
      }
    case false:
      color = Colors.blueGrey.shade100;
  }
  return color;
}
