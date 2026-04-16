import 'package:la_dinamica_app/models/ModelProvider.dart';

class StudentGrades {
  final List<StudentExamResults> actualResults;
  final List<StudentExamResults> filteredActualResults;

  Map<String,Map<String,Map<String, dynamic>>> historicalExamgrades; //Map<EvalName, Map<MetricID, Map<Date, Grade>>>: EvalName not repeated
  Map<String,Map<String, dynamic>> gradesPerStudent; // Map<EvalName,Map<MetricID, Grade>>
  Map<String,Map<String, dynamic>>  tscoresPerStudent; // Map<EvalName,Map<MetricID, Tscore>>
  
  Map<String, Map<String, dynamic>> metricsIds; // Map<EvalName, Map<MetricID, MetricName>>
  Map<String, double> examsTotals;//Map<EvalName,TscoreTotal>
  List<String> allExamNames;
  List<dynamic> metricsPerExam;

  String actualExam;
  String actualMetric;

  StudentGrades({
    this.actualResults = const [],
    this.filteredActualResults = const [],
    this.gradesPerStudent = const {},
    this.tscoresPerStudent = const {},
    this.historicalExamgrades = const {},
    this.examsTotals = const {},
    this.metricsIds = const {},
    this.allExamNames= const [],
    this.metricsPerExam = const [],
    this.actualExam = '',
    this.actualMetric = '',
  });

  StudentGrades copyWith({
    List<StudentExamResults>? actualResults,
    List<StudentExamResults>? filteredActualResults,
    Map<String,Map<String, dynamic>>? gradesPerStudent,
    Map<String,Map<String, dynamic>>? tscoresPerStudent,
    Map<String,Map<String,Map<String, dynamic>>>? historicalExamgrades,
    Map<String, double>? examsTotals,
    Map<String, Map<String, dynamic>>? metricsIds,
    List<String>? allExamNames,
    List<dynamic>? metricsPerExam,
    String? actualExam,
    String? actualMetric,
  }) {
    return StudentGrades(
      actualResults: actualResults ?? this.actualResults,
      filteredActualResults: filteredActualResults ?? this.filteredActualResults,
      gradesPerStudent: gradesPerStudent ?? this.gradesPerStudent,
      tscoresPerStudent: tscoresPerStudent ?? this.tscoresPerStudent,
      historicalExamgrades: historicalExamgrades ?? this.historicalExamgrades,
      examsTotals: examsTotals ?? this.examsTotals,
      metricsIds: metricsIds ?? this.metricsIds,
      allExamNames: allExamNames ?? this.allExamNames,
      metricsPerExam: metricsPerExam ?? this.metricsPerExam,
      actualExam: actualExam ?? this.actualExam,
      actualMetric: actualMetric ?? this.actualMetric,
    );
  }

  void clear() {
    actualResults.clear();
  }

}