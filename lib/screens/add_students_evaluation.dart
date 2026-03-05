import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/providers/all_students_provider.dart';
import 'package:la_dinamica_app/providers/exam_provider.dart';
import 'package:la_dinamica_app/providers/students_evaluated_provider.dart';
import 'package:la_dinamica_app/screens/grade_registration_screen.dart';
import 'package:la_dinamica_app/widgets/preview_student_container_reduce.dart';


class ExamStudentSelectionPage extends ConsumerStatefulWidget {
  
  const ExamStudentSelectionPage({
    super.key,
    });

  @override
  ConsumerState<ExamStudentSelectionPage> createState() => _ExamStudentSelectionPageState();
}

class _ExamStudentSelectionPageState extends ConsumerState<ExamStudentSelectionPage> {
  String? selectedDate;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final studentsFuture = ref.watch(studentsProvider);
    final selectedStudents = ref.watch(selectedStudentsProvider);

    void startExam() {
      if (selectedStudents.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Selecciona al menos un alumno')),
        );
        return;
      }
      ref.read(examProvider.notifier).addStudents(
        studentsFuture.value!.where((student) => selectedStudents.contains(student.user_id)).toList()
      );
      debugPrint('🧪 Iniciando prueba con ${selectedStudents.length} alumnos');
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => GradeRegistrationScreen(),
      ));
    }

    return Scaffold(
      body: studentsFuture.when(
        error: (e,s)=>Center(child: Text("error al obtener datos de alumnos"),), 
        loading: ()=>CircularProgressIndicator(),
        data:(students) {
            return SafeArea(
              child: Scaffold(
                body: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Selecciona los alumnos para la prueba',
                      style: GoogleFonts.mulish(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.08),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: students.length,
                        itemBuilder: (context, i) {
                          return FadeInUp(
                            child: Column(
                              children: [
                                Dismissible(
                                  key: Key(students[i].user_id.toString()),
                                  background: Container(
                                    color: const Color.fromARGB(255, 102, 165, 104),
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 20),
                                    child: const Icon(Icons.add_task, color: Colors.white),
                                  ),
                                  confirmDismiss: (direction) async {
                                    if (direction == DismissDirection.startToEnd) {
                                      ref.read(selectedStudentsProvider.notifier)
                                          .toggle(students[i].user_id!);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Alumno agregado a la lista'),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    } else if (direction == DismissDirection.endToStart) {
                                      ref.read(selectedStudentsProvider.notifier)
                                          .remove(students[i].user_id!);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Alumno eliminado de la lista'),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                    return false;
                                  },
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor: colorList[6],
                                      child: PreviewStudentContainerReduce(
                                        student: students[i],
                                        backgroundColor: selectedStudents.contains(students[i].user_id!)
                                            ? Colors.green.withAlpha(30)
                                            : Colors.transparent,
                                        trailingIcon: selectedStudents.contains(students[i].user_id!)
                                            ? const Icon(Icons.check_circle, color: Colors.green)
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(height: 0, indent: 20, endIndent: 20),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: () => startExam(),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Iniciar Prueba'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
        },
        ),
    );
  }
}


