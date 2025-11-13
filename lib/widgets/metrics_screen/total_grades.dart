import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/actual_student_grades_provider.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/bar_grades_indicator.dart';

class TotalGrades extends ConsumerStatefulWidget {
  final ExamResults exam;
  final String studentId;

  const TotalGrades({
    super.key,
    required this.exam,
    required this.studentId,
  });

  @override
  ConsumerState<TotalGrades> createState() => _TotalGradesState();
}

class _TotalGradesState extends ConsumerState<TotalGrades> {
  @override
  Widget build(BuildContext context) {

    double total = ref.read(studentGradesProvider.notifier).calculateActualTotal(widget.studentId, widget.exam);
    final Map<String, double> tscores = ref.read(studentGradesProvider.notifier).adaptTscoresperStudent(widget.exam)[widget.studentId]!;

    return Center(
      child: SizedBox(
        child: Column(
          children: [
            Text(widget.exam.evaluation!.name!, style: GoogleFonts.gochiHand(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
            ExpandableList(
                  title: widget.exam.evaluation!.name!, 
                  metricIds: tscores.keys.toList(),
                  metricNames: jsonDecode(widget.exam.metric_names!),
                  totalMetric: total,
                  tscores: tscores,
                  ), 
            ]
          ),
        )
      );
  }
}

class ExpandableList extends StatelessWidget {
  final String title;
  final List<String> metricIds;
  final Map<String,dynamic> metricNames;
  final double totalMetric;
  final Map<String, dynamic> tscores;

  const ExpandableList({
    super.key, 
    required this.title, 
    required this.metricIds,
    required this.metricNames, 
    required this.totalMetric,
    required this.tscores,
    });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: StatBar(label: title, filled: totalMetric/10),
      children: metricIds
          .map((item) => ListTile(
                title: Text("${metricNames[item]} :     ${tscores[item]/10}"),
              ))
          .toList(),
    );
  }
}