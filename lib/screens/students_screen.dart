import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/screens/add_student_screen.dart';
import 'package:la_dinamica_app/screens/student_detail_screen.dart';
import 'package:la_dinamica_app/widgets/preview_student_container_reduce.dart';
import 'package:la_dinamica_app/widgets/search_student_container.dart';

//const students = ['Sebas Putin','Alex Sintec','Isaac Hernandez'];

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  Future<Map<String, dynamic>>? _studentsFuture; // Ajusta el tipo aquí

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() {
    final db = DatabaseHelper();
    _studentsFuture = db.fetchGeneralData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        // Ajusta el tipo aquí
        future: _studentsFuture,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // El snapshot.data contiene la información en forma de lista de los alumnos [ids, names, emails, phones, address, ages, birthdays]
            List<dynamic> students = snapshot.data!['names']!;
            List<dynamic> students_ids = snapshot.data!['ids']!;
            List<int> students_index =
                List.generate(students.length, (index) => index);
            int num = students.length;

            return ScrollViewContent(
              screenHeight: MediaQuery.of(context).size.height,
              students: students,
              num_alumnos: num,
              index_list: students_index,
              ids: students_ids,
              onAddStudent: () {
                _loadStudents(); // Vuelve a cargar la lista de estudiantes
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddStudentScreen(),
                  ),
                ).then((_) {
                  // Actualiza la lista al volver de la pantalla de agregar estudiante
                  setState(() {
                    _loadStudents();
                  });
                });
              },
            );
          }
        },
      ),
    );
  }
}

class ScrollViewContent extends StatelessWidget {
  const ScrollViewContent({
    super.key,
    required this.screenHeight,
    required this.students,
    required this.num_alumnos,
    required this.index_list,
    required this.ids,
    required this.onAddStudent,
  });

  final double screenHeight;
  final List<dynamic> students;
  final List<dynamic> ids;
  final int num_alumnos;
  final List<int> index_list;
  final VoidCallback onAddStudent;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.06,
            ),
            SearchStudentContainer(
              circleText: 'Total de alumnos: $num_alumnos',
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Padding(
              padding: EdgeInsets.only(right: screenHeight * 0.01),
              child: Row(
                children: [
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: onAddStudent,
                    label: const Text('Agregar alumno'),
                    icon: const Icon(Icons.group_add_rounded),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(colorList[3]),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            ...index_list.map((i) {
              return FadeInUp(
                child: Column(
                  children: [
                    Dismissible(
                      key: Key(
                          ids[i].toString()), // Llave única para cada elemento
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(Icons.arrow_forward,
                            color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        print(direction);
                        //TODO:   ISACC AQUI VAN LAS FUNCIONES CON UN IF CON DIRECTION
                        return false;
                      },

                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentDetailScreen(
                                name: students[i],
                                id: ids[i],
                              ),
                            ),
                          );
                        },
                        splashColor: colorList[6],
                        child: PreviewStudentContainerReduce(
                          name: students[i],
                          id: ids[i],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 0,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
