import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:la_dinamica_app/backend/database.dart';

class LineChartWidget extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  LineChartWidget({super.key, required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    var n = 30;
    
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
    final x_data = <String>[];
    double i = 0;
    for(var key in data.keys){
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
          titlesData: FlTitlesData(
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
              gradient: LinearGradient(
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

