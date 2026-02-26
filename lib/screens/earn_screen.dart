import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/backend/attendance_report.dart';
import 'package:la_dinamica_app/backend/income_report.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/line_chart_widget.dart';
import 'package:la_dinamica_app/widgets/pie_chart_products_widget.dart';
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
      firstDate: DateTime(1950),
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
      data: (userAsync) => userAsync.permissions['watchIncome']! ?
      Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: awsDb.getAllInconmeRange(userAsync.tenant.tenant_id, startDate, endDate),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> totalIncome = snapshot.data!;
            final today = ref.watch(dateProvider);
            final todayPlanIncome = awsDb.getIncomePlans(startDate,endDate,userAsync.tenant.tenant_id,totalIncome['payments']);
            final todaySaleIncome = awsDb.getIncomeSales(startDate,endDate,userAsync.tenant.tenant_id,totalIncome['sales']);
            return incomeScreen(context, screenWidth, totalIncome,todayPlanIncome,todaySaleIncome, today, userAsync);
          }
        },
      ),
      ): Scaffold(
        body: Center(child: 
          Text('No tienes acceso a esta sección')) 
      )
    );
  }

  Center incomeScreen(
    BuildContext context,
    double screenWidth,
    Map<String, dynamic> income,
    double todayPlanIncome,
    double todaySaleIncome,
    String date,
    UserLocal user,
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
              Text('Seleccione un periodo',style: GoogleFonts.michroma()),
              const SizedBox(height: 10),
              SizedBox(
                width: screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 5,
                      child: FilledButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(colorList[2]),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          ),
                        ),
                        onPressed: () => _selectDate(context, true),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Inicio: ${startDate.month}/${startDate.day}/${startDate.year}",
                            style: GoogleFonts.michroma(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('A', style: GoogleFonts.michroma(),),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 5,
                      child: FilledButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(colorList[2]),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          ),
                        ),
                        onPressed: () => _selectDate(context, false),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Final: ${endDate.month}/${endDate.day}/${endDate.year}",
                            style: GoogleFonts.michroma(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ), // Espaciado entre los botones y el gráfico
              Text('Generar reportes en csv', style: GoogleFonts.michroma()),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        generateAttendanceReport(startDate, endDate, user.tenant.tenant_id);
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
                        generateIncomeReport(startDate, endDate, user.tenant.tenant_id);
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
                height: 130,
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
                        style: GoogleFonts.michroma(color: Colors.white),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ingresos de planes: ',
                            style: GoogleFonts.michroma(color: Colors.white),
                          ),
                          Text(
                            '\$${todayPlanIncome.toString()}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ingresos de productos: ',
                            style: GoogleFonts.michroma(color: Colors.white),
                          ),
                          Text(
                            '\$${todaySaleIncome.toString()}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const Divider(height: 0, indent: 20, endIndent: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: ',
                            style: GoogleFonts.michroma(color: Colors.white),
                          ),
                          Text(
                            '\$${(todaySaleIncome+todayPlanIncome).toString()}',
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
                width: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorList[1], width: 1),
                ),
                child: PieChartWidgetPlans(
                  startDate: startDate, 
                  endDate: endDate, 
                  tenantId: user.tenant.tenant_id,
                  screenWidth: screenWidth,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorList[1], width: 1),
                ),
                child: PieChartWidgetProducts(
                  startDate: startDate, 
                  endDate: endDate, 
                  tenantId: user.tenant.tenant_id,
                  screenWidth: screenWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
