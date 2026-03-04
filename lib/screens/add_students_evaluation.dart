import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/Student.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/exam_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/students_evaluated_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
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
  Future<List<Student>>? _studentsFuture;
  UserLocal? user;
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() async {
    final _user = await ref.read(userProvider.future);
    final _date = ref.read(dateProvider);
    setState(() {
      user = _user;
      selectedDate = _date;
      _studentsFuture = DataStoreReadService().getStudents(user!.tenant.tenant_id);
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

          return Scroll(
            screenHeight: screenHeight,
            students: students,
            names: names,
            indexList: indexList,
            ids: ids,
            images: images,
            user: user!,
            date: selectedDate!,
          );
        }
      },
    );
  }
}

class Scroll extends ConsumerWidget {
  Scroll({
    super.key,
    required this.screenHeight,
    required this.students,
    required this.names,
    required this.indexList,
    required this.ids,
    required this.images,
    required this.user,
    required this.date,
  });

  final double screenHeight;
  final List<Student> students;
  final List<dynamic> names;
  List<dynamic> ids;
  final List<dynamic> images;
  final List<int> indexList;
  final UserLocal user;
  final String date;


  @override
Widget build(BuildContext context, WidgetRef ref) {
  final selectedStudents = ref.watch(selectedStudentsProvider);

  void startExam() {
    if (selectedStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Selecciona al menos un alumno')),
      );
      return;
    }
    ref.read(examProvider.notifier).addStudents(
      students.where((student) => selectedStudents.contains(student.user_id)).toList()
    );
    debugPrint('🧪 Iniciando prueba con ${selectedStudents.length} alumnos');
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => GradeRegistrationScreen(),
    ));
  }

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
              itemCount: indexList.length,
              itemBuilder: (context, i) {
                return FadeInUp(
                  child: Column(
                    children: [
                      Dismissible(
                        key: Key(ids[i].toString()),
                        background: Container(
                          color: const Color.fromARGB(255, 102, 165, 104),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child: const Icon(Icons.add_task, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            ref.read(selectedStudentsProvider.notifier)
                                .toggle(ids[i]);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Alumno agregado a la lista'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          } else if (direction == DismissDirection.endToStart) {
                            ref.read(selectedStudentsProvider.notifier)
                                .remove(ids[i]);
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
                              backgroundColor: selectedStudents.contains(ids[i])
                                  ? Colors.green.withAlpha(30)
                                  : Colors.transparent,
                              trailingIcon: selectedStudents.contains(ids[i])
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
 }
}

