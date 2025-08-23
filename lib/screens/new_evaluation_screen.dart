import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/Evaluations.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/add_metrics_screen.dart';
import 'package:la_dinamica_app/widgets/view_exams_box.dart';

class NewEvaluationScreen extends ConsumerStatefulWidget{
  const NewEvaluationScreen({super.key});

  @override
  ConsumerState<NewEvaluationScreen> createState() => _NewEvaluationScreenState();
}

class _NewEvaluationScreenState extends ConsumerState<NewEvaluationScreen> {
  UserLocal? user;
  List<Evaluations>? _evaluations;

  @override
  void initState() {
    super.initState();
    loadExamns();  
  }
  
  Future<void> loadExamns() async {
    final _user = await ref.read(userProvider.future);
    setState(() {
      user = _user;
    });
    final awsDb = DataStoreReadService();
    final exams = await awsDb.getEvaluations(user!.tenantId);
    setState(() {
      _evaluations = exams;
    });
    safePrint("Exámenes cargados: $_evaluations");
  }

  @override
  Widget build(BuildContext context) {
    
    if (_evaluations == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Evaluación'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NewMetricsPage()),);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // ⬅️ Big rounded corners
                  ),
                  minimumSize: const Size(400, 200), // ⬅️ Square shape
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.zero, // remove internal padding
                ),
                child: const Icon(
                  Icons.add,
                  size: 40, // 
                  color: Colors.white,
                ),
              ),
            Text("Crear nueva prueba"),
            SizedBox(height: 40),
            ViewExamsBox(evaluations: _evaluations, user: user!), 
              ]
        ),
      ),  
    );
  }
}