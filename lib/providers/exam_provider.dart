import 'dart:convert';
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

  double? getGrade(String studentId, String metricName) {
    return state.grades[studentId]?[metricName];
  }

  void uploadGrades(String tenantId, String profId){
    final aws = DataStoreService();
    for(var student in state.students){
      aws.saveGrade(
        student: student, 
        evaluation: state.eval, 
        grades: jsonEncode(state.grades[(student.user_id).toString()]), 
        tenantId: tenantId, 
        profId: profId);
    }
  }
}

final examProvider = NotifierProvider<ExamNotifier, ExamState>(() => ExamNotifier());
