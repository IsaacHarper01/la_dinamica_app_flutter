import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/providers/exam_provider.dart';
import 'package:la_dinamica_app/providers/students_evaluated_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/widgets/exam/set_base10_widget.dart';
import 'package:la_dinamica_app/widgets/preview_text_student_container.dart';
import 'package:la_dinamica_app/widgets/exam/stop_wacth_widget.dart';
import 'package:la_dinamica_app/widgets/test_name_description_box.dart';

class GradeRegistrationScreen extends ConsumerStatefulWidget{

  const GradeRegistrationScreen({
    super.key,
  });

  @override
  ConsumerState<GradeRegistrationScreen> createState() => _GradeRegistrationState();
}

class _GradeRegistrationState extends ConsumerState<GradeRegistrationScreen>{
  UserLocal? user;

  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    loadUser();
    controllers = List.generate(
    ref.read(examProvider).students.length,
    (index) => TextEditingController(),
    );
  }

Future<void> loadUser() async{
  user = await ref.read(userProvider.future);
}
  void saveGrades() {
    final examState = ref.read(examProvider);
    final students = examState.students;
    final currentTest = examState.actualState;

    for (var i = 0; i < students.length; i++) {
      final grade = controllers[i].text.isNotEmpty ? controllers[i].text  : "0.0";

      ref.read(examProvider.notifier).setGrade(
            studentId: students[i].user_id.toString(),
            metricName: currentTest,
            grade: grade,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final examState = ref.watch(examProvider);
    final students = examState.students;
    final tests = examState.descriptions.keys.toList();
    final currentTest = examState.actualState;
    final types = examState.types;
    final length = students.length;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: 
        SingleChildScrollView(
          child: Column(
            children: [
              TestInfoBox(),
              SizedBox(height: 20,),
              if (types[currentTest] == "Tiempo") ...[
                StopwatchWidget(),
                SizedBox(height: 10),
                SetBase10Widget(),
                SizedBox(height: 20),
              ],
          
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
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
                      return PreviewStudentContainerText(
                        type: types[currentTest]!,
                        name: students[index].name!,
                        id: students[index].user_id!,
                        image: students[index].image!,
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        controller: controllers[index],
                      );
                    },
                  ),
                ),
              
              ElevatedButton(
                onPressed: () {
                if ((tests.indexOf(currentTest) + 1) % tests.length == 0){
                  saveGrades();
                  ref.read(examProvider.notifier).uploadGrades(user!.tenant.tenant_id, user!.userId);
                  ref.read(examProvider.notifier).disposeAll();
                  ref.read(selectedStudentsProvider.notifier).clear();
                  Navigator.pop(context);
                }else{
                  saveGrades();
                  safePrint("actual provider state: ${ref.read(examProvider.notifier).state.grades}");
                  ref.read(examProvider.notifier).setActualState(tests[(tests.indexOf(currentTest) + 1) % tests.length]);
                  for (var controller in controllers) {
                    controller.clear();
                  }
                  }             
                },
                child: const Icon(Icons.arrow_circle_right),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

