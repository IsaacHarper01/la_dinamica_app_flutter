import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:la_dinamica_app/models/MetricsType.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';

class DataStoreService {
  
  Future<void> savePlan({
    required String type,
    required int clases,
    required double price,
  }) async {
    final item = LocalPlan(
      type: type,
      clases: clases,
      price: price,
    );

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
        prof_id: profId
        );

    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Pago guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar el Pago: $e');
      rethrow;
    }
  }

  Future<void> saveMetric({
    required int userId,
    required String metric,
    required String date,
    required double value,
  }) async {
    final item = Metric(
        user_id: userId,
        metric: metric,
        date: TemporalDate(DateTime.parse(date)),
        value: value);

    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Metrica guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar Metrica: $e');
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
  }) async {
    try {
      final students = await Amplify.DataStore.query(
        Student.classType,
        sortBy: [Student.USER_ID.descending()],
        pagination: const QueryPagination(limit: 1,),
        );
      final lastNumId =  students.isNotEmpty? students.first.user_id: 0;
      
      final item = Student(
        user_id: lastNumId! + 1,
        name: name,
        address: address,
        phone: phone,
        age: age,
        birthday: TemporalDate(DateTime.parse(birthday)),
        email: email,
        image: image);

    await Amplify.DataStore.save(item);
      safePrint('✅ Alumno guardado correctamente');
      final id = item.id;
      safePrint('ID del Alumno guardado: $id');
      return item.user_id!;
    }
    
    catch (e) {
      safePrint('❌ Error al consultar los alumnos: $e');
      rethrow;
    }
  }

  Future<void> saveAttendance({
    required int userId,
    required String name,
    required String date,
  }) async {
    final awsDb  = DataStoreReadService();
    final todayAttendance = await awsDb.getAttendanceByDate(date);
    
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
        date: TemporalDate(DateTime.parse(date)));

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
    required String? clientId,
    required String? name,
    required String? role,
    required String? plan,
    required bool? status,
  }) async {
    final item = User(
        id: id,
        db_id: clientId,
        name: name,
        role: role,
        Plan: plan,
        status: status,
    );

    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Usuario guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar el usuario: $e');
      rethrow;
    }
  }

  Future<void> saveMetricsType(
    {required String name,
     required double minValue,
     required double maxValue,
     required String? category,
     required String? gymId,
     }) 
     async {
    final item = MetricsType(
      name: name,
      min_value: minValue,
      max_value: maxValue,
      category: category,
      client_id: gymId,);
    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Tipo de métrica guardado correctamente');
    }
    catch (e) {
      safePrint('❌ Error al guardar el tipo de métrica: $e');
      rethrow;
      }
    }
}