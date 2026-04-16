import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/student_grades.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';


final studentGradesProvider = 
  StateNotifierProvider.family<GradeNotifier, AsyncValue<StudentGrades>, String>(
      (ref, studentId) => GradeNotifier(ref, studentId)); 

class GradeNotifier extends StateNotifier<AsyncValue<StudentGrades>> {
  final Ref ref;
  final String studentId;

  GradeNotifier(this.ref, this.studentId) : super(const AsyncValue.loading()) {  //by defafult load last exam
    loadExamResults(studentId,'last',null,null);
  }

  Future<void> loadExamResults(String studentId, String mode, DateTime? start, DateTime? end)async{
    final user = await ref.watch(userProvider.future);
    final aws = DataStoreReadService();

    Map<String,Map<String,double>> tscores = {}; //Map<EvalName, Map<StudentID, grade>>
    Map<String,Map<String,double>> grades = {}; //Map<EvalName, Map<StudentID, grade>>
    Map<String, double> allTotals = {};
    List<ExamResults> results = [];
    List<ExamResults> filteredResults = [];
    Set<String> allExamNamesSet = {};
    List<String> allExamNames = [];
    List<dynamic> metricsPerExam = [];
    Map<String, Map<String, dynamic>> metricsIds = {};
    Map<String,Map<String,Map<String, dynamic>>> historicalExamgrades = {}; //Evalname, metric, date
    StudentGrades newStudentGrades;
    List<JoinResults> joinResults;
    String actualExam='';

    switch (mode) {
      case 'last':
        joinResults = await aws.getLastExamResult(user.tenant.tenant_id, studentId);
        break;
      case 'range':
        joinResults = await aws.getJoinResultsRange(studentId, user.tenant.tenant_id, start!, end!);
        break;
      case 'all':
        joinResults = await aws.getAllJoinResults(user.tenant.tenant_id, studentId);
        break;
      default:
        joinResults = await aws.getLastExamResult(user.tenant.tenant_id, studentId);
        break;
    }
    
    if(joinResults.isNotEmpty)
    {
      
      for(var exam in joinResults) {
       
        results.add(exam.result!);
        final evalName = exam.result!.evaluation!.name!;
        final Map<String, double> auxGrades = adaptGradesperStudent(exam.result!)[studentId]!;
        
        if(allExamNamesSet.contains(evalName)){
          for(var metricId in auxGrades.keys){
            historicalExamgrades[evalName]![metricId]![exam.result!.date.toString()] = auxGrades[metricId];
          }
        }else{
          filteredResults.add(exam.result!);

          final examTscores = adaptTscoresperStudent(exam.result!)[studentId]!;
          allTotals[evalName] = calculateActualTotal(examTscores);
          grades[evalName] = auxGrades;
          metricsIds[evalName] = jsonDecode(exam.result!.metric_names!);
          tscores[evalName] = examTscores;

          historicalExamgrades.putIfAbsent(evalName, ()=>{});
          for(var metricId in grades[evalName]!.keys){
            historicalExamgrades[evalName]!.putIfAbsent(metricId, ()=>{});
            historicalExamgrades[evalName]![metricId]![exam.result!.date.toString()] = grades[evalName]![metricId];
           }
          }

        allExamNamesSet.add(evalName);
        }

      allExamNames = allExamNamesSet.toList();
      actualExam = allExamNames[0];
      metricsPerExam = metricsIds[actualExam]!.values.toList();

      newStudentGrades = StudentGrades(
        actualResults: results, 
        filteredActualResults: filteredResults,
        gradesPerStudent: grades, 
        tscoresPerStudent: tscores,
        historicalExamgrades: historicalExamgrades, 
        examsTotals: allTotals,
        allExamNames: allExamNames,
        metricsPerExam: metricsPerExam,
        metricsIds: metricsIds,
        actualExam: allExamNames[0],
        actualMetric: metricsPerExam[0],
        );

      safePrint('Metric GRADES: $filteredResults');
      safePrint('Metric HISTORICAL: $historicalExamgrades');
      safePrint('Metric ACTUALEXAM: $actualExam');
      // safePrint('Metric ACTUALMETRIC: ${metricsPerExam[0]}');
      // safePrint('Metric METRICS: $metricsIds');
      state = AsyncValue.data(newStudentGrades);
      }
  }

  Map<String,Map<String,Map<String, dynamic>>> getHistoricalExamGrades(Map<String, Map<String, double>> grades){
    Map<String,Map<String,Map<String, dynamic>>> result={};
    return result;
  }

  Map<String, Map<String, double>> adaptGradesperStudent(ExamResults actualExam){
    final decoded = jsonDecode(actualExam.grades!) as Map<String, dynamic>;
    final grades = decoded.map((key, value) {
      return MapEntry(
        key,
        (value as Map<String, dynamic>).map((k, v) => MapEntry(k, (v as num).toDouble())),
      );
    });
    final Map<String, Map<String, double>> gradesPerStudent = {};
    for (var metricId in grades.keys){
      for (var studentId in grades[metricId]!.keys){
        gradesPerStudent.putIfAbsent(studentId, ()=>{});
        gradesPerStudent[studentId]![metricId] = grades[metricId]![studentId]!;
      }
    }
    return gradesPerStudent; //return Map<StudentID, Map<MetricId, Grade>>
  }

  Map<String, Map<String, double>> adaptTscoresperStudent(ExamResults actualExam){ //change (Map<MetricId,Map<StudentId,Value>>) to (Map<StudentID,Map<MetricId, Value>>)
    final decoded = jsonDecode(actualExam.tscore!) as Map<String, dynamic>;
    final tscores = decoded.map((key, value) {
      return MapEntry(
        key,
        (value as Map<String, dynamic>).map((k, v) => MapEntry(k, (v as num).toDouble())),
      );
    });
    final Map<String, Map<String, double>> tscoresPerStudent = {};
    for (var metricId in tscores.keys){
      for (var studentId in tscores[metricId]!.keys){
        tscoresPerStudent.putIfAbsent(studentId, ()=>{});
        tscoresPerStudent[studentId]![metricId] = tscores[metricId]![studentId]!;
      }
    }
    return tscoresPerStudent;
  }

  double calculateActualTotal(Map<String, double> allGrades){ //(Metric,value)
    final gradesList = allGrades.values.toList();
    final total = gradesList.reduce((a,b)=>a+b)/gradesList.length;
    return total;
  }

  Future<void> setActualExam(String name)async{
    final currentExam = state.value;
    final metricsPerExam =  currentExam!.metricsIds[name]!.values.toList();
    final updated = currentExam.copyWith(actualExam: name, metricsPerExam: metricsPerExam,actualMetric: metricsPerExam[0]);
    state = AsyncValue.data(updated);
  }

  Future<void> setMetricsPerExam(List<dynamic> metrics)async{
    final currentState = state.value;
    final updated = currentState!.copyWith(metricsPerExam: metrics);
    state = AsyncValue.data(updated);
  }

  Future<void> setActualMetric(String name)async{
    final currentExam = state.value;
    final updated = currentExam!.copyWith(actualMetric: name);
    state = AsyncValue.data(updated);
  }
}
