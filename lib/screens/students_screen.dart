import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/attendance_provider.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/students_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/add_student_screen.dart';
import 'package:la_dinamica_app/screens/student_detail_screen.dart';
import 'package:la_dinamica_app/widgets/preview_student_container_reduce.dart';
import 'package:la_dinamica_app/widgets/search_student_container.dart';

class StudentsScreen extends ConsumerStatefulWidget {
  const StudentsScreen({super.key});

  @override
  ConsumerState<StudentsScreen> createState() => StudentsScreenState();
}

class StudentsScreenState extends ConsumerState<StudentsScreen> {
  Future<List<Student>>? _studentsFuture;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() async {
    final user = await ref.read(userProvider.future);
    setState(() {
      _studentsFuture = DataStoreReadService().getStudents(user.db_id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (_studentsFuture == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<Student>>(
      future: _studentsFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Student>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final students = snapshot.data!;
          final names = students.map((g) => g.name).toList();
          final ids = students.map((g) => g.user_id).toList();
          final images = students.map((g) => g.image).toList();
          final indexList = List.generate(students.length, (index) => index);

          return ScrollViewContent(
            screenHeight: screenHeight,
            students: names,
            numAlumnos: students.length,
            indexList: indexList,
            ids: ids,
            images: images,
            onAddStudent: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddStudentScreen(),
                ),
              ).then((_) {
                _loadStudents(); // Recarga después de agregar
              });
            },
          );
        }
      },
    );
  }
}

class ScrollViewContent extends ConsumerWidget {
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

  void _deleteRegister(id) {
    final db = DatabaseHelper();
    db.deleteRegister(id, null);
    final awsDb = DataStoreDeleteService();
    awsDb.deleteStudentByID(id);
  }

  void handleDeleteDash(context, i) async {
    // Mostrar un cuadro de diálogo para confirmar la eliminación
    bool? shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text(
            '¿Estás seguro de que quieres eliminar este registro?',
          ),
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
  Widget build(BuildContext context, WidgetRef ref) {
    final attendedIds = ref.watch(attendedIdsProvider);
    final date = ref.watch(dateProvider);

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.06),
            SearchStudentContainer(circleText: 'Total de alumnos: $numAlumnos'),
            SizedBox(height: screenHeight * 0.01),
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
            SizedBox(height: screenHeight * 0.01),
            ...indexList.map((i) {
              return FadeInUp(
                child: Column(
                  children: [
                    Dismissible(
                      key: Key(ids[i].toString()),
                      // Llave única para cada elemento
                      background: Container(
                        color: const Color.fromARGB(255, 102, 165, 104),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(Icons.add_task, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: const Color.fromARGB(255, 179, 103, 97),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          ref
                              .read(studentsProvider.notifier)
                              .insertAttendance(ids[i], students[i], date);
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
                              builder:
                                  (context) => StudentDetailScreen(
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
                          backgroundColor:
                              attendedIds.contains(ids[i])
                                  ? Colors.green.withAlpha(20)
                                  : Colors.transparent,
                          trailingIcon:
                              attendedIds.contains(ids[i])
                                  ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                  : null,
                        ),
                      ),
                    ),
                    const Divider(height: 0, indent: 20, endIndent: 20),
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
