import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';
import 'package:workout_notebook/utils/widgets/app_dailog.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';

class CalendarElement extends StatefulWidget {
  const CalendarElement({super.key, required this.date});
  final DateTime date;

  @override
  State<CalendarElement> createState() => _CalendarElementState();
}

class _CalendarElementState extends State<CalendarElement> {
  String uuid = '';

  @override
  Widget build(BuildContext context) {
    final workouts =
        (context.read<NotebookBloc>().state as NotebookSuccess).savedWorkouts;
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => workouts.isNotEmpty
            ? AppDailog(
                title: 'Choose workout',
                content: Column(
                  mainAxisSize: .min,
                  children: [
                    Container(
                      color: Colors.blueGrey.shade200,
                      child: DropdownMenu(
                        label: Text('workouts'),
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
                            date: DateTime(
                              widget.date.year,
                              widget.date.month,
                              widget.date.day,
                            ),
                          ),
                        );
                        context.pop();
                      } else {
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Assign workout!',
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
                                topLeft: Radius.circular(
                                  20,
                                ),
                                topRight: Radius.circular(
                                  20,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              )
            : AppDailog(
                title: 'First create workout',
                actions: [
                  AppOutlinedButton(
                    backgrounColor: Colors.blueGrey.shade200,
                    padding: .zero,
                    onPressed: () {
                      context.goNamed(RouterNames.creator.name);
                    },
                    child: Text('Add workout', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
      ),
      child: Container(
        margin: _getMargin(widget.date.day),
        decoration: AppTheme.boxDecoration(
          backgrounColor: Colors.blueGrey.shade100,
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
