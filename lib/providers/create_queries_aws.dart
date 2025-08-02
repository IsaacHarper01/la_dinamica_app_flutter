import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';

class DataStoreService {

  Future<void> savePlan({
    required String type,
    required int clases,
    required double price,
    required String gymId,
  }) async {
    final item = LocalPlan(type: type, clases: clases, price: price, client_id: gymId);

    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Plan guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar el plan: $e');
      rethrow;
    }
  }
  
  Future<void> savePayment({
    required int userId,
    required double amount,
    required int clases,
    required String type,
    required String date,
    required String? dbId,
    required String? profId,
  }) async {
    final item = Pay(
      user_id: userId,
      amount: amount,
      clases: clases,
      type: type,
      date: TemporalDate(DateTime.parse(date)),
      client_id: dbId,
      prof_id: profId,
    );

    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Pago guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar el Pago: $e');
      rethrow;
    }
  }

  Future<int> saveGeneral({
    required String name,
    required String address,
    required String phone,
    required int age,
    required String birthday,
    required String email,
    required String image,
    required String? gymId,
  }) async {
    try {
      final students = await Amplify.DataStore.query(
        Student.classType,
        where: Student.CLIENT_ID.eq(gymId),
        sortBy: [Student.USER_ID.descending()],
        pagination: const QueryPagination(limit: 1),
      );
      final lastNumId = students.isNotEmpty ? students.first.user_id : 0;

      final item = Student(
        user_id: lastNumId! + 1,
        name: name,
        address: address,
        phone: phone,
        age: age,
        birthday: TemporalDate(DateTime.parse(birthday)),
        email: email,
        image: image,
        client_id: gymId,
      );

      await Amplify.DataStore.save(item);
      safePrint('✅ Alumno guardado correctamente');
      final id = item.id;
      safePrint('ID del Alumno guardado: $id');
      return item.user_id!;
    } catch (e) {
      safePrint('❌ Error al consultar los alumnos: $e');
      rethrow;
    }
  }

  Future<void> saveAttendance({
    required int userId,
    required String name,
    required String date,
    required String gymId,
    required String profId,
  }) async {
    final awsDb = DataStoreReadService();
    final todayAttendance = await awsDb.getAttendanceByDate(date, gymId);

    if (todayAttendance.isNotEmpty) {
      for (var att in todayAttendance) {
        if (att.user_id == userId) {
          safePrint('Asistencia ya registrada para el usuario: $userId');
          return;
        }
      }
    }
    final item = Attendance(
      user_id: userId,
      name: name,
      date: TemporalDate(DateTime.parse(date)),
      client_id: gymId,
      prof_id: profId,
    );

    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Asistencia guardada correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar la Asistencia: $e');
      rethrow;
    }
  }

  Future<void> saveUser({
    required String id,
    required String name,
  }) async {
    final item = User(
      user_id: id,
      name: name,
    );
    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Usuario guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar el usuario: $e');
      rethrow;
    }
  }

  Future<void> saveUserAccess({
    required String permissions,
    required bool status,
    required Tenant tenant,
    required User user,
  }) async {
    final item = UserAccess(
      permissions: permissions,
      status: status,
      tenant: tenant,
      user: user,
    );
    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Acceso de usuario guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar el acceso de usuario: $e');
      rethrow;
    }
  }

  Future<void> saveTenant({
    required String tenantId,
    required String name,
    required String plan,
    required bool status,
  }) async {
    final item = Tenant(
      tenant_id: tenantId,
      name: name,
      plan: plan,
      status: status,
    );
    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Gimnasio guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar el gimnasio: $e');
      rethrow;
    }
  }

}