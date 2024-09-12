import 'package:flutter/material.dart';
import 'package:la_dinamica_app/screens/scanner.dart';
import 'package:la_dinamica_app/widgets/preview_student_container.dart';
import 'package:la_dinamica_app/widgets/search_student_container.dart';
import 'package:la_dinamica_app/backend/database.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight = isPortatil
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 2;
    final db = DatabaseHelper();

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => scannerQR(),
          child: Icon(Icons.qr_code_scanner_outlined),
        ),
        body: FutureBuilder(
          future: db.fetchAttendanceToday(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              List<dynamic> ids = snapshot.data['ids'];
              List<dynamic> names = snapshot.data['names'];
              int num_alumnos = ids.length;

              return screen_info(
                screenHeight: screenHeight,
                num_alumnos: num_alumnos,
                students: names,
              );
            }
          },
        ));
  }
}

class screen_info extends StatelessWidget {
  const screen_info({
    super.key,
    required this.screenHeight,
    required this.num_alumnos,
    required this.students,
  });

  final double screenHeight;
  final int num_alumnos;
  final List<dynamic> students;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.06,
            ),
            SearchStudentContainer(
              circleText: 'Asistencias de hoy: $num_alumnos',
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            // Verifica si no hay alumnos
            num_alumnos == 0
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/f=ma11.png',
                      height: screenHeight * 0.2,
                      fit: BoxFit.cover,
                    ))
                : Column(
                    children: students.map((student) {
                      return Column(
                        children: [
                          PreviewStudentContainer(name: student),
                          const Divider(
                            height: 0,
                            indent: 20,
                            endIndent: 20,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
