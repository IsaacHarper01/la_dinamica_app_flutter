import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/exam_state.dart';
import 'package:la_dinamica_app/models/Evaluations.dart';
import 'package:la_dinamica_app/models/ExamResults.dart';
import 'package:la_dinamica_app/models/Metric.dart';
import 'package:la_dinamica_app/models/Student.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'dart:math';

import 'package:la_dinamica_app/providers/read_queries_aws.dart';


class ExamNotifier extends Notifier<ExamState> {
  @override
  ExamState build() {
    return ExamState();
  }

  void addStudent(Student student) {
    state = state.copyWith(students: [...state.students, student]);
  }

  void addStudents(List<Student> students) {
    state = state.copyWith(students: students);
  }

  void setEvalname(Evaluations evalName){
    state = state.copyWith(eval: evalName);
  }

  void setMetrics(List<Metric> metrics) {
    state = state.copyWith(metrics: metrics);
  }

  void setActualState(Metric actualState) {
    state = state.copyWith(actualState: actualState);
  }

  void setDescriptions(Map<String, String?> descriptions) {
    state = state.copyWith(descriptions: descriptions);
  }

  void setMetricNames(Map<String, String> metriNames){
    state = state.copyWith(metricNames: metriNames);
  }

  void setTypes(Map<String, String> types) {
    state = state.copyWith(types: types);
  }

  void setHiggerBetter(Map<String, bool> higgerBetter) {
    state = state.copyWith(higgerBetter: higgerBetter);
  }

  void disposeAll(){
    state = ExamState();
  }

  void setGrade({
    required String studentId,
    required Metric metric,
    required double grade,
  }) {
    final newGrades = Map<Metric, Map<String, double>>.from(state.grades);

    newGrades.putIfAbsent(metric, () => {});
    newGrades[metric]![studentId] = grade;

    state = state.copyWith(grades: newGrades);
  }

  bool checkDataformat(String type, String data){
    switch (type) {
      
      case "Tiempo":
        if(stringToTime(data)!=null){
          return true;
        }else{
          return false;
        }
      case "Repeticiones":        
        if (RegExp(r'^\d+$').hasMatch(data)) {
          return true;
          }else{
            return false;
          }
      case "Base10":
        final num = double.tryParse(data);
        if(num == null || num < 0 || num > 10){
          return false;
        }else{
          return true;
        }
      case "Distancia":
        final regex = RegExp(r'^(\d+(\.\d+)?)(\s*(m))?$');
        if (!regex.hasMatch(data)) {
          safePrint("Formato invalido para : $data");
          return false;
        }else{
          return true;
        }
      default:
        return false;
    }
  }

  Duration? stringToTime(String timeString) {
    //Time should be in format HH:MM:SS:MS("00:00:00.00")
    try{
    final parts = timeString.split(':');
    final secondsParts = parts[2].split('.');
    final seconds = int.parse(secondsParts[0]);
    final milliseconds = int.parse(secondsParts[1]);

    return Duration(
      hours:int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: seconds,
      milliseconds: milliseconds*10,
      );
    }catch(e){
      safePrint("Foramto der tiempo invalido");
      return null;
    }  
  }

  void getMetricNames(){
    final Map<String, String> newMetricNames = {};
    for (var metric in state.metrics){
      newMetricNames[metric.id] = metric.name;
    }
    setMetricNames(newMetricNames);
  }

  Map<String, Map<String, double>> adaptGrades(Map<Metric, Map<String, double>> grades){// recive Map<Metric, Map<StudentID, Grade>>
    Map<String, Map<String, double>> result = {};
    for(var metric in grades.keys){
      result[metric.id] = grades[metric]!;
    }
    return result;// return Map<MetricID, Map<StudentID, double>>
  }

  Map<Metric, Map<String, double>> readaptGrades(Map<String, Map<String, double>> grades){// recive Map<MetricID, Map<StudentID, Grade>>
    Map<Metric, Map<String, double>> result = {};
    final metrics = state.metrics;
    Map<String, Metric> metyricById = {for(var metric in metrics) metric.id : metric};
    for(var metricId in grades.keys){
      final metric = metyricById[metricId];
      if(metric != null){
        result[metric] = grades[metricId]!;
      }
    }
    return result;// return Map<Metric, Map<StudentID, double>>
  }

  Map<Metric, Map<String, double>> calculateTscore(Map<Metric, Map<String, double>> grades){ //consider the entry like Map<Metric, Map<Student, Grade>>
    Map<Metric, Map<String, double>> tscores = {};

    for(var metric in grades.keys){
      final metricGrades = grades[metric]!.values.toList();
      final mean = metricGrades.reduce((a,b)=>a+b)/metricGrades.length;
      final standartDev = stdDev(metricGrades, mean);
      for (var student in grades[metric]!.keys){
        tscores.putIfAbsent(metric, ()=>{});
        tscores[metric]![student] = tscore(zscore(grades[metric]![student]!, mean, standartDev, metric.higgerBetter!));
      }
    }
      return tscores;
    }

  double stdDev(List<double> values, double mean){
      final variance = values.map((v)=>pow(v-mean,2)).reduce((a,b)=>a+b)/values.length;
      return sqrt(variance);
  } 
  
  double zscore(double value, double mean, double stdev, bool higgerBetter){
    final zscore = higgerBetter ? ((value-mean)/stdev) : ((mean-value)/stdev);
    return zscore;
  }

  double tscore(double value){
    final tscore = (50+(25*value));
    return double.parse(tscore.toStringAsFixed(2));
  }

  Future<void> uploadGrades(String tenantId, String profId)async{
    final aws = DataStoreService();
    final date = ref.watch(dateProvider);
    
    final newGrades = await aws.saveGrade(
        eval: state.eval,
        date: DateTime.parse(date), 
        profName: profId,
        tenantID: tenantId,
        grades: jsonEncode(adaptGrades(state.grades)), // Model in amplify should recive (Map<MetricID, Map<StudentID, Grade>>)
        types: jsonEncode(state.types),
        tscore: jsonEncode(adaptGrades(calculateTscore(state.grades))),
        metricNames: jsonEncode(state.metricNames),
        higgerBetter: jsonEncode(state.higgerBetter)
       );
    await uploadJoinResults(newGrades, tenantId, date, state.students);
    await updateLastExamDate();
  }

  Future<void> updateLastExamDate()async{
    final date = ref.watch(dateProvider);
    final newEval = state.eval.copyWith(lastDate: TemporalDate(DateTime.parse(date)));
    await Amplify.DataStore.save(newEval);
  }

  Future<void> uploadJoinResults(ExamResults result, String tenaniId, String date, List<Student> students)async{
    final aws = DataStoreService();
    for(var student in students){
      aws.saveJoinResult(tenaniId: tenaniId, date: date, student: student, result: result);
    }
  }

  Map<Metric, Map<String, double>> mixResults(Map<String, dynamic> lastData, Map<String, Map<String, double>> actualData){
    
    Map<String, Metric> metyricById = {for(var metric in state.metrics) metric.id : metric};

    for(var metricId in lastData.keys){
      Map<String, dynamic> lastGrades = lastData[metricId] as Map<String, dynamic>;
      for(var studentId in actualData[metricId]!.keys){
          lastGrades[studentId] = actualData[metricId]![studentId];
      }
      lastData[metricId] = lastGrades;
    }

    Map<Metric, Map<String, double>> finalResult =
    lastData.map((metricId, gradesMap) {
        return MapEntry(
          metyricById[metricId]!,
          (gradesMap as Map<String, dynamic>).map((studentId, value) =>
              MapEntry(studentId, (value as num).toDouble())),
        );
      });
    return finalResult;//Map<MetricID, Map<StudentID, Grade>>
  }

  List<Student> getStudentsWithoutGrades(Map<String, dynamic> lastDataDecoded){
    List<Student> studentsWithoutGrades = [];
    final List<Student> actualStudents = state.students;
    safePrint("Students in exam: $actualStudents");
    final List<String> studentsWithGrades = lastDataDecoded[state.metrics.first.id].keys.toList();
    safePrint("Students with grades: $studentsWithGrades");
    for(var student in actualStudents){
      if(!studentsWithGrades.contains(student.id)){
        studentsWithoutGrades.add(student);
      }
    }
    
    return studentsWithoutGrades;
  }

  Future<void> updateEvalResults(String tenaniId, String profId)async{

    final actualEval = state.eval;
    final aws = DataStoreReadService();
    final date = ref.watch(dateProvider);
    final lastDatalist = await aws.getLastEvaluationResult(actualEval.id, actualEval.lastDate.toString());
    final lastDataDecoded = jsonDecode(lastDatalist.first.grades!) as Map<String, dynamic>;

    final newStudentsWithoutGrades = getStudentsWithoutGrades(lastDataDecoded);
    
    final mixedGrades = mixResults(lastDataDecoded, adaptGrades(state.grades));

    final newTscores = calculateTscore(mixedGrades);
    final newResult = lastDatalist.first.copyWith(
      date: TemporalDate(DateTime.parse(date)),
      grades: jsonEncode(adaptGrades(mixedGrades)),
      tscore: jsonEncode(adaptGrades(newTscores)),
    );
    // safePrint("NEW RESULT GRADES: $newTscores");
    await Amplify.DataStore.save(newResult);

    
    if(newStudentsWithoutGrades.isNotEmpty){
      await uploadJoinResults(newResult, tenaniId, date, newStudentsWithoutGrades);
    }
    await updateLastExamDate();
  }
}

final examProvider = NotifierProvider<ExamNotifier, ExamState>(() => ExamNotifier());
