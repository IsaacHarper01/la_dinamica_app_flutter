import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/Grades.dart';
import 'package:la_dinamica_app/providers/actual_student_grades_provider.dart';
import 'package:la_dinamica_app/providers/image_fromS3_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/buttons_menu_metrics.dart';
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
  List<Grades>? grades;
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
    final aws = DataStoreReadService();
    setState(() {
      user = _user;
    });
    grades = await aws.getLastExam(user!.tenant.tenant_id, widget.studentId);
    if(grades != null){
      ref.read(studentGradesProvider.notifier).setGrades(grades!);
    }
    safePrint("Calificaciones obtenidas para el estudiante ${widget.studentId} son: $grades");
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = ref.watch(studentImageProvider(widget.image));
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenWidth =isPortatil ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.8;
    final grades = ref.watch(studentGradesProvider).actualGrades;
    
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
                              child: ButtonsMenu(options: ["Último Examen","Último mes","Último Año","Todo"], screenWidth: screenWidth)
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
                SizedBox(
                  height: 330,
                  child: grades!.length == 0
                      ? const Center(
                          child: Text(
                            "No hay calificaciones disponibles",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                            itemCount: grades.length,
                            itemBuilder: (context, index) {
                              final grade = grades[index];
                              return TotalGrades(
                                grade: grade,
                              );
                            },
                          ),
                ),
              ],
            ),
          Container(
            height: 400,
            color: const Color.fromRGBO(35, 55, 69, 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(74, 92, 106, 1.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
    );
  }
}
