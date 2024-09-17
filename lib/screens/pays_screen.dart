import 'package:flutter/material.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';

class PaysScreen extends StatefulWidget {
  const PaysScreen({super.key});

  @override
  State<PaysScreen> createState() => _PaysScreenState();
}

class _PaysScreenState extends State<PaysScreen> {
  int selectedIndex = 0; // Variable para guardar el índice seleccionado

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
    final db = DatabaseHelper();

    return Scaffold(
      body: FutureBuilder(
          future: db.fetchNamesIdsPlans(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final data = snapshot.data;
              final names = data[0];
              final ids = data[1];
              final plansType = data[2];
              final costs = data[3];
              final classes = data[4]; // Añadir las clases

              return paymentBox(screenWidth, screenHeight, names, ids,
                  plansType, costs, classes, selectedIndex, (newIndex) {
                setState(() {
                  selectedIndex = newIndex; // Actualizar el índice seleccionado
                });
              });
            }
          }),
    );
  }
}

Widget paymentBox(
    double screenWidth,
    double screenHeight,
    List<String> names,
    List<String> ids,
    List<String> plansType,
    List<String> costs,
    List<String> classes, // Añadir el array de clases
    int selectedIndex,
    Function(int) onPlanSelected) {
  return Center(
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
              const Row(
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
                        value: names[0], // Valor inicial
                        onChanged: (String? newValue) {
                          // Aquí puedes manejar el valor seleccionado
                        },
                        items:
                            names.map<DropdownMenuItem<String>>((String value) {
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
                        value: plansType[
                            selectedIndex], // Valor inicial basado en el índice seleccionado
                        onChanged: (String? newValue) {
                          // Actualizar el índice cuando se selecciona un nuevo plan
                          onPlanSelected(plansType.indexOf(newValue!));
                        },
                        items: plansType.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Text(
                        'Total de clases: ${classes[selectedIndex]}', // Mostrar el total de clases según el plan seleccionado
                        style: const TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Text(
                        'Total a pagar: ${costs[selectedIndex]}',
                        style: const TextStyle(color: Colors.white),
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
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
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
  );
}
