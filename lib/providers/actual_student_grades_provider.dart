import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/student_grades.dart';
import 'package:la_dinamica_app/models/Grades.dart';

class GradeNotifier extends Notifier<StudentGrades> {
  
  @override
  StudentGrades build() {
    return StudentGrades();
  }

  void setGrades(Grades grades){
    state = state.copyWith(actualGrades: [grades]);
  }
  void setTypes(Map<String, String> types){
    state = state.copyWith(types: types);
  }
  void setExamTree(Map<String, String> examTree){
    state = state.copyWith(examTree: examTree);
  }
}

final studentGradesProvider = NotifierProvider<GradeNotifier, StudentGrades>(() => GradeNotifier()); 