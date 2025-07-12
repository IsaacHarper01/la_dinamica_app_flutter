import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/student.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/storageS3.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

final studentsProvider =
    StateNotifierProvider<StudentsNotifier, AsyncValue<List<Student>>>((ref) {
      return StudentsNotifier(ref);
    });

class StudentsNotifier extends StateNotifier<AsyncValue<List<Student>>> {
  final Ref ref;

  StudentsNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> fetchAttendanceToday(String date) async {
    try {
      final awsDb = DataStoreReadService();
      final awsS3 = Storages3();
      final user = await ref.watch(userProvider.future);
      final tenenatId = user.db_id;
      final snapshot = await awsDb.getAttendanceByDate(date, tenenatId!); 
      if (snapshot.isEmpty) {
        state = const AsyncValue.data([]);
        return;
      }

      List<dynamic> ids = snapshot.map((g) => g.user_id).toList();
      List<dynamic> names = snapshot.map((g) => g.name).toList();
      List<dynamic> images = await awsS3.getImages(
        snapshot.map((g) => g.user_id!).toList(), tenenatId);

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
      final user = await ref.watch(userProvider.future);
      final gymid = user.db_id;
      final profId = user.id;
      safePrint("gymid: $gymid, profId: $profId");
      await awsDb.saveAttendance(userId: studentId, name: name, date: date, gymId: gymid!, profId: profId!);
      await awsDb2.verifyPayment(studentId, date, gymid, profId,); 
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
