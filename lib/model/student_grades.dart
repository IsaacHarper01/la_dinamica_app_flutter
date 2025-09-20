import 'package:la_dinamica_app/models/Grades.dart';

class StudentGrades {
  final List<Grades> actualGrades;
  final Map<String, String> types;
  final Map<String, String> examTree;

  StudentGrades({
    this.actualGrades = const [],
    this.types = const {},
    this.examTree = const {},
  });

  StudentGrades copyWith({
    List<Grades>? actualGrades,
    Map<String, String>? types,
    Map<String, String>? examTree,
  }) {
    return StudentGrades(
      actualGrades: actualGrades ?? this.actualGrades,
      types: types ?? this.types,
      examTree: examTree ?? this.examTree,
    );
  }
}