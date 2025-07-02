import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/User.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:uuid/uuid.dart';

final userProvider = StateNotifierProvider<UserNotifier, User?>(
  (ref) => UserNotifier(),
);

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  void setUser(User user) {
    state = user;
  }

  Future<void> initializeUser(WidgetRef ref) async {
    final awsDb = DataStoreReadService();
    final awsDb2 = DataStoreService();

    try {
      final cognitoUser = await Amplify.Auth.getCurrentUser();
      final userId = cognitoUser.userId;
      final email = cognitoUser.signInDetails.toJson()['username'] as String?;

      if (await awsDb.userExists(userId)) {
        final dbUser = await awsDb.getUser(userId);
        state = dbUser!;
        safePrint('✅ Usuario obtenido: $dbUser');
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
          clientId: newUser.db_id,
          name: newUser.name,
          role: newUser.role,
          plan: newUser.Plan,
          status: newUser.status,
        );
        safePrint('✅ Usuario creado: $newUser');
        state = newUser;
      }
    } catch (e) {
      state = null;
      safePrint('❌ Error al obtener el usuario actual: $e');
      return;
    }
  }
}
