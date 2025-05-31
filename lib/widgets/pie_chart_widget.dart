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
    var n = 30;

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
              height: 400, // or any fixed height
              child: ChartPie(
                data: snapshot.data!,),
            ),
          );
        }
      },
    );
  }
}

class ChartPie extends StatelessWidget {
  final List<Payments> data;

  const ChartPie({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final sections = <PieChartSectionData>[];
    final percentages = <String, double>{};
    final colors = <Color>[];
    final random = Random();
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
          title: '${value.toStringAsFixed(1)}%',
          radius: 40,
        ),
      );
      }

    Column Chartinfo(Map<String, double> percentages, double totalAmount, List<Color> colors) {
      final List<String> planTypes = percentages.keys.toList(); 
      final List<double> amounts = percentages.values.toList();

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Text('Total: \$${totalAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 20),
          ...List.generate(
            colors.length,
            (index) {
              return Indicator(
                color: colors[index], 
                text: '${planTypes[index]}:  \$${amounts[index].toStringAsFixed(2)}', 
                isSquare: false);
            }),
        ]
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Ingresos por plan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: 
          [ 
          SizedBox(
            width: 400,
            height: 300,
            child: PieChart(PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 90,
            sections: sections,))),
          Chartinfo(percentages, total, colors) 
          ]
          ),
      ],
    );
  }
}


