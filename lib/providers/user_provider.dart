import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/User.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:uuid/uuid.dart';


final userProvider = StateProvider<User?>((ref) => null);

Future<void> initializeUser(WidgetRef ref) async {
  final awsDb = DataStoreReadService();
  final awsDb2 = DataStoreService();

  try {
    final cognitoUser = await Amplify.Auth.getCurrentUser();
    final userId = cognitoUser.userId;
    final email = cognitoUser.signInDetails.toJson()['username'] as String?;
    if (await awsDb.userExists(userId)){

      final dbUser = await awsDb.getUser(userId);
      ref.read(userProvider.notifier).state = dbUser;
      safePrint('✅ Usuario obtenido: $dbUser');
    }else{
      final newId = { '1': Uuid().v4()};

      final newUser = User(
        id: userId,
        db_id: jsonEncode(newId),
        name: '',
        role: 'owner',
        Plan: 'free',
        status: true,
      );
      awsDb2.saveUser(id: newUser.id, clientId: newUser.db_id, name: newUser.name, role: newUser.role, plan: newUser.Plan, status: newUser.status);
      safePrint('✅ Usuario creado: $newUser');
      ref.read(userProvider.notifier).state = newUser;
    }

  }
  catch (e) {
    safePrint('❌ Error al obtener el usuario actual: $e');
    return;
  }
}