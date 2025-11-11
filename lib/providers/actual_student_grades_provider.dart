import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/student_grades.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class GradeNotifier extends Notifier<StudentGrades> {
  
  @override
  StudentGrades build() {
    return StudentGrades();
  }

  void setGrades(List<ExamResults> grades){
    state = state.copyWith(actualGrades: grades);
  }
}

final studentGradesProvider = NotifierProvider<GradeNotifier, StudentGrades>(() => GradeNotifier()); 