import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/add_students_to_gruop_provider.dart';
import 'package:la_dinamica_app/widgets/preview_student_container_reduce.dart';

class StudentsListWidget extends ConsumerStatefulWidget {
  final List<Student> allstudents;
  final double screenHeight;

  const StudentsListWidget({
    super.key,
    required this.allstudents,
    required this.screenHeight,
    });

  @override
  ConsumerState<StudentsListWidget> createState() => _StudentsListWidgetState();
}

class _StudentsListWidgetState extends ConsumerState<StudentsListWidget> {
  
  @override
  Widget build(BuildContext context) {
    final studentsinGroup = ref.watch(groupStudentsProvider);
    final indexList = List.generate(widget.allstudents.length, (index) => index);
    final ids = widget.allstudents.map((g) => g.user_id).toList();
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
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(),
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
                            ref.read(groupStudentsProvider.notifier).add(widget.allstudents[i]);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Alumno agregado correctamente al grupo'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ref.read(groupStudentsProvider.notifier).remove(widget.allstudents[i]);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Alumno eliminado correctamente del grupo'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          return false;
                        },
      
                        child: PreviewStudentContainerReduce(
                            name: widget.allstudents[i].name!,
                            id: widget.allstudents[i].user_id!,
                            image: widget.allstudents[i].image!,
                            backgroundColor:
                                studentsinGroup.contains(widget.allstudents[i])
                                    ? Colors.green.withAlpha(20)
                                    : Colors.transparent,
                            trailingIcon:
                                studentsinGroup.contains(ids[i])
                                    ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                    : null,
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
      ),
    );
  }
}