import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/exam_state.dart';
import 'package:la_dinamica_app/models/Student.dart';


class ExamNotifier extends Notifier<ExamState> {
  @override
  ExamState build() {
    return ExamState();
  }

  void addStudent(Student student) {
    state = state.copyWith(students: [...state.students, student]);
  }

  void addStudents(List<Student> students) {
    state = state.copyWith(students: [...state.students, ...students]);
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

  void setGrade({
    required String studentId,
    required String metricName,
    required String subMetricName,
    required double grade,
  }) {
    final newGrades = Map<String, Map<String, Map<String, double>>>.from(state.grades);

    newGrades.putIfAbsent(studentId, () => {});
    newGrades[studentId]!.putIfAbsent(metricName, () => {});
    newGrades[studentId]![metricName]![subMetricName] = grade;

    state = state.copyWith(grades: newGrades);
  }

  double? getGrade(String studentId, String metricName, String subMetricName) {
    return state.grades[studentId]?[metricName]?[subMetricName];
  }
}

final examProvider = NotifierProvider<ExamNotifier, ExamState>(() => ExamNotifier());
