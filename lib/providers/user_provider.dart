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
    final attributes = await Amplify.Auth.fetchUserAttributes();
    final Map<String, String> userAtributes = {for (var attr in attributes) attr.userAttributeKey.toString(): attr.value};
    final userId = userAtributes['sub']!;
    safePrint("Usuario actual: $userId");
    
    try {
      if (await awsDb.userExists(userId)) {
        final dbUser = await awsDb.getUser(userId);
        safePrint("Usuario existe");
        final userAccess = await awsDb.getUserAccess(dbUser!.user_id,);
        if(userAccess!= null){
          safePrint("Tenant actual: ${userAccess.first.tenant!.tenant_id}"); 
          final Map<String, bool> decodedPermisions = Map<String, bool>.from(jsonDecode(userAccess.first.permissions!));
          final newUser = UserLocal(
            user: dbUser,
            tenant: userAccess.first.tenant!,
            name: userAccess.first.user!.name,
            schoolname: userAccess.first.tenant!.name,
            permissions: decodedPermisions,
            plan: userAccess.first.tenant!.plan!,
            status: userAccess.first.tenant!.status!,
            userAccess: userAccess,
          );
          safePrint(
            '✅ Usuario cargado correctamente: $newUser, ${newUser.tenant}, ${newUser.name}, ${newUser.schoolname}, ${newUser.permissions}, ${newUser.plan}, ${newUser.status}',
          );
          return newUser;
          }
          else{
            final newUser = UserLocal(
            user: dbUser,
            tenant: null,
            name: userAtributes['name']!,
            schoolname: "",
            permissions: null,
            plan: "Free",
            status: true,
            userAccess: null,
          );
          return newUser;
          }
      } else {
        final name = userAtributes['name']!;
        final plan = "Free";
        final status = true;

        final user = await awsDb2.saveUser(
          id: userId, 
          name: name
          );
       
        final newUser = UserLocal(
          user: user,
          name: user.name,
          plan: plan,
          status: status,
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

  Future<UserLocal> registerGym(String name, String sport, User user)async{
        
        final awsDb2 = DataStoreService();
        final nameSchool = name;
        final newTenantId = Uuid().v4();
        final plan = "Free";
        final status = true;

        
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
          user: user,
          tenant: tenant,
          name: user.name,
          schoolname: nameSchool,
          permissions: permisions, // Default permissions
          plan: plan,
          status: status,
          userAccess: [userAccess],
        );
        return newUser;
  }

  void updateUser({
    User? user,
    String? name,
    Tenant? tenant,
    String? schoolname,
    Map<String, bool>? permissions,
    String? plan,
    bool? status,
    List<UserAccess>? userAccess,
  }) {
    final currentUser = state.value;

    if (currentUser == null) {
      safePrint('⚠️ No hay usuario actual para actualizar.');
      return;
    }

    final updatedUser = UserLocal(
      user: user ?? currentUser.user,
      name: name ?? currentUser.name,
      tenant: tenant ?? currentUser.tenant,
      schoolname: schoolname ?? currentUser.schoolname,
      permissions: permissions ?? currentUser.permissions,
      plan: plan ?? currentUser.plan,
      status: status ?? currentUser.status,
      userAccess: userAccess ?? currentUser.userAccess,
    );

    state = AsyncValue.data(updatedUser);

    safePrint(
      '✅ Usuario actualizado: ${updatedUser.user.name}, ${updatedUser.tenant}, ${updatedUser.name}, ${updatedUser.schoolname}, ${updatedUser.permissions}, ${updatedUser.plan}, ${updatedUser.status}, access=${updatedUser.userAccess?.length ?? 0}',
    );
  }
}
