import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/add_students_to_gruop_provider.dart';
import 'package:la_dinamica_app/screens/student_detail_screen.dart';
import 'package:la_dinamica_app/widgets/preview_student_container_reduce.dart';

class StudentsByGroupListWidget extends ConsumerStatefulWidget {
  final List<Student> allstudents;
  final List<Student> filterStudents;
  final bool showAll;
  final double screenHeight;

  const StudentsByGroupListWidget({
    super.key,
    required this.allstudents,
    required this.filterStudents,
    required this.showAll,
    required this.screenHeight,
    });

  @override
  ConsumerState<StudentsByGroupListWidget> createState() => _StudentsListWidgetState();
}

class _StudentsListWidgetState extends ConsumerState<StudentsByGroupListWidget> {
  
  
  @override
  Widget build(BuildContext context) {
    List<Student> showedStudents = widget.showAll ? widget.allstudents : widget.filterStudents;
   
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.white,
          width: 2
          ),
        borderRadius: BorderRadius.circular(12)
        ),
      margin: const EdgeInsets.all(16),
      height: widget.screenHeight*0.5,
      child: Column(
            children: [
              SizedBox(),
              Expanded(
                child: 
                ListView.builder(
                  itemCount: showedStudents.length,
                  itemBuilder: (context, index){
                    return FadeInUp(
                      child: Column(
                        children: [
                          Dismissible(
                            key: Key(showedStudents[index].user_id.toString()),
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
                                ref.read(groupStudentsProvider.notifier).add(showedStudents[index]);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  snackBarAnimationStyle: AnimationStyle(duration: Duration(milliseconds: 500)),
                                  const SnackBar(
                                    content: Text('Alumno agregado correctamente al grupo'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ref.read(groupStudentsProvider.notifier).remove(showedStudents[index]);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Alumno eliminado correctamente del grupo'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              return false;
                            },
                            child: InkWell(
                              onTap:(){
                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => StudentDetailScreen(
                                              student: showedStudents[index],
                                            ),
                                      ),
                                    );
                              },
                              child: PreviewStudentContainerReduce(
                                  student: showedStudents[index],
                                  backgroundColor:
                                      widget.filterStudents.contains(showedStudents[index])
                                          ? Colors.green.withAlpha(20)
                                          : Colors.transparent,
                                  trailingIcon:
                                      widget.filterStudents.contains(showedStudents[index])
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
                )
              )
            ],
          ),
        );
  }
}