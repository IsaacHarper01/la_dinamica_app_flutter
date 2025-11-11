import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/bar_grades_indicator.dart';

class TotalGrades extends StatefulWidget {
  final ExamResults grade;

  const TotalGrades({
    super.key,
    required this.grade,
  });

  @override
  State<TotalGrades> createState() => _TotalGradesState();
}

class _TotalGradesState extends State<TotalGrades> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> examTree = jsonDecode(widget.grade.tscore!); //change this
    Map<String, dynamic> examTypes = jsonDecode(widget.grade.types!);
    Map<String, dynamic> totalMetrics = jsonDecode(widget.grade.tscore!);
    Map<String, dynamic> totalSubmetrics = jsonDecode(widget.grade.grades!);

    List<String> metrics = examTree.keys.toList();
    return Center(
      child: SizedBox(
        child: Column(
          children: [
          Text(widget.grade.evaluation!.name!, style: GoogleFonts.gochiHand(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: metrics.length,
              itemBuilder: (context, index){
                final List<dynamic> subMetrics = examTree[metrics[index]]!;
                if (subMetrics.isNotEmpty) {
                  return ExpandableList(
                  title: metrics[index], 
                  items: subMetrics,
                  totalMetric: double.parse(totalMetrics[metrics[index]]),
                  totalSubmetrics: totalSubmetrics,
                  ); 
                }else {
                return StatBar(label: metrics[index], filled: double.parse(totalMetrics[metrics[index]]));
                }
              }
            ),
          ]
        ),
      ),
    );
  }
}

class ExpandableList extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final double totalMetric;
  final Map<String, dynamic> totalSubmetrics;

  const ExpandableList({
    super.key, 
    required this.title, 
    required this.items, 
    required this.totalMetric,
    required this.totalSubmetrics,
    });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: StatBar(label: title, filled: totalMetric),
      children: items
          .map((item) => ListTile(
                title: Text("$item :     ${totalSubmetrics[item]}"),
              ))
          .toList(),
    );
  }
}