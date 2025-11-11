import 'package:la_dinamica_app/models/ModelProvider.dart';

class StudentGrades {
  final List<ExamResults>? actualGrades;

  StudentGrades({
    this.actualGrades = const [],
  });

  StudentGrades copyWith({
    List<ExamResults>? actualGrades,
  }) {
    return StudentGrades(
      actualGrades: actualGrades ?? this.actualGrades,
    );
  }

  void clear() {
    actualGrades!.clear();
  }

}