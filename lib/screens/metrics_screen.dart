import 'dart:io';

import 'package:flutter/material.dart';
import 'package:la_dinamica_app/widgets/calendar_widget.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';


class MetricsPage extends StatefulWidget {
  final String name;
  final String image;

  const MetricsPage({super.key, required this.name, required this.image});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  late String title;
  late String photo;
  

  @override
  void initState(){
    super.initState();
    title = widget.name;
    photo = widget.image;
  }
  
  @override
  Widget build(BuildContext context){
    DateTime? selectedDate;
    TimeRange? selectedRange;
    final List<String> metricas = ['velocidad','fuerza','resistencia'];
    final List<String> tipo_de_metrica = ['examen','evaluacion_mensual','evaluacion_diaria']; 
    String? selectedValue = 'velocidad';

    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('$title')),
        ),
        backgroundColor: Color.fromRGBO(6, 20, 27, 1.0),
        body: ListView(
          children: [
            SizedBox(height: 20),
            Container( //Student photo and Calendar Cointainer
              height: 400,
              color: Color.fromRGBO(35, 55, 69, 1.0), //provisional ELIMINAR!!!
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
                                child: Image.file(
                                  File(photo),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        ),
                        FilledButton.icon(
                          onPressed: (){},
                          label: const Text(
                            'Agregar Metrica',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: const Icon(
                            Icons.plus_one,
                            color: Colors.white,
                          ),
                          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(colorList[3])),
                        ),
                    ]
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
                                print('RANGO SELECIONADO: $selectedRange');
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  )
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
                      FilledButton(onPressed: (){}, child: Text("Velocidad")),
                      FilledButton(onPressed: (){}, child: Text("Examen"))
                    ],
                  ),
                ),
                Container(  //Main Charts container
                height: 330,
                color: Color.fromRGBO(17, 33, 45, 1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 280,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(74, 92, 106, 1.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Container(
                      height: 280,
                      width: 330,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(74, 92, 106, 1.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  ],
                ),
              ),
              ]
            ),
            Container(
              height: 400,
              color: Color.fromRGBO(35, 55, 69, 1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 350,
                    width: 620,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(74, 92, 106, 1.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
  }
}