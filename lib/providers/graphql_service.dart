import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';

class GraphQLService {
  static Future<Map<String, dynamic>> mutate({
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

      return jsonDecode(response.data!) as Map<String, dynamic>;
    } catch (e) {
      safePrint('❌ GraphQL mutation failed: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> queryList({
    required String document,
    required Map<String, dynamic> variables,
    required String key,
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
        return <dynamic>[];
      }

      final decoded = jsonDecode(response.data!) as Map<String, dynamic>;
      final items = decoded[key]?['items'] as List<dynamic>? ?? <dynamic>[];
      return items;
    } catch (e) {
      safePrint('❌ GraphQL query failed: $e');
      rethrow;
    }
  }
}