import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/piechart_indicator.dart';

class PieChartWidgetPlans extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String tenantId;
  final double screenWidth;

  const PieChartWidgetPlans({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.tenantId,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parsedDate = DateTime.tryParse(ref.watch(dateProvider));

    if (parsedDate == null) {
      return const Center(child: Text('Fecha inválida'));
    }

    final awsDb = DataStoreReadService();
    var n = 30;

    if (startDate.toString().split(' ')[0] !=
        endDate.toString().split(' ')[0]) {
      n = endDate.difference(startDate).inDays;
    }

    final lastdate = parsedDate.subtract(Duration(days: n));
    final today = parsedDate;

    return FutureBuilder(
      future: awsDb.getPaymentsRange(lastdate, today, tenantId),
      builder: (BuildContext context, AsyncSnapshot<List<Payment>> snapshot) {
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
              child: ChartPie(data: snapshot.data!, screenWidth: screenWidth),
            ),
          );
        }
      },
    );
  }
}

class ChartPie extends StatelessWidget {
  final List<Payment> data;
  final double screenWidth;

  const ChartPie({
    super.key,
    required this.data,
    required this.screenWidth,
    });

  @override
  Widget build(BuildContext context) {
    final sections = <PieChartSectionData>[];
    final percentages = <String, double>{};
    final planNames = <String, String>{};
    final colors = <Color>[];
    final random = Random();
    double total = 0;

    for (var pay in data) {
      final planID = pay.plan!.id;
      final amount = pay.amount!;
      if (percentages.containsKey(planID)) {
        percentages[planID] = percentages[planID]! + amount;
      } else {
        percentages[planID] = amount;
        planNames[planID] = pay.plan!.type!;
      }
      total += amount;
    }

    for (var planID in percentages.keys) {
      final value = percentages[planID]! / total * 100; // Calculate percentage
      
      final color = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        0.8,
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

    Column chartInfo(
      Map<String, double> percentages,
      Map<String, String> planNames,
      double totalAmount,
      List<Color> colors,
    ) {
      List<String> planTypes = [];
      List<double> amounts = [];

      for(var planId in percentages.keys){
        planTypes.add(planNames[planId]!);
        amounts.add(percentages[planId]!);
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total: \$${totalAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 20),
          ...List.generate(sections.length, (index) {
            return Indicator(
              color: colors[index],
              text:
                  '${planTypes[index]}:  \$${amounts[index].toStringAsFixed(2)}',
              isSquare: false,
            );
          }),
        ],
      );
    }

    return Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Text(
      'Ingresos por plan',
      style: GoogleFonts.michroma(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    const SizedBox(height: 12),
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Pie chart container
        Expanded(
          flex: 1,
          child: AspectRatio(
            aspectRatio: 1, // Ensures it's a perfect circle
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: screenWidth * 0.1,
                sections: sections,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: chartInfo(percentages, planNames, total, colors),
            ),
          ),
        ),
      ],
    ),
  ],
);
  }
}
