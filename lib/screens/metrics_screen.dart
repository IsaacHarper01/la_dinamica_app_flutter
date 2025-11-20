
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/providers/actual_student_grades_provider.dart';
import 'package:la_dinamica_app/providers/image_fromS3_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/widgets/dropown_button.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/buttons_menu_metrics.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/progresion_time_line.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/radar_chart_all_exams.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/radar_chart_exam.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/total_grades.dart';


class MetricsPage extends ConsumerStatefulWidget {
  final String studentId;
  final String name;
  final String image;

  const MetricsPage({super.key, required this.studentId ,required this.name, required this.image});

  @override
  ConsumerState<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends ConsumerState<MetricsPage> {
  late String title;
  String photo = "assets/images/default_profile.jpg";
  UserLocal? user;
  Map<String, dynamic>? totals;

  @override
  void initState() {
    super.initState();
    title = widget.name;
    photo = widget.image;
    loadData();
  }

  void loadData() async{
    final _user = await ref.read(userProvider.future);
    setState(() {
      user = _user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = ref.watch(imageProvider(widget.image));
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenWidth =isPortatil ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.8;
    final resultsAsync = ref.watch(studentGradesProvider(widget.studentId));

    List<String> examOptions = [];

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return resultsAsync.when(
      error: (e,st)=>Center(child: Text("Error al cargar los datos del examen $e"),), 
      loading: ()=> Center(child: CircularProgressIndicator(),), 
      data: (results){
        examOptions = results.allExamNames;
        return Scaffold(
          appBar: AppBar(title: Center(child: Text(title))),
          backgroundColor: const Color.fromRGBO(6, 20, 27, 1.0),
          body: SingleChildScrollView(
            child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 350,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        Expanded(
                          child: Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Opacity(
                                  opacity: 0.7,
                                  child: imageUrl.when(
                              data: (url) => Image.network(
                                url ?? "",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/default_profile.jpg',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                              loading: () => SizedBox(
                                width: 50,
                                height: 50,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              error: (_, __) => Image.asset(
                                'assets/images/default_profile.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                                ),
                              ),
                          ),
                        ),
                      const SizedBox(width: 20),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          height: screenWidth*0.5,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SingleChildScrollView(
                                child: SizedBox(
                                  child: ButtonsMenu(
                                    options: ["Último Examen","Último mes","Último Año","Todo"], 
                                    screenWidth: screenWidth,
                                    studentId: widget.studentId,
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Column(
                  children: [
                    Container(
                      height: 330,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:Border.all(color: colorList[1], width: 2),
                        ),
                      child: results.actualResults!.isEmpty
                          ? const Center(
                              child: Text(
                                "No hay calificaciones disponibles",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ListView.builder(
                                itemCount: results.actualResults!.length,
                                itemBuilder: (context, index) {
                                  final examResult = results.actualResults![index];
                                  return TotalGrades(
                                    exam: examResult,
                                    studentId: widget.studentId,
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              SizedBox(height: 10,),
              Container(
                height: 402,
                decoration: 
                  BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:Border.all(color: colorList[1], width: 2),
                        ),
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      OptionDropdown(
                        options: examOptions,
                        onSelected: (String selected) => ref.read(studentGradesProvider(widget.studentId).notifier).setActualExam(selected),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                                Expanded(
                                  child: ProgresionTimeLine(
                                    studentId: widget.studentId,
                                    onSelected:(String selected) => ref.read(studentGradesProvider(widget.studentId).notifier).setActualMetric(selected),
                                    )),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: 
                                  RadarChartExam(studentId: widget.studentId)),
                                  ],
                                ),
                            ]
                      ),
                    ),
                  ),
                SizedBox(height: 10,),
                Container(
                  height: 400,
                  decoration: 
                    BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:Border.all(color: colorList[1], width: 2),
                        ),
                  width: double.infinity,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: RadarChartAllExams(studentId: widget.studentId),
                      ),
                  
                  )
                ],
              ),
            )
          );
        }
      );
  }
}
