import 'package:la_dinamica_app/models/ModelProvider.dart';

class UserLocal{
  final String userId;
  final String name;
  final Tenant tenant;
  final String schoolname;
  final Map<String, bool> permissions;
  final String plan;
  final bool status;
  final List<UserAccess> userAccess;

  UserLocal({
    required this.userId,
    required this.name,
    required this.tenant,
    required this.schoolname,
    required this.permissions,
    required this.plan,
    required this.status,
    required this.userAccess,
  });

  UserLocal copyWith({
    String? userId,
    String? name,
    Tenant? tenant,
    String? schoolname,
    Map<String, bool>? permissions,
    String? plan,
    bool? status,
    List<UserAccess>? userAccess,
  }) {
    return UserLocal(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      tenant: tenant ?? this.tenant,
      schoolname: schoolname ?? this.schoolname,
      permissions: permissions ?? this.permissions,
      plan: plan ?? this.plan,
      status: status ?? this.status,
      userAccess: userAccess ?? this.userAccess,
    );
  }
}