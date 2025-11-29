import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:uuid/uuid.dart';

final userProvider = AsyncNotifierProvider<UserNotifier, UserLocal>(
  UserNotifier.new,
);

class UserNotifier extends AsyncNotifier<UserLocal> {
  @override
  Future<UserLocal> build() async {
    final awsDb = DataStoreReadService();
    final awsDb2 = DataStoreService();
    final Map<String, String> userAtributes;  

    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      userAtributes = {for (var attr in attributes) attr.userAttributeKey.toString(): attr.value};
      final userId = userAtributes['sub']!;
      final email = userAtributes['email']!;
      safePrint("Comprobando existencia de usuario: $userId");
      safePrint("Detalles de inicio de sesión: $userAtributes");
      if (await awsDb.userExists(userId)) {
        final dbUser = await awsDb.getUser(userId);
        final userAccess = await awsDb.getUserAccess(dbUser!.user_id,); 
        final Map<String, bool> decodedPermisions = Map<String, bool>.from(jsonDecode(userAccess!.first.permissions!));
        final newUser = UserLocal(
          userId: dbUser.user_id,
          tenant: userAccess.first.tenant!,
          name: userAccess.first.user!.name,
          schoolname: userAccess.first.tenant!.name,
          permissions: decodedPermisions,
          plan: userAccess.first.tenant!.plan!,
          status: userAccess.first.tenant!.status!,
          userAccess: userAccess,
        );
        safePrint(
          '✅ Usuario cargado correctamente: ${newUser.userId}, ${newUser.tenant}, ${newUser.name}, ${newUser.schoolname}, ${newUser.permissions}, ${newUser.plan}, ${newUser.status}',
        );

        return newUser;
      } else {
        final name = userAtributes['name']!;
        final nameSchool = userAtributes['nickname']!;
        final newTenantId = Uuid().v4();
        final plan = "Free";
        final status = true;

        final user = await awsDb2.saveUser(
          id: userId, 
          name: name
          );
        final tenant = await awsDb2.saveTenant(
          tenantId: newTenantId,
          name: nameSchool,
          plan: plan,
          status: status,
        );
        final permisions = {
            'deleteStudents': true,
            'watchIncome': true,
            'setPlans': true,
            'setEvaluations': true,
            'deletePayments': true,
            'addProfesor' : true,
            'editPast': true,
            'editProducts': true,
            'sellProducts': true,
            };
        final userAccess = await awsDb2.saveUserAccess(
          user: user,
          tenant: tenant,
          permissions: permisions,
          status: true,
          isAdmin: true,
        );

        final newUser = UserLocal(
          userId: userId,
          tenant: tenant,
          name: email,
          schoolname: nameSchool,
          permissions: permisions,
          // Default permissions
          plan: plan,
          status: status,
          userAccess: [userAccess],
        );

        return newUser;
      }
    } catch (e) {
      safePrint('❌ Error al obtener el usuario actual: $e');
      throw Exception("Error al cargar el usuario");
    }
  }

  void setUser(UserLocal user) {
    state = AsyncValue.data(user);
  }

  void updateUser({
    String? userId,
    String? name,
    Tenant? tenant,
    String? schoolname,
    Map<String, bool>? permissions,
    String? plan,
    bool? status,
  }) {
    final currentUser = state.value;
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        userId: userId ?? currentUser.userId,
        name: name ?? currentUser.name,
        tenant: tenant ?? currentUser.tenant,
        schoolname: schoolname ?? currentUser.schoolname,
        permissions: permissions ?? currentUser.permissions,
        plan: plan ?? currentUser.plan,
        status: status ?? currentUser.status,
      );
      state = AsyncValue.data(updatedUser);
      safePrint(
        '✅ Usuario actualizado: ${updatedUser.userId}, ${updatedUser.tenant}, ${updatedUser.name}, ${updatedUser.schoolname}, ${updatedUser.permissions}, ${updatedUser.plan}, ${updatedUser.status}',
      );
    }
  }
}
