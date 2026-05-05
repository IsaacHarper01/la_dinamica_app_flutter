import 'package:la_dinamica_app/models/ModelProvider.dart';

class UserLocal{
  final User user;
  final String name;
  final Tenant? tenant;
  final String? schoolname;
  final Map<String, bool>? permissions;
  final String? plan;
  final bool? status;
  final List<UserAccess>? userAccess;

  UserLocal({
    required this.user,
    required this.name,
    this.tenant,
    this.schoolname,
    this.permissions,
    this.plan,
    this.status,
    this.userAccess,
  });

  UserLocal copyWith({
    User? user,
    String? name,
    Tenant? tenant,
    String? schoolname,
    Map<String, bool>? permissions,
    String? plan,
    bool? status,
    List<UserAccess>? userAccess,
  }) {
    return UserLocal(
      user: user ?? this.user,
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