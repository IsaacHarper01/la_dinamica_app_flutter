import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/backend/attendance_report.dart';
import 'package:la_dinamica_app/backend/income_report.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/model/income_state.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/income_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/add_expenses_widget.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/box_info_widget.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/line_chart_widget.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/pie_chart_products_widget.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/pie_chart_widget.dart';


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
          ref.read(incomeProvider.notifier).reLoadIncomeData(pickedDate, endDate);
          startDate = pickedDate;
        } else {
          ref.read(incomeProvider.notifier).reLoadIncomeData(startDate, pickedDate);
          endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).value!;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final months = {1:"Enero",2:"Febrero",3:"Marzo",4:"Abril",5:"Mayo",6:"Junio",7:"Julio",8:"Agosto",9:"Septiembre",10:"Octubre",11:"Noviembre",12:"Diciembre",};
    final screenWidth = isPortatil
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * 0.8;
    final date = ref.watch(dateProvider);
    final incomeState = ref.watch(incomeProvider);
    return incomeState.when(
      error: (e,s)=>Center(child: Text("Error al obtener los datos $e"),), 
      loading: ()=>Center(child: CircularProgressIndicator(),),
      data:(data) {
        return Scaffold(
          body: incomeScreen(
            context, 
            screenWidth,
            data,  
            date, 
            user,
            months,),
        floatingActionButton: FloatingActionButton(
          onPressed: ()async{
            showDialog(context: context, builder: (_) => AddExpensesWidget());
          },
          child: Icon(Icons.receipt_long),
          ),
            );
      },
      ); 
  }

  Center incomeScreen(
    BuildContext context,
    double screenWidth,
    IncomeState incomeData,
    String date,
    UserLocal user,
    Map<int,String> months,
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
              BoxInfoWidget(
                screenWidth: screenWidth, 
                planData: incomeData.dayPlanIncome!, 
                productData: incomeData.dayProductIncome!,
                expenses: incomeData.dayExpense!, 
                date: date,
                text: "Ingresos del día: $date"),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorList[1], width: 1),
                ),
                child: LineChartWidget(startDate: startDate, endDate: endDate, user: user),
              ),
              const SizedBox(height: 20),
              BoxInfoWidget(
                screenWidth: screenWidth, 
                planData: incomeData.planIncome!, 
                productData: incomeData.productIncome!, 
                expenses: incomeData.expenseTotal!,
                date: date, 
                text: "Ingresos mensuales: ${months[DateTime.parse(date).month]}"),
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
