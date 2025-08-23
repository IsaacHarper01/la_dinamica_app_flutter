import 'package:la_dinamica_app/models/Student.dart';

class ExamState {
  final List<Student> students;
  final Map<String, List<String>> metrics;
  final Map<String, String?> descriptions;
  final Map<String, Map<String, Map<String, double>>> grades;
  final String actualState;

  ExamState({
    this.students = const [],
    this.metrics = const {},
    this.descriptions = const {},
    this.grades = const {},
    this.actualState = '',
  });

  ExamState copyWith({
    List<Student>? students,
    Map<String, List<String>>? metrics,
    Map<String, String?>? descriptions,
    Map<String, Map<String, Map<String, double>>>? grades,
    String? actualState,
  }) {
    return ExamState(
      students: students ?? this.students,
      metrics: metrics ?? this.metrics,
      descriptions: descriptions ?? this.descriptions,
      grades: grades ?? this.grades,
      actualState: actualState ?? this.actualState,
    );
  }
}