import 'package:la_dinamica_app/models/Evaluations.dart';
import 'package:la_dinamica_app/models/Metric.dart';
import 'package:la_dinamica_app/models/Student.dart';

class ExamState {
  final List<Student> students;
  final Evaluations eval;
  final List<Metric> metrics;
  final Map<String, String?> descriptions;
  final Map<String, String> types;
  final Map<Metric, Map<String, double>> grades; // Metric -> (StudentID -> Grade)
  final Map<String, bool> higgerBetter;
  final Metric? actualState;
  final Map<String, String> metricNames;

  ExamState({
    this.students = const [],
    Evaluations? eval,
    this.metrics = const [],
    this.descriptions = const {},
    this.types = const {},
    this.grades = const {},
    this.higgerBetter = const {},
    this.metricNames = const {},
    this.actualState,
  }) : eval = eval ?? Evaluations();

  ExamState copyWith({
    List<Student>? students,
    Evaluations? eval,
    List<Metric>? metrics,
    Map<String, String?>? descriptions,
    Map<String, String>? types,
    Map<Metric, Map<String, double>>? grades,
    Map<String, String>? metricNames,
    Map<String, bool>? higgerBetter,
    Metric? actualState,
  }) {
    return ExamState(
      students: students ?? this.students,
      eval: eval?? this.eval,
      metrics: metrics ?? this.metrics,
      descriptions: descriptions ?? this.descriptions,
      types: types ?? this.types,
      grades: grades ?? this.grades,
      metricNames: metricNames ?? this.metricNames,
      higgerBetter: higgerBetter ?? this.higgerBetter,
      actualState: actualState ?? this.actualState,
    );
  }
}