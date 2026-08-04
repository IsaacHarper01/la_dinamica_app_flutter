import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

import 'graphql_service.dart';

class GraphqlServiceCreate {

  Future<void> savePlan({//tested and works
    required String type,
    required int clases,
    required double price,
    required String gymId,
  }) async {
    try {
      await GraphQLService.mutate(
        document: '''
          mutation CreateLocalPlan(\$input: CreateLocalPlanInput!) {
            createLocalPlan(input: \$input) {
              id
            }
          }
        ''',
        variables: {
          'input': {
            'type': type,
            'clases': clases,
            'price': price,
            'client_id': gymId,
            'defaultPlan': false,
            'expiration': 0,
          },
        },
      );
      safePrint('✅ Plan guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar el plan: $e');
      rethrow;
    }
  }
  
  Future<void> savePayment({//tested and works
    required int userId,
    required double amount,
    required int clases,
    required LocalPlan plan,
    required String date,
    required String? dbId,
    required String? profId,
  }) async {
    final newUUID = dbId! + date + plan.id + userId.toString();

    try {
      await GraphQLService.mutate(
        document: '''
          mutation CreatePayment(\$input: CreatePaymentInput!) {
            createPayment(input: \$input) {
              id
            }
          }
        ''',
        variables: {
          'input': {
            'id': newUUID,
            'plan_id': plan.id,
            'user_id': userId,
            'amount': amount,
            'clases': clases,
            'date': date,
            'client_id': dbId,
            'prof_id': profId,
            'debt': false,
          },
        },
      );
      safePrint('✅ Pago guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar el Pago: $e');
      rethrow;
    }
  }

  Future<int> saveStudent({//tested and works
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
      const listStudents = '''
        query ListStudents(\$filter: ModelStudentFilterInput, \$limit: Int) {
          listStudents(filter: \$filter, limit: \$limit) {
            items {
              user_id
            }
          }
        }
      ''';

      final items = await GraphQLService.queryList(
        document: listStudents,
        variables: {
          'filter': {
            'client_id': {'eq': gymId},
          },
          'limit': 1000,
        },
        key: 'listStudents',
      );
      final lastNumId = items
          .map<int>((item) => (item['user_id'] as num? ?? 0).toInt())
          .fold<int>(0, (max, value) => value > max ? value : max);

      final newUUID = name.toLowerCase().replaceAll(" ", "")+birthday+gymId;
      final item = Student(
        id: newUUID,
        user_id: lastNumId + 1,
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

      await GraphQLService.mutate(
        document: '''
          mutation CreateStudent(\$input: CreateStudentInput!) {
            createStudent(input: \$input) {
              id
            }
          }
        ''',
        variables: {
          'input': {
            'id': newUUID,
            'user_id': lastNumId + 1,
            'name': name,
            'address': address,
            'phone': phone,
            'age': age,
            'birthday': birthday,
            'email': email,
            'image': image,
            'client_id': gymId,
            'hasDebt': false,
            'remainClasses': remainClases ?? 0,
            'expirationPlan': expirationDate?.format(),
          },
        },
      );
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
    required Student student,
    required String date,
    required String gymId,
    required String profId,
    required bool status
  }) async {
    final newUUID = student.id+date;

    try {
      await GraphQLService.mutate(
        document: '''
          mutation CreateAttendance(\$input: CreateAttendanceInput!) {
            createAttendance(input: \$input) {
              id
            }
          }
        ''',
        variables: {
          'input': {
            'id': newUUID,
            'studentID': student.id,
            'date': date,
            'client_id': gymId,
            'prof_id': profId,
            'status': status,
          },
        },
      );
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
      await GraphQLService.mutate(
        document: '''
          mutation CreateUser(\$input: CreateUserInput!) {
            createUser(input: \$input) {
              user_id
            }
          }
        ''',
        variables: {
          'input': {
            'user_id': id,
            'name': name,
          },
        },
      );
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
      await GraphQLService.mutate(
        document: '''
          mutation CreateUserAccess(\$input: CreateUserAccessInput!) {
            createUserAccess(input: \$input) {
              id
            }
          }
        ''',
        variables: {
          'input': {
            'user_id': user.user_id,
            'tenant_id': tenant.tenant_id,
            'permissions': jsonEncode(permissions),
            'status': status,
            'isAdmin': isAdmin,
          },
        },
      );
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
      await GraphQLService.mutate(
        document: '''
          mutation CreateTenant(\$input: CreateTenantInput!) {
            createTenant(input: \$input) {
              tenant_id
            }
          }
        ''',
        variables: {
          'input': {
            'tenant_id': tenantId,
            'name': name,
            'plan': plan,
            'status': status,
          },
        },
      );
      safePrint('✅ Gimnasio guardado correctamente');
      return item;
    } catch (e) {
      safePrint('❌ Error al guardar el gimnasio: $e');
      rethrow;
    }
  }

  Future<Evaluations> saveEvaluation({//tested and works
  required String name,
  required String gymId,
    }) async {
      final evaluation = Evaluations(
        name: name,
        tenant_id: gymId,
      );

      await GraphQLService.mutate(
        document: '''
          mutation CreateEvaluations(\$input: CreateEvaluationsInput!) {
            createEvaluations(input: \$input) {
              id
            }
          }
        ''',
        variables: {
          'input': {
            'name': name,
            'tenant_id': gymId,
          },
        },
      );
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
    await GraphQLService.mutate(
      document: '''
        mutation CreateStudentExamResults(\$input: CreateStudentExamResultsInput!) {
          createStudentExamResults(input: \$input) {
            id
          }
        }
      ''',
      variables: {
        'input': {
          'tenant_id': tenantId,
          'student_id': student.id,
          'evaluation_id': eval.id,
          'grades': grades,
          'date': date.toIso8601String().split('T').first,
        },
      },
    );
    return newGrade;
  }

  Future<Metric> saveMetric({//tested and works
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

  await GraphQLService.mutate(
    document: '''
      mutation CreateMetric(\$input: CreateMetricInput!) {
        createMetric(input: \$input) {
          id
        }
      }
    ''',
    variables: {
      'input': {
        'name': name,
        'tenant_id': tenantId,
        'description': description,
        'type': type,
        'higgerBetter': higgerBetter,
      },
    },
  );
  safePrint('✅ Metric saved: ${metric.id}, ${metric.name}');
  return metric;
}

  Future<JoinMetric> saveJoinedMetric({//tested and works
  required Metric metric,
  required Evaluations evaluation,
  required String tenantId,
}) async {
  final joinMetric = JoinMetric(
    metric: metric,          // Pass the object
    evaluation: evaluation,  // Pass the object
    tenant_id: tenantId,
  );

  await GraphQLService.mutate(
    document: '''
      mutation CreateJoinMetric(\$input: CreateJoinMetricInput!) {
        createJoinMetric(input: \$input) {
          id
        }
      }
    ''',
    variables: {
      'input': {
        'metric_id': metric.id,
        'evaluation_id': evaluation.id,
        'tenant_id': tenantId,
      },
    },
  );
  safePrint('✅ JoinMetric saved: ${joinMetric.id}');
  return joinMetric;
}

  Future<void> markDebtStatus({//tested and NO working
    required Payment pay,
    required bool status,
    })async{
      await GraphQLService.mutate(
        document: '''
          mutation UpdatePayment(\$input: UpdatePaymentInput!) {
            updatePayment(input: \$input) {
              id
            }
          }
        ''',
        variables: {
          'input': {
            'id': pay.id,
            'debt': status,
          },
        },
      );
    }

  Future<void> saveProduct({//tested and works
    required String code,
    required String name,
    required String tenaniId,
    required double price,
    required String image,
    required int stock,
    required String category,
  })async{
      await GraphQLService.mutate(
        document: '''
          mutation CreateProduct(\$input: CreateProductInput!) {
            createProduct(input: \$input) {
              id
            }
          }
        ''',
        variables: {
          'input': {
            'name': name,
            'code': code,
            'tenant_id': tenaniId,
            'price': price,
            'image': image,
            'stock': stock,
            'category': category,
          },
        },
      );
  }

  Future<void> saveSale({//tested and works
    required String tenaniId,
    required double price,
    required Product product,
    required String date,
    required String profName,
  })async{
      await GraphQLService.mutate(
        document: '''
          mutation CreateSale(\$input: CreateSaleInput!) {
            createSale(input: \$input) {
              id
            }
          }
        ''',
        variables: {
          'input': {
            'tenant_id': tenaniId,
            'price': price,
            'product_id': product.id,
            'date': date,
            'profname': profName,
          },
        },
      );
  }

  Future<Groups> saveGroup({//tested and works
    required String name,
    required String tenantId,
    required String description,
  })async{
    final newGroup = Groups(
      name: name,
      tenant_id: tenantId,
      description: description
    );
    await GraphQLService.mutate(
      document: '''
        mutation CreateGroups(\$input: CreateGroupsInput!) {
          createGroups(input: \$input) {
            id
          }
        }
      ''',
      variables: {
        'input': {
          'name': name,
          'tenant_id': tenantId,
          'description': description,
        },
      },
    );
    return newGroup;
  }

  Future<void> saveJoinGroup({//tested and works
    required Student student,
    required Groups group,
    required String tenantId
  })async{
    await GraphQLService.mutate(
      document: '''
        mutation CreateJoinGroups(\$input: CreateJoinGroupsInput!) {
          createJoinGroups(input: \$input) {
            id
          }
        }
      ''',
      variables: {
        'input': {
          'tenant_id': tenantId,
          'student_id': student.id,
          'group_id': group.id,
        },
      },
    );
  }

  Future<void> saveExpense({//tested and works
    required Tenant tenant,
    required DateTime date,
    required String name,
    required double amount,
    required String? description,
  })async{
    await GraphQLService.mutate(
      document: '''
        mutation CreateExpense(\$input: CreateExpenseInput!) {
          createExpense(input: \$input) {
            id
          }
        }
      ''',
      variables: {
        'input': {
          'tenant_id': tenant.tenant_id,
          'name': name,
          'amount': amount,
          'description': description,
          'date': date.toIso8601String().split('T').first,
        },
      },
    );
  }

}
