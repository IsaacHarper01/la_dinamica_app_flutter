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

  GradeNotifier(this.ref, this.studentId) : super(const AsyncValue.loading()) {
    loadExamResults(studentId,'last',null,null);
  }

  Future<void> loadExamResults(String studentId, String mode, DateTime? start, DateTime? end)async{
    final user = await ref.watch(userProvider.future);
    final aws = DataStoreReadService();

    Map<String,Map<String,double>> tscores = {};
    Map<String,Map<String,double>> grades = {};
    Map<String, double> allTotals = {};
    List<ExamResults> results = [];
    List<String> allExamNames = [];
    Map<String, Map<String, dynamic>> metricsIds = {};
    StudentGrades newStudentGrades;
    List<JoinResults> joinResults;
    String actualExam;
    String actualMetric;

    switch (mode) {
      case 'last':
        joinResults = await aws.getLastExamResult(user.tenant.tenant_id, studentId);
      case 'range':
        joinResults = await aws.getJoinResultsRange(studentId, user.tenant.tenant_id, start!, end!);
      case 'all':
        joinResults = await aws.getAllJoinResults(user.tenant.tenant_id, studentId);
      default:
        joinResults = await aws.getLastExamResult(user.tenant.tenant_id, studentId);
    }
    
    if(joinResults.isNotEmpty)
    {
      for(var exam in joinResults) {
        results.add(exam.result!);
        final evalName = exam.result!.evaluation!.name!;
        final examTscores = adaptTscoresperStudent(exam.result!)[studentId]!;
        tscores[evalName] = examTscores;
        allTotals[evalName] = calculateActualTotal(examTscores);
        grades[evalName] = adaptGradesperStudent(exam.result!)[studentId]!;
        allExamNames.add(evalName);
        metricsIds[evalName] = jsonDecode(exam.result!.metric_names!);
        }

      actualExam = allExamNames[0];
      final metrics = metricsIds[actualExam]!.values.toList();
      actualMetric = metrics[0] ?? '';

      newStudentGrades = StudentGrades(
        actualResults: results, 
        gradesPerStudent: grades, 
        tscoresPerStudent: tscores, 
        examsTotals: allTotals,
        allExamNames: allExamNames,
        metricsIds: metricsIds,
        actualExam: allExamNames[0],
        actualMetric: actualMetric,
        );

      safePrint('Metric DATA: $grades');
      safePrint('Metric DATA: $metricsIds');
      state = AsyncValue.data(newStudentGrades);
      }
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
    return gradesPerStudent;
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
    final updated = currentExam!.copyWith(actualExam: name);
    state = AsyncValue.data(updated);
  }

  Future<void> setActualMetric(String name)async{
    final currentExam = state.value;
    final updated = currentExam!.copyWith(actualMetric: name);
    state = AsyncValue.data(updated);
  }
}
