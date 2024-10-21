import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/screens/add_student_screen.dart';
import 'package:la_dinamica_app/screens/student_detail_screen.dart';
import 'package:la_dinamica_app/widgets/preview_student_container_reduce.dart';
import 'package:la_dinamica_app/widgets/search_student_container.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  Future<Map<String, dynamic>>? _studentsFuture;

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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // El snapshot.data contiene la información en forma de lista de los alumnos [ids, names, emails, phones, address, ages, birthdays]
            List<dynamic> students = snapshot.data!['names']!;
            List<dynamic> studentsIds = snapshot.data!['ids']!;
            List<int> studentsIndex =
                List.generate(students.length, (index) => index);
            int num = students.length;
            List<dynamic> images = snapshot.data!['images']!;

            return ScrollViewContent(
              screenHeight: MediaQuery.of(context).size.height,
              students: students,
              numAlumnos: num,
              indexList: studentsIndex,
              ids: studentsIds,
              images: images,
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
    required this.numAlumnos,
    required this.indexList,
    required this.ids,
    required this.images,
    required this.onAddStudent,
  });

  final double screenHeight;
  final List<dynamic> students;
  final List<dynamic> ids;
  final List<dynamic> images;
  final int numAlumnos;
  final List<int> indexList;
  final VoidCallback onAddStudent;

  void _insertAttendance(id, name) {
    final db = DatabaseHelper();
    db.InserAttendanceData(id, name);
    db.varifyPay(id);
  }

  void _deleteRegister(id) {
    final db = DatabaseHelper();
    db.deleteRegister(id, null);
  }

  void handleDeleteDash(context, i) async {
    // Mostrar un cuadro de diálogo para confirmar la eliminación
    bool? shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar este registro?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false); // Retornar false si cancela
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop(true); // Retornar true si confirma
              },
            ),
          ],
        );
      },
    );

    // Si el usuario confirma, eliminar el registro
    if (shouldDelete == true) {
      _deleteRegister(ids[i]);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro Eliminado'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
              circleText: 'Total de alumnos: $numAlumnos',
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
                    label: const Text(
                      'Agregar alumno',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: const Icon(
                      Icons.group_add_rounded,
                      color: Colors.white,
                    ),
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
            ...indexList.map((i) {
              return FadeInUp(
                child: Column(
                  children: [
                    Dismissible(
                      key: Key(
                          ids[i].toString()), // Llave única para cada elemento
                      background: Container(
                        color: const Color.fromARGB(255, 102, 165, 104),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(Icons.add_task,
                            color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: const Color.fromARGB(255, 179, 103, 97),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20), 
                        child:
                            const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          _insertAttendance(ids[i], students[i]);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Asistencia Registrada'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          handleDeleteDash(context, i);
                        }

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
                                image: images[i],
                              ),
                            ),
                          );
                        },
                        splashColor: colorList[6],
                        child: PreviewStudentContainerReduce(
                          name: students[i],
                          id: ids[i],
                          image: images[i],
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
            }),
          ],
        ),
      ),
    );
  }
}
