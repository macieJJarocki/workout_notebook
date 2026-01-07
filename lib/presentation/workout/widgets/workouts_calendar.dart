import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/widgets/app_dailog.dart';
import 'package:workout_notebook/utils/widgets/app_outlined_button.dart';

class WorkoutsCalendar extends StatelessWidget {
  const WorkoutsCalendar({
    super.key,
    required this.height,
  });
  final double height;

  @override
  Widget build(BuildContext context) {
    final workouts =
        (context.read<NotebookBloc>().state as NotebookSuccess).savedWorkouts;
    final DateTime dateNow = DateTime.now();
    final int daysInMonth = DateUtils.getDaysInMonth(
      dateNow.year,
      dateNow.month,
    );
    return Container(
      height: height,
      decoration: AppTheme.boxDecoration(
        backgrounColor: Colors.blueGrey.shade200,
      ),
      margin: EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: .spaceBetween,
        children: [
          Container(
            margin: .directional(top: 20, bottom: 20, start: 8, end: 8),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Icon(Icons.arrow_back_ios),
                Text(
                  'Plan your trening',
                  style: TextStyle(fontSize: 20, fontWeight: .bold),
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.8,
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
                    builder: (context) => AppDailog(
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
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        AppOutlinedButton(
                          backgrounColor: Colors.blueGrey.shade200,
                          padding: .zero,
                          onPressed: () {},
                          child: Text(
                            'Save',
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
