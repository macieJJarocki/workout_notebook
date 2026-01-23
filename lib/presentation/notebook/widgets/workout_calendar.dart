import 'package:flutter/material.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/widgets/workout_calendar_element.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/data/services/date_service.dart';

class WorkoutsCalendar extends StatefulWidget {
  const WorkoutsCalendar({
    super.key,
    required this.height,
    required this.dateService,
  });
  final double height;
  final DateService dateService;

  @override
  State<WorkoutsCalendar> createState() => _WorkoutsCalendarState();
}

class _WorkoutsCalendarState extends State<WorkoutsCalendar> {
  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = widget.dateService.date;
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
            leading: IconButton(
              onPressed: () {
                if (dateTime.month > DateTime.now().month) {
                  widget.dateService.date = dateTime.copyWith(
                    month: dateTime.month - 1,
                  );
                  setState(() {});
                }
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            title: Text(
              AppLocalizations.of(context)!.plan_your_workout,
              style: TextStyle(fontSize: 20, fontWeight: .bold),
              textAlign: .center,
            ),
            subtitle: Text(
              //TODO  inject locale
              widget.dateService.dateAsString(pattern: "yMMMM", locale: 'pl'),
              textAlign: .center,
              style: TextStyle(fontStyle: .italic),
            ),
            trailing: IconButton(
              onPressed: () {
                widget.dateService.date = widget.dateService.date.copyWith(
                  month: widget.dateService.date.month + 1,
                );
                setState(() {});
              },
              icon: Icon(Icons.arrow_forward_ios),
            ),
          ),
          SizedBox(
            height: widget.height * 0.7,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.dateService.daysInMonth(),
              itemBuilder: (context, index) {
                return CalendarElement(
                  date: DateTime(
                    widget.dateService.date.year,
                    widget.dateService.date.month,
                    index + 1,
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
