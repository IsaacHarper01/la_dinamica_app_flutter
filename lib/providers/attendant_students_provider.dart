import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/attendance_model.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/default_plan_provider.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

final attendanceRefreshProvider = Provider((ref) {
  final user = ref.watch(userProvider).value;
  final date = ref.watch(dateProvider).today;
  return (user, date);
});

final studentsAttendanceProvider =
    StateNotifierProvider<StudentsNotifier, AsyncValue<AttendanceModel>>((ref) {
      return StudentsNotifier(ref);
    });

class StudentsNotifier extends StateNotifier<AsyncValue<AttendanceModel>> {
  final Ref ref;

  StudentsNotifier(this.ref) : super(const AsyncValue.loading()){
    loadValues();
  }
  
  Future<void> loadValues() async {
    await fetchAttendanceToday(ref.read(dateProvider).today);
    await fetchAttendanceInRange();
  }

  Future<void> fetchAttendanceToday(String date) async {
    try {
      final awsDb = DataStoreReadService();
      final user = await ref.watch(userProvider.future);
      final tenenatId = user.tenant.tenant_id;
      final snapshot = await awsDb.getAttendanceByDate(date, tenenatId);
      if (snapshot.isEmpty) {
        state = AsyncValue.data(AttendanceModel(attendanceToday: [], attendanceInRange: []));
        return;
      }

     List<Student> students = snapshot.map((att) => att.student!).toList();
     final current = state.value ?? AttendanceModel(attendanceToday: [], attendanceInRange: []);
     state = AsyncValue.data(current.copyWith(attendanceToday: students));
    } catch (e) {
      if (!mounted) return;
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> fetchAttendanceInRange() async {
    try {
      final awsDb = DataStoreReadService();
      final user = await ref.watch(userProvider.future);
      final startDate = ref.watch(dateProvider).start;
      final endDate = ref.watch(dateProvider).end;
      final tenenatId = user.tenant.tenant_id;
      final snapshot = await awsDb.getAttendanceRange(startDate, endDate, tenenatId);
      if (snapshot.isEmpty) {
        state = AsyncValue.data(AttendanceModel(attendanceToday: [], attendanceInRange: []));
        return;
      }

     final current = state.value ?? AttendanceModel(attendanceToday: [], attendanceInRange: []);
     state = AsyncValue.data(current.copyWith(attendanceInRange: snapshot));
    } catch (e) {
      if (!mounted) return;
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> insertAttendance(Student student , String date) async {
    try {
      final awsDb = DataStoreService();
      final awsDb2 = DataStoreReadService();
      final user = await ref.watch(userProvider.future);
      final gymid = user.tenant.tenant_id;
      final profId = user.name;

      await awsDb.saveAttendance(
        student: student,
        date: date,
        gymId: gymid,
        profId: profId,
        status: true,
      );
      await awsDb2.verifyPayment(student.user_id!, date, gymid, profId, ref.watch(defaultPlanProvider));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } finally {
      await fetchAttendanceToday(date);
    }
  }

  Future<void> deleteAttendance(
    Student deleted,
    String date,
    String tenantId,
  ) async {
    try {
      final awsDb = DataStoreDeleteService();
      await awsDb.deleteAttendanceByID(deleted, date, tenantId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }finally {
      await fetchAttendanceToday(date);
    }
  }

  Map<String, int> getAttendanceMap() {
    final attendances = state.value?.attendanceInRange;
    Map<String, int> studentsPerDay = {};
        for (var attendance in attendances!) {
          String dateKey = attendance.date.format();
          if (studentsPerDay.containsKey(dateKey)) {
            studentsPerDay[dateKey] = studentsPerDay[dateKey]! + 1;
          } else {
            studentsPerDay[dateKey] = 1;
          }
        }
      return studentsPerDay;
    }

}
