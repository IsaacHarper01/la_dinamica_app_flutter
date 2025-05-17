import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/config/provider/theme_provider.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';

class PaysScreen extends ConsumerStatefulWidget {
  const PaysScreen({super.key});

  @override
  ConsumerState<PaysScreen> createState() => _PaysScreenState();
}

class _PaysScreenState extends ConsumerState<PaysScreen> {
  ValueNotifier<int> planIndexNotifier = ValueNotifier<int>(0);
  ValueNotifier<int> nameIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;
    final screenHeight = isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 2;
    final screenWidth = isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width * 0.8;
    final db = DatabaseHelper();
    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final String date = ref.watch(dateProvider);

    return Scaffold(
      body: FutureBuilder(
          future: db.fetchNamesIdsPlans(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Error al cargar datos'));
            } else {
              final data = snapshot.data;
              final names = data[0];
              final ids = data[1];
              final plansType = data[2];
              final costs = data[3];
              final clases = data[4]; // Añadir las clases

              return paymentBox(
                  screenWidth,
                  screenHeight,
                  names,
                  ids,
                  plansType,
                  costs,
                  clases,
                  planIndexNotifier,
                  nameIndexNotifier,
                  context,
                  isDarkMode,
                  date,
                  isPortrait);
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
    List<String> clases,
    ValueNotifier<int> planIndexNotifier,
    ValueNotifier<int> nameIndexNotifier,
    BuildContext context,
    bool isDarkMode,
    String date,
    bool isPortrait) {
  return Center(
    child: clases.isEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              isDarkMode
                  ? 'assets/images/f_ma18.png'
                  : 'assets/images/f_ma11.png',
              height: isDarkMode ? screenHeight * 0.3 : screenHeight * 0.2,
              fit: BoxFit.cover,
            ))
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                height: 520,
                width: screenWidth * 0.8,
                decoration: BoxDecoration(
                    color: colorList[1],
                    borderRadius: BorderRadius.circular(10)),
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
                            ValueListenableBuilder<int>(
                              valueListenable: nameIndexNotifier,
                              builder: (context, nameIndex, _) {
                                return DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                  ),
                                  value: (nameIndex < names.length)
                                      ? names[nameIndex]
                                      : null,
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      nameIndexNotifier.value =
                                          names.indexOf(newValue);
                                    }
                                  },
                                  items: names.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        overflow: TextOverflow
                                            .ellipsis, // Limitar a 15 caracteres y agregar "..."
                                      ),
                                    );
                                  }).toList(),
                                  selectedItemBuilder: (BuildContext context) {
                                    return names.map((String value) {
                                      return Text(
                                        value.length > 15
                                            ? '${value.substring(0, isPortrait ? 10 : value.length < 50 ? value.length - 1 : 50)}...'
                                            : value,
                                        // Limitar a 15 caracteres en el valor seleccionado también
                                        overflow: TextOverflow.ellipsis,
                                        // Agregar elipsis si es necesario
                                        maxLines: 1,
                                        softWrap: false,
                                      );
                                    }).toList();
                                  },
                                  style: const TextStyle(color: Colors.black),
                                );
                              },
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
                            ValueListenableBuilder<int>(
                              valueListenable: planIndexNotifier,
                              builder: (context, planIndex, _) {
                                return DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                  ),
                                  value: (planIndex < plansType.length)
                                      ? plansType[planIndex]
                                      : null,
                                  // Verificar si planIndex es válido
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      planIndexNotifier.value =
                                          plansType.indexOf(newValue);
                                    }
                                  },
                                  items: plansType
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  style: const TextStyle(color: Colors.black),
                                );
                              },
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            ValueListenableBuilder<int>(
                              valueListenable: planIndexNotifier,
                              builder: (context, planIndex, _) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total de clases: ${clases[planIndex]}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.01,
                                    ),
                                    Text(
                                      'Total a pagar: ${costs[planIndex]}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
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
                                  WidgetStatePropertyAll(colorList[3]),
                            ),
                            onPressed: () {
                              assignedPlan(
                                clases: clases,
                                context: context,
                                costs: costs,
                                date: date,
                                nameIndex:
                                    int.parse(ids[nameIndexNotifier.value]),
                                planIndex: planIndexNotifier.value,
                                plansType: plansType,
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Asignar',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
  );
}

void assignedPlan({
  required int nameIndex,
  required List<String> costs,
  required int planIndex,
  required List<String> clases,
  required List<String> plansType,
  required String date,
  required BuildContext context,
}) {
  var payMap = {
    'userId': nameIndex,
    'amount': costs[planIndex],
    'clases': clases[planIndex],
    'type': plansType[planIndex],
    'date': date
  };
  //print(payMap);
  final db = DatabaseHelper();
  db.InserPaymentData(payMap);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Registro exitoso'),
      backgroundColor: Colors.green,
    ),
  );
}
