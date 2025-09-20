import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/Grades.dart';
import 'package:la_dinamica_app/providers/image_fromS3_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/select_date_range_metrics.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/bar_grades_indicator.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/buttons_menu_metrics.dart';


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
  Grades? grades;

  @override
  void initState() {
    super.initState();
    title = widget.name;
    photo = widget.image;
    loadData();
  }

  void loadData() async{
    final _user = await ref.read(userProvider.future);
    final selectedRange = ref.read(selectedDateProviderMetrics);
    final aws = DataStoreReadService();
    setState(() {
      user = _user;
    });
    grades = await aws.getLastExam(user!.tenantId, widget.studentId);
    safePrint("Calificaciones obtenidas para el estudiante ${widget.studentId} son: $grades");
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = ref.watch(studentImageProvider(widget.image));
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight =isPortatil ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 2;
    
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(title))),
      backgroundColor: const Color.fromRGBO(6, 20, 27, 1.0),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 400,
            color: const Color.fromRGBO(35, 55, 69, 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 280,
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Opacity(
                          opacity: 0.7,
                          child: imageUrl.when(
                      data: (url) => Image.network(
                        url ?? "",
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/default_profile.jpg',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      loading: () => SizedBox(
                        width: screenHeight * 0.06,
                        height: screenHeight * 0.06,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (_, __) => Image.asset(
                        'assets/images/default_profile.jpg',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 350,
                  width: 400,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(74, 92, 106, 1.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          child: ButtonsMenu(options: ["Último Examen","Último mes","Último Año","Todo"])
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                height: 330,
                color: const Color.fromRGBO(17, 33, 45, 1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 300,
                      width: 400,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 12),
                            StatBar(label: "Top Speed", filled: 8),
                            SizedBox(height: 12),
                            StatBar(label: "Parkour", filled: 9),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                  width: 620,
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
    );
  }
}
