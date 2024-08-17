import 'package:flutter/material.dart';
import 'package:la_dinamica_app/widgets/preview_student_container_reduce.dart';
import 'package:la_dinamica_app/widgets/search_student_container.dart';

const students = <String>[
  'Isaac se la super come',
  'Paco',
  'Chava',
  'Alex',
  'Sebas',
  'Diego',
  'Carlos',
  'Hector'
];

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.06,
          ),
          FilledButton.icon(
            onPressed: () {
              //TODO, hacer funcion de agregar
            },
            label: const Text('Agregar alumno'),
            icon: const Icon(Icons.group_add_rounded),
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          const SearchStudentContainer(circleText: 'Total de alumnos: 150'),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          ...students.map((student) {
            return Column(
              children: [
                PreviewStudentContainerReduce(name: student),
                const Divider(
                  height: 0,
                  indent: 20,
                  endIndent: 20,
                ),
              ],
            );
          })
        ],
      ),
    )));
  }
}
