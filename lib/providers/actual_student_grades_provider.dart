import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/student_grades.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class GradeNotifier extends Notifier<StudentGrades> {
  
  @override
  StudentGrades build() {
    return StudentGrades();
  }

  void setGrades(List<ExamResults> grades){
    state = state.copyWith(actualResults: grades);
  }

  Map<String, Map<String, double>> adaptGradesperStudent(ExamResults actualExam){
    Map<String, Map<String, double>> decoded = jsonDecode(actualExam.grades!);
    final grades = decoded.map((key, value) {
      return MapEntry(
        key,
        (value as Map<String, dynamic>).map((k, v) => MapEntry(k, (v as num).toDouble())),
      );
    });
    final Map<String, Map<String, double>> gradesPerStudent = {};
    for (var metricId in grades.keys){
      for (var studentId in grades[metricId]!.keys){
        gradesPerStudent.putIfAbsent(studentId, ()=>{});
        gradesPerStudent[studentId]![metricId] = grades[metricId]![studentId]!;
      }
    }
    return gradesPerStudent;
  }

  Map<String, Map<String, double>> adaptTscoresperStudent(ExamResults actualExam){
    final decoded = jsonDecode(actualExam.tscore!) as Map<String, dynamic>;
    final tscores = decoded.map((key, value) {
      return MapEntry(
        key,
        (value as Map<String, dynamic>).map((k, v) => MapEntry(k, (v as num).toDouble())),
      );
    });
    final Map<String, Map<String, double>> tscoresPerStudent = {};
    for (var metricId in tscores.keys){
      for (var studentId in tscores[metricId]!.keys){
        tscoresPerStudent.putIfAbsent(studentId, ()=>{});
        tscoresPerStudent[studentId]![metricId] = tscores[metricId]![studentId]!;
      }
    }
    return tscoresPerStudent;
  }

  double calculateActualTotal(String studentId, ExamResults result){
    Map<String, Map<String, double>> tscores = adaptTscoresperStudent(result);
    final allGrades = tscores[studentId];
    final gradesList = allGrades!.values.toList();
    final total = gradesList.reduce((a,b)=>a+b)/gradesList.length;
    return total;
  }

}

final studentGradesProvider = NotifierProvider<GradeNotifier, StudentGrades>(() => GradeNotifier()); 