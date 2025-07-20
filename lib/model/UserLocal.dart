class UserLocal{
  final String userId;
  final String name;
  final String tenantId;
  final String schoolname;
  final String permissions;
  final String plan;
  final bool status;

  UserLocal({
    required this.userId,
    required this.name,
    required this.tenantId,
    required this.schoolname,
    required this.permissions,
    required this.plan,
    required this.status,
  });
}