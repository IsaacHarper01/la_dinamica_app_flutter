import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';

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

  Future<List<LocalPlan>> getallPlans() async {
    try {
      // Consultar los datos almacenados en DataStore
      List<LocalPlan> plans = await Amplify.DataStore.query(
        LocalPlan.classType,
      );
      safePrint('✅ Planes obtenidos correctamente');
      return plans;
    } catch (e) {
      safePrint('❌ Error al obtener los planes: $e');
      rethrow;
    }
  }

  Future<List<Payment>> getPaymentsRange(
    DateTime startDate,
    DateTime endDate,
    String tenantId,
  ) async {
    try {
      List<Payment> payments = await Amplify.DataStore.query(
        Payment.classType,
        where: Payment.DATE.between(TemporalDate(startDate), TemporalDate(endDate)) 
            .and(Payment.CLIENT_ID.eq(tenantId)),
      );
      safePrint('✅ Pagos obtenidos correctamente');
      return payments;
    } catch (e) {
      safePrint('❌ Error al obtener los pagos: $e');
      rethrow;
    }
  }

  Future<List<Payment>> getTodayPayments(String tenantId, String date)async{
    try {
      final expenses = await Amplify.DataStore.query(
        Payment.classType,
        where: Payment.DATE.eq(date).and(Payment.CLIENT_ID.eq(tenantId))
        );
      return expenses;
      } catch (e) {
        rethrow;
      }
    }

  Future<List<Sale>> getSalesPerRange(DateTime startDate,DateTime endDate,String tenantId,) async {
    try {
      List<Sale> sales = await Amplify.DataStore.query(
        Sale.classType,
        where: (Sale.TENANT_ID.eq(tenantId))
        .and(Sale.DATE.between(TemporalDate(startDate), TemporalDate(endDate)))
        ,
      );
      safePrint('✅ Ventas obtenidas correctamente');
      return sales;
    } catch (e) {
      safePrint('❌ Error al obtener las ventas: $e');
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
      List<Payment> payments = await Amplify.DataStore.query(
        Payment.classType,
        where: Payment.USER_ID.eq(userId) 
            .and(Payment.CLIENT_ID.eq(tenantId))
            .and(Payment.CLASES.gt(0)),
        sortBy: [Payment.DATE.descending()],);
        lastPay = payments.last;

    }catch(e){
      safePrint('❌ Error al obtener el ultimo pago del usuario: $e');
    }

    try{
      List<Payment> debtPays = await Amplify.DataStore.query(
        Payment.classType,
        where: Payment.USER_ID.eq(userId) 
            .and(Payment.CLIENT_ID.eq(tenantId))
            .and(Payment.DEBT.eq(true))
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
  
  Future<List<Student>> getStudents(String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Student> general = await Amplify.DataStore.query(
        Student.classType,
        where: Student.CLIENT_ID.eq(tenantId),
        sortBy: [Student.USER_ID.ascending()],
        );
        
      safePrint('✅ Alumnos obtenidos correctamente');
      return general;
    } catch (e) {
      safePrint('❌ Error al obtener los Alumnos: $e');
      rethrow;
    }
  }

  Future<List<Student>> getAllStudents() async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Student> general = await Amplify.DataStore.query(
        Student.classType,
        );
        
      safePrint('✅ Alumnos obtenidos correctamente');
      return general;
    } catch (e) {
      safePrint('❌ Error al obtener los Alumnos: $e');
      rethrow;
    }
  }

  Future<Student?> checkIfStudentExists(String uuid, String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Student> general = await Amplify.DataStore.query(
        Student.classType,
        where: Student.ID.eq(uuid) 
            .and(Student.CLIENT_ID.eq(tenantId)),
      );
      if (general.isNotEmpty) {
        safePrint('✅ El alumno con ID $uuid existe');
        return general.first;
      } else {
        safePrint('❌ El alumno con ID $uuid no existe');
        return null;
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

  Future<List<Attendance>> getAttendanceByDate(String date, String tenantId) async {
    try {
      List<Attendance> attendance = await Amplify.DataStore.query(
        Attendance.classType,
        where: Attendance.DATE.eq(date) 
            .and(Attendance.CLIENT_ID.eq(tenantId)
            .and(Attendance.STATUS.eq(true))
            ),
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
            .and(Attendance.CLIENT_ID.eq(tenantId)
            .and(Attendance.STATUS.eq(true)))
      );
      safePrint('✅ Asistencias obtenidas correctamente');
      return attendance;
    } catch (e) {
      safePrint('❌ Error al obtener las asistencias: $e');
      rethrow;
    }
  }

  Future<List<Expense>> getExpensesRange(Tenant tenant, DateTime start, DateTime end)async{
    try{
      final List<Expense> allexpenses = await Amplify.DataStore.query(
      Expense.classType,
      where: Expense.DATE.between(TemporalDate(start), TemporalDate(end))
      .and(Expense.TENANT.eq(tenant.tenant_id)));

      return allexpenses;
    }catch(e){
      return [];
    }
  }

  Future<List<Expense>> getTodayExpenses(String tenantId, String date)async{
    try {
      final expenses = await Amplify.DataStore.query(
        Expense.classType,
        where: Expense.DATE.eq(date).and(Expense.TENANT.eq(tenantId))
        );
      return expenses;
      } catch (e) {
        rethrow;
      }
    } 

  Future<List<Payment>?> getLastTenPayments(int userId, String tenaniId)async{
    try{
      List<Payment> payments = await Amplify.DataStore.query(
        Payment.classType,
        where: Payment.USER_ID.eq(userId).and(Payment.CLIENT_ID.eq(tenaniId)),
        sortBy: [Payment.DATE.descending()],
        pagination: const QueryPagination.firstPage(),
        );
        return payments;
    }catch(e){
      safePrint('❌ Error al obtener los ultimos 10 pagos: $e');
      return null;
    }
  }

  Future<void> verifyPayment(Student student, String date, String tenantId, String profId, LocalPlan defaultPlan) async {
     try {
        if(student.remainClasses! > 0){
          final updatedStudent = student.copyWith(remainClasses: student.remainClasses! - 1);
          await Amplify.DataStore.save(updatedStudent);
        } else {
        if(defaultPlan.client_id!='none'){
        final newPayment = Payment(
          user_id: student.user_id,
          amount: defaultPlan.price,
          clases: defaultPlan.clases,
          plan: defaultPlan,
          date: TemporalDate(DateTime.parse(date)),
          client_id: tenantId,
          prof_id: profId,
          debt: false,
        );
        await Amplify.DataStore.save(newPayment);
        safePrint('✅ Pago por defecto creado correctamente');
        }else{
          return;
        }
    }
    }catch (e) {
      safePrint('❌ Error al verificar el pago: $e');
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

  Future<List<UserAccess>> userHasAccess(User user, Tenant tenant)async{
    try {
      final access = await Amplify.DataStore.query(
        UserAccess.classType,
        where: UserAccess.USER.eq(user.user_id)
        .and(UserAccess.TENANT.eq(tenant.tenant_id)
          )
        );
        return access;
    } catch (e) {
      safePrint('');
      rethrow;
    }
  }

  Future<void> giveUserAccess(Tenant tenant, String permissions, String userid) async {
    try{
    final user = await getUser(userid);
    if (user != null) {
        final access = await userHasAccess(user, tenant);
        if (access.isEmpty){
          final userAccess = UserAccess(
          user: user,
          tenant: tenant,
          permissions: permissions,
          status: true,
          isAdmin: false,
          );
          await Amplify.DataStore.save(userAccess);
          safePrint('✅ Usuario con ID ${user.user_id} ha sido dado acceso al tenant con ID ${tenant.tenant_id} con permisos: $permissions');
          return;
        }else{
          final newAccess = access.first.copyWith(permissions: permissions);
          await Amplify.DataStore.save(newAccess);
          safePrint('✅ Permisos del usuario ${user.user_id} han sido actualizados: $permissions');
        }
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
          isAdmin
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

  Future<List<UserAccess>> getUserPermisions(String tenaniId) async {
    List<UserAccess> userAccess = [];
    try {
      userAccess = await Amplify.DataStore.query(
        UserAccess.classType,
        where: UserAccess.TENANT.eq(tenaniId)
        );
      return userAccess;
    } catch (e) {
      return [];
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
   
  Future<List<JoinMetric>?> getJoinMetrics(String tenantId, Evaluations exam) async {
    try {
      final joinMetrics = await Amplify.DataStore.query(
        JoinMetric.classType,
        where: JoinMetric.TENANT_ID.eq(tenantId).and(JoinMetric.EVALUATION.eq(exam.id)),
      );
      safePrint('✅ Métricas conjuntas obtenidas correctamente ${joinMetrics.first.metric!.name}');
      return joinMetrics;
    } catch (e) {
      safePrint('❌ Error al obtener las métricas conjuntas: $e');
      rethrow;
    }
  }

  Future<List<StudentExamResults>> getStudentResultsRange(
      String studentId,
      String tenantId,
      DateTime start,
      DateTime end,
    ) async {
      List<StudentExamResults> allItems = [];
      String? nextToken;

      do {
        final request = GraphQLRequest<String>(
          document: '''
          query GetStudentResultsRange(
            \$studentId: ID!,
            \$tenantId: ID!,
            \$start: String!,
            \$end: String!
            \$nextToken: String
          ) {
            listStudentExamResults(
              filter: {
                student_id: { eq: \$studentId }
                tenant_id: { eq: \$tenantId }
                date: { between: [\$start, \$end] }
              }
              nextToken: \$nextToken
            ) {
              items {
              id
              date
              tenant_id
              grades
              tscores
              evaluation{
                id
                name
                tenant_id
                lastDate
                higgerBetter
                types
                metric_names
              }
              createdAt
              updatedAt
            }
            nextToken
            }
          }
        ''',
          variables: {
            "studentId": studentId,
            "tenantId": tenantId,
            "start": start.toIso8601String().split("T").first,
            "end": end.toIso8601String().split("T").first,
            "nextToken": nextToken,
          },
        );

        final response = await Amplify.API.query(request: request).response;

        if (response.errors.isNotEmpty) {
          throw Exception(response.errors.first.message);
        }

        final data = jsonDecode(response.data!);
        final result = data['listStudentExamResults'];

        final items = result['items'] as List;
        allItems.addAll(
          items.map((e) => StudentExamResults.fromJson(e)),
        );

        nextToken = result['nextToken'];

      } while (nextToken != null);

      return allItems;
}

   Future<List<StudentExamResults>> getLastStudentExamResult(
      String tenantId,
      String studentId,
    ) async {
      const graphQLDocument = r'''
        query ListStudentExamResultsByStudent($studentId: ID!) {
          listStudentExamResults(
            filter: { student_id: { eq: $studentId } }
          ) {
            items {
              id
              date
              tenant_id
              grades
              tscores
              evaluation{
                id
                name
                tenant_id
                lastDate
                higgerBetter
                types
                metric_names
              }
              createdAt
              updatedAt
            }
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: graphQLDocument,
        variables: {
          "studentId": studentId,
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.errors.isNotEmpty) {
        throw Exception(response.errors.first.message);
      }

      final data = jsonDecode(response.data!);
      final items = data['listStudentExamResults']['items'] as List;

      // 🔥 filter + sort locally
      final filtered = items
          .where((e) => e['tenant_id'] == tenantId)
          .toList();

      filtered.sort((a, b) => b['date'].compareTo(a['date']));

      if (filtered.isEmpty) return [];

      return [StudentExamResults.fromJson(filtered.first)];
    }

  Future<List<StudentExamResults>> getAllStudentResults(String tenaniId, String studentId)async{
    final results = await Amplify.DataStore.query(
      StudentExamResults.classType,
      where: StudentExamResults.STUDENT.eq(studentId)
      .and(StudentExamResults.TENANT_ID.eq(tenaniId)),
      sortBy: [StudentExamResults.DATE.descending()],
      );
    return results;
  }

  Future<List<Product>> getProducts(String tenaniId)async{
      try {
        safePrint("Obteniendo productos para $tenaniId");
        final products = await Amplify.DataStore.query(
          Product.classType, 
          where: Product.TENANT_ID.eq(tenaniId));
        safePrint("Productos obtenidos correctamente: $products");
        return products;
      } catch (e) {
        rethrow;
      }
  }

  Future<Product?> productExists(String productCode, String tenaniId)async {
    safePrint("🔍 Buscando el producto: $productCode");
    try {
      final products = await Amplify.DataStore.query(
        Product.classType,
        where: Product.TENANT_ID.eq(tenaniId)
        .and(Product.CODE.eq(productCode))
        );
        return products.first;
    } catch (e) {
      safePrint('❌ Error checking product via GraphQL: $e');
      return null;
    }
  }

  Future<void> sellProduct(Product product, UserLocal user, String date)async{
    try {
        final aws = DataStoreService();
        final oldStock = product.stock;
        final newProduct = product.copyWith(stock: oldStock!-1);
        await Amplify.DataStore.save(newProduct);
        await aws.saveSale(tenaniId: user.tenant!.tenant_id, price: product.price!, product: product, date: date, profName: user.name);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<List<Sale>> fetchSales(String tenantId, String date)async{
    try {
      final sales = await Amplify.DataStore.query(
        Sale.classType,
        where: Sale.DATE.eq(date).and(Sale.TENANT_ID.eq(tenantId))
        );
      return sales;
      } catch (e) {
        rethrow;
      }
    } 
  
  Future<String> apiAssistant()async{
    final session = await Amplify.Auth.fetchAuthSession();
    if (session is CognitoAuthSession) {
      final tokensResult = session.userPoolTokensResult;
      final accessToken = tokensResult.value.accessToken.raw;
      
      final response = await http.post(
        Uri.parse("https://k424jq6fj1.execute-api.us-east-1.amazonaws.com/laDinamicaApp/generate"),
        headers: {
          'Content-Type':'application/json',
          'Authorization':'Bearer $accessToken'
        },
        body: jsonEncode("datos de prueba"),
      );
      safePrint(response.statusCode);
      safePrint(response.body);
      return "Datos obtenidos correctamente"; 
      }else{
        return "Fallo al obtener datos";
      }
    }

  Future<String> generateRutineByGroup(String description)async{
    final session = await Amplify.Auth.fetchAuthSession();
    if (session is CognitoAuthSession) {
      final tokensResult = session.userPoolTokensResult;
      final accessToken = tokensResult.value.accessToken.raw;
      
      final response = await http.post(
        Uri.parse("https://k424jq6fj1.execute-api.us-east-1.amazonaws.com/laDinamicaApp/generateByGroup"),
        headers: {
          'Content-Type':'application/json',
          'Authorization':'Bearer $accessToken'
        },
        body: jsonEncode({"prompt":description}),
      );
      safePrint(response.statusCode);
      return response.body; 
      }else{
        return "Fallo al obtener datos";
      }
  }

  Future<List<JoinGroups>> getJoinGroups(String tenantId)async{
    try {
      final joinGroups = await Amplify.DataStore.query(
        JoinGroups.classType, 
        where: JoinGroups.TENANT_ID.eq(tenantId)
        );
      safePrint("Grupos obtenidos correctamente $joinGroups");
      return joinGroups;
    } catch (e) {
      return [];
    }
  }

}