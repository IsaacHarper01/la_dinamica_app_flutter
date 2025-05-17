import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';

class LineChartWidget extends ConsumerWidget{
  final DateTime startDate;
  final DateTime endDate;
  
  LineChartWidget({super.key, required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.parse(ref.watch(dateProvider));
    var n = 30;
    print('FECHA DE HOY: $today');
    if(startDate.toString().split(' ')[0] != endDate.toString().split(' ')[0]){
      n = endDate.difference(startDate).inDays;
    }

    final lastdate = today.subtract(Duration(days: n));
    DatabaseHelper db = DatabaseHelper();

    return FutureBuilder(
        future: db.fetchTotalAmountRange(lastdate, today), 
      builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Linechart(snapshot.data);
              }
            }
          );
  }

  Center Linechart(data) {

    final y_data = <FlSpot>[];
    double i = 0;
    final sortedDataList = data.entries.toList()
          ..sort((a,b)=> DateTime.parse(a.key).compareTo(DateTime.parse(b.key)));
    final orderedData = Map.fromEntries(sortedDataList);

    for(var key in orderedData.keys){
      y_data.add(FlSpot(i,data[key]));
      i++;
    }
    
    return Center(
    child: Container(
      width: 300, // Set a specific width
      height: 400, // Set a specific height
      child: LineChart(
        LineChartData(
          minY: 0,
          gridData: FlGridData(show: true),
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
              spots: y_data,
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
    ),
  );
  }
}

