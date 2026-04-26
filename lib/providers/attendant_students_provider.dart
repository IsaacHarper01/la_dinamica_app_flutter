import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
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
      final userAsync = ref.watch(userProvider);
      return StudentsNotifier(ref,userAsync);
    });

class StudentsNotifier extends StateNotifier<AsyncValue<AttendanceModel>> {
  final Ref ref;

  StudentsNotifier(this.ref, AsyncValue<UserLocal> userAsync) : super(const AsyncValue.loading()){
    userAsync.whenData((user){
      loadValues();
    });
  }
  
  Future<void> loadValues() async {
    try {
      final today = await fetchAttendanceToday(ref.read(dateProvider).today);
      final range = await fetchAttendanceInRange();
      final dateMap = getMap(range);

      AttendanceModel model = AttendanceModel(
        attendanceToday: today, 
        attendanceInRange: range,
        attendancebyDate: dateMap,
        );
      state = AsyncValue.data(model);
    } catch (e, st) {
      if(!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  Map<DateTime, double> getMap(List<Attendance> range){
    Map<DateTime, double> newMap = {};
    for (var attendance in range){
      final key = DateTime.parse(attendance.date.toString().split(" ")[0]);
      if (newMap.containsKey(key)){
        newMap[key] = newMap[key]! + 1;
      }else{
        newMap[key] = 1;
      }
    }
    return newMap;
  }

  Future<List<Attendance>> fetchAttendanceToday(String date) async {
    try {
      final awsDb = DataStoreReadService();
      final user = await ref.read(userProvider.future);
      final tenenatId = user.tenant.tenant_id;
      final attendants = await awsDb.getAttendanceByDate(date, tenenatId);
      if (attendants.isEmpty) {
        return [];
      }else{
     //List<Student> students = attendants.map((att) => att.student!).toList();
     return attendants;
     }
    } catch (e) {
      return [];
    }
  }

  Future<void> setAttendanceToday(String date)async{
    final attendants = await fetchAttendanceToday(date);
    if (attendants.isNotEmpty){
      final current = state.value ?? AttendanceModel(attendanceToday: [], attendanceInRange: []);
      state = AsyncValue.data(current.copyWith(attendanceToday: attendants));
    }
  }

  Future<List<Attendance>> fetchAttendanceInRange() async {
    try {
      final awsDb = DataStoreReadService();
      final user = await ref.read(userProvider.future);
      final startDate = ref.read(dateProvider).start;
      final endDate = ref.read(dateProvider).end;
      final tenenatId = user.tenant.tenant_id;
      final snapshot = await awsDb.getAttendanceRange(startDate, endDate, tenenatId);
      if (snapshot.isEmpty) {
        return [];
      }
     return snapshot;
    } catch (e) {
      return [];
    }
  }

  Future<void> setAttendanceInRange() async{
    final attendances = await fetchAttendanceInRange();
    final dateMap = getMap(attendances);
    if(attendances.isNotEmpty){
      final current = state.value ?? AttendanceModel(attendanceToday: [], attendanceInRange: []);
      state = AsyncValue.data(current.copyWith(attendanceInRange: attendances, attendancebyDate: dateMap));
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
      await awsDb2.verifyPayment(student, date, gymid, profId, ref.watch(defaultPlanProvider));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } finally {
      await loadValues();
    }
  }

  Future<void> deleteAttendance(
    Attendance deleted,
    String date,
  ) async {
    try {
      final awsDb = DataStoreDeleteService();
      await awsDb.deleteAttendance(deleted);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }finally {
      await loadValues();
    }
  }
}
