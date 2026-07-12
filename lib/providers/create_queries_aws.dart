import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

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
    required LocalPlan plan,
    required String date,
    required String? dbId,
    required String? profId,
  }) async {
    final newUUID = dbId! + date + plan.id + userId.toString();
    final item = Payment(
      id: newUUID,
      user_id: userId,
      amount: amount,
      clases: clases,
      plan: plan,
      date: TemporalDate(DateTime.parse(date)),
      client_id: dbId,
      prof_id: profId,
      debt: false,
    );

    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Pago guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar el Pago: $e');
      rethrow;
    }
  }

  Future<Student> saveStudent({
    required String name,
    required String address,
    required String phone,
    required int age,
    required String birthday,
    required String email,
    required String image,
    required String gymId,
    int? remainClases,
    TemporalDate? expirationDate,
  }) async {
    try {
      final students = await Amplify.DataStore.query(
        Student.classType,
        where: Student.CLIENT_ID.eq(gymId),
        sortBy: [Student.USER_ID.descending()],
        pagination: const QueryPagination(limit: 1),
      );
      final lastNumId = students.isNotEmpty ? students.first.user_id : 0;
      final newUUID = name.toLowerCase().replaceAll(" ", "")+birthday+gymId;
      final item = Student(
        id: newUUID,
        user_id: lastNumId! + 1,
        name: name,
        address: address,
        phone: phone,
        age: age,
        birthday: TemporalDate(DateTime.parse(birthday)),
        email: email,
        image: image,
        client_id: gymId,
        remainClasses: remainClases ?? 0,
        expirationPlan: expirationDate,
      );

      await Amplify.DataStore.save(item);
      safePrint('✅ Alumno guardado correctamente');
      final id = item.id;
      safePrint('ID del Alumno guardado: $id');
      return item;
    } catch (e) {
      safePrint('❌ Error al consultar los alumnos: $e');
      rethrow;
    }
  }

  Future<void> saveAttendance({
    required Student student,
    required String date,
    required String gymId,
    required String profId,
    required bool status
  }) async {
    final newUUID = student.id+date;
    final item = Attendance(
      id: newUUID,
      student: student,
      date: TemporalDate(DateTime.parse(date)),
      client_id: gymId,
      prof_id: profId,
      status: status,
    );

    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Asistencia guardada correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar la Asistencia: $e');
      rethrow;
    }
  }

  Future<User> saveUser({
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
      return item;
    } catch (e) {
      safePrint('❌ Error al guardar el usuario: $e');
      rethrow;
    }
  }

  Future<UserAccess> saveUserAccess({
    required Map<String, bool> permissions,
    required bool status,
    required Tenant tenant,
    required User user,
    required bool isAdmin,
  }) async {
    final item = UserAccess(
      permissions: jsonEncode(permissions),
      status: status,
      tenant: tenant,
      user: user,
      isAdmin: isAdmin,
    );
    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Acceso de usuario guardado correctamente');
      return item;
    } catch (e) {
      safePrint('❌ Error al guardar el acceso de usuario: $e');
      rethrow;
    }
  }

  Future<Tenant> saveTenant({
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
      return item;
    } catch (e) {
      safePrint('❌ Error al guardar el gimnasio: $e');
      rethrow;
    }
  }

  Future<Evaluations> saveEvaluation({
  required String name,
  required String gymId,
    }) async {
      final evaluation = Evaluations(
        name: name,
        tenant_id: gymId,
      );

      await Amplify.DataStore.save(evaluation);
      safePrint('✅ Evaluation saved: ${evaluation.id}, ${evaluation.name}');
      return evaluation;
    }

  Future<StudentExamResults> saveStudentExamResults({
    required Student student,
    required Evaluations eval,
    required String grades,
    required String tenantId,
    required DateTime date,
  })async{
    final newGrade = StudentExamResults(
      tenant_id: tenantId,
      student: student,
      evaluation: eval,
      grades: grades,
      date: TemporalDate(date),
    );
    await Amplify.DataStore.save(newGrade);
    return newGrade;
  }

  Future<Metric> saveMetric({
  required String name,
  required String tenantId,
  required String description,
  required String type,
  required bool higgerBetter
}) async {
  safePrint('nombre: $name, tenant: $tenantId, description $description, type: $type');
  final metric = Metric(
    name: name,
    tenant_id: tenantId,
    description: description,
    type: type,
    higgerBetter: higgerBetter,
  );

  await Amplify.DataStore.save(metric);
  safePrint('✅ Metric saved: ${metric.id}, ${metric.name}');
  return metric;
}

  Future<JoinMetric> saveJoinedMetric({
  required Metric metric,
  required Evaluations evaluation,
  required String tenantId,
}) async {
  final joinMetric = JoinMetric(
    metric: metric,          // Pass the object
    evaluation: evaluation,  // Pass the object
    tenant_id: tenantId,
  );

  await Amplify.DataStore.save(joinMetric);
  safePrint('✅ JoinMetric saved: ${joinMetric.id}');
  return joinMetric;
}

  Future<void> markDebtStatus({
    required Payment pay,
    required bool status,
    })async{
      final newPay = pay.copyWith(debt:status);
      Amplify.DataStore.save(newPay);
    }

  Future<void> saveProduct({
    required String code,
    required String name,
    required String tenaniId,
    required double price,
    required String image,
    required int stock,
    required String category,
  })async{
      final newProduct = Product(
        name: name,
        code: code,
        tenant_id: tenaniId,
        price: price,
        image: image,
        stock: stock,
        category: category
      );
      Amplify.DataStore.save(newProduct);
  }

  Future<void> saveSale({
    required String tenaniId,
    required double price,
    required Product product,
    required String date,
    required String profName,
  })async{
      final newSale = Sale(
        tenant_id: tenaniId,
        price: price,
        product: product,
        date: TemporalDate(DateTime.parse(date)),
        profname: profName
      );
      Amplify.DataStore.save(newSale);
  }

  Future<Groups> saveGroup({
    required String name,
    required String tenantId,
    required String description,
  })async{
    final newGroup = Groups(
      name: name,
      tenant_id: tenantId,
      description: description
    );
    Amplify.DataStore.save(newGroup);
    return newGroup;
  }

  Future<void> saveJoinGroup({
    required Student student,
    required Groups group,
    required String tenantId
  })async{
    final newJoinGroup = JoinGroups(
      tenant_id: tenantId,
      student: student,
      group: group
    );
    Amplify.DataStore.save(newJoinGroup);
  }

  Future<void> saveExpense({
    required Tenant tenant,
    required DateTime date,
    required String name,
    required double amount,
    required String? description,
  })async{
    final newExpense = Expense(
      tenant: tenant,
      name: name, 
      amount: amount,
      description: description,
      date: TemporalDate(date));
    Amplify.DataStore.save(newExpense);
  }

}
