import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/student.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';

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
      final awsDb = DataStoreReadService();
      final snapshot = await awsDb.getAttendanceByDate(date); //await db.fetchAttendanceToday(date);
      if (snapshot.isEmpty) {
        state = const AsyncValue.data([]);
        return;
      }

      List<dynamic> ids = snapshot.map((g)=> g.userId).toList() ?? [];
      List<dynamic> names = snapshot.map((g)=> g.name).toList() ?? [];
      List<dynamic> images = await awsDb.getImages(snapshot.map((g)=> g.userId!).toList());

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
      final awsDb = DataStoreService();
      final awsDb2 = DataStoreReadService();
      await db.InserAttendanceData(studentId, name, date);
      await awsDb.saveAttendance(
        userId: studentId,
        name: name,
        date: date,
      );
      await db.varifyPay(studentId,date);
      await awsDb2.verifyPayment(studentId, date);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } finally {
      await fetchAttendanceToday(date);
    }
  }

  Future<void> deleteAttendance(int studentId, String date) async {
    try {
      final db = DatabaseHelper(); 
      final awsDb = DataStoreDeleteService();
      await db.deleteAttendance(studentId, date);
      await awsDb.deleteAttendanceByID(studentId, date);
      await fetchAttendanceToday(date);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}