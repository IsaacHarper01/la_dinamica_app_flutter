import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/student.dart';
import 'package:la_dinamica_app/models/User.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

final studentsProvider =
    StateNotifierProvider<StudentsNotifier, AsyncValue<List<Student>>>((ref) {
      final user = ref.watch(userProvider);
      if (user == null) {
        // Return an empty dummy notifier to avoid crashes
        return StudentsNotifier(ref, null);
      }
      return StudentsNotifier(ref, user);
    });

class StudentsNotifier extends StateNotifier<AsyncValue<List<Student>>> {
  final Ref ref;
  final User? user;

  StudentsNotifier(this.ref, this.user) : super(const AsyncValue.loading());

  Future<void> fetchAttendanceToday(String date) async {
    try {
      if (user == null || !mounted) return;
      final awsDb = DataStoreReadService();
      final snapshot = await awsDb.getAttendanceByDate(
        date,
      ); //await db.fetchAttendanceToday(date);
      if (snapshot.isEmpty) {
        state = const AsyncValue.data([]);
        return;
      }

      List<dynamic> ids = snapshot.map((g) => g.user_id).toList();
      List<dynamic> names = snapshot.map((g) => g.name).toList();
      List<dynamic> images = await awsDb.getImages(
        snapshot.map((g) => g.user_id!).toList(),
      );

      if (!mounted) return;

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
      if (!mounted) return;
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> insertAttendance(int studentId, String name, String date) async {
    try {
      final awsDb = DataStoreService();
      final awsDb2 = DataStoreReadService();
      await awsDb.saveAttendance(userId: studentId, name: name, date: date);
      await awsDb2.verifyPayment(studentId, date, user!);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } finally {
      await fetchAttendanceToday(date);
    }
  }

  Future<void> deleteAttendance(int studentId, String date) async {
    try {
      final awsDb = DataStoreDeleteService();
      await awsDb.deleteAttendanceByID(studentId, date);
      await fetchAttendanceToday(date);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
