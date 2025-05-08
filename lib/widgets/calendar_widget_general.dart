import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';

class CalendarButton extends ConsumerWidget {
  const CalendarButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(dateProvider);

    return IconButton(
      icon: const Icon(Icons.calendar_today),
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.parse(selectedDate),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          ref.read(dateProvider.notifier).state = picked.toString().split(' ')[0];
        }
      },
    );
  }
}
