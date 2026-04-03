import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/providers/attendant_students_provider.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/income_summary_provider.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/average_widget.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/days_chart_widget.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/line_graph_widget.dart';

class LineChartWidget extends ConsumerWidget {

  const LineChartWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenWidth = isPortatil ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.8;
    final financialData = ref.watch(incomeSummaryProvider);
    final studentsData = ref.watch(studentsAttendanceProvider);
    final startDate = ref.watch(dateProvider).start;
    final endDate = ref.watch(dateProvider).end;

    
    var n = 30;

    if (startDate.toString().split(' ')[0] !=
        endDate.toString().split(' ')[0]) {
      n = endDate.difference(startDate).inDays;
    }

    return financialData.when(
      error: (e, s) => Text("Error al obtener los datos: $e"),
      loading: () => const CircularProgressIndicator(),
      data: (financialData) {
          return studentsData.when(
            error:(e, s) => Text("Error al obtener los datos: $e"),
            loading: () => const CircularProgressIndicator(),
            data: (studentsdata) {
            final studentsPerDay =  getCountPerDay(studentsdata.attendancebyDate!);
            final financialPerDay = getCountPerDay(financialData.mapDate!);
             return  Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text('Analisis de los ultimos $n días',
                      style: GoogleFonts.michroma(color: Colors.white)),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text('Ingresos por día',
                            style: GoogleFonts.michroma(fontSize: 11),
                            ),
                            SizedBox(
                              width: screenWidth * 0.37, 
                              height: 200, 
                              child: DaysChartWidget(values: financialPerDay['values']),
                              ),]
                            ,),
                        SizedBox(
                          width: screenWidth * 0.58, 
                          height: 350, 
                          child: LineGraphWidget(data: financialData.mapDate!),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(children: [
                            Text('Estudiantes por día',
                            style: GoogleFonts.michroma(fontSize: 11),
                          ),
                          SizedBox( 
                            height: 200,
                            child: DaysChartWidget(values: studentsPerDay['values']),
                            ),
                          ]
                          ),
                        ),
                        Expanded(
                          child: Column(children: [
                            AverageWidget(average: "\$${financialPerDay['average'].toStringAsFixed(2)}", title1: 'Ingresos promedio',title2: "por día",),
                            const SizedBox(height: 20),
                            AverageWidget(average: studentsPerDay['average'].toStringAsFixed(2),title1: 'Estudiantes promedio',title2: "por día",),
                            ]),
                        ),
                      ],
                    )
                  ],
                ),
              );
             },
            );
      },
    );
  }
  
  Map<String, dynamic> getCountPerDay(Map<DateTime, double> data){ //this function could be used for both income and students
    List<double> values = [0,0,0,0,0,0,0]; // [LU, MA, MI, JU, VI, SA, DO]
    int aux = 0;
    
    data.forEach((dateStr, earning) {
      final date = dateStr;
      final day = date.weekday;
      values[day - 1] += earning;
      aux += 1;
    });
    
    double sum = 0.0;

    for (var i = 0; i < values.length; i++) {
      if (values[i] != 0) {
        sum += values[i];
      }
    }
    final average = sum / aux;

    return {
      'values': values,
      'average': average,
    };
  }
}

