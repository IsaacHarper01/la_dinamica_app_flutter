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
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else{
            //El snapshot.data contiene la informacion en forma de lista de los alumnos[ids,names,emails,phones,address,ages,birthdays]
            List<dynamic> students = snapshot.data['names'];
            //probablemente sea mejor pasarle todo el snapshot a scroll view para tener no solo la informacion de los nombres
         return scroll_virew(screenHeight: screenHeight, students: students);
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
  });

  final double screenHeight;
  final List<dynamic> students;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
));
}
}
