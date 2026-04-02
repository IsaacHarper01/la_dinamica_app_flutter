import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LineGraphWidget extends ConsumerStatefulWidget {
  final Map<DateTime, double> data;
  const LineGraphWidget({
    super.key, 
    required this.data
    });

  @override
  ConsumerState<LineGraphWidget> createState() => _LineGraphWidgetState();
}

class _LineGraphWidgetState extends ConsumerState<LineGraphWidget> {
  @override
  Widget build(BuildContext context) {

    final yData = <FlSpot>[];
    double i = 0;

    final filteredEntries =
        widget.data.entries.toList();

    filteredEntries.sort(
      (a, b) => a.key.compareTo(b.key),
    );
    final orderedData = Map.fromEntries(filteredEntries);

    for (var key in orderedData.keys) {
      final value = orderedData[key];
      if (value is num) {
        yData.add(FlSpot(i, value!));
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
}