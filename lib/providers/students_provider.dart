import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/student.dart';

import '../backend/database.dart';

final studentsProvider = StateNotifierProvider<StudentsNotifier, AsyncValue<List<Student>>>((ref) {
  return StudentsNotifier();
});

class StudentsNotifier extends StateNotifier<AsyncValue<List<Student>>> {
  StudentsNotifier() : super(const AsyncValue.loading());

  Future<void> fetchAttendanceToday() async {
    try {
      final db = DatabaseHelper();
      final snapshot = await db.fetchAttendanceToday();

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

  Future<void> insertAttendance(int studentId, String name) async {
    try {
      final db = DatabaseHelper();
      await db.InserAttendanceData(studentId, name);

      await db.varifyPay(studentId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } finally {
      await fetchAttendanceToday();
    }
  }

  Future<void> deleteAttendance(int studentId, String date) async {
    try {
      final db = DatabaseHelper();
      await db.deleteAttendance(studentId, date);
      await fetchAttendanceToday();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}