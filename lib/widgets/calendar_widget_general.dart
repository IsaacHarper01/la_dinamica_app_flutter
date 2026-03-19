import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/attendant_students_provider.dart';

class CalendarButton extends ConsumerWidget {
  const CalendarButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(dateProvider).today;

    return IconButton(
      icon: Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.parse(selectedDate),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          ref.read(dateProvider.notifier).setToday(picked.toString().split(' ')[0]);
          ref.read(studentsAttendanceProvider.notifier).fetchAttendanceToday(ref.read(dateProvider).today);
        }
      },
    );
  }
}
