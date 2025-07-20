import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final tenantId = user.tenantId;

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
                return infocharts(snapshot.data, n, linechart);
              }
            }
          );
  }

infocharts(alldata, n, linegraph){
    final inconmeData = alldata[0];
    final studentData = alldata[1];

    final incomePerDay = getCountPerDay(inconmeData);
    final studentsPerDay = getCountPerDay(studentData);

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text('Analisis de los ultimos $n días',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          const SizedBox(height: 25),
          Row(
            children: [
              Column(children: [
                const Text('Ingresos por día',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 210, 
                height: 200, 
                child: DaysChartWidget(values: incomePerDay['values']),
                ),
              ],),
              const Spacer(),
              SizedBox(
                width: 450, 
                height: 350, 
                child: linegraph(inconmeData, n),
              ),
              const SizedBox(height: 20),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(children: [
                const Text('Estudiantes por día',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 210, 
                height: 200,
                child: DaysChartWidget(values: studentsPerDay['values']),
                ),
              ]
              ),
              
              Column(children: [
                AverageWidget(average: studentsPerDay['average'].toStringAsFixed(2),title1: 'Estudiantes promedio',title2: "por día",),
                const SizedBox(height: 20),
                AverageWidget(average: "\$${incomePerDay['average'].toStringAsFixed(2)}", title1: 'Ingresos promedio',title2: "por día",),
                ]),
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

    data.forEach((dateStr, earning) {
      final date = DateTime.parse(dateStr);
      final day = date.weekday;
      safePrint("day: $day, earning: $earning");
      values[day - 1] += earning;
    });
    int aux = 0;
    double sum = 0.0;

    for (var i = 0; i < values.length; i++) {
      if (values[i] != 0) {
        sum += values[i];
        aux +=1;
      }
    }
    final average = sum / aux;

    return {
      'values': values,
      'average': average,
    };
  }
}

