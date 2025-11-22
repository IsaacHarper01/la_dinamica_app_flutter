import 'package:la_dinamica_app/models/ModelProvider.dart';

class StudentGrades {
  final List<ExamResults>? actualResults;
  Map<String,Map<String, dynamic>> gradesPerStudent;
  Map<String,Map<String, double>>  tscoresPerStudent;
  Map<String,Map<String,Map<String, dynamic>>> historicalExamgrades;
  Map<String, double> examsTotals;
  Map<String, Map<String, dynamic>> metricsIds;
  List<String> allExamNames;

  String actualExam;
  String actualMetric;

  StudentGrades({
    this.actualResults = const [],
    this.gradesPerStudent = const {},
    this.tscoresPerStudent = const {},
    this.historicalExamgrades = const {},
    this.examsTotals = const {},
    this.metricsIds = const {},
    this.allExamNames= const [],
    this.actualExam = '',
    this.actualMetric = '',
  });

  StudentGrades copyWith({
    List<ExamResults>? actualResults,
    Map<String,Map<String, dynamic>>? gradesPerStudent,
    Map<String,Map<String, double>>? tscoresPerStudent,
    Map<String,Map<String,Map<String, dynamic>>>? historicalExamgrades,
    Map<String, double>? examsTotals,
    Map<String, Map<String, dynamic>>? metricsIds,
    List<String>? allExamNames,
    String? actualExam,
    String? actualMetric,
  }) {
    return StudentGrades(
      actualResults: actualResults ?? this.actualResults,
      gradesPerStudent: gradesPerStudent ?? this.gradesPerStudent,
      tscoresPerStudent: tscoresPerStudent ?? this.tscoresPerStudent,
      historicalExamgrades: historicalExamgrades ?? this.historicalExamgrades,
      examsTotals: examsTotals ?? this.examsTotals,
      metricsIds: metricsIds ?? this.metricsIds,
      allExamNames: allExamNames ?? this.allExamNames,
      actualExam: actualExam ?? this.actualExam,
      actualMetric: actualMetric ?? this.actualMetric,
    );
  }

  void clear() {
    actualResults!.clear();
  }

}