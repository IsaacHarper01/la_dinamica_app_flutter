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

    try {
      final cognitoUser = await Amplify.Auth.getCurrentUser();
      final userId = cognitoUser.userId;
      final email = cognitoUser.signInDetails.toJson()['username'] as String;
                            
      if (await awsDb.userExists(userId)) {

        final dbUser = await awsDb.getUser(userId);
        final userAccess = await awsDb.getUserAccess(dbUser!.user_id); //this gets the first userAccess but I have to chosen by the account chosen value
           
        final newUser = UserLocal(
          userId: dbUser.user_id,
          tenantId: userAccess!.first.tenant!.tenant_id,
          name: dbUser.name,
          schoolname: userAccess.first.tenant!.name,
          permissions: userAccess.first.permissions!,
          plan: userAccess.first.tenant!.plan!,
          status: userAccess.first.tenant!.status!,
          userAccess: userAccess, 
        );
        safePrint('✅ Usuario cargado correctamente: ${newUser.userId}, ${newUser.tenantId}, ${newUser.name}, ${newUser.schoolname}, ${newUser.permissions}, ${newUser.plan}, ${newUser.status}');
        return newUser;
      } else {
        final newTenantId = Uuid().v4();
        final schoolName = "La Dinámica Gym"; //change this to the actual school name logic
        final plan = "Free";
        final status = true;
        
        final user = User(
          user_id: userId, 
          name: email,);

        final tenant = Tenant(
          tenant_id: newTenantId,
          name: schoolName,
          plan: plan,
          status: status,
        );

        final userAccess = UserAccess(
          user: user,
          tenant: tenant,
          permissions: 'admin', // Default permissions
          status: true,
        );
        await awsDb2.saveUser(
          id: userId,
          name: email,
        );
        await awsDb2.saveTenant(
          tenantId: newTenantId,
          name: schoolName,
          plan: plan,
          status: status,
        );
        await awsDb2.saveUserAccess(
          user: user,
          tenant: tenant,
          permissions: 'admin', // Default permissions
          status: true,
        );
        
        final newUser = UserLocal(
          userId: userId,
          tenantId: newTenantId,
          name: email,
          schoolname: schoolName,
          permissions: 'admin', // Default permissions
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
    String? tenantId,
    String? schoolname,
    String? permissions,
    String? plan,
    bool? status,
  }) {
    final currentUser = state.value;
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        userId: userId ?? currentUser.userId,
        name: name ?? currentUser.name,
        tenantId: tenantId ?? currentUser.tenantId,
        schoolname: schoolname ?? currentUser.schoolname,
        permissions: permissions ?? currentUser.permissions,
        plan: plan ?? currentUser.plan,
        status: status ?? currentUser.status,
      );
      state = AsyncValue.data(updatedUser);
      safePrint('✅ Usuario actualizado: ${updatedUser.userId}, ${updatedUser.tenantId}, ${updatedUser.name}, ${updatedUser.schoolname}, ${updatedUser.permissions}, ${updatedUser.plan}, ${updatedUser.status}');
    }
  }
}
