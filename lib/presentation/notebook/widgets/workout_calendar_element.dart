import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/date_service.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';
import 'package:workout_notebook/utils/widgets/app_dailog.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';

class CalendarElement extends StatefulWidget {
  const CalendarElement({
    super.key,
    required this.date,
    required this.dateService,
  });
  final DateTime date;
  final DateService dateService;
  @override
  State<CalendarElement> createState() => _CalendarElementState();
}

class _CalendarElementState extends State<CalendarElement> {
  String uuid = '';

  @override
  Widget build(BuildContext context) {
    final workouts =
        (context.watch<NotebookBloc>().state as NotebookSuccess).savedWorkouts;

    final bool isDateAssigned = workouts.any(
      (element) => element.assignedDates.contains(widget.date),
    );

    final workoutsWithDate = workouts
        .where(
          (element) => element.assignedDates.contains(widget.date),
        )
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
                    isDateAssigned
                        ? Container(
                            margin: .only(top: 8),
                            height: AppTheme.deviceHeight(context) * 0.3,
                            decoration: AppTheme.boxDecoration(
                              backgrounColor: Colors.blueGrey.shade200,
                            ),
                            child: ListView.builder(
                              itemCount: workoutsWithDate.length,
                              itemBuilder: (context, index) {
                                return BlocBuilder<NotebookBloc, NotebookState>(
                                  builder: (context, state) {
                                    return Container(
                                      margin: .only(
                                        top: 8,
                                        right: 8,
                                        left: 8,
                                      ),
                                      decoration: AppTheme.boxDecoration(
                                        backgrounColor:
                                            Colors.blueGrey.shade100,
                                      ),
                                      child: GestureDetector(
                                        onLongPress: () {
                                          workouts[index].assignedDates.remove(
                                            widget.date,
                                          );
                                          context.read<NotebookBloc>().add(
                                            NotebookWorkoutEdited(
                                              workout: workouts[index],
                                            ),
                                          );
                                          context.pop();
                                        },
                                        child: ListTile(
                                          contentPadding: .zero,
                                          title: Row(
                                            mainAxisAlignment: .spaceAround,
                                            children: [
                                              Text(
                                                '${AppLocalizations.of(context)!.string_name}: ${workoutsWithDate[index].name}',
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
                                                value:
                                                    workouts[index].isCompleted,
                                                onChanged: (value) => context
                                                    .read<NotebookBloc>()
                                                    .add(
                                                      NotebookWorkoutEdited(
                                                        workout: workouts[index]
                                                            .copyWith(
                                                              isCompleted:
                                                                  value,
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
                        dropdownMenuEntries: List.from(
                          workouts.map(
                            (e) => DropdownMenuEntry(
                              value: e.uuid,
                              label: e.name,
                            ),
                          ),
                        ),
                        menuStyle: MenuStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.blueGrey.shade200,
                          ),
                        ),
                        onSelected: (value) {
                          setState(() {
                            uuid = value as String;
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
                      if (uuid.isNotEmpty) {
                        context.read<NotebookBloc>().add(
                          NotebookWorkoutDateAssigned(
                            uuid: uuid,
                            date: widget.date,
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
          backgrounColor: isDateAssigned
              ? Colors.green
              : Colors.blueGrey.shade50,
        ),
        child: Center(
          child: Text(
            (widget.date.day).toString(),
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
