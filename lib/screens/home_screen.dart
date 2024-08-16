import 'package:flutter/material.dart';
import 'package:la_dinamica_app/widgets/preview_student_container.dart';
import 'package:la_dinamica_app/widgets/search_student_container.dart';

const students = <String>[
  'Isaac se la super come'
      'Paco',
  'Chava',
  'Alex',
  'Sebas',
  'Diego',
  'Carlos',
  'Hector'
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.06,
            ),
            const SearchStudentContainer(),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            ...students.map((student) {
              return Column(
                children: [
                  PreviewStudentContainer(name: student),
                  const Divider(
                    height: 0,
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    ));
  }
}
