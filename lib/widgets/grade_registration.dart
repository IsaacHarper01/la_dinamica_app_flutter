import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/providers/exam_provider.dart';
import 'package:la_dinamica_app/widgets/preview_text_student_container.dart';
import 'package:la_dinamica_app/widgets/stop_wacth_widget.dart';

class GradeRegistrationScreen extends ConsumerStatefulWidget{
  const GradeRegistrationScreen({
    super.key,
  });

  @override
  ConsumerState<GradeRegistrationScreen> createState() => _GradeRegistrationState();
}

class _GradeRegistrationState extends ConsumerState<GradeRegistrationScreen>{

  @override
  Widget build(BuildContext context) {
    final examState = ref.watch(examProvider);
    final students = examState.students;
    final tests = examState.descriptions.keys.toList();
    final currentTest = examState.actualState;
    final description = examState.descriptions[currentTest] ?? "";
    final types = examState.types;
    final length = students.length;
    
    final List<PreviewStudentContainerText> studentsContainer = students.map((student) => 
      PreviewStudentContainerText(
        type: types[currentTest]!,
        name: student.name!,
        id: student.user_id!,
        image: student.image!,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      )
    ).toList(); 

    return Scaffold(

      body: SafeArea(
        child: Column(
        children: [
          Center(
            child: Text(
              currentTest,
              style: GoogleFonts.gochiHand(fontSize: 20),
              )),
          const SizedBox(height: 10),
          Text(
            description,
            style: GoogleFonts.montserrat(fontSize: 16),
          ),
          if (types[currentTest] == "Tiempo") ...[
            SizedBox(height: 20),
            StopwatchWidget(),
            SizedBox(height: 20),
          ],

          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorList[1],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
                itemCount: length,
                itemBuilder: (context, index) {
                  return studentsContainer[index];
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(examProvider.notifier).setActualState(tests[(tests.indexOf(currentTest) + 1) % tests.length]);
        },
        child: const Icon(Icons.arrow_circle_right),
      ),
    );
  }
}

