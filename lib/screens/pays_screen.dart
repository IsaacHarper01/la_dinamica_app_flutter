import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';

class PaysScreen extends StatelessWidget {
  const PaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight = isPortatil
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 2;
    final screenWidth = isPortatil
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            height: 520,
            width: screenWidth * 0.8,
            decoration: BoxDecoration(
                color: colorList[1], borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Asignar Plan',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ],
                  ),
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        screenWidth * 0.1, 0, screenWidth * 0.1, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const Text('Alumno',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                            value: 'Isaac', // Valor inicial
                            onChanged: (String? newValue) {
                              // Aquí puedes manejar el valor seleccionado
                            },
                            items: <String>[
                              'Isaac',
                              'Sebas',
                              'Alex',
                              'Come Pito'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const Text(
                            'Tipo de plan',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                            value: 'Plan A', // Valor inicial
                            onChanged: (String? newValue) {
                              // Aquí puedes manejar el valor seleccionado
                            },
                            items: <String>[
                              'Plan A',
                              'Plan B',
                              'Plan C',
                              'Come mas Pito'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const Text(
                            'Total de clases: 15',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const Text(
                            'Total a pagar: \$450',
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(colorList[3])),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'Asignar',
                              style: TextStyle(fontSize: 20),
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
