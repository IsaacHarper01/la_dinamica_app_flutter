import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/model/earn_summary_model.dart';
import 'package:la_dinamica_app/model/pie_chart_item.dart';
import 'package:la_dinamica_app/providers/income_summary_provider.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/piechart_indicator.dart';


class PieChartWidget extends ConsumerWidget {
  final double screenWidth;
  final String selectedValue;

  const PieChartWidget({
    super.key,
    required this.screenWidth,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financialData = ref.watch(incomeSummaryProvider);
    final sections = <PieChartSectionData>[];
    final summary = <String, double>{};
    final itemNames = <String, String>{};
    final colors = <Color>[];
    final random = Random();

    double total = 0;

    return financialData.when(
      error: (e,st) => Center(child: Text("error al cargar la data $e"),), 
      loading: () => Center(child: CircularProgressIndicator(),),
      data: (data) {
            final adaptedData = adaptData(selectedValue, data);
            
            for (var item in adaptedData) {
              final itemID = (selectedValue == "Ingreso Neto") ? item.type : item.id;
              final amount = item.value;
              if (summary.containsKey(itemID)) {
                summary[itemID] = summary[itemID]! + amount;
              } else {
                summary[itemID] = amount;
                itemNames[itemID] = (selectedValue == "Ingreso Neto") ? item.type : item.label;
              }
              total += amount;
            }         

            for (var itemID in summary.keys) {
              final value = summary[itemID]! / total * 100; // Calculate percentage
              
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

         return Center(
            child: SizedBox(
              height: 400, // or any fixed height
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    selectedValue,
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
                            child: chartInfo(summary, itemNames,sections,total,colors),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
  }

  Column chartInfo(
      Map<String, double> summary,
      Map<String, String> itemNames,
      List<PieChartSectionData> sections,
      double totalAmount,
      List<Color> colors,
    ) {

      List<String> financialName = [];
      List<double> amounts = [];

      for(var id in summary.keys){
              financialName.add(itemNames[id]!);
              amounts.add(summary[id]!);
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
                  '${financialName[index]}:  \$${amounts[index].toStringAsFixed(2)}',
              isSquare: false,
            );
          }),
        ],
      );
    }


  List<PieChartItem> adaptData(String selectedValue, FinancialSummary data){
    List<PieChartItem> financialItems = [];
    switch (selectedValue) {
      case "Ingreso Neto":
        for(var plan in data.payments.rangelist){
          final item = PieChartItem(
            id: plan.plan!.id,
            label: plan.plan!.type!, 
            value: plan.amount!,
            type: "Planes",
            );
          financialItems.add(item);
        }
        for(var sale in data.sales.rangelist){
          final item = PieChartItem(
            id: sale.product!.id,
            label: sale.product!.name!, 
            value: sale.price!,
            type: "Productos",
            );
          financialItems.add(item);
        }
        break;
      case "Ingreso de planes":
        for(var plan in data.payments.rangelist){
          final item = PieChartItem(
            id: plan.plan!.id,
            label: plan.plan!.type!, 
            value: plan.amount!,
            type: "Planes",
            );
          financialItems.add(item);
        }
        break;
      case "Ingreso de productos":
        for(var sale in data.sales.rangelist){
          final item = PieChartItem(
            id: sale.product!.id,
            label: sale.product!.name!, 
            value: sale.price!,
            type: "Productos",
            );
          financialItems.add(item);
        }
        break;
      case "Gastos":
        for(var expense in data.expenses.rangelist){
          final item = PieChartItem(
            id: expense.name.toLowerCase().trim(),
            label: expense.name.toLowerCase().trim(), 
            value: expense.amount,
            type: "Gastos",
            );
          financialItems.add(item);
        }
        break;
      default:
    }
    return financialItems;
  }
}
