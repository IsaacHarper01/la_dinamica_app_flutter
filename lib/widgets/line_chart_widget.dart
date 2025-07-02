import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';

class LineChartWidget extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;

  const LineChartWidget({
    super.key,
    required this.startDate,
    required this.endDate,
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
    var n = 30;

    if (startDate.toString().split(' ')[0] !=
        endDate.toString().split(' ')[0]) {
      n = endDate.difference(startDate).inDays;
    }

    final lastdate = today.subtract(Duration(days: n));
    final awsDb = DataStoreReadService();

    return FutureBuilder(
      future: awsDb.getTotalAmounRange(lastdate, today),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == null || snapshot.data.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          return lineChart(snapshot.data, n);
        }
      },
    );
  }

  Center lineChart(data, n) {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Análisis de los últimos $n días',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 500, // Set a specific width
            height: 400, // Set a specific height
            child: LineChart(
              LineChartData(
                minY: 0,
                gridData: const FlGridData(show: true),
                titlesData: const FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
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
                    ),
                    // Use gradient instead of colors
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withAlpha(50),
                          Colors.lightBlue.withAlpha(25),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
