import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/provider/theme_provider.dart';
import 'package:la_dinamica_app/screens/scanner.dart';
import 'package:la_dinamica_app/widgets/preview_student_container.dart';
import 'package:la_dinamica_app/widgets/search_student_container.dart';
import 'package:la_dinamica_app/backend/database.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;
    final screenHeight = isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 2;
    final db = DatabaseHelper();
    final isDarkMode = ref.watch(isDark);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => scannerQR(context),
        child: const Icon(Icons.qr_code_scanner_outlined),
      ),
      body: FutureBuilder(
        future: db.fetchAttendanceToday(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Error al cargar los datos.'));
          } else {
            List<dynamic> ids = snapshot.data['ids'] ?? [];
            List<dynamic> names = snapshot.data['names'] ?? [];
            List<dynamic> images = snapshot.data['images'] ?? [];

            List<int> studentsIndex =
                List.generate(ids.length, (index) => index);
            int numAlumnos = ids.length;

            return ScreenInfo(
                screenHeight: screenHeight,
                numAlumnos: numAlumnos,
                students: names,
                images: images,
                studentsIndex: studentsIndex,
                isDarkMode: isDarkMode);
          }
        },
      ),
    );
  }
}

class ScreenInfo extends StatelessWidget {
  const ScreenInfo(
      {super.key,
      required this.screenHeight,
      required this.numAlumnos,
      required this.students,
      required this.images,
      required this.studentsIndex,
      required this.isDarkMode});

  final double screenHeight;
  final int numAlumnos;
  final List<dynamic> students;
  final List<dynamic> images;
  final List<int> studentsIndex;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return numAlumnos == 0
        ? Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                isDarkMode
                    ? 'assets/images/f=ma18.png'
                    : 'assets/images/f=ma11.png',
                height: isDarkMode ? screenHeight * 0.3 : screenHeight * 0.2,
                fit: BoxFit.cover,
              ),
            ),
          )
        : SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.06,
                  ),
                  SearchStudentContainer(
                    circleText: 'Asistencias de hoy: $numAlumnos',
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  // Verifica si no hay alumnos
                  Column(
                    children: studentsIndex.map(
                      (i) {
                        return Column(
                          children: [
                            PreviewStudentContainer(
                              name: students[i],
                              image: images[i],
                            ),
                            const Divider(
                              height: 0,
                              indent: 20,
                              endIndent: 20,
                            ),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
          );
  }
}
