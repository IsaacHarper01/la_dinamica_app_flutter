import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/provider/theme_provider.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/screens/add_new_plan.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  late Future plansFuture;

  @override
  void initState() {
    super.initState();
    plansFuture = fetchPlans();
  }

  Future fetchPlans() async {
    final db = DatabaseHelper();
    return db.fetchPlansData();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenWidth = isPortatil
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width * 0.8;
    final isDarkMode = ref.watch(isDark);

    return Scaffold(
      body: FutureBuilder(
          future: plansFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              List<List<String>> planes = [];
              for (var item in snapshot.data) {
                planes.add([
                  item['type'],
                  item['clases'].toString(),
                  item['price'].toString()
                ]);
              }
              return boxPlans(screenWidth, context, planes, isDarkMode);
            }
          }),
    );
  }

  Center boxPlans(double screenWidth, BuildContext context,
      List<List<String>> planes, bool isDarkMode) {
    return Center(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  //TODO, funcionalidad de Habilitar vencimiento
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: colorList[3],
                      borderRadius: BorderRadius.circular(18)),
                  child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Habilitar vencimiento',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )),
                )),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  ref.read(isDark.notifier).update((state) => !isDarkMode);
                },
                child: Container(
                  width: 80,
                  decoration: BoxDecoration(
                      color: colorList[3],
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          isDarkMode ? 'Dark' : 'Light',
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                  color: colorList[1], borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Configuraciones de planes',
                          style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              color: Colors.white),
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
                            onPressed: () async {
                              // Esperar a que regrese de AddNewPlan
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AddNewPlan(),
                                  ));

                              // Si el resultado no es nulo, recargar planes
                              if (result == true) {
                                setState(() {
                                  plansFuture = fetchPlans();
                                });
                              }
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.add_circle_outlined,
                                  color: Colors.white,
                                ),
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
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color: Colors.black),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
