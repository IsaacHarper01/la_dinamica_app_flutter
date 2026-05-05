import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/screens/exam_detail_screen.dart';

class ViewExamsBox extends ConsumerStatefulWidget{
  final List<Evaluations>? evaluations;
  final UserLocal user;

  const ViewExamsBox({
    super.key,
    required this.evaluations,
    required this.user,
    });

  @override
  ConsumerState<ViewExamsBox> createState() => _ViewExamsBoxState(); 
}

class _ViewExamsBoxState extends ConsumerState<ViewExamsBox> {
  Evaluations? selectedExamId;
  final awsDb = DataStoreReadService();
  final awsDelete = DataStoreDeleteService(); 
  List<JoinMetric>? examMetrics;

  void handleDeleteExam(Evaluations exam) async{
    bool? shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
      title: const Text("Eliminar examen"),
      content: const Text("¿Estás seguro de que deseas eliminar este examen?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text("Eliminar"),
        ),
      ],
    );
  },
    );
    if (shouldDelete == true) {
      awsDelete.deleteExamn(exam, widget.user.tenant!.tenant_id);//aws.deleteExamn() I have to implement this method
      debugPrint("Examen eliminado: ${exam.name}");
    } else {
      debugPrint("Eliminación cancelada");
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 400,
      decoration: BoxDecoration(
        color: colorList[1],
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Exámenes disponibles",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),
              ...?widget.evaluations?.map((exam) {
                final isSelected = exam == selectedExamId;
                return Card(
                  color: isSelected ? Colors.green[100] : colorList[2],
                  child: ListTile(
                    title: Text(exam.name ?? "Sin nombre", style: GoogleFonts.gochiHand(color: colorList[4], fontSize: 20),),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        handleDeleteExam(exam);
                      },
                    ),
                    onTap: () {
                      setState(() {
                        selectedExamId = exam;
                      });
                      debugPrint("Selected exam: ${exam.name}");
                    },
                  ),
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async{
                  if (selectedExamId != null){
                    final selectedExam = widget.evaluations?.firstWhere((exam) => exam == selectedExamId);
                    debugPrint("Proceeding with exam: ${selectedExam?.name}");
                    examMetrics = await awsDb.getJoinMetrics(widget.user.tenant!.tenant_id, selectedExam!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExamDetailScreen(
                          exam: selectedExam,
                          metrics: examMetrics!,
                          user: widget.user,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Por favor, selecciona un examen.")),
                    );
                  }
                },
                child: const Text("Ver detalles del examen", style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
