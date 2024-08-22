import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/screens/add_student_screen.dart';
import 'package:la_dinamica_app/screens/student_detail_screen.dart';
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
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight = isPortatil
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 2;

    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.06,
          ),
          const SearchStudentContainer(circleText: 'Total de alumnos: 150'),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Padding(
            padding: EdgeInsets.only(right: screenHeight * 0.01),
            child: Row(children: [
              const Spacer(),
              FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddStudentScreen()));
                },
                label: const Text('Agregar alumno'),
                icon: const Icon(Icons.group_add_rounded),
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(colorList[3])),
              ),
            ]),
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          ...students.map((student) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentDetailScreen(name: student),
                      ),
                    );
                  },
                  splashColor: colorList[6],
                  child: PreviewStudentContainerReduce(name: student),
                ),
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
