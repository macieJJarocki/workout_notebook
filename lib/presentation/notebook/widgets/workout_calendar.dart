import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workout_notebook/l10n/app_localizations.dart';
import 'package:workout_notebook/presentation/notebook/widgets/workout_calendar_element.dart';
import 'package:workout_notebook/utils/app_theme.dart';
import 'package:workout_notebook/utils/date_service.dart';

class WorkoutsCalendar extends StatefulWidget {
  const WorkoutsCalendar({
    super.key,
    required this.height,
    required this.service,
  });
  final double height;
  final DateService service;

  @override
  State<WorkoutsCalendar> createState() => _WorkoutsCalendarState();
}

class _WorkoutsCalendarState extends State<WorkoutsCalendar> {
  @override
  Widget build(BuildContext context) {
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
                widget.service.date = widget.service.date.copyWith(
                  month: widget.service.date.month - 1,
                );
                setState(() {});
              },
              icon: Icon(Icons.arrow_back_ios),
            ),

            title: Text(
              AppLocalizations.of(context)!.plan_your_trening,
              style: TextStyle(fontSize: 20, fontWeight: .bold),
              textAlign: .center,
            ),
            subtitle: Text(
              widget.service.dateAsString(locale: 'pl'),
              textAlign: .center,
              style: TextStyle(fontStyle: .italic),
            ),
            trailing: IconButton(
              onPressed: () {
                widget.service.date = widget.service.date.copyWith(
                  month: widget.service.date.month + 1,
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
              itemCount: widget.service.daysInMonth(),
              itemBuilder: (context, index) {
                return CalendarElement(
                  date: DateTime(
                    widget.service.date.year,
                    widget.service.date.month,
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
