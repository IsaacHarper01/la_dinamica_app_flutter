import 'package:la_dinamica_app/models/ModelProvider.dart';

class AttendanceModel {
  final List<Attendance> attendanceToday;
  final List<Attendance> attendanceInRange;
  final Map<DateTime, double>? attendancebyDate;

  AttendanceModel({
    required this.attendanceToday,
    required this.attendanceInRange,
    this.attendancebyDate,
  });

  AttendanceModel copyWith({
    List<Attendance>? attendanceToday,
    List<Attendance>? attendanceInRange,
    Map<DateTime, double>? attendancebyDate,
  }){
    return AttendanceModel(
      attendanceToday: attendanceToday ?? this.attendanceToday,
      attendanceInRange: attendanceInRange ?? this.attendanceInRange,
      attendancebyDate: attendancebyDate ?? this.attendancebyDate,
    );
  }
}