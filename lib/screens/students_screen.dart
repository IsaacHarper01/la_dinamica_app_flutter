import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/screens/add_student_screen.dart';
import 'package:la_dinamica_app/screens/student_detail_screen.dart';
import 'package:la_dinamica_app/widgets/preview_student_container_reduce.dart';
import 'package:la_dinamica_app/widgets/search_student_container.dart';

//const students = ['Sebas Putin','Alex Sintec','Isaac Hernandez'];

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight = isPortatil
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 2;
    final db = DatabaseHelper();
    return Scaffold(
      body: FutureBuilder(
        future: db.fetchGeneralData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            //El snapshot.data contiene la informacion en forma de lista de los alumnos[ids,names,emails,phones,address,ages,birthdays]
            List<dynamic> students = snapshot.data['names'];
            List<dynamic> students_ids = snapshot.data['ids'];
            List<int> students_index =
                List.generate(students.length, (index) => index);
            int num = students.length;
            //probablemente sea mejor pasarle todo el snapshot a scroll view para tener no solo la informacion de los nombres
            return scroll_virew(
              screenHeight: screenHeight,
              students: students,
              num_alumnos: num,
              index_list: students_index,
              ids: students_ids,
            );
          }
        },
      ),
    );
  }
}

class scroll_virew extends StatelessWidget {
  const scroll_virew({
    super.key,
    required this.screenHeight,
    required this.students,
    required this.num_alumnos,
    required this.index_list,
    required this.ids,
  });

  final double screenHeight;
  final List<dynamic> students;
  final List<dynamic> ids;
  final int num_alumnos;
  final List<int> index_list;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Center(
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.06,
          ),
          SearchStudentContainer(circleText: 'Total de alumnos: $num_alumnos'),
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
          ...index_list.map((i) {
            return FadeInUp(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StudentDetailScreen(name: students[i]),
                        ),
                      );
                    },
                    splashColor: colorList[6],
                    child: PreviewStudentContainerReduce(
                      name: students[i],
                      id: ids[i],
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
          })
        ],
      ),
    ));
  }
}
