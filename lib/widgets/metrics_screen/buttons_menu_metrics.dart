import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/Student.dart';
import 'package:la_dinamica_app/providers/actual_student_grades_provider.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/select_date_range_metrics.dart';


class ButtonsMenu extends ConsumerWidget {
  final List<String> options;
  final double screenWidth;
  final Student student;

  const ButtonsMenu({
    super.key, 
    required this.options,
    required this.screenWidth,
    required this.student
    });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDateProviderMetrics);
    final today = DateTime.parse(ref.watch(dateProvider).today);
    DateTime lastDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(4, (index) {
        final value = index + 1;
        final isSelected = selected == value;
        return GestureDetector(
          onTap: () {
            ref.read(selectedDateProviderMetrics.notifier).state = value;
            switch (value) {
              case 1:
                ref.read(studentGradesProvider(student).notifier).loadExamResults(student,'last',null,null);
              case 2:
                lastDate = today.subtract(Duration(days: 30));
                ref.read(studentGradesProvider(student).notifier).loadExamResults(student,'range',lastDate, today);
              case 3:
                lastDate = today.subtract(Duration(days: 360));
                ref.read(studentGradesProvider(student).notifier).loadExamResults(student,'range',lastDate, today);
              case 4:
                ref.read(studentGradesProvider(student).notifier).loadExamResults(student,'all',null,null);
              default:
                ref.read(studentGradesProvider(student).notifier).loadExamResults(student,'last',null,null);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            height: screenWidth * 0.1,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.blueAccent : Colors.grey,
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              options[value-1],
              style: TextStyle(
                fontSize: 18,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }),
    );
  }
}
