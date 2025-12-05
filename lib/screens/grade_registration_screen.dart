import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/providers/exam_provider.dart';
import 'package:la_dinamica_app/providers/students_evaluated_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
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

double convertTime(String time){
  List<String> parts = time.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);

  // Split seconds and milliseconds
  List<String> secParts = parts[2].split('.');
  int seconds = int.parse(secParts[0]);
  int hundredths = int.parse(secParts[1]); // "91" hundredths

  // Convert to total seconds as double
  double totalSeconds = hours * 3600 + minutes * 60 + seconds + hundredths / 100;
  return totalSeconds;
}

bool saveGrades(BuildContext context) {
    final examState = ref.read(examProvider);
    final students = examState.students;
    final currentTest = examState.actualState;
    safePrint("ACTUAL TEST $currentTest");
    for (var i = 0; i < students.length; i++) {
      final grade = controllers[i].text.isNotEmpty ? controllers[i].text  : "";
      if(ref.read(examProvider.notifier).checkDataformat(currentTest!.type!, grade))
      {
        ref.read(examProvider.notifier).setGrade(
            studentId: students[i].id,
            metric: currentTest,
            grade: currentTest.type == "Tiempo" ? convertTime(grade) : double.parse(grade),
            );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Formato de datos incorrecto $grade'),
          backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final examState = ref.watch(examProvider);
    final students = examState.students;
    final metrics = examState.metrics;
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
              if ((types[currentTest!.name] == "Tiempo" )||(types[currentTest.name] == "Repeticiones" )) ...[
                StopwatchWidget(),
                SizedBox(height: 10),
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
                        type: types[currentTest.name]!,
                        name: students[index].name!,
                        id: students[index].user_id!,
                        image: students[index].image!,
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        controller: controllers[index],
                      );
                    },
                  ),
                ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      onPressed: (){
                        ref.read(examProvider.notifier).setActualState(metrics[(tests.indexOf(currentTest.name) - 1) % tests.length]);
                      }, 
                      child: const Icon(Icons.arrow_circle_left)
                      ),
                    if ((tests.indexOf(currentTest.name) + 1) % tests.length == 0) ...[
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed:(){}, 
                          label: Text('Combinar Resultados'),
                          icon: Icon(Icons.merge_type)
                          ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          onPressed: ()async{ 
                              if(saveGrades(context))
                                {
                                  await ref.read(examProvider.notifier).uploadGrades(user!.tenant.tenant_id, user!.userId);
                                  ref.read(selectedStudentsProvider.notifier).clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                            },
                          label: const Text('Guardar Calificaciones'),
                          icon: const Icon(Icons.save_alt_outlined),
                          ),
                      ],
                    )
                    ] else ...[
                      ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      onPressed: (){ 
                        if(saveGrades(context))
                        {
                          ref.read(examProvider.notifier).setActualState(metrics[(tests.indexOf(currentTest.name) + 1) % tests.length]);
                          for (var controller in controllers) {
                            controller.clear();
                            }
                          }
                      },
                      child: const Icon(Icons.arrow_circle_right),
                      ),
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

