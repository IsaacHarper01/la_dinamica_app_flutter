import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

class CalendarTimeRangePicker extends StatefulWidget {
  final void Function(DateTime date, TimeRange? range) onSelectionChanged;

  const CalendarTimeRangePicker({super.key, required this.onSelectionChanged});

  @override
  State<CalendarTimeRangePicker> createState() => _CalendarTimeRangePickerState();
}

class _CalendarTimeRangePickerState extends State<CalendarTimeRangePicker> {
  DateTime _selectedDate = DateTime.now();
  TimeRange? _selectedTimeRange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableCalendar(
          focusedDay: _selectedDate,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          calendarStyle: 
            CalendarStyle(defaultTextStyle: TextStyle(color: Color.fromRGBO(204, 208, 207, 1.0)),
                          weekendTextStyle: TextStyle(color: Color.fromRGBO(204, 208, 207, 1.0)),
                          selectedTextStyle: TextStyle(color: Color.fromRGBO(204, 208, 207, 1.0)),
                          rangeStartDecoration: BoxDecoration(color: Color.fromRGBO(155, 168, 171, 1.0))),
          selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
          onDaySelected: (selectedDay, _) {
            setState(() {
              _selectedDate = selectedDay;
            });
            widget.onSelectionChanged(_selectedDate, _selectedTimeRange);
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final result = await showTimeRangePicker(
              context: context,
              start: TimeOfDay(hour: 9, minute: 0),
              end: TimeOfDay(hour: 17, minute: 0),
            );
            if (result != null) {
              setState(() {
                _selectedTimeRange = result;
              });
              widget.onSelectionChanged(_selectedDate, _selectedTimeRange);
            }
          },
          child: const Text("Pick Time Range"),
        ),
        if (_selectedTimeRange != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Time: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
