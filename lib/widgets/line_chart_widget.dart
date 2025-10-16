import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/widgets/average_widget.dart';
import 'package:la_dinamica_app/widgets/days_chart_widget.dart';

class LineChartWidget extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;
  final UserLocal user;

  const LineChartWidget({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.user,
  });

  bool _isValidDate(String value) {
    try {
      DateTime.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.parse(ref.watch(dateProvider));
    final tenantId = user.tenant.tenant_id;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenWidth = isPortatil ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.8;
    
    var n = 30;

    if (startDate.toString().split(' ')[0] !=
        endDate.toString().split(' ')[0]) {
      n = endDate.difference(startDate).inDays;
    }

    final lastdate = today.subtract(Duration(days: n));
    final awsDb = DataStoreReadService();

    return FutureBuilder(
      future: awsDb.getTotalAmounRange(lastdate, today, tenantId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return infocharts(screenWidth ,snapshot.data, n, linechart);
              }
            }
          );
  }

infocharts(screenWidth, alldata, n, linegraph){
    final inconmeData = alldata[0];
    final studentData = alldata[1];

    final incomePerDay = getCountPerDay(inconmeData);
    final studentsPerDay = getCountPerDay(studentData);

    return Center(
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
                    child: DaysChartWidget(values: incomePerDay['values']),
                    ),]
                  ,),
              SizedBox(
                width: screenWidth * 0.58, 
                height: 350, 
                child: linegraph(inconmeData, n),
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
                  AverageWidget(average: studentsPerDay['average'].toStringAsFixed(2),title1: 'Estudiantes promedio',title2: "por día",),
                  const SizedBox(height: 20),
                  AverageWidget(average: "\$${incomePerDay['average'].toStringAsFixed(2)}", title1: 'Ingresos promedio',title2: "por día",),
                  ]),
              ),
            ],
          )
        ],
      ),
    );
  }

  Center linechart(data, n) {
    safePrint("data: $data");
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
                      colors: [Colors.blue.withOpacity(0.2), Colors.lightBlue.withOpacity(0.1)],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  
  Map<String, dynamic> getCountPerDay(data){ //this function could be used for both income and students
    List<double> values = [0,0,0,0,0,0,0]; // [LU, MA, MI, JU, VI, SA, DO]
    int aux = 0;

    data.forEach((dateStr, earning) {
      final date = DateTime.parse(dateStr);
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

