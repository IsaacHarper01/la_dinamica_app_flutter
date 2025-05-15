import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/provider/theme_provider.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/students_provider.dart';
import 'package:la_dinamica_app/screens/scanner.dart';
import 'package:la_dinamica_app/widgets/calendar_widget_general.dart';

import '../model/student.dart';
import '../widgets/preview_student_container.dart';
import '../widgets/search_student_container.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late String selectedDate;

  @override
  void initState() {
    super.initState();

    // Defer execution to avoid modifying state during widget build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedDate = ref.read(dateProvider);
      print(selectedDate);
      ref.read(studentsProvider.notifier).fetchAttendanceToday(selectedDate);
    });
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
      print("No se escanearon datos o hubo un error");
      return;
    }

    final id = result['id'];
    final name = result['name'];

    await ref
        .read(studentsProvider.notifier)
        .insertAttendance(id, name, selectedDate);
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
    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    final studentsState = ref.watch(studentsProvider);

    void _onDateSelected(String date) {
      setState(() {
        ref.read(dateProvider.notifier).state = date;
      });
    }

    return Scaffold(
      appBar: AppBar(
        actions: [CalendarButton()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => registerAssistance(context),
        child: const Icon(Icons.qr_code_scanner_outlined),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: studentsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (students) {
          if (students == null || students.isEmpty) {
            return Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  isDarkMode
                      ? 'assets/images/f_ma18.png'
                      : 'assets/images/f_ma11.png',
                  height: isDarkMode ? screenHeight * 0.3 : screenHeight * 0.2,
                  fit: BoxFit.cover,
                ),
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
                                  .deleteAttendance(
                                      student.id, ref.watch(dateProvider));
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
