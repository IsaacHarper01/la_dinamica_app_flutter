import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/Student.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/students_evaluated_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/widgets/preview_student_container_reduce.dart';


class ExamStudentSelectionPage extends ConsumerStatefulWidget {
  const ExamStudentSelectionPage({super.key});

  @override
  ConsumerState<ExamStudentSelectionPage> createState() => _ExamStudentSelectionPageState();
}

class _ExamStudentSelectionPageState extends ConsumerState<ExamStudentSelectionPage> {
  final Set<String> _selectedStudentIds = {};
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
      _studentsFuture = DataStoreReadService().getStudents(user!.tenantId);
    });
  }

  void _startExam(List<Student> students) {
    final selected = students.where((s) => _selectedStudentIds.contains(s.id)).toList();

    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Select at least one student')),
      );
      return;
    }

    debugPrint('🧪 Starting exam with ${selected.length} students');
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
            students: names,
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
  const Scroll({
    super.key,
    required this.screenHeight,
    required this.students,
    required this.indexList,
    required this.ids,
    required this.images,
    required this.user,
    required this.date,
  });

  final double screenHeight;
  final List<dynamic> students;
  final List<dynamic> ids;
  final List<dynamic> images;
  final List<int> indexList;
  final UserLocal user;
  final String date;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStudents = ref.watch(selectedStudentsProvider);

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.06),
        
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
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          ref
                              .read(selectedStudentsProvider.notifier)
                              .toggle(ids[i]);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Alumno agregado a la lista'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } 
                        return false;
                      },

                      child: Material(
                        color: Colors.transparent, // so it doesn't override your background
                        child: InkWell(
                          splashColor: colorList[6],
                          child: PreviewStudentContainerReduce(
                            name: students[i],
                            id: ids[i],
                            image: images[i],
                            backgroundColor:
                                selectedStudents.contains(ids[i])
                                    ? Colors.green.withAlpha(20)
                                    : Colors.transparent,
                            trailingIcon:
                                selectedStudents.contains(ids[i])
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    : null,
                          ),
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

// Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton.icon(
//                 onPressed: () {},
//                 icon: const Icon(Icons.play_arrow),
//                 label: const Text('Iniciar Prueba'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size.fromHeight(50),
//                 ),
//               ),
//             ),