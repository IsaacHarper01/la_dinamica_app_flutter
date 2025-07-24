import 'package:la_dinamica_app/models/ModelProvider.dart';

class UserLocal{
  final String userId;
  final String name;
  final String tenantId;
  final String schoolname;
  final String permissions;
  final String plan;
  final bool status;
  final List<UserAccess> userAccess;

  UserLocal({
    required this.userId,
    required this.name,
    required this.tenantId,
    required this.schoolname,
    required this.permissions,
    required this.plan,
    required this.status,
    required this.userAccess,
  });

  UserLocal copyWith({
    String? userId,
    String? name,
    String? tenantId,
    String? schoolname,
    String? permissions,
    String? plan,
    bool? status,
    List<UserAccess>? userAccess,
  }) {
    return UserLocal(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      tenantId: tenantId ?? this.tenantId,
      schoolname: schoolname ?? this.schoolname,
      permissions: permissions ?? this.permissions,
      plan: plan ?? this.plan,
      status: status ?? this.status,
      userAccess: userAccess ?? this.userAccess,
    );
  }
}