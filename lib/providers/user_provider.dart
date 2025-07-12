import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/User.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:uuid/uuid.dart';

final userProvider = AsyncNotifierProvider<UserNotifier, User>(
  UserNotifier.new,
);

class UserNotifier extends AsyncNotifier<User> {
  
  @override
  Future<User> build() async {
    final awsDb = DataStoreReadService();
    final awsDb2 = DataStoreService();
    final accountChoshen = '1'; // This should be replaced with the actual account chosen logic

    try {
      final cognitoUser = await Amplify.Auth.getCurrentUser();
      final userId = cognitoUser.userId;
      final email = cognitoUser.signInDetails.toJson()['username'] as String?;

      if (await awsDb.userExists(userId)) {
        final dbUser = await awsDb.getUser(userId);
        safePrint('Usuario encontrado: $dbUser');
        final dbGym = jsonDecode(dbUser!.db_id!)[accountChoshen];
        safePrint('GYM ID: $dbGym');

        final newUser = User(
          id: dbUser.id,
          db_id: dbGym,
          name: email ?? 'Unknown',
          role: dbUser.role,
          Plan: dbUser.Plan,
          status: dbUser.status,
        );
        safePrint('✅ Usuario obtenido: $newUser');
        return newUser;
      } else {
        final newId = Uuid().v4();

        final newUser = User(
          id: userId,
          db_id: newId,
          name: email,
          role: 'owner',
          Plan: 'free',
          status: true,
        );
        
        await awsDb2.saveUser(
          id: newUser.id,
          clientId: "1:${newUser.db_id}",
          name: newUser.name,
          role: newUser.role,
          plan: newUser.Plan,
          status: newUser.status,
        );
        return newUser;
      }
    } catch (e) {
      safePrint('❌ Error al obtener el usuario actual: $e');
      throw Exception("Error al cargar el usuario");
    }
  }

  void setUser(User user) {
    state = AsyncValue.data(user);
  }

  
}
