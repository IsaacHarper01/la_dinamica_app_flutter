import 'package:la_dinamica_app/models/Evaluations.dart';
import 'package:la_dinamica_app/models/Grades.dart';

class MetricsState {
  final List<Evaluations> evaluations;
  final List<Grades> grades;

  MetricsState({
    this.evaluations = const [],
    this.grades = const [],
  });

  MetricsState copyWith({
    List<Evaluations>? evaluations,
    List<Grades>? grades,
  }) {
    return MetricsState(
      evaluations: evaluations ?? this.evaluations,
      grades: grades ?? this.grades,
    );
  }
}