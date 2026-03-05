import 'package:la_dinamica_app/models/ModelProvider.dart';

class StudentsLists {
  final List<Student> allStudents;
  final List<Student> attendedStudents;
  final List<Student> filteredStudents;

  StudentsLists({
    this.allStudents = const [],
    this.attendedStudents = const [],
    this.filteredStudents = const [],
  });

  StudentsLists copyWith({
    List<Student>? allStudents,
    List<Student>? attendedStudents,
    List<Student>? filteredStudents,
  }) {
    return StudentsLists(
      allStudents: allStudents ?? this.allStudents,
      attendedStudents: attendedStudents ?? this.attendedStudents,
      filteredStudents: filteredStudents ?? this.filteredStudents,
    );
  }
}