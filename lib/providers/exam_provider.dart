import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/exam_state.dart';
import 'package:la_dinamica_app/models/Evaluations.dart';
import 'package:la_dinamica_app/models/Student.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';


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

  void setMetrics(Map<String, List<String>> metrics) {
    state = state.copyWith(metrics: metrics);
  }

  void setActualState(String actualState) {
    state = state.copyWith(actualState: actualState);
  }

  void setDescriptions(Map<String, String?> descriptions) {
    state = state.copyWith(descriptions: descriptions);
  }

  void setTypes(Map<String, String> types) {
    state = state.copyWith(types: types);
  }

  void setObjetives(Map<String, dynamic> objetives){
    state = state.copyWith(objetives: objetives);
    safePrint("OBJETIVES: ${state.objetives.toString()}");
  }

  void setPenalties(Map<String, dynamic> penalties){
    state = state.copyWith(penalties: penalties);
    safePrint("PENALTIES: ${state.penalties.toString()}");
  }

  void disposeAll(){
    state = ExamState();
  }

  void setGrade({
    required String studentId,
    required String metricName,
    required String grade,
  }) {
    final newGrades = Map<String, Map<String, dynamic>>.from(state.grades);

    newGrades.putIfAbsent(studentId, () => {});
    newGrades[studentId]![metricName] = grade;

    state = state.copyWith(grades: newGrades);
  }

  void setConversion({required studentId, required base10}){
    final newConversions = Map<String, Map<String, double>>.from(state.conversions);

    newConversions.putIfAbsent(state.actualState, () => {});
    newConversions[state.actualState]![studentId] = base10;
    state = state.copyWith(conversions: newConversions);

    safePrint("CONVERSIONS: ${state.conversions.toString()}");
  }

  double? getGrade(String studentId, String metricName) {
    return state.grades[studentId]?[metricName];
  }

  double? calculateConversion(String amount){
    if (state.types[state.actualState] == "Tiempo"){
      final duration = stringToTime(amount);
      final objetive = stringToTime(state.objetives[state.actualState].substring(1));
      final penalty = stringToTime(state.penalties[state.actualState]);
      String comparator = state.objetives[state.actualState][0];
      safePrint("DURATION: $duration, OBJETIVE: $objetive, PENALTY: $penalty, COMPARATOR: $comparator");

      if (comparator == "<"){
        if (duration <= objetive){
          return 10.0;
        } else{
          final ratio = (duration - objetive).inMilliseconds/ penalty.inMilliseconds;
          return 10.0 - (ratio) ;
        } 
      } else if (comparator == ">"){
        if (duration >= objetive){
          return 10.0;
        } else{
          double ratio = (objetive - duration).inMilliseconds/ penalty.inMilliseconds;
          return 10.0 - (ratio);
        } 
      }
      else{
        safePrint("Error in comparator");
        return null;
      }
    }else{
      safePrint("Error in actual state for conversion");
      return null;
    }
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

  Map<String, dynamic> calculateTotals(Student student){
    Map<String, dynamic> totals = {};
    for(var metric in state.metrics.keys){ 
      int submetrics = state.metrics[metric]?.length ?? 0;
      safePrint("Calculating total for metric: $metric with $submetrics submetrics");
      dynamic total = 0.0;
      if (submetrics > 0){
        for(var submetric in state.metrics[metric]!){
          if(state.types[submetric]=="Base10"){
            total += double.parse(state.grades[student.user_id.toString()]?[submetric]);
          }else if(state.conversions[submetric] != null){
            total += state.conversions[submetric]?[student.user_id.toString()] ?? 0.0;
          } else{
            submetrics -= 1;
          }
        }
        safePrint("Total for metric $metric: $total");
        if (submetrics == 0) {
          safePrint( "submetric for $submetrics");
          totals[metric] = (state.grades[student.user_id.toString()]![metric]).toString();
        } else {
          safePrint("Average for metric $metric: ${total/submetrics}");
          totals[metric] = (total/submetrics).toString();
        }
      } else{
        safePrint("No submetrics for $metric");
          if(state.types[metric]=="Base10"){
            totals[metric] = (state.grades[student.user_id.toString()]![metric]).toString();
          }else if(state.conversions[metric] != null){
            totals[metric] = (state.conversions[metric]![student.user_id.toString()]).toString();
          } else{
            totals[metric] = (state.grades[student.user_id.toString()]![metric]).toString();
          }
        }
    }
    return totals;
  }

  void uploadGrades(String tenantId, String profId){
    final aws = DataStoreService();
    for(var student in state.students){
      aws.saveGrade(
        student: student, 
        evaluation: state.eval, 
        grades: jsonEncode(state.grades[(student.user_id).toString()]),
        types: jsonEncode(state.types), 
        examTree: jsonEncode(state.metrics),
        totals: jsonEncode(calculateTotals(student)),
        tenantId: tenantId, 
        profId: profId);
    }
  }
}

final examProvider = NotifierProvider<ExamNotifier, ExamState>(() => ExamNotifier());
