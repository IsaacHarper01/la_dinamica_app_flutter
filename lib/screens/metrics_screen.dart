import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/widgets/calendar_widget.dart';
import 'package:time_range_picker/time_range_picker.dart';

class MetricsPage extends StatefulWidget {
  final String name;
  final String image;

  const MetricsPage({super.key, required this.name, required this.image});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  late String title;
  String photo = "assets/images/default_profile.jpg";

  @override
  void initState() {
    super.initState();
    title = widget.name;
    photo = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDate;
    TimeRange? selectedRange;
    final List<String> metricas = ['velocidad', 'fuerza', 'resistencia'];
    final List<String> tipoDeMetrica = [
      'examen',
      'evaluacion_mensual',
      'evaluacion_diaria',
    ];
    String? selectedValue = 'velocidad';

    return Scaffold(
      appBar: AppBar(title: Center(child: Text(title))),
      backgroundColor: const Color.fromRGBO(6, 20, 27, 1.0),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 400,
            color: const Color.fromRGBO(35, 55, 69, 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 280,
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Opacity(
                          opacity: 0.7,
                          child: Image.network(photo,fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/default_profile.jpg',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () {},
                      label: const Text(
                        'Agregar Metrica',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(Icons.plus_one, color: Colors.white),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(colorList[3]),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 350,
                  width: 400,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(74, 92, 106, 1.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        child: CalendarTimeRangePicker(
                          onSelectionChanged: (date, range) {
                            setState(() {
                              selectedDate = date;
                              selectedRange = range;
                              safePrint('RANGO SELECIONADO: $selectedRange');
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 50,
                width: 500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FilledButton(
                      onPressed: () {},
                      child: const Text("Velocidad"),
                    ),
                    FilledButton(onPressed: () {}, child: const Text("Examen")),
                  ],
                ),
              ),
              Container(
                //Main Charts container
                height: 330,
                color: const Color.fromRGBO(17, 33, 45, 1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 280,
                      width: 300,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(74, 92, 106, 1.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Container(
                      height: 280,
                      width: 330,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(74, 92, 106, 1.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 400,
            color: const Color.fromRGBO(35, 55, 69, 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 350,
                  width: 620,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(74, 92, 106, 1.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
