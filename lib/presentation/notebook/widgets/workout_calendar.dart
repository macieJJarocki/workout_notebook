import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';
import 'package:workout_notebook/utils/widgets/app_dailog.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';
import 'package:workout_notebook/utils/widgets/date_service.dart';

class WorkoutsCalendar extends StatefulWidget {
  const WorkoutsCalendar({
    super.key,
    required this.height,
  });
  final double height;

  @override
  State<WorkoutsCalendar> createState() => _WorkoutsCalendarState();
}

class _WorkoutsCalendarState extends State<WorkoutsCalendar> {
  String dropdownMenuValue = '';

  @override
  Widget build(BuildContext context) {
    final workouts =
        (context.read<NotebookBloc>().state as NotebookSuccess).savedWorkouts;
    final DateTime dateNow = DateService.now;
    final int daysInMonth = DateUtils.getDaysInMonth(
      dateNow.year,
      dateNow.month,
    );
    return Container(
      height: widget.height,
      margin: .all(4),
      decoration: AppTheme.boxDecoration(
        backgrounColor: Colors.blueGrey.shade200,
      ),
      child: Column(
        mainAxisAlignment: .spaceAround,
        children: [
          ListTile(
            leading: Icon(Icons.arrow_back_ios),
            title: Text(
              'Plan your trening',
              style: TextStyle(fontSize: 20, fontWeight: .bold),
              textAlign: .center,
            ),
            subtitle: Text('12.12.2026', textAlign: .center),

            trailing: Icon(Icons.arrow_forward_ios),
          ),
          SizedBox(
            height: widget.height * 0.7,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              physics: NeverScrollableScrollPhysics(),
              itemCount: daysInMonth,
              itemBuilder: (context, index) {
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
                                        dropdownMenuValue = value as String;
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
                                  if (dropdownMenuValue.isNotEmpty) {
                                    context.read<NotebookBloc>().add(
                                      NotebookWorkoutDateAssigned(
                                        uuid: dropdownMenuValue,
                                        date: DateTime(
                                          dateNow.year,
                                          dateNow.month,
                                          index + 1,
                                        ),
                                      ),
                                    );
                                    context.pop();
                                  }
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
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
                                child: Text(
                                  'Add workout',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                  ),
                  child: Container(
                    margin: _getMargin(index),
                    decoration: AppTheme.boxDecoration(
                      backgrounColor: Colors.blueGrey.shade100,
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          fontWeight: .bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

EdgeInsetsGeometry _getMargin(int index) {
  if (index % 7 == 0) {
    return .only(top: 2, bottom: 2, left: 6, right: 2);
  } else if (index % 7 == 6) {
    return .only(top: 2, bottom: 2, left: 2, right: 6);
  }
  return .all(2);
}

// TODO add calendar element widget !!!
