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
import 'package:workout_notebook/utils/widgets/app_snack_bar.dart';

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
      onTap: () => widget.dateService.compareDates(widget.date)
          ? showDialog(
              context: context,
              builder: (context) {
                // TODO when tere is no workout error occure "(Null check operator used on a null value)"
                // when savedWorkouts.length == 0 :)
                return workouts.isNotEmpty ||
                        workoutsAssigned[dateAsString]!.isNotEmpty
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
                                    height:
                                        AppTheme.deviceHeight(context) * 0.3,
                                    decoration: AppTheme.boxDecoration(
                                      backgrounColor: Colors.blueGrey.shade200,
                                    ),
                                    child: ListView.builder(
                                      itemCount: workoutsAssigned[dateAsString]!
                                          .length,
                                      itemBuilder: (context, index) {
                                        return BlocBuilder<
                                          NotebookBloc,
                                          NotebookState
                                        >(
                                          builder: (context, state) {
                                            final workout =
                                                workoutsAssigned[dateAsString]![index];
                                            return Container(
                                              margin: .only(
                                                top: 8,
                                                right: 8,
                                                left: 8,
                                              ),
                                              decoration:
                                                  AppTheme.boxDecoration(
                                                    backgrounColor: Colors
                                                        .blueGrey
                                                        .shade100,
                                                  ),
                                              child: GestureDetector(
                                                onLongPress: () {
                                                  context
                                                      .read<NotebookBloc>()
                                                      .add(
                                                        NotebookEntityDeleted(
                                                          model: workout,
                                                          date: widget.date,
                                                        ),
                                                      );
                                                  context.pop();
                                                },
                                                onTap: () {
                                                  context.goNamed(
                                                    RouterNames.edit.name,
                                                    extra: [
                                                      workout.uuid,
                                                      widget.date,
                                                    ],
                                                  );
                                                  context.pop();
                                                },
                                                child: ListTile(
                                                  contentPadding: .zero,
                                                  title: Text(
                                                    workout.name,
                                                    textAlign: .center,
                                                    style: TextStyle(
                                                      overflow: .ellipsis,
                                                    ),
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
                                  AppSnackBar.build(
                                    message: AppLocalizations.of(
                                      context,
                                    )!.snack_bar_assign_workout,
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
                              context.goNamed(RouterNames.create.name);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.button_add,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      );
              },
            )
          : null,
      child: Container(
        margin: _getMargin(widget.date.day),
        decoration: AppTheme.boxDecoration(
          backgrounColor: widget.dateService.compareDates(widget.date)
              ? _getColor(workoutsAssigned, widget.date)
              : Colors.grey.shade400,
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

Color _getColor(Map<String, List<Workout>> workoutsAssigned, DateTime date) {
  late Color color;
  switch (workoutsAssigned.containsKey(date.toString())) {
    case true:
      if ((workoutsAssigned[date.toString()] as List<Workout>).every(
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
