import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/widgets/bar_chart_widget.dart';
import 'package:la_dinamica_app/widgets/pie_chart_widget.dart';

class EarnScreen extends StatefulWidget {
  const EarnScreen({super.key});

  @override
  _EarnScreenState createState() => _EarnScreenState();
}

class _EarnScreenState extends State<EarnScreen> {
  DateTime startDate = DateTime.now(); // Fecha de inicio
  DateTime endDate = DateTime.now(); // Fecha de finalización

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
    final screenWidth = isPortatil
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 35),
                const Text('Filtro de fecha para'),
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
                                8.0), // Ajusta el valor según lo que desees
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
                                8.0), // Ajusta el valor según lo que desees
                          ),
                        ),
                      ),
                      onPressed: () {
                        _selectDate(
                            context, false); // false para fecha de finalización
                      },
                      child: Text(
                        "Final: ${endDate.month}/${endDate.day}/${endDate.year}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                    height: 10), // Espaciado entre los botones y el gráfico
                const Text('Generar reportes en csv'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth / 2.8,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          border: Border.all(width: 1),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Activo',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth / 2.8,
                      decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          border: Border.all(width: 1),
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Desactivado',
                            style: TextStyle(color: Colors.black),
                          ),
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
                      borderRadius: BorderRadius.circular(16)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Datos de la fecha Actual: 05/07/2024',
                          style: TextStyle(color: Colors.white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Asistencias',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '25 Alumnos',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Ganancias',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '\$1000',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorList[1], width: 5)),
                    child: const BarChartWidget()),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorList[1], width: 5)),
                    child: const PieChartWidget()), // Tu widget de gráfico
              ],
            ),
          ),
        ),
      ),
    );
  }
}
