import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/providers/actual_student_grades_provider.dart';

class RadarChartExam extends ConsumerStatefulWidget {
  final String studentId;
  const RadarChartExam({super.key, required this.studentId});

  @override
  ConsumerState<RadarChartExam> createState() => _nameState();
}

class _nameState extends ConsumerState<RadarChartExam> {
  
  @override
  Widget build(BuildContext context) {
    final examGrades = ref.watch(studentGradesProvider(widget.studentId));
    
    return examGrades.when(
      error: (e,st)=>Center(child: Text('Error al cargar datos: $e'),), 
      loading: ()=> Center(child: CircularProgressIndicator(),),
      data:(data) {
        final option =data.actualExam;

        final ids = data.metricsIds[option]!.keys.toList();
        final tscores = data.tscoresPerStudent[option];
        final entries = ids
        .map((id) => RadarEntry(value: tscores![id]!))
        .toList();

        
        return entries.length >= 3 ? 
         Container(
                  height: 300,
                  decoration: BoxDecoration(
                    // color: const Color.fromARGB(255, 30, 68, 97),
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: RadarChart(
                    RadarChartData(
                      radarBackgroundColor: Colors.transparent,
                      radarBorderData: BorderSide(width: 0.5),
                      borderData: FlBorderData(show: false),
                      tickCount: 5,                 // number of inner rings
                      ticksTextStyle: const TextStyle(color: Colors.grey),
                      tickBorderData: const BorderSide(color: Colors.grey,width: 0.2),

                      gridBorderData: const BorderSide(color: Colors.grey),

                      getTitle: (index, angle) {
                        return RadarChartTitle(
                          text: data.metricsIds[option]![ids[index]],
                          angle: angle,
                        );
                      },

                      dataSets: [
                        RadarDataSet(
                          fillColor: Color.fromRGBO(76, 142, 204, 0.498),
                          dataEntries: entries,
                            )
                          ]
                        ),
                    duration:Duration(milliseconds: 150),
                    curve:Curves.slowMiddle,
                    ),
                ):
          Center(child: Text('No hay suficientes metricas para construir esta grafica'),); 
          },
      );
  }
}