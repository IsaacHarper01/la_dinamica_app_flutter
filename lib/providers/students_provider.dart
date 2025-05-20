import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/student.dart';

import '../backend/database.dart';

final studentsProvider = StateNotifierProvider<StudentsNotifier, AsyncValue<List<Student>>>((ref) {
  return StudentsNotifier(ref);
});

class StudentsNotifier extends StateNotifier<AsyncValue<List<Student>>> {
  final Ref ref;

  StudentsNotifier(this.ref) : super(const AsyncValue.loading());


  Future<void> fetchAttendanceToday(String date) async {
    try {
      final db = DatabaseHelper();
      final snapshot = await db.fetchAttendanceToday(date);
      if (snapshot.isEmpty) {
        state = const AsyncValue.data([]);
        return;
      }

      List<dynamic> ids = snapshot['ids'] ?? [];
      List<dynamic> names = snapshot['names'] ?? [];
      List<dynamic> images = snapshot['images'] ?? [];

      if (ids.isEmpty || names.isEmpty || images.isEmpty) {
        state = const AsyncValue.data([]);
        return;
      }

      List<Student> students = List.generate(ids.length, (index) {
        return Student(
          id: ids[index],
          name: names[index],
          image: images[index],
        );
      });

      state = AsyncValue.data(students);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> insertAttendance(int studentId, String name, String date) async {
    try {
      final db = DatabaseHelper();
      await db.InserAttendanceData(studentId, name, date);

      await db.varifyPay(studentId,date);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } finally {
      await fetchAttendanceToday(date);
    }
  }

  Future<void> deleteAttendance(int studentId, String date) async {
    try {
      final db = DatabaseHelper();
      await db.deleteAttendance(studentId, date);
      await fetchAttendanceToday(date);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}