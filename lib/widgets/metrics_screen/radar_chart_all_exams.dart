import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/providers/actual_student_grades_provider.dart';

class RadarChartAllExams extends ConsumerStatefulWidget {
  final String studentId;

  const RadarChartAllExams({
    super.key,
    required this.studentId,
    });

  @override
  ConsumerState<RadarChartAllExams> createState() => _nameState();
}

class _nameState extends ConsumerState<RadarChartAllExams> {
  @override
  Widget build(BuildContext context) {
    final examGrades = ref.watch(studentGradesProvider(widget.studentId));
    List<String> options = [];
    
    return examGrades.when(
      error: (e,st)=> Center(child: Text('Error al cargar los datos $e'),), 
      loading: ()=>Center(child: CircularProgressIndicator(),),
      data: (data){
        options = data.allExamNames;
        final grades = data.examsTotals;
        final entries = options.map((examName)=>RadarEntry(value: grades[examName]!)).toList();
        return 
        options.length>=3 ?
        Column(
          children: [
                Text('Vision General de periodo', style: GoogleFonts.shortStack(fontSize: 20),),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                            // color: const Color.fromARGB(255, 30, 68, 97),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: RadarChart(
                            RadarChartData(
                              radarBackgroundColor: Colors.transparent,
                              radarBorderData: BorderSide(width: 0.1),
                              borderData: FlBorderData(show: false),
                              tickCount: 4,                 // number of inner rings
                              ticksTextStyle: const TextStyle(color: Colors.grey),
                              tickBorderData: const BorderSide(color: Colors.grey),
                        
                              gridBorderData: const BorderSide(color: Colors.grey),
                        
                              getTitle: (index, angle) {
                  
                                return RadarChartTitle(
                                  text: options[index],
                                  angle: angle,
                                );
                              },
                        
                              dataSets: [
                                RadarDataSet(
                                  fillColor: Color.fromRGBO(76, 142, 204, 0.498),
                                  dataEntries: entries
                                )
                                ]),
                            duration:Duration(milliseconds: 150),
                            curve:Curves.linear,
                            ),
                          ),
                        ),
                      ),
                    ]
            ): 
            Center(child: Text('Datos insuficientes'));
          }
      );
    }
}