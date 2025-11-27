

import 'package:aws_common/aws_common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/providers/actual_student_grades_provider.dart';
import 'package:la_dinamica_app/widgets/dropown_button.dart';

class ProgresionTimeLine extends ConsumerStatefulWidget {
  final String studentId;
  final Future<void> Function(String) onSelected;
  const ProgresionTimeLine({
    super.key, 
    required this.studentId,
    required this.onSelected
    });

  @override
  ConsumerState<ProgresionTimeLine> createState() => _nameState();
}

class _nameState extends ConsumerState<ProgresionTimeLine> {
  
  @override
  Widget build(BuildContext context) {
    final examGrades = ref.watch(studentGradesProvider(widget.studentId));

    return examGrades.when(
      error: (e,st) => Center(child:  Text("Error al cargar datos $e"),), 
      loading: ()=> Center(child: CircularProgressIndicator(),),
      data: (data) {
        
        final actualExam = data.actualExam;
        final List<String> options = data.metricsPerExam.cast<String>().toList();
        final datos = convertData(data.historicalExamgrades,data.metricsIds,data.actualMetric,actualExam);

        return Container(
          height: 350,
          width: double.infinity,
          child: Column(
            children: [
              OptionDropdown(options: options, onSelected: widget.onSelected),
              Expanded(child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: timeLineProgresion(datos)
                )
              )
            ],
          )
        );
      },
    );
  } 

  bool _isValidDate(String value) {
    try {
      DateTime.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Map<String,dynamic> convertData(
    Map<String,Map<String, Map<String,dynamic>>> historicalGrades, 
    Map<String, Map<String, dynamic>> metricsIds,
    String actualMetric, 
    String actualExam)
    {
      Map<String, dynamic> dateGrades = {};
      final exam = metricsIds[actualExam];
      final metricID = exam!.entries.firstWhere((entrie) => entrie.value == actualMetric).key;
      dateGrades = historicalGrades[actualExam]![metricID]!;
      return dateGrades;
  }


  Widget timeLineProgresion(data){
    final yData = <FlSpot>[];
    double i = 0;
    
    final filteredEntries =
        data.entries.where((entry) => _isValidDate(entry.key)).toList();

    filteredEntries.sort(
      (a, b) => DateTime.parse(a.key).compareTo(DateTime.parse(b.key)),
    );
    final orderedData = Map.fromEntries(filteredEntries);

    for (var key in orderedData.keys) {
      final value = orderedData[key];
      if (value is num) {
        yData.add(FlSpot(i, value.toDouble()));
      }
      i++;
    }
    return Center(
    child:
      LineChart(
            LineChartData(
              minY: 0,
              gridData: const FlGridData(show: true),
              titlesData: const FlTitlesData(
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles:false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  curveSmoothness: 0.2,
                  spots: yData,
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.lightBlue],
                  ), // Use gradient instead of colors
                  barWidth: 3,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [const Color.fromARGB(255, 33, 150, 243).withOpacity(0.2), Colors.lightBlue.withOpacity(0.1)],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }


}