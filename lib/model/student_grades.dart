import 'package:la_dinamica_app/models/ModelProvider.dart';

class StudentGrades {
  final List<ExamResults>? actualResults;

  StudentGrades({
    this.actualResults = const [],
  });

  StudentGrades copyWith({
    List<ExamResults>? actualResults,
  }) {
    return StudentGrades(
      actualResults: actualResults ?? this.actualResults,
    );
  }

  void clear() {
    actualResults!.clear();
  }

}