import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/widgets/piechart_indicator.dart'; 


class PieChartWidget extends ConsumerWidget{
    final DateTime startDate;
    final DateTime endDate;

    const PieChartWidget({super.key, required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final today = DateTime.parse(ref.watch(dateProvider));
    final awsDb = DataStoreReadService();
    var n = 5;

    if(startDate.toString().split(' ')[0] != endDate.toString().split(' ')[0]){
      n = endDate.difference(startDate).inDays;
    }

    final lastdate = today.subtract(Duration(days: n));
    
    return FutureBuilder(

      future: awsDb.getPaymentsRange(lastdate, today),
      builder: (BuildContext context, AsyncSnapshot<List<Payments>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          return Center(
            child: SizedBox(
              height: 300, // or any fixed height
              child: PieChartgraph(snapshot.data!),
            ),
          );
        }
      },
    );
  }
}

PieChartgraph(List<Payments> data) {
  
  final sections = <PieChartSectionData>[];
  final percentages = <String, double>{};
  final random = Random();
  final colors = [];
  double total = 0;

  for (var pay in data) {
    final type = pay.type;
    final amount = pay.amount!;
    if (percentages.containsKey(type)) {
      percentages[pay.type!] = percentages[pay.type]! + amount;
    } else {
      percentages[pay.type!] = amount;
    }
    total += amount; 
  }

  for (var type in percentages.keys) {
    final value = percentages[type]! / total * 100; // Calculate percentage
    final color = Color.fromRGBO(
      random.nextInt(256), 
      random.nextInt(256), 
      random.nextInt(256), 
      0.8
    );
    colors.add(color);
    sections.add(
      PieChartSectionData(
        value: value,
        color: color, // You can customize the color
        title: '$value%',
        radius: 70,
      ),
    );
    }

  return PieChart(PieChartData(
    sectionsSpace: 0,
    centerSpaceRadius: 40,
    sections: sections,
    startDegreeOffset: -90,
    )
  );
}
