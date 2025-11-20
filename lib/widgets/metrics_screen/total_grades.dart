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
    final gradesState = ref.watch(studentGradesProvider(widget.studentId));
    
    return gradesState.when(
      error: (e,st)=> Center(child: Text('Error al cargar los datos $e'),), 
      loading: ()=> Center(child: CircularProgressIndicator(),),
      data:(grades) {
        final examName = widget.exam.evaluation!.name!;
        return Center(
          child: SizedBox(
            child: Column(
              children: [
                Text(examName, style: GoogleFonts.gochiHand(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                ExpandableList(
                      title: examName, 
                      metricIds: grades.tscoresPerStudent![examName]!.keys.toList(),
                      metricNames: jsonDecode(widget.exam.metric_names!),
                      totalMetric: grades.examsTotals[examName]!,
                      tscores: grades.tscoresPerStudent[examName]!,
                      grades: grades.gradesPerStudent[examName]!,
                      ), 
                ]
              ),
            )
          );
        },
      );
  }
}

class ExpandableList extends StatelessWidget {
  final String title;
  final List<String> metricIds;
  final Map<String,dynamic> metricNames;
  final double totalMetric;
  final Map<String, dynamic> tscores;
  final Map<String, dynamic> grades;

  const ExpandableList({
    super.key, 
    required this.title, 
    required this.metricIds,
    required this.metricNames, 
    required this.totalMetric,
    required this.tscores,
    required this.grades,
    });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: StatBar(label: title, filled: totalMetric/10),
      children: metricIds
          .map((item) => ListTile(
                title: Text("${metricNames[item]} : ${grades[item]},   Tscore: ${tscores[item]/10}"),
              ))
          .toList(),
    );
  }
}