import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/config/provider/theme_provider.dart';
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
    final themeMode = ref.watch(themeNotifierProvider);
    final isDark = themeMode == ThemeMode.dark;

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
              return boxPlans(screenWidth, context, planes, isDark, themeMode);
            }
          }),
    );
  }

  Center boxPlans(double screenWidth, BuildContext context,
      List<List<String>> planes, bool isDark, ThemeMode themeMode) {
    return Center(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          spacing: 20,
          children: [
            TextButton(
              onPressed: () {
                //TODO, funcionalidad de Habilitar vencimiento
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: const Text('Habilitar vencimiento'),
            ),
            Center(
              child: PopupMenuButton<ThemeMode>(
                initialValue: themeMode,
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.color_lens),
                    SizedBox(width: 4),
                    Text('Tema'),
                  ],
                ),
                onSelected: (mode) async {
                  ref.read(themeNotifierProvider.notifier).setTheme(mode);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: ThemeMode.light,
                    child: Row(
                      children: [
                        Icon(Icons.light_mode, color: Colors.amber[400]),
                        const SizedBox(width: 8),
                        const Text('Claro'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: ThemeMode.dark,
                    child: Row(
                      children: [
                        Icon(Icons.dark_mode, color: Colors.deepPurple[800]),
                        const SizedBox(width: 8),
                        const Text('Oscuro'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: ThemeMode.system,
                    child: Row(
                      children: [
                        Icon(Icons.settings, color: Colors.grey[400]),
                        const SizedBox(width: 8),
                        const Text('Sistema'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
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
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              surfaceTintColor:
                                  Theme.of(context).colorScheme.surfaceTint,
                              foregroundColor: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              iconColor: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
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
                              spacing: 5,
                              children: [
                                Icon(Icons.add_circle_outlined),
                                Text('Agregar nuevo plan')
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
