import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class DataStoreReadService {

  Future<List<LocalPlan>> getPlans(String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<LocalPlan> plans = await Amplify.DataStore.query(
        LocalPlan.classType,
        where: LocalPlan.CLIENT_ID.eq(tenantId),
      );
      safePrint('✅ Planes obtenidos correctamente');
      return plans;
    } catch (e) {
      safePrint('❌ Error al obtener los planes: $e');
      rethrow;
    }
  }

  Future<List<List<String>>> getPlansNamesIds(String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<LocalPlan> plans = await Amplify.DataStore.query(
        LocalPlan.classType,
        where: LocalPlan.CLIENT_ID.eq(tenantId),
      );
      List<Student> general = await Amplify.DataStore.query(
        Student.classType,
        where: Student.CLIENT_ID.eq(tenantId),
        );

      List<String> names = [];
      List<String> ids = [];
      List<String> planType = [];
      List<String> planPrice = [];
      List<String> numClases = [];

      for (var person in general) {
        names.add(person.name!);
        ids.add(person.user_id.toString());
      }
      for (var plan in plans) {
        planType.add(plan.type!);
        planPrice.add(plan.price.toString());
        numClases.add(plan.clases.toString());
      }
      return [names, ids, planType, planPrice, numClases];
    } catch (e) {
      safePrint('❌ Error al obtener los planes: $e');
      rethrow;
    }
  }

  Future<List<Pay>> getPayments(String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Pay> payments = await Amplify.DataStore.query(
        Pay.classType,
        where: Pay.CLIENT_ID.eq(tenantId),
        );
      safePrint('✅ Pagos obtenidos correctamente');
      return payments;
    } catch (e) {
      safePrint('❌ Error al obtener los Pagos: $e');
      rethrow;
    }
  }

  Future<List<Pay>> getPaymentsRange(
    DateTime startDate,
    DateTime endDate,
    String tenantId,
  ) async {
    try {
      List<Pay> payments = await Amplify.DataStore.query(
        Pay.classType,
        where: Pay.DATE.between(TemporalDate(startDate), TemporalDate(endDate)) 
            .and(Pay.CLIENT_ID.eq(tenantId)),
      );
      safePrint('✅ Pagos obtenidos correctamente');
      return payments;
    } catch (e) {
      safePrint('❌ Error al obtener los pagos: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getLastPayandStudentData(int userId, String tenantId) async {
    dynamic studentData;
    dynamic lastPay;
    dynamic debts;

    try {
      List<Student> general = await Amplify.DataStore.query(
        Student.classType,
        where: Student.USER_ID.eq(userId)
          .and(Student.CLIENT_ID.eq(tenantId)),);
      studentData = general.first;
    } catch (e) {
      safePrint('❌ Error al obtener los datos del usuario: $e'); 
    }
    try{
      List<Pay> payments = await Amplify.DataStore.query(
        Pay.classType,
        where: Pay.USER_ID.eq(userId) 
            .and(Pay.CLIENT_ID.eq(tenantId)),
        sortBy: [Pay.DATE.descending()],);
        lastPay = payments.last;

    }catch(e){
      safePrint('❌ Error al obtener el ultimo pago del usuario: $e');
    }

    try{
      List<Pay> debtPays = await Amplify.DataStore.query(
        Pay.classType,
        where: Pay.USER_ID.eq(userId) 
            .and(Pay.CLIENT_ID.eq(tenantId))
            .and(Pay.DEBT.eq(true))
        );
      debts = debtPays;
    }catch(e){
      safePrint('❌ Error al obtener el ultimo pago del usuario: $e');
    }
      
      Map<String, dynamic> result = {
        'lastPay': lastPay,
        'studentData': studentData,
        'debts' : debts,
      };
      return result;
  }

  Future<double> getIncomeRange(DateTime startDate, DateTime endDate, String tenantId) async {
    double totalIncome = 0.0;
    try {
      // Consultar los datos almacenados en DataStore
      List<Pay> payments = await Amplify.DataStore.query(
        Pay.classType,
        where: Pay.DATE.between(TemporalDate(startDate), TemporalDate(endDate)) 
            .and(Pay.CLIENT_ID.eq(tenantId)),
      );

      if (payments.isEmpty) {
        safePrint(
          '❌ No se encontraron ingresos en el rango de fechas proporcionado',
        );
        return 0.0;
      } else {
        for (var payment in payments) {
          totalIncome += payment.amount ?? 0.0;
        }
        safePrint('✅ Ingreso calculado correctamente');
      }
      return totalIncome;
    } catch (e) {
      safePrint('❌ Error al obtener los Ingresos: $e');
      rethrow;
    }
  }
  
  Future<List<Map<String, dynamic>>?> getTotalAmounRange(DateTime startDate,DateTime endDate, String tenantId) async {
    Map<String, dynamic> clasesDates = {};
    Map<String, dynamic> studentsPerDay = {};

    try {
      List<Pay> payments = await Amplify.DataStore.query(
        Pay.classType,
        where: Pay.DATE.between(TemporalDate(startDate), TemporalDate(endDate)) 
            .and(Pay.CLIENT_ID.eq(tenantId)),
      );
      List<Attendance> students = await Amplify.DataStore.query(
        Attendance.classType,
        where: Attendance.DATE.between(TemporalDate(startDate),TemporalDate(endDate)) 
            .and(Attendance.CLIENT_ID.eq(tenantId)),
        );

      if (payments.isNotEmpty) {
        for (var payment in payments) {
          String dateKey = payment.date!.format();
          double amount = payment.amount ?? 0.0;

          if (clasesDates.containsKey(dateKey)) {
            clasesDates[dateKey] += amount;
          } else {
            clasesDates[dateKey] = amount;
          }
        }
      }
      else {
        safePrint('❌ No se encontraron pagos en el rango de fechas proporcionado');
        clasesDates = {};
        }
      if (students.isNotEmpty) {

        for (var student in students) {
          String dateKey = student.date!.format();
          if (studentsPerDay.containsKey(dateKey)) {
            studentsPerDay[dateKey] += 1;
          } else {
            studentsPerDay[dateKey] = 1;
          }
        }
      } else{
        safePrint('❌ No se encontraron asistencias en el rango de fechas proporcionado');
        studentsPerDay = {};
      }
      return [clasesDates, studentsPerDay];
    }
    catch (e) {
      safePrint('❌ Error al obtener el monto total: $e');
      rethrow;
    }
  }

  Future<List<Student>> getStudents(String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Student> general = await Amplify.DataStore.query(
        Student.classType,
        where: Student.CLIENT_ID.eq(tenantId),
        );
        
      safePrint('✅ Alumnos obtenidos correctamente');
      return general;
    } catch (e) {
      safePrint('❌ Error al obtener los Alumnos: $e');
      rethrow;
    }
  }

  Future<bool> checkIfStudentExists(int id, String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Student> general = await Amplify.DataStore.query(
        Student.classType,
        where: Student.USER_ID.eq(id) 
            .and(Student.CLIENT_ID.eq(tenantId)),
      );
      if (general.isNotEmpty) {
        safePrint('✅ El alumno con ID $id existe');
        return true;
      } else {
        safePrint('❌ El alumno con ID $id no existe');
        return false;
      }
    } catch (e) {
      safePrint('❌ Error al verificar la existencia del alumno: $e');
      rethrow;
    }
  }

  Future<List<List<String>>> getAgesandAddress(List<int> ids, String tenantId) async {
    try {
      List<Student> general = [];
      for (var id in ids) {
        general.addAll(
          await Amplify.DataStore.query(
            Student.classType,
            where: Student.USER_ID.eq(id)
              .and(Student.CLIENT_ID.eq(tenantId)),
          )
        );
      }
      List<String> ages = [];
      List<String> addresses = [];
      if (general.isNotEmpty) {
        for (var student in general) {
          ages.add(student.age.toString());
          addresses.add(student.address!);
        }
        safePrint('✅ Edades y direcciones obtenidas correctamente');
        return [ages, addresses];
      } else {
        safePrint('❌ No se encontró el alumno con el ID proporcionado');
        return [[], []];
      }
    } catch (e) {
      safePrint('❌ Error al obtener las edades y direcciones: $e');
      rethrow;
    }
  }

  Future<List<Attendance>> getAttendance(String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Attendance> attendance = await Amplify.DataStore.query(
        Attendance.classType,
        where: Attendance.CLIENT_ID.eq(tenantId),
      );
      safePrint('✅ Asistencias obtenidas correctamente');
      return attendance;
    } catch (e) {
      safePrint('❌ Error al obtener las asistencias: $e');
      rethrow;
    }
  }

  Future<List<Attendance>> getAttendanceByDate(String date, String tenantId) async {
    try {
      List<Attendance> attendance = await Amplify.DataStore.query(
        Attendance.classType,
        where: Attendance.DATE.eq(date) 
            .and(Attendance.CLIENT_ID.eq(tenantId)),
      );
      return attendance;
    } catch (e) {
      safePrint('❌ Error al obtener las asistencias: $e');
      rethrow;
    }
  }

  Future<List<Attendance>> getAttendanceRange(
    DateTime startDate,
    DateTime endDate,
    String tenantId,
  ) async {
    try {
      List<Attendance> attendance = await Amplify.DataStore.query(
        Attendance.classType,
        where: Attendance.DATE.between(TemporalDate(startDate),TemporalDate(endDate),) 
            .and(Attendance.CLIENT_ID.eq(tenantId)),
      );
      safePrint('✅ Asistencias obtenidas correctamente');
      return attendance;
    } catch (e) {
      safePrint('❌ Error al obtener las asistencias: $e');
      rethrow;
    }
  }

  Future<LocalPlan?> getSimplePlan(String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<LocalPlan> plans = await Amplify.DataStore.query(
        LocalPlan.classType,
        where: LocalPlan.CLASES.eq(1) 
            .and(LocalPlan.CLIENT_ID.eq(tenantId)),
      );
      safePrint('✅ Planes obtenidos correctamente');
      if (plans.isNotEmpty) {
        return plans.first;
      } else {
        return null;
      }
    } catch (e) {
      safePrint('❌ Error al obtener los planes: $e');
      rethrow;
    }
  }

  Future<Pay?> getLastPayment(int userId, String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Pay> payments = await Amplify.DataStore.query(
        Pay.classType,
        where: Pay.USER_ID.eq(userId)  
            .and(Pay.CLIENT_ID.eq(tenantId)),
        sortBy: [Pay.DATE.descending()],
      );
      safePrint('✅ Pagos obtenidos correctamente');
      if (payments.isNotEmpty) {
        return payments.last;
      } else {
        return null;
      }
    } catch (e) {
      safePrint('❌ Error al obtener los pagos: $e');
      return null;
    }
  }

  Future<List<Pay>?> getLastTenPayments(int userId, String tenaniId)async{
    try{
      List<Pay> payments = await Amplify.DataStore.query(
        Pay.classType,
        where: Pay.USER_ID.eq(userId).and(Pay.CLIENT_ID.eq(tenaniId)),
        sortBy: [Pay.DATE.descending()],
        pagination: const QueryPagination.firstPage(),
        );
        return payments;
    }catch(e){
      safePrint('❌ Error al obtener los ultimos 10 pagos: $e');
      return null;
    }
  }

  Future<void> verifyPayment(int userId, String date, String tenantId, String profId) async {
    try {
      Pay? lastPayment = await getLastPayment(userId, tenantId);
      LocalPlan? basePlan = await getSimplePlan(tenantId);
      double cost = 0.0;
      String planType = 'Clase Unica';

      if (basePlan != null) {
        cost = basePlan.price!;
        planType = basePlan.type!;
      }
      if (lastPayment == null) {
        final newPayment = Pay(
          user_id: userId, //This user ID is the student ID
          amount: cost,
          clases: 0,
          type: planType,
          date: TemporalDate(DateTime.parse(date)),
          client_id: tenantId, //this user ID is the client ID
          prof_id: profId, //This user ID is the teacher ID
          debt: false,
        );

        await Amplify.DataStore.save(newPayment);
      } else {
        if (lastPayment.type != planType && (lastPayment.clases!) > 0) {
          var remainingClases = (lastPayment.clases!) - 1;
          Pay newPayment = lastPayment.copyWith(clases: remainingClases);
          await Amplify.DataStore.save(newPayment);
        } else {
          final newPayment = Pay(
            user_id: userId,
            amount: cost,
            clases: 0,
            type: planType,
            date: TemporalDate(DateTime.parse(date)),
            client_id: tenantId, // this user ID is the client ID
            prof_id: profId, //This user ID is the teacher ID
          );
          await Amplify.DataStore.save(newPayment);
        }
      }

      safePrint('✅ Pago verificado correctamente');
    } catch (e) {
      safePrint('❌ Error al verificar el pago: $e');
      rethrow;
    }
  }

  Future<bool> userExists(String userId) async {
    try {
      const listUsers = '''
        query ListUsers(\$filter: ModelUserFilterInput) {
          listUsers(filter: \$filter) {
            items {
              user_id
            }
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: listUsers,
        variables: {
          "filter": {
            "user_id": {"eq": userId}
          }
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.errors.isNotEmpty) {
        safePrint('❌ GraphQL errors: ${response.errors}');
        return false;
      }

      final data = response.data;
      if (data == null) return false;

      final decoded = jsonDecode(data);
      final items = decoded['listUsers']['items'] as List<dynamic>;

      return items.isNotEmpty;
    } catch (e) {
      safePrint('❌ Error checking user via GraphQL: $e');
      return false;
    }
  }

  Future<User?> getUser(String userId) async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
        query GetUser(\$user_id: ID!) {
          getUser(user_id: \$user_id) {
            user_id
            name
            createdAt
            updatedAt
            access {
              items {
                id
                user_id
                tenant_id
                permissions
                status
                createdAt
                updatedAt
              }
            }
          }
        }
      ''',
        variables: { 'user_id': userId },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.errors.isNotEmpty) {
        safePrint('❌ GraphQL errors: ${response.errors}');
        return null;
      }

      if (response.data == null) {
        safePrint('⚠️ User not found with ID: $userId');
        return null;
      }

      final data = jsonDecode(response.data!);
      final userJson = data['getUser'];

      if (userJson == null) {
        safePrint('⚠️ User not found with ID: $userId');
        return null;
      }

      // Convert JSON back into your Amplify-generated User model
      final user = User.fromJson(Map<String, dynamic>.from(userJson));

      return user;
    } catch (e) {
      safePrint('❌ Error getting user: $e');
      rethrow;
    }
  }

  Future<Tenant?> getTenant(String tenantId) async {
    try {
      final tenants = await Amplify.DataStore.query(
        Tenant.classType,
        where: Tenant.TENANT_ID.eq(tenantId),
      );
      if (tenants.isNotEmpty) return tenants.first;
      safePrint('⚠️ Tenant not found with ID: $tenantId');
      return null;
    } catch (e) {
      safePrint('❌ Error getting tenant: $e');
      rethrow;
    }
  }

  Future<User> userLocalAdapter(UserLocal user) async{
    try{
      final newUser = User(
        user_id: user.userId,
        name: user.name,
      );
      return newUser;
    }catch(e){
      safePrint('❌ Error converting UserLocal to User: $e');
      rethrow;
    }
  }
  
  Future<void> giveUserAccess(Tenant tenant, String permissions, String userid) async {
    try{
    final user = await getUser(userid);
    if (user != null) {
        final userAccess = UserAccess(
          user: user,
          tenant: tenant,
          permissions: permissions,
          status: true,
        );
        await Amplify.DataStore.save(userAccess);
        safePrint('✅ Usuario con ID ${user.user_id} ha sido dado acceso al tenant con ID ${tenant.tenant_id} con permisos: $permissions');
    }
    }catch (e) {
      safePrint('❌ Error giving user access: $e');
      rethrow;
    }
  }

  Future<List<UserAccess>?> getUserAccess(String userId) async {
  const graphQLDocument = '''
    query GetUserAccessByUserId(\$userId: ID!) {
      listUserAccesses(filter: { user_id: { eq: \$userId } }) {
        items {
          id
          user_id
          tenant_id
          permissions
          status
          user {
            user_id
            name
          }
          tenant {
            tenant_id
            name
            plan
            status
          }
        }
      }
    }
  ''';

  try {
    final request = GraphQLRequest<String>(
      document: graphQLDocument,
      variables: {'userId': userId},
    );

    final response = await Amplify.API.query(request: request).response;

    if (response.errors.isNotEmpty) {
      safePrint('❌ GraphQL Errors: ${response.errors}');
      return null;
    }

    final data = jsonDecode(response.data!) as Map<String, dynamic>;
    final items = data['listUserAccesses']?['items'] as List?;
    
    if (items == null || items.isEmpty) {
      safePrint('⚠️ User access not found for user ID: $userId');
      return null;
    }

    // Convert each map to a UserAccess model using fromJson
    final userAccessList = items
        .map((item) => UserAccess.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    return userAccessList;
  } catch (e) {
    safePrint('❌ Error getting user access: $e');
    return null;
  }
}

  Future<List<Evaluations>?> getEvaluations(String tenantId) async {
    try {
      final evaluations = await Amplify.DataStore.query(
        Evaluations.classType,
        where: Evaluations.TENANT_ID.eq(tenantId),
      );
      safePrint('✅ Evaluaciones obtenidas correctamente');
      return evaluations;
    } catch (e) {
      safePrint('❌ Error al obtener las evaluaciones: $e');
      rethrow;
    }
  }
   
  Future<List<JointMetric>?> getJointMetrics(String tenantId, Evaluations exam) async {
    try {
      final jointMetrics = await Amplify.DataStore.query(
        JointMetric.classType,
        where: JointMetric.TENANT_ID.eq(tenantId).and(JointMetric.EVALUATION.eq(exam.id)),
      );
      safePrint('✅ Métricas conjuntas obtenidas correctamente ${jointMetrics.first.metric!.name}');
      return jointMetrics;
    } catch (e) {
      safePrint('❌ Error al obtener las métricas conjuntas: $e');
      rethrow;
    }
  }

  Future<List<JoinSubMetric>> getJoinSubMetrics(String tenantId, SingleMetric metric) async {
    try {
      final joinSubMetrics = await Amplify.DataStore.query(
        JoinSubMetric.classType,
        where: JoinSubMetric.TENANT_ID.eq(tenantId).and(JoinSubMetric.METRIC.eq(metric.id)),
      );
      safePrint('✅ Submétricas obtenidas correctamente');
      return joinSubMetrics;
    } catch (e) {
      safePrint('❌ Error al obtener las submétricas: $e');
      rethrow;
    }
  }

  Future<List<Grades>?> getLastExam(String tenantId, String studentId) async{
    try {
      final grades = await Amplify.DataStore.query(
        Grades.classType,
        where: Grades.STUDENT.eq(studentId).and(Grades.TENANT_ID.eq(tenantId)));
      return([grades.last]);
    } catch (e) {
      safePrint("Error al obtener calificaciones");
      return null;
    }
  }

  Future<List<Grades>> getRangeExams(String tenantId, String studentId, DateTime start, DateTime end) async{
    try {
      final grades = await Amplify.DataStore.query(
        Grades.classType,
        where:Grades.DATE.between(
          TemporalDate(start), 
          TemporalDate(end)).
          and(Grades.STUDENT.eq(studentId).
          and(Grades.TENANT_ID.eq(tenantId))));
      return(grades);
    } catch (e) {
      safePrint("Error al obtener calificaciones");
      rethrow;
    }
  }
}


