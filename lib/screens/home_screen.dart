import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/provider/theme_provider.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/students_provider.dart';
import 'package:la_dinamica_app/screens/scanner.dart';

import '../model/student.dart';
import '../widgets/preview_student_container.dart';
import '../widgets/search_student_container.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(studentsProvider.notifier).fetchAttendanceToday();
  }

  Future<void> registerAssistance(BuildContext context) async {
    final result = await scannerQR(context);

    if (result == null || result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID no encontrado'),
          backgroundColor: Colors.red,
        ),
      );
      safePrint("No se escanearon datos o hubo un error");
      return;
    }

    final id = result['id'];
    final name = result['name'];

    await ref.read(studentsProvider.notifier).insertAttendance(id, name);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Asistencia registrada'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;
    final screenHeight = isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 2;
    final isDarkMode = ref.watch(isDark);

    final studentsState = ref.watch(studentsProvider);
    final _dataStoreService = DataStoreService();
    DataStoreReadService dataStoreReadService = DataStoreReadService();
    DataStoreDeleteService dataStoreDeleteService = DataStoreDeleteService();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => registerAssistance(context),
        child: const Icon(Icons.qr_code_scanner_outlined),
      ),
      body: studentsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (students) {
          if (students.isEmpty) {
            return Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      isDarkMode
                          ? 'assets/images/f=ma18.png'
                          : 'assets/images/f=ma11.png',
                      height:
                          isDarkMode ? screenHeight * 0.3 : screenHeight * 0.2,
                      fit: BoxFit.cover,
                    ),
                  ),
                  FilledButton(
                      onPressed: () async {
                        await _dataStoreService.savePlan(
                          type: "Lorem ipsum dolor sit amet",
                          clases: 1020,
                          price: 123.45,
                        );
                        /* List<Plans> plans =
                            await dataStoreReadService.getPlans();
                        safePrint(plans); */
                        /* String planIdToDelete =
                            '3fc79bef-387b-47a1-b57b-0fc4bbc1940a';
                        await dataStoreDeleteService
                            .deletePlanById(planIdToDelete); */
                      },
                      child: const Text('Crear')),
                  FilledButton(
                      onPressed: () async {
                        /* await _dataStoreService.savePlan(
                          type: "Lorem ipsum dolor sit amet",
                          clases: 1020,
                          price: 123.45,
                        ); */
                        List<Plans> plans =
                            await dataStoreReadService.getPlans();
                        safePrint(plans);
                        /* String planIdToDelete =
                            '3fc79bef-387b-47a1-b57b-0fc4bbc1940a';
                        await dataStoreDeleteService
                            .deletePlanById(planIdToDelete); */
                      },
                      child: const Text('Read'))
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.06),
                  SearchStudentContainer(
                    circleText: 'Asistencias de hoy: ${students.length}',
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Column(
                      children: students.asMap().entries.map(
                    (entry) {
                      Student student = entry.value;

                      return Column(
                        children: [
                          PreviewStudentContainer(
                            name: student.name,
                            image: student.image,
                            onDismissed: () {
                              ref
                                  .read(studentsProvider.notifier)
                                  .deleteAttendance(student.id,
                                      DateTime.now().toString().split(' ')[0]);
                            },
                          ),
                          const Divider(
                            height: 0,
                            indent: 20,
                            endIndent: 20,
                          ),
                        ],
                      );
                    },
                  ).toList())
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
