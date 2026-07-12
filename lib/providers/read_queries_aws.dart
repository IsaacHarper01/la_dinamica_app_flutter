import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';

class DataStoreReadService {
  Future<List<T>> _queryGraphQLList<T>({
    required String operationName,
    required String document,
    required Map<String, dynamic> variables,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final request = GraphQLRequest<String>(
        document: document,
        variables: variables,
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.errors.isNotEmpty) {
        throw Exception('GraphQL errors: ${response.errors}');
      }

      if (response.data == null) {
        return <T>[];
      }

      final decoded = jsonDecode(response.data!) as Map<String, dynamic>;
      final items = decoded[operationName]?['items'] as List<dynamic>? ?? <dynamic>[];

      return items
          .map((item) => fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (e) {
      safePrint('❌ La consulta GraphQL falló para $operationName: $e');
      rethrow;
    }
  }


  Future<List<LocalPlan>> getPlans(String tenantId) async {//tested and works
    const document = '''
      query ListLocalPlans(
        \$filter: ModelLocalPlanFilterInput
      ) {
        listLocalPlans(filter: \$filter) {
          items {
            id
            type
            clases
            price
            client_id
            defaultPlan
            expiration
            createdAt
            updatedAt
          }
        }
      }
    ''';

    return _queryGraphQLList<LocalPlan>(
      operationName: 'listLocalPlans',
      document: document,
      variables: {
        'filter': {'client_id': {'eq': tenantId}},
      },
      fromJson: LocalPlan.fromJson,
    );
  }

  Future<List<LocalPlan>> getallPlans() async { //tested and works
    const document = '''
      query ListLocalPlans {
        listLocalPlans {
          items {
            id
            type
            clases
            price
            client_id
            defaultPlan
            expiration
            createdAt
            updatedAt
          }
        }
      }
    ''';

    return _queryGraphQLList<LocalPlan>(
      operationName: 'listLocalPlans',
      document: document,
      variables: const {},
      fromJson: LocalPlan.fromJson,
    );
  }

  Future<List<Payment>> getPaymentsRange(
    DateTime startDate,
    DateTime endDate,
    String tenantId,
  ) async {
    const document = '''
      query ListPayments(
        \$filter: ModelPaymentFilterInput
      ) {
        listPayments(filter: \$filter) {
          items {
            id
            plan_id
            composite_key
            user_id
            amount
            clases
            date
            client_id
            prof_id
            debt
            createdAt
            updatedAt
          }
        }
      }
    ''';

    final payments = await _queryGraphQLList<Payment>(
      operationName: 'listPayments',
      document: document,
      variables: {
        'filter': {
          'client_id': {'eq': tenantId},
          'date': {
            'between': [
              startDate.toIso8601String().split('T').first,
              endDate.toIso8601String().split('T').first,
            ],
          },
        },
      },
      fromJson: Payment.fromJson,
    );

    payments.sort((a, b) => (a.date ?? TemporalDate(DateTime(1970))).format().compareTo((b.date ?? TemporalDate(DateTime(1970))).format()));
    return payments;
  }

  Future<List<Payment>> getTodayPayments(String tenantId, String date) async {
    const document = '''
      query ListPayments(
        \$filter: ModelPaymentFilterInput
      ) {
        listPayments(filter: \$filter) {
          items {
            id
            plan_id
            composite_key
            user_id
            amount
            clases
            date
            client_id
            prof_id
            debt
            createdAt
            updatedAt
          }
        }
      }
    ''';

    return _queryGraphQLList<Payment>(
      operationName: 'listPayments',
      document: document,
      variables: {
        'filter': {
          'client_id': {'eq': tenantId},
          'date': {'eq': date},
        },
      },
      fromJson: Payment.fromJson,
    );
  }

  Future<List<Sale>> getSalesPerRange(DateTime startDate, DateTime endDate, String tenantId) async {
    const document = '''
      query ListSales(
        \$filter: ModelSaleFilterInput
      ) {
        listSales(filter: \$filter) {
          items {
            id
            product_id
            tenant_id
            price
            date
            profname
            createdAt
            updatedAt
          }
        }
      }
    ''';

    return _queryGraphQLList<Sale>(
      operationName: 'listSales',
      document: document,
      variables: {
        'filter': {
          'tenant_id': {'eq': tenantId},
          'date': {
            'between': [
              startDate.toIso8601String().split('T').first,
              endDate.toIso8601String().split('T').first,
            ],
          },
        },
      },
      fromJson: Sale.fromJson,
    );
  }

  Future<Map<String, dynamic>> getLastPayandStudentData(int userId, String tenantId) async {
    dynamic studentData;
    dynamic lastPay;
    dynamic debts;

    try {
      final students = await _queryGraphQLList<Student>(
        operationName: 'listStudents',
        document: '''
          query ListStudents(
            \$filter: ModelStudentFilterInput
          ) {
            listStudents(filter: \$filter) {
              items {
                id
                user_id
                name
                address
                age
                phone
                birthday
                email
                image
                client_id
                hasDebt
                remainClasses
                expirationPlan
              }
            }
          }
        ''',
        variables: {
          'filter': {
            'user_id': {'eq': userId},
            'client_id': {'eq': tenantId},
          },
        },
        fromJson: Student.fromJson,
      );
      studentData = students.isNotEmpty ? students.first : null;
    } catch (e) {
      safePrint('❌ Error al obtener los datos del usuario: $e');
    }

    try {
      final payments = await _queryGraphQLList<Payment>(
        operationName: 'listPayments',
        document: '''
          query ListPayments(
            \$filter: ModelPaymentFilterInput
          ) {
            listPayments(filter: \$filter) {
              items {
                id
                plan_id
                user_id
                amount
                clases
                date
                client_id
                prof_id
                debt
              }
            }
          }
        ''',
        variables: {
          'filter': {
            'user_id': {'eq': userId},
            'client_id': {'eq': tenantId},
            'clases': {'gt': 0},
          },
        },
        fromJson: Payment.fromJson,
      );
      lastPay = payments.isNotEmpty
          ? payments.reduce((a, b) =>
              (a.date?.format() ?? '').compareTo(b.date?.format() ?? '') >= 0 ? a : b)
          : null;
    } catch (e) {
      safePrint('❌ Error al obtener el ultimo pago del usuario: $e');
    }

    try {
      debts = await _queryGraphQLList<Payment>(
        operationName: 'listPayments',
        document: '''
          query ListPayments(
            \$filter: ModelPaymentFilterInput
          ) {
            listPayments(filter: \$filter) {
              items {
                id
                plan_id
                user_id
                amount
                clases
                date
                client_id
                prof_id
                debt
              }
            }
          }
        ''',
        variables: {
          'filter': {
            'user_id': {'eq': userId},
            'client_id': {'eq': tenantId},
            'debt': {'eq': true},
          },
        },
        fromJson: Payment.fromJson,
      );
    } catch (e) {
      safePrint('❌ Error al obtener el ultimo pago del usuario: $e');
    }

    return {
      'lastPay': lastPay,
      'studentData': studentData,
      'debts': debts,
    };
  }
  
  Future<List<Student>> getStudents(String tenantId) async {//tested and works
    final List<Student> students = <Student>[];
    String? nextToken;

    do {
      final request = GraphQLRequest<String>(
        document: '''
          query ListStudents(
            \$filter: ModelStudentFilterInput,
            \$nextToken: String,
            \$limit: Int
          ) {
            listStudents(
              filter: \$filter,
              nextToken: \$nextToken,
              limit: \$limit
            ) {
              items {
                id
                user_id
                name
                address
                age
                phone
                birthday
                email
                image
                client_id
                hasDebt
                remainClasses
                expirationPlan
                createdAt
                updatedAt
              }
              nextToken
            }
          }
        ''',
        variables: {
          'filter': {'client_id': {'eq': tenantId}},
          'nextToken': nextToken,
          'limit': 1000,
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.errors.isNotEmpty) {
        throw Exception('Errores de GraphQL: ${response.errors}');
      }

      if (response.data == null) {
        break;
      }

      final data = jsonDecode(response.data!) as Map<String, dynamic>;
      final result = data['listStudents'] as Map<String, dynamic>? ?? <String, dynamic>{};
      final items = result['items'] as List<dynamic>? ?? <dynamic>[];

      students.addAll(
        items
            .map((item) => Student.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
      );

      nextToken = result['nextToken'] as String?;
    } while (nextToken != null && nextToken.isNotEmpty);

    students.sort((a, b) => (a.user_id ?? 0).compareTo(b.user_id ?? 0));
    return students;
  }

  Future<List<Student>> getAllStudents() async {
    const document = '''
      query ListStudents {
        listStudents {
          items {
            id
            user_id
            name
            address
            age
            phone
            birthday
            email
            image
            client_id
            hasDebt
            remainClasses
            expirationPlan
            createdAt
            updatedAt
          }
        }
      }
    ''';

    return _queryGraphQLList<Student>(
      operationName: 'listStudents',
      document: document,
      variables: const {},
      fromJson: Student.fromJson,
    );
  }

  Future<Student?> checkIfStudentExists(int id, String tenantId) async {//tested and works
    final students = await _queryGraphQLList<Student>(
      operationName: 'listStudents',
      document: '''
        query ListStudents(
          \$filter: ModelStudentFilterInput
        ) {
          listStudents(filter: \$filter) {
            items {
              id
              user_id
              name
              address
              age
              phone
              birthday
              email
              image
              client_id
              hasDebt
              remainClasses
              expirationPlan
            }
          }
        }
      ''',
      variables: {
        'filter': {
          'user_id': {'eq': id},
          'client_id': {'eq': tenantId},
        },
      },
      fromJson: Student.fromJson,
    );

    if (students.isNotEmpty) {
      safePrint('✅ El alumno con ID $id existe');
      return students.first;
    }
    safePrint('❌ El alumno con ID $id no existe');
    return null;
  }

  Future<List<List<String>>> getAgesandAddress(List<int> ids, String tenantId) async {
    try {
      final students = await _queryGraphQLList<Student>(
        operationName: 'listStudents',
        document: '''
          query ListStudents(
            \$filter: ModelStudentFilterInput
          ) {
            listStudents(filter: \$filter) {
              items {
                id
                user_id
                age
                address
              }
            }
          }
        ''',
        variables: {
          'filter': {
            'client_id': {'eq': tenantId},
            'or': ids.map((id) => {'user_id': {'eq': id}}).toList(),
          },
        },
        fromJson: Student.fromJson,
      );
      final general = students.where((student) => ids.contains(student.user_id)).toList();
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
    const document = '''
      query ListAttendances(
        \$filter: ModelAttendanceFilterInput
      ) {
        listAttendances(filter: \$filter) {
          items {
            id
            studentID
            date
            client_id
            prof_id
            status
          }
        }
      }
    ''';

    return _queryGraphQLList<Attendance>(
      operationName: 'listAttendances',
      document: document,
      variables: {
        'filter': {
          'date': {'eq': date},
          'client_id': {'eq': tenantId},
          'status': {'eq': true},
        },
      },
      fromJson: Attendance.fromJson,
    );
  }

  Future<List<Attendance>> getAttendanceRange(
    DateTime startDate,
    DateTime endDate,
    String tenantId,
  ) async {
    const document = '''
      query ListAttendances(
        \$filter: ModelAttendanceFilterInput
      ) {
        listAttendances(filter: \$filter) {
          items {
            id
            studentID
            date
            client_id
            prof_id
            status
          }
        }
      }
    ''';

    return _queryGraphQLList<Attendance>(
      operationName: 'listAttendances',
      document: document,
      variables: {
        'filter': {
          'date': {
            'between': [
              startDate.toIso8601String().split('T').first,
              endDate.toIso8601String().split('T').first,
            ],
          },
          'client_id': {'eq': tenantId},
          'status': {'eq': true},
        },
      },
      fromJson: Attendance.fromJson,
    );
  }

  Future<List<Expense>> getExpensesRange(Tenant tenant, DateTime start, DateTime end) async {
    const document = '''
      query ListExpenses(
        \$filter: ModelExpenseFilterInput
      ) {
        listExpenses(filter: \$filter) {
          items {
            id
            tenant_id
            name
            amount
            date
            description
          }
        }
      }
    ''';

    return _queryGraphQLList<Expense>(
      operationName: 'listExpenses',
      document: document,
      variables: {
        'filter': {
          'tenant_id': {'eq': tenant.tenant_id},
          'date': {
            'between': [
              start.toIso8601String().split('T').first,
              end.toIso8601String().split('T').first,
            ],
          },
        },
      },
      fromJson: Expense.fromJson,
    );
  }

  Future<List<Expense>> getTodayExpenses(String tenantId, String date) async {
    const document = '''
      query ListExpenses(
        \$filter: ModelExpenseFilterInput
      ) {
        listExpenses(filter: \$filter) {
          items {
            id
            tenant_id
            name
            amount
            date
            description
          }
        }
      }
    ''';

    return _queryGraphQLList<Expense>(
      operationName: 'listExpenses',
      document: document,
      variables: {
        'filter': {
          'tenant_id': {'eq': tenantId},
          'date': {'eq': date},
        },
      },
      fromJson: Expense.fromJson,
    );
  }

  Future<List<Payment>?> getLastTenPayments(int userId, String tenaniId) async {
    const document = '''
      query ListPayments(
        \$filter: ModelPaymentFilterInput
      ) {
        listPayments(filter: \$filter) {
          items {
            id
            plan_id
            user_id
            amount
            clases
            date
            client_id
            prof_id
            debt
          }
        }
      }
    ''';

    try {
      final payments = await _queryGraphQLList<Payment>(
        operationName: 'listPayments',
        document: document,
        variables: {
          'filter': {
            'user_id': {'eq': userId},
            'client_id': {'eq': tenaniId},
          },
        },
        fromJson: Payment.fromJson,
      );
      payments.sort((a, b) => (b.date ?? TemporalDate(DateTime(1970))).format().compareTo((a.date ?? TemporalDate(DateTime(1970))).format()));
      return payments.take(10).toList();
    } catch (e) {
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
        final aWSService = DataStoreService(); 
        await aWSService.savePayment(
          userId: student.user_id!, 
          amount: defaultPlan.price!, 
          clases: defaultPlan.clases!, 
          plan: defaultPlan, 
          date: date, 
          dbId: tenantId, 
          profId: profId);
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
        safePrint('❌ Errores de GraphQL: ${response.errors}');
        return false;
      }

      final data = response.data;
      if (data == null) return false;

      final decoded = jsonDecode(data);
      final items = decoded['listUsers']['items'] as List<dynamic>;

      return items.isNotEmpty;
    } catch (e) {
      safePrint('❌ Error al verificar el usuario mediante GraphQL: $e');
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
        safePrint('❌ Errores de GraphQL: ${response.errors}');
        return null;
      }

      if (response.data == null) {
        safePrint('⚠️ No se encontró ningún usuario con ID: $userId');
        return null;
      }

      final data = jsonDecode(response.data!);
      final userJson = data['getUser'];

      if (userJson == null) {
        safePrint('⚠️ No se encontró ningún usuario con ID: $userId');
        return null;
      }

      // Convert JSON back into your Amplify-generated User model
      final user = User.fromJson(Map<String, dynamic>.from(userJson));

      return user;
    } catch (e) {
      safePrint('❌ Error al obtener el usuario: $e');
      rethrow;
    }
  }

  Future<List<UserAccess>> userHasAccess(User user, Tenant tenant) async {
    const document = '''
      query ListUserAccesses(
        \$filter: ModelUserAccessFilterInput
      ) {
        listUserAccesses(filter: \$filter) {
          items {
            id
            user_id
            tenant_id
            permissions
            status
            isAdmin
          }
        }
      }
    ''';

    return _queryGraphQLList<UserAccess>(
      operationName: 'listUserAccesses',
      document: document,
      variables: {
        'filter': {
          'user_id': {'eq': user.user_id},
          'tenant_id': {'eq': tenant.tenant_id},
        },
      },
      fromJson: UserAccess.fromJson,
    );
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
      safePrint('❌ Error al otorgar acceso al usuario: $e');
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
      safePrint('❌ Errores de GraphQL: ${response.errors}');
      return null;
    }

    final data = jsonDecode(response.data!) as Map<String, dynamic>;
    final items = data['listUserAccesses']?['items'] as List?;
    
    if (items == null || items.isEmpty) {
      safePrint('⚠️ No se encontró acceso para el usuario con ID: $userId');
      return null;
    }

    // Convert each map to a UserAccess model using fromJson
    final userAccessList = items
        .map((item) => UserAccess.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    return userAccessList;
  } catch (e) {
    safePrint('❌ Error al obtener el acceso del usuario: $e');
    return null;
  }
}

  Future<List<UserAccess>> getUserPermisions(String tenaniId) async {
    const document = '''
      query ListUserAccesses(
        \$filter: ModelUserAccessFilterInput
      ) {
        listUserAccesses(filter: \$filter) {
          items {
            id
            user_id
            tenant_id
            permissions
            status
            isAdmin
          }
        }
      }
    ''';

    return _queryGraphQLList<UserAccess>(
      operationName: 'listUserAccesses',
      document: document,
      variables: {
        'filter': {
          'tenant_id': {'eq': tenaniId},
        },
      },
      fromJson: UserAccess.fromJson,
    );
  }

  Future<List<Evaluations>?> getEvaluations(String tenantId) async {//tested and works
    try {
      final evaluations = await _queryGraphQLList<Evaluations>(
        operationName: 'listEvaluations',
        document: '''
          query ListEvaluations(
            \$filter: ModelEvaluationsFilterInput
          ) {
            listEvaluations(filter: \$filter) {
              items {
                id
                name
                tenant_id
                lastDate
                higgerBetter
                types
                metric_names
              }
            }
          }
        ''',
        variables: {
          'filter': {'tenant_id': {'eq': tenantId}},
        },
        fromJson: Evaluations.fromJson,
      );
      safePrint('✅ Evaluaciones obtenidas correctamente');
      return evaluations;
    } catch (e) {
      safePrint('❌ Error al obtener las evaluaciones: $e');
      rethrow;
    }
  }
   
  Future<List<JoinMetric>?> getJoinMetrics(String tenantId, Evaluations exam) async {//tested and works
    try {
      final joinMetrics = await _queryGraphQLList<JoinMetric>(
        operationName: 'listJoinMetrics',
        document: '''
          query ListJoinMetrics(
            \$filter: ModelJoinMetricFilterInput
          ) {
            listJoinMetrics(filter: \$filter) {
              items {
                id
                metric_id
                evaluation_id
                tenant_id
                metric {
                  id
                  name
                  tenant_id
                  description
                  type
                  higgerBetter
                }
                evaluation {
                  id
                  name
                  tenant_id
                  lastDate
                  higgerBetter
                  types
                  metric_names
                }
              }
            }
          }
        ''',
        variables: {
          'filter': {
            'tenant_id': {'eq': tenantId},
            'evaluation_id': {'eq': exam.id},
          },
        },
        fromJson: JoinMetric.fromJson,
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

  Future<List<StudentExamResults>> getAllStudentResults(String tenaniId, String studentId) async {
    const document = '''
      query ListStudentExamResults(
        \$filter: ModelStudentExamResultsFilterInput
      ) {
        listStudentExamResults(filter: \$filter) {
          items {
            id
            date
            tenant_id
            grades
            tscores
            evaluation_id
            student_id
          }
        }
      }
    ''';

    final results = await _queryGraphQLList<StudentExamResults>(
      operationName: 'listStudentExamResults',
      document: document,
      variables: {
        'filter': {
          'student_id': {'eq': studentId},
          'tenant_id': {'eq': tenaniId},
        },
      },
      fromJson: StudentExamResults.fromJson,
    );

    results.sort((a, b) => (b.date ?? TemporalDate(DateTime(1970))).format().compareTo((a.date ?? TemporalDate(DateTime(1970))).format()));
    return results;
  }

  Future<List<Product>> getProducts(String tenaniId) async {//tested and works
    const document = '''
      query ListProducts(
        \$filter: ModelProductFilterInput
      ) {
        listProducts(filter: \$filter) {
          items {
            id
            code
            name
            tenant_id
            price
            image
            stock
            category
          }
        }
      }
    ''';

    return _queryGraphQLList<Product>(
      operationName: 'listProducts',
      document: document,
      variables: {
        'filter': {'tenant_id': {'eq': tenaniId}},
      },
      fromJson: Product.fromJson,
    );
  }

  Future<Product?> productExists(String productCode, String tenaniId) async {
    safePrint("🔍 Buscando el producto: $productCode");
    try {
      final products = await _queryGraphQLList<Product>(
        operationName: 'listProducts',
        document: '''
          query ListProducts(
            \$filter: ModelProductFilterInput
          ) {
            listProducts(filter: \$filter) {
              items {
                id
                code
                name
                tenant_id
                price
                image
                stock
                category
              }
            }
          }
        ''',
        variables: {
          'filter': {
            'tenant_id': {'eq': tenaniId},
            'code': {'eq': productCode},
          },
        },
        fromJson: Product.fromJson,
      );
      return products.isNotEmpty ? products.first : null;
    } catch (e) {
      safePrint('❌ Error al verificar el producto mediante GraphQL: $e');
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
  
  Future<List<Sale>> fetchSales(String tenantId, String date) async {
    const document = '''
      query ListSales(
        \$filter: ModelSaleFilterInput
      ) {
        listSales(filter: \$filter) {
          items {
            id
            product_id
            tenant_id
            price
            date
            profname
          }
        }
      }
    ''';

    return _queryGraphQLList<Sale>(
      operationName: 'listSales',
      document: document,
      variables: {
        'filter': {
          'tenant_id': {'eq': tenantId},
          'date': {'eq': date},
        },
      },
      fromJson: Sale.fromJson,
    );
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

  Future<List<JoinGroups>> getJoinGroups(String tenantId) async {
    const document = '''
      query ListJoinGroups(
        \$filter: ModelJoinGroupsFilterInput
      ) {
        listJoinGroups(filter: \$filter) {
          items {
            id
            student_id
            group_id
            tenant_id
          }
        }
      }
    ''';

    return _queryGraphQLList<JoinGroups>(
      operationName: 'listJoinGroups',
      document: document,
      variables: {
        'filter': {'tenant_id': {'eq': tenantId}},
      },
      fromJson: JoinGroups.fromJson,
    );
  }

}