import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/exam_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/screens/add_students_evaluation.dart';

class ExamDetailScreen extends ConsumerStatefulWidget{

  final Evaluations exam;
  final List<JointMetric> metrics;
  final UserLocal user;
  

  const ExamDetailScreen({
    super.key,
    required this.exam,
    required this.metrics,
    required this.user,
  });

  @override
  _ExamDetailScreenState createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends ConsumerState<ExamDetailScreen> {
  final Map<String, List<String>>? examDetails = {};
  final Map<String, String?> examDescriptions = {};
  final List<MetricCard> examCards = [];
  // examState will be accessed in the build method using ref.watch(examProvider)

  @override
  void initState(){
    super.initState();
    loadExamDetails();  
  }

  void addMetricCard(String name, List<String>? submetrics) {
    examCards.add(MetricCard(name: name, submetrics: submetrics));
  }

  loadExamDetails() async {
    final awsDb = DataStoreReadService();

    for (var joinmetric in widget.metrics){
      examDescriptions[joinmetric.metric!.name] = joinmetric.metric!.description;
      final submetrics = await awsDb.getJoinSubMetrics(widget.user.tenantId, joinmetric.metric!);
      if (submetrics != null) {
        setState(() {
          examDetails![joinmetric.metric!.name] = submetrics.map((e) => e.submetric!.name).toList();
          for (var submetric in submetrics) {
            examDescriptions[submetric.submetric!.name] = submetric.submetric!.description;
          }
        });
      } else {
        safePrint("No se encontraron métricas para ${joinmetric.metric!.name}");
      }
    }
    for (var entry in examDetails!.entries) {
      setState(() {
        addMetricCard(entry.key, entry.value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exam.name!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Detalles del Examen:", style: GoogleFonts.michroma(fontSize: 20),),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: examCards.length,
                itemBuilder: (context, index) {
                  return examCards[index];
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Volver"),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(examProvider.notifier).setMetrics(examDetails!);
                    ref.read(examProvider.notifier).setDescriptions(examDescriptions);
                    ref.read(examProvider.notifier).setActualState(examDetails!.keys.first);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ExamStudentSelectionPage())
                      );
                  },
                  child: const Text("Aplicar"),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String name;
  final List<String>? submetrics;

  const MetricCard({
    super.key,
    required this.name,
    this.submetrics,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.grey,
      elevation: 3,
      color: colorList[2], //Color.fromRGBO(37,55, 69, 0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: GoogleFonts.gochiHand(fontSize: 23, fontWeight: FontWeight.bold)),
            if (submetrics != null && submetrics!.isNotEmpty)
              ...submetrics!.map((submetric) => Text("    - $submetric", style: GoogleFonts.gochiHand(fontSize: 15),)).toList(),
          ],
        ),
      ),
    );
  }
}


