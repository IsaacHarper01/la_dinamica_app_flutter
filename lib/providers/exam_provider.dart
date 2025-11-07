import 'dart:convert';
import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/exam_state.dart';
import 'package:la_dinamica_app/models/Evaluations.dart';
import 'package:la_dinamica_app/models/Metric.dart';
import 'package:la_dinamica_app/models/Student.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';


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

  double? getGrade(String studentId, String metricName) {
    return state.grades[studentId]?[metricName];
  }

  Duration stringToTime(String timeString) {
    //Time should be in format HH:MM:SS:MS("00:00:00.00")
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
  }

  Map<String,Map<String, double>> calculateTscore(Map<Metric, Map<String, double>> grades){ //consider the entry like Map<Metric, Map<Student, Grade>>
    Map<String, Map<String, double>> tscores = {};
    for(var metric in grades.keys){
      final metricGrades = grades[metric]!.values.toList();
      final students = grades[metric]!.keys.toList();
      final mean = metricGrades.reduce((a,b)=>a+b)/metricGrades.length;
      final standartDev = stdDev(metricGrades, mean);
      final zscores = zscore(metricGrades, mean, standartDev, metric.higgerBetter!);
      final tsc = tscore(zscores);
    }
      return tscores;
    }

  double stdDev(List<double> values, double mean){
      final variance = values.map((v)=>pow(v-mean,2)).reduce((a,b)=>a+b)/values.length;
      return sqrt(variance);
  } 
  
  List<double> zscore(List<double> values, double mean, double stdev, bool higgerBetter){
    final zscores = higgerBetter ? values.map((x)=>(x-mean)/stdev).toList() : values.map((x)=>(mean-x)/stdev).toList();
    return zscores;
  }

  List<double> tscore(List<double> values){
    final tscores = values.map((x)=>(50+25*x)).toList();
    return tscores;
  }

  void uploadGrades(String tenantId, String profId){
    final aws = DataStoreService();
    final date = ref.watch(dateProvider);
    for(var student in state.students){
      aws.saveGrade(
        student: student, 
        eval: state.eval,
        date: DateTime.parse(date), 
        profName: profId,
        tenantID: tenantId,
        grades: jsonEncode(state.grades[(student.user_id).toString()]),
        types: jsonEncode(state.types),
        tscore: jsonEncode(calculateTscore(state.grades)),
        higgerBetter: jsonEncode(state.higgerBetter)
       );
    }
  }
}

final examProvider = NotifierProvider<ExamNotifier, ExamState>(() => ExamNotifier());
