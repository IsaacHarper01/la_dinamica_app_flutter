import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class DataStoreDeleteService {
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

  Future<void> _mutateGraphQL({
    required String document,
    required Map<String, dynamic> variables,
  }) async {
    try {
      final request = GraphQLRequest<String>(
        document: document,
        variables: variables,
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.errors.isNotEmpty) {
        throw Exception('GraphQL errors: ${response.errors}');
      }

      if (response.data == null) {
        throw Exception('GraphQL mutation returned no data');
      }
    } catch (e) {
      safePrint('❌ La mutación GraphQL falló: $e');
      rethrow;
    }
  }

  // Método para eliminar un plan por ID
  Future<void> deletePlanById(String planId, String tenantID) async {
    try {
      final plans = await _queryGraphQLList<LocalPlan>(
        operationName: 'listLocalPlans',
        document: '''
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
        ''',
        variables: {
          'filter': {
            'id': {'eq': planId},
            'client_id': {'eq': tenantID},
          },
        },
        fromJson: LocalPlan.fromJson,
      );

      if (plans.isNotEmpty) {
        final planToDelete = plans.first;
        await _mutateGraphQL(
          document: '''
            mutation DeleteLocalPlan(
              \$input: DeleteLocalPlanInput!
            ) {
              deleteLocalPlan(input: \$input) {
                id
              }
            }
          ''',
          variables: {
            'input': {'id': planToDelete.id},
          },
        );
        safePrint('✅ Plan eliminado correctamente');
      } else {
        safePrint('❌ No se encontró el plan con el ID proporcionado');
      }
    } catch (e) {
      safePrint('❌ Error al eliminar el plan: $e');
      rethrow;
    }
  }

  Future<void> deleteStudent(Student student) async {
      try {
          await _mutateGraphQL(
            document: '''
              mutation DeleteStudent(
                \$input: DeleteStudentInput!
              ) {
                deleteStudent(input: \$input) {
                  id
                }
              }
            ''',
            variables: {
              'input': {'id': student.id},
            },
          );
          safePrint('✅ Alumno eliminado correctamente');
        
      } catch (e) {
        safePrint('❌ Error al eliminar Alumno: $e');
        rethrow;
      }
    }

  Future<void> deleteAttendance(Attendance attendance) async {
      try {
        final student = attendance.student!;
        final tenantId = attendance.client_id;
        final date = attendance.date;
        await _mutateGraphQL(
          document: '''
            mutation UpdateAttendance(
              \$input: UpdateAttendanceInput!
            ) {
              updateAttendance(input: \$input) {
                id
                status
              }
            }
          ''',
          variables: {
            'input': {
              'id': attendance.id,
              'status': false,
            },
          },
        );
        safePrint("Asistencia eliminada correctamente"); 
        final payments = await _queryGraphQLList<Payment>(
          operationName: 'listPayments',
          document: '''
            query ListPayments(
              \$filter: ModelPaymentFilterInput
            ) {
              listPayments(filter: \$filter) {
                items {
                  id
                  composite_key
                  user_id
                  amount
                  clases
                  date
                  client_id
                  prof_id
                  debt
                  plan {
                    id
                    type
                    clases
                    price
                    client_id
                    defaultPlan
                    expiration
                  }
                  createdAt
                  updatedAt
                }
              }
            }
          ''',
          variables: {
            'filter': {
              'user_id': {'eq': student.user_id},
              'client_id': {'eq': tenantId},
              'date': {'eq': date.format()},
            },
          },
          fromJson: Payment.fromJson,
        );

        final sortedPayments = payments.toList()
          ..sort((a, b) {
            final aDate = a.date;
            final bDate = b.date;
            if (aDate == null && bDate == null) return 0;
            if (aDate == null) return 1;
            if (bDate == null) return -1;
            return bDate.compareTo(aDate);
          });

        Payment? lastPayment = sortedPayments.isNotEmpty ? sortedPayments.last : null;

        if (lastPayment != null) {
          final planType = lastPayment.plan?.type;
          if (planType != null) {
            final plan = await _queryGraphQLList<LocalPlan>(
              operationName: 'listLocalPlans',
              document: '''
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
              ''',
              variables: {
                'filter': {
                  'type': {'eq': planType},
                },
              },
              fromJson: LocalPlan.fromJson,
            );

            if (plan.isNotEmpty && plan.first.clases! > lastPayment.clases! && lastPayment.date?.format() != date.format()) {
              await _mutateGraphQL(
                document: '''
                  mutation UpdatePayment(
                    \$input: UpdatePaymentInput!
                  ) {
                    updatePayment(input: \$input) {
                      id
                      clases
                    }
                  }
                ''',
                variables: {
                  'input': {
                    'id': lastPayment.id,
                    'clases': lastPayment.clases! + 1,
                  },
                },
              );
            } else {
              await _mutateGraphQL(
                document: '''
                  mutation DeletePayment(
                    \$input: DeletePaymentInput!
                  ) {
                    deletePayment(input: \$input) {
                      id
                    }
                  }
                ''',
                variables: {
                  'input': {'id': lastPayment.id},
                },
              );
            }
          }
        }
        
      } catch (e) {
        safePrint('❌ Error al eliminar la Asistencia: $e');
        rethrow;
      }
    }

  Future<void> deleteExamn(Evaluations exam, String tenantId) async {
    try {
      final metrics = await _queryGraphQLList<JoinMetric>(
        operationName: 'listJoinMetrics',
        document: '''
          query ListJoinMetrics(
            \$filter: ModelJoinMetricFilterInput
          ) {
            listJoinMetrics(filter: \$filter) {
              items {
                id
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
      for (var metric in metrics) {
        await _mutateGraphQL(
          document: '''
            mutation DeleteJoinMetric(
              \$input: DeleteJoinMetricInput!
            ) {
              deleteJoinMetric(input: \$input) {
                id
              }
            }
          ''',
          variables: {
            'input': {'id': metric.id},
          },
        );
        if (metric.metric != null) {
          await _mutateGraphQL(
            document: '''
              mutation DeleteMetric(
                \$input: DeleteMetricInput!
              ) {
                deleteMetric(input: \$input) {
                  id
                }
              }
            ''',
            variables: {
              'input': {'id': metric.metric!.id},
            },
          );
        }
      }
      await _mutateGraphQL(
        document: '''
          mutation DeleteEvaluations(
            \$input: DeleteEvaluationsInput!
          ) {
            deleteEvaluations(input: \$input) {
              id
            }
          }
        ''',
        variables: {
          'input': {'id': exam.id},
        },
      );
      safePrint('✅ Examen eliminado correctamente');

    } catch (e) {
      safePrint('❌ Error al eliminar el examen: $e');
      rethrow;
    }
  }

  Future<void> deletePayment(Payment pay) async {
      try {
          await _mutateGraphQL(
            document: '''
              mutation DeletePayment(
                \$input: DeletePaymentInput!
              ) {
                deletePayment(input: \$input) {
                  id
                }
              }
            ''',
            variables: {
              'input': {'id': pay.id},
            },
          );
          safePrint('✅ Pago eliminado correctamente');
      } catch (e) {
        safePrint('❌ Error al eliminar Pago: $e');
      }
    }

  Future<void> deleteSale(Sale saleToDelete)async{
    try {
      await _mutateGraphQL(
        document: '''
          mutation DeleteSale(
            \$input: DeleteSaleInput!
          ) {
            deleteSale(input: \$input) {
              id
            }
          }
        ''',
        variables: {
          'input': {'id': saleToDelete.id},
        },
      );
      safePrint('✅ Venta eliminada correctamente');
    } catch (e) {
      safePrint('❌ Error al eliminar Venta: $e');
    }
  }

  Future<void> deleteProduct(Product product)async{
      try {
        await _mutateGraphQL(
          document: '''
            mutation DeleteProduct(
              \$input: DeleteProductInput!
            ) {
              deleteProduct(input: \$input) {
                id
              }
            }
          ''',
          variables: {
            'input': {'id': product.id},
          },
        );
        safePrint('✅ Producto eliminado correctamente');
      } catch (e) {
        safePrint('❌ Error al eliminar Producto: $e');
      }
  }

  Future<void> deleteUserAccess(UserAccess userAccess)async{
      await _mutateGraphQL(
        document: '''
          mutation DeleteUserAccess(
            \$input: DeleteUserAccessInput!
          ) {
            deleteUserAccess(input: \$input) {
              id
            }
          }
        ''',
        variables: {
          'input': {'id': userAccess.id},
        },
      );
  }

  Future<void> deleteExpense(Expense expenseToDelete)async{
    try {
      await _mutateGraphQL(
        document: '''
          mutation DeleteExpense(
            \$input: DeleteExpenseInput!
          ) {
            deleteExpense(input: \$input) {
              id
            }
          }
        ''',
        variables: {
          'input': {'id': expenseToDelete.id},
        },
      );
      safePrint('✅ Gasto eliminado correctamente');
    } catch (e) {
      safePrint('❌ Error al eliminar el Gasto: $e');
    }
  }  

  Future<void> deleteFromGroup(JoinGroups joinGroup)async{
    try {
      await _mutateGraphQL(
        document: '''
          mutation DeleteJoinGroups(
            \$input: DeleteJoinGroupsInput!
          ) {
            deleteJoinGroups(input: \$input) {
              id
            }
          }
        ''',
        variables: {
          'input': {'id': joinGroup.id},
        },
      );
      safePrint("✅ Alumno removido correctamente");
    } catch (e) {
      safePrint('❌ Error al remover alumno: $e');
    }
  }

}
