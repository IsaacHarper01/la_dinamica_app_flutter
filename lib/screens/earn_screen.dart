import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/backend/attendance_report.dart';
import 'package:la_dinamica_app/backend/income_report.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/models/User.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/widgets/line_chart_widget.dart';
import 'package:la_dinamica_app/widgets/pie_chart_widget.dart';

class EarnScreen extends ConsumerStatefulWidget {
  const EarnScreen({super.key});

  @override
  EarnScreenState createState() => EarnScreenState();
}

class EarnScreenState extends ConsumerState<EarnScreen> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    final selectedDate = ref.read(dateProvider);
    startDate = DateTime.parse(selectedDate);
    endDate = DateTime.parse(selectedDate);
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenWidth =
        isPortatil
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * 0.8;
    final awsDb = DataStoreReadService();
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading:()=> Scaffold(body: Center(child: CircularProgressIndicator(),),),
      error: (e, _) => Scaffold(body: Center(child: Text('Error al cargar usuario: $e')),),
      data: (userAsync) => Scaffold(
      body: FutureBuilder<double>(
        future: awsDb.getIncomeRange(startDate, endDate, userAsync.db_id!),
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            double result = snapshot.data!;
            final today = ref.watch(dateProvider);
            return incomeScreen(context, screenWidth, result, today, userAsync);
          }
        },
      ),
      )
    );
  }

  Center incomeScreen(
    BuildContext context,
    double screenWidth,
    double result,
    String date,
    User user,
  ) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              const Text('Seleccione un periodo'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón de Fecha de Inicio
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(colorList[2]),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ), // Ajusta el valor según lo que desees
                        ),
                      ),
                    ),
                    onPressed: () {
                      _selectDate(context, true); // true para fecha de inicio
                    },
                    child: Text(
                      "Inicio: ${startDate.month}/${startDate.day}/${startDate.year}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text('A'),
                  const SizedBox(width: 20), // Espaciado entre botones
                  // Botón de Fecha de Final
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(colorList[2]),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ), // Ajusta el valor según lo que desees
                        ),
                      ),
                    ),
                    onPressed: () {
                      _selectDate(
                        context,
                        false,
                      ); // false para fecha de finalización
                    },
                    child: Text(
                      "Final: ${endDate.month}/${endDate.day}/${endDate.year}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ), // Espaciado entre los botones y el gráfico
              const Text('Generar reportes en csv'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        generateAttendanceReport(startDate, endDate, user.db_id!);
                      },
                      child: const Text(
                        'Reporte de asistencias',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        generateIncomeReport(startDate, endDate, user.db_id!);
                      },
                      child: const Text(
                        'Reporte de Ingresos',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 110,
                width: screenWidth * 0.9,
                decoration: BoxDecoration(
                  color: colorList[3],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Datos de la fecha Actual: $date',
                        style: const TextStyle(color: Colors.white),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'Ingresos: ',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '\$${result.toString()}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorList[1], width: 1),
                ),
                child: LineChartWidget(startDate: startDate, endDate: endDate, user: user),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorList[1], width: 1),
                ),
                child: PieChartWidget(
                  startDate: startDate, 
                  endDate: endDate, 
                  tenantId: user.db_id!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
