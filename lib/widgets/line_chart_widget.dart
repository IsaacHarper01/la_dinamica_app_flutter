import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final y_data = <FlSpot>[];
    final x_data = <String>['2024-12-02','2024-12-03','2024-12-04','2024-12-05','2024-12-06'];
    final List<double> values = [230.0,330.4,130.0,540.3,250.0];
    for (var i = 0; i < values.length; i++) {
      y_data.add(FlSpot(i.toDouble(), values[i]));
    }
    return Center(
      child: Container(
        width: 300, // Set a specific width
        height: 400, // Set a specific height
        child: LineChart(
          LineChartData(
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
