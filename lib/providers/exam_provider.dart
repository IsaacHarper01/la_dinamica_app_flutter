import 'dart:convert';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:la_dinamica_app/model/exam_state.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';


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
    required Student student,
    required Metric metric,
    required double grade,
  }) {
    final newGrades = Map<Metric, Map<Student, double>>.from(state.grades);

    newGrades.putIfAbsent(metric, () => {});
    newGrades[metric]![student] = grade;

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
  try {
    timeString = timeString.trim();

    // -------------------------------
    // Case 1: HH:MM:SS.MS
    // -------------------------------
    if (timeString.contains(':')) {
      final parts = timeString.split(':');
      if (parts.length != 3) throw FormatException();

      final secondsParts = parts[2].split('.');
      final seconds = int.parse(secondsParts[0]);
      final milliseconds = secondsParts.length > 1
          ? _parseMilliseconds(secondsParts[1])
          : 0;

      return Duration(
        hours: int.parse(parts[0]),
        minutes: int.parse(parts[1]),
        seconds: seconds,
        milliseconds: milliseconds,
      );
    }

    // -------------------------------
    // Case 2: "1m 23.5s" or "2m"
    // -------------------------------
    if (timeString.contains('m')) {
      int minutes = 0;
      int seconds = 0;
      int milliseconds = 0;

      final minuteMatch = RegExp(r'(\d+)m').firstMatch(timeString);
      if (minuteMatch != null) {
        minutes = int.parse(minuteMatch.group(1)!);
      }

      final secondMatch = RegExp(r'(\d+)(\.\d+)?s').firstMatch(timeString);
      if (secondMatch != null) {
        seconds = int.parse(secondMatch.group(1)!);

        if (secondMatch.group(2) != null) {
          final msString = secondMatch.group(2)!.replaceFirst('.', '');
          milliseconds = _parseMilliseconds(msString);
        }
      }

      return Duration(
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
      );
    }

    // -------------------------------
    // Case 3: "123.15s" or "75s"
    // -------------------------------
    if (timeString.endsWith('s')) {
      final clean = timeString.replaceAll('s', '');
      final parts = clean.split('.');

      final seconds = int.parse(parts[0]);
      final milliseconds =
          parts.length > 1 ? _parseMilliseconds(parts[1]) : 0;

      return Duration(
        seconds: seconds,
        milliseconds: milliseconds,
      );
    }

    throw FormatException();
  } catch (e) {
    safePrint("Formato de tiempo inválido: $timeString");
    return null;
  }
}

int _parseMilliseconds(String msStr) {
  if (msStr.length == 1) return int.parse(msStr) * 100;
  if (msStr.length == 2) return int.parse(msStr) * 10;
  return int.parse(msStr.substring(0, 3));
}
  void getMetricNames(){
    final Map<String, String> newMetricNames = {};
    for (var metric in state.metrics){
      newMetricNames[metric.id] = metric.name;
    }
    setMetricNames(newMetricNames);
  }

  Map<Student, Map<String, double>> adaptMapGrades(Map<Metric, Map<Student, double>> grades,) { // recive Map<Metric, Map<StudentID, Grade>>
        final Map<Student, Map<String, double>> result = {};

        for (final entry in grades.entries) {
          final metric = entry.key;
          final studentMap = entry.value;

          for (final studentEntry in studentMap.entries) {
            final student = studentEntry.key;
            final grade = studentEntry.value;

            result.putIfAbsent(student, () => {});
            result[student]![metric.id] = grade;
          }
        }
        return result; // return Map<StudentID, Map<MetricID, Grade>>
      }

  Future<void> uploadStudentsGrades(String tenantId, bool mix)async{
    final aws = GraphqlServiceCreate();
    final date = ref.watch(dateProvider).today;
    final currentExam = state.eval;
    final adaptedGrades = adaptMapGrades(state.grades); //Map<StudentID, Map<MetricID, Grade>>

    for (var student in adaptedGrades.keys){
      await aws.saveStudentExamResults(
        student: student, 
        eval: currentExam, 
        grades: jsonEncode(adaptedGrades[student]), 
        tenantId: tenantId, 
        date: DateTime.parse(date));
    }
    await updateLastExamDate();
  }

  Future<void> calculateTscoreOnCloud(Evaluations eval, String tenantId, String date)async{
    safePrint("EVAL ID: ${eval.id}");
    safePrint(tenantId);
    safePrint(date);
    final session = await Amplify.Auth.fetchAuthSession();
    if (session is CognitoAuthSession) {
      final tokensResult = session.userPoolTokensResult;
      final accessToken = tokensResult.value.accessToken.raw;
      
      final response = await http.post(
        Uri.parse("https://k424jq6fj1.execute-api.us-east-1.amazonaws.com/laDinamicaApp/calculateTscores"),
        headers: {
          'Content-Type':'application/json',
          'Authorization':'Bearer $accessToken'
        },
        body: jsonEncode(
          {
            "evaluation_id":eval.id,
            "tenant_id":tenantId,
            "date":date,
          }),
      );
      safePrint("RESPUESTA: ${response.statusCode}");
      return; 
      }else{
        return;
      }
  }

  Future<void> updateLastExamDate()async{
    final date = ref.watch(dateProvider).today;
    final newEval = state.eval.copyWith(lastDate: TemporalDate(DateTime.parse(date)));
    await Amplify.DataStore.save(newEval);
  }

}

final examProvider = NotifierProvider<ExamNotifier, ExamState>(() => ExamNotifier());
