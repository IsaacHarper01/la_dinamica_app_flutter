import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenWidth = isPortatil
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width * 0.8;
    final screenHeight = isPortatil
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 4;

    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Container(
          height: screenHeight * 0.2 + planes.length * 60,
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
              color: colorList[1], borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Configuraciones de planes',
                      style: TextStyle(
                          fontSize: screenWidth * 0.06, color: Colors.white),
                    )
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(colorList[3])),
                        onPressed: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.add_circle_outlined),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Agregar nuevo plan',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: planes.map((item) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: item.map((subitem) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  subitem,
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.04),
                                ),
                              ),
                            );
                          }).toList()),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(colorList[3])),
                        onPressed: () {},
                        child: const Text(
                          'Guardar',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}

const planes = [
  ['Tipo de Plan', 'Clases', 'Precio'],
  ['Tipo de Plan', 'Clases', 'Precio'],
  ['Tipo de Plan', 'Clases', 'Precio'],
  ['Tipo de Plan', 'Clases', 'Precio']
];
