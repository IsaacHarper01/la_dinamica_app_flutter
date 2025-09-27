import 'package:la_dinamica_app/models/Grades.dart';

class StudentGrades {
  final List<Grades>? actualGrades;

  StudentGrades({
    this.actualGrades = const [],
  });

  StudentGrades copyWith({
    List<Grades>? actualGrades,
  }) {
    return StudentGrades(
      actualGrades: actualGrades ?? this.actualGrades,
    );
  }

  void clear() {
    actualGrades!.clear();
  }

}