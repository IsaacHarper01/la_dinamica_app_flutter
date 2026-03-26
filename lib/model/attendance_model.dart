import 'package:la_dinamica_app/models/ModelProvider.dart';

class AttendanceModel {
  final List<Student> attendanceToday;
  final List<Attendance> attendanceInRange;

  AttendanceModel({
    required this.attendanceToday,
    required this.attendanceInRange,
  });

  AttendanceModel copyWith({
    List<Student>? attendanceToday,
    List<Attendance>? attendanceInRange,
  }){
    return AttendanceModel(
      attendanceToday: attendanceToday ?? this.attendanceToday,
      attendanceInRange: attendanceInRange ?? this.attendanceInRange,
    );
  }
}