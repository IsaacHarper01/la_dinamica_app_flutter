import 'package:amplify_flutter/amplify_flutter.dart';
import 'graphql_service.dart';

class GraphqlServiceUpdate {

  Future<void> updateStudent({
    required String id,
    String? name,
    String? address,
    String? phone,
    int? age,
    String? birthday,
    String? email,
    String? image,
    String? gymId,
    int? remainClasses,
    TemporalDate? expirationPlan,

  }) async {
    await GraphQLService.mutate(
      document: '''
        mutation UpdateStudent(\$input: UpdateStudentInput!) {
          updateStudent(input: \$input) {
            id
          }
        }
      ''',
      variables: {
        'input': {
          'id': id,
          'name': name,
          'address': address,
          'phone': phone,
          'age': age,
          'birthday': birthday,
          'email': email,
          'image': image,
          'client_id': gymId,
          'remainClasses': remainClasses,
          'expirationPlan': expirationPlan?.format(),
        },
      },
    );
  }

}