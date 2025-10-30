import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/widgets/piechart_indicator.dart';

class PieChartWidgetProducts extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String tenantId;
  final double screenWidth;

  const PieChartWidgetProducts({
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
      future: awsDb.getSalesPerRange(lastdate, today, tenantId),
      builder: (BuildContext context, AsyncSnapshot<List<Sale>> snapshot) {
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
  final List<Sale> data;
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
    final productNames = <String, String>{};
    final colors = <Color>[];
    final random = Random();
    double total = 0;

    for (var sale in data) {
      final productID = sale.product!.id;
      final amount = sale.price!;
      if (percentages.containsKey(productID)) {
        percentages[productID] = percentages[productID]! + amount;
      } else {
        percentages[productID] = amount;
        productNames[productID] = sale.product!.name!;
      }
      total += amount;
    }

    for (var productID in percentages.keys) {
      final value = percentages[productID]! / total * 100; // Calculate percentage
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
      Map<String, String> productNames,
      double totalAmount,
      List<Color> colors,
    ) {
      List<String> productTypes = [];
      List<double> amounts = [];

      for(var productId in percentages.keys){
        if (percentages[productId]! > 0)
        {productTypes.add(productNames[productId]!);
        amounts.add(percentages[productId]!);}
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Total: \$${totalAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 20),
          ...List.generate(productTypes.length, (index) {
            return Indicator(
              color: colors[index],
              text:
                  '${productTypes[index]}:  \$${amounts[index].toStringAsFixed(2)}',
              isSquare: false,
            );
          }),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Ingresos por producto',
          style: GoogleFonts.michroma()
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: chartInfo(percentages,productNames ,total, colors)),
            Expanded(
              child: SizedBox(
                height: 300,
                child: 
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: screenWidth * 0.1,
                    sections: sections,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
