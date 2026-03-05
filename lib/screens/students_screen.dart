import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/all_students_provider.dart';
import 'package:la_dinamica_app/providers/attendance_provider.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/attendant_students_provider.dart';
import 'package:la_dinamica_app/screens/add_student_screen.dart';
import 'package:la_dinamica_app/screens/groups.dart';
import 'package:la_dinamica_app/screens/student_detail_screen.dart';
import 'package:la_dinamica_app/widgets/preview_student_container_reduce.dart';
import 'package:la_dinamica_app/widgets/students_number_home.dart';

class StudentsScreen extends ConsumerStatefulWidget {
  const StudentsScreen({super.key});

  @override
  ConsumerState<StudentsScreen> createState() => StudentsScreenState();
}

class StudentsScreenState extends ConsumerState<StudentsScreen>  with WidgetsBindingObserver{
  UserLocal? user;
  String? selectedDate;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(searchTermProvider.notifier).state = _searchController.text;
    });
  }

  void loadStudents(){
    ref.read(studentsProvider.notifier).fetchStudents(selectedDate!);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchTermProvider.notifier).state = '';
  }

  void _deleteAttendance(id,date,tenantId) {
    final awsDb = DataStoreDeleteService();
    awsDb.deleteAttendanceByID(id, date, tenantId);
  }

  void handleDeleteDash(context, Student student) async {
    // Mostrar un cuadro de diálogo para confirmar la eliminación
    bool? shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text(
            '¿Estás seguro de que quieres eliminar esta asistencia?',
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
      _deleteAttendance(student.user_id, selectedDate, user!.tenant.tenant_id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Asistencia Eliminada'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final _studentsFuture = ref.watch(studentsProvider);
    final attendedIds = ref.watch(attendedIdsProvider);
    final date = ref.watch(dateProvider);
    final filteredStudents = ref.watch(filteredStudentsProvider);
    final searchTerm = ref.watch(searchTermProvider);

    return Scaffold(
      body: _studentsFuture.when(
      error: (e,s) => Center(child: Text("Error al obtener la lista de Alumnos"),),
      loading: () => Center(child: CircularProgressIndicator(),),
      data:(students) {
        return Column(
                children: [
                  SizedBox(height: screenHeight * 0.06),
                  StudentsNumberHome(studentsNumber: "Total de alumnos: ${students.length}"),
                  SizedBox(height: screenHeight * 0.01),
                  Padding(
                    padding: EdgeInsets.only(right: screenHeight * 0.01),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          FilledButton.icon(
                            onPressed: (){
                              Navigator.push(context, 
                                MaterialPageRoute(builder: (context)=> GroupsPage(allStudents: students, screenHeight: screenHeight,))
                              );
                            },
                            label: const Text(
                              'Grupos',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(
                              Icons.group,
                              color: Colors.white,
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(colorList[3]),
                            ),
                          ),
                          const Spacer(),
                          FilledButton.icon(
                            onPressed:(){
                              Navigator.push(context, 
                              MaterialPageRoute(builder: (builder) => AddStudentScreen())
                              );},
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
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar por ID o nombre...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon:
                          searchTerm.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: _clearSearch,
                              )
                              : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                if (filteredStudents.isEmpty && searchTerm.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(128),
                        ),
                        Text(
                          'No se encontraron estudiantes\ncon el término: "$searchTerm"',
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  )else
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index){
                        final student = filteredStudents[index];
                        return FadeInUp(
                          child: Column(
                            children: [
                              Dismissible(
                                key: Key(student.user_id.toString()),
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
                                        .read(studentsAttendanceProvider.notifier)
                                        .insertAttendance(student, date);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Asistencia Registrada'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    handleDeleteDash(context, student);
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
                                              student: student,
                                            ),
                                      ),
                                    );
                                  },
                                  splashColor: colorList[6],
                                  child: PreviewStudentContainerReduce(
                                    student: student,
                                    backgroundColor:
                                        attendedIds.contains(student)
                                            ? Colors.green.withAlpha(20)
                                            : Colors.transparent,
                                    trailingIcon:
                                        attendedIds.contains(student)
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
                      }
                     ),
                  )
                          ]
          );
        }
      )
    );
  }
}


