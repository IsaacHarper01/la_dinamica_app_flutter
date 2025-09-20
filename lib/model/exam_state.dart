import 'package:la_dinamica_app/models/Evaluations.dart';
import 'package:la_dinamica_app/models/Student.dart';

class ExamState {
  final List<Student> students;
  final Evaluations eval;
  final Map<String, List<String>> metrics;
  final Map<String, String?> descriptions;
  final Map<String, String> types;
  final Map<String, Map<String, dynamic>> grades;
  final Map<String, dynamic> objetives;
  final Map<String, dynamic> penalties;
  final Map<String, Map<String, double>>  conversions;
  final String actualState;

  ExamState({
    this.students = const [],
    Evaluations? eval,
    this.metrics = const {},
    this.descriptions = const {},
    this.types = const {},
    this.grades = const {},
    this.objetives = const {},
    this.penalties = const {},
    this.conversions = const {},
    this.actualState = '',
  }) : eval = eval ?? Evaluations();

  ExamState copyWith({
    List<Student>? students,
    Evaluations? eval,
    Map<String, List<String>>? metrics,
    Map<String, String?>? descriptions,
    Map<String, String>? types,
    Map<String, Map<String, dynamic>>? grades,
    Map<String, dynamic>? objetives,
    Map<String, dynamic>? penalties,
    Map<String, Map<String, double>>? conversions,
    String? actualState,
  }) {
    return ExamState(
      students: students ?? this.students,
      eval: eval?? this.eval,
      metrics: metrics ?? this.metrics,
      descriptions: descriptions ?? this.descriptions,
      types: types ?? this.types,
      grades: grades ?? this.grades,
      objetives: objetives ?? this.objetives,
      penalties: penalties ?? this.penalties,
      conversions: conversions ?? this.conversions,
      actualState: actualState ?? this.actualState,
    );
  }
}