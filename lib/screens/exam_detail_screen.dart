import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/exam_provider.dart';
import 'package:la_dinamica_app/screens/add_students_evaluation.dart';

class ExamDetailScreen extends ConsumerStatefulWidget{

  final Evaluations exam;
  final List<JoinMetric> metrics;
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
  final List<Metric> metrics = [];
  final Map<String, String?> examDescriptions = {};
  final Map<String, String> examTypes = {};
  final Map<String, bool> examhigger = {};
  final List<MetricCard> examCards = [];
  // examState will be accessed in the build method using ref.watch(examProvider)

  @override
  void initState(){
    super.initState();
    loadExamDetails();  
  }

  void addMetricCard(Metric metric) {
    examCards.add(MetricCard(metric: metric));
  }

  loadExamDetails() async {

    for (var entry in widget.metrics) {
      if(entry.metric!=null)
      {
        setState(() {
        addMetricCard(entry.metric!);
        metrics.add(entry.metric!);
        examTypes[entry.metric!.name] = entry.metric!.type!;
        examDescriptions[entry.metric!.name] = entry.metric!.description ?? " ";
        examhigger[entry.metric!.name] = entry.metric!.higgerBetter!;
        });
      }
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
                    ref.read(examProvider.notifier).disposeAll();
                    ref.read(examProvider.notifier).setEvalname(widget.exam);
                    ref.read(examProvider.notifier).setActualState(metrics[0]);
                    ref.read(examProvider.notifier).setMetrics(metrics);
                    ref.read(examProvider.notifier).getMetricNames();
                    ref.read(examProvider.notifier).setTypes(examTypes);
                    ref.read(examProvider.notifier).setDescriptions(examDescriptions);
                    ref.read(examProvider.notifier).setHiggerBetter(examhigger);
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

  final Metric metric;

  const MetricCard({
    super.key,
    required this.metric,
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
            Text(metric.name, style: GoogleFonts.gochiHand(fontSize: 19)),
            Text(metric.type!, style: GoogleFonts.gochiHand(fontSize: 14)),
            Text(metric.description != null ? metric.description! : '', style: GoogleFonts.gochiHand(fontSize: 10)),

          ],
        ),
      ),
    );
  }
}


