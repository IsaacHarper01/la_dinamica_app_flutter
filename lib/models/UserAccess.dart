/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the UserAccess type in your schema. */
class UserAccess extends amplify_core.Model {
  static const classType = const _UserAccessModelType();
  final String id;
  final String? _permissions;
  final bool? _status;
  final bool? _isAdmin;
  final User? _user;
  final Tenant? _tenant;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserAccessModelIdentifier get modelIdentifier {
      return UserAccessModelIdentifier(
        id: id
      );
  }
  
  String? get permissions {
    return _permissions;
  }
  
  bool? get status {
    return _status;
  }
  
  bool? get isAdmin {
    return _isAdmin;
  }
  
  User? get user {
    return _user;
  }
  
  Tenant? get tenant {
    return _tenant;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const UserAccess._internal({required this.id, permissions, status, isAdmin, user, tenant, createdAt, updatedAt}): _permissions = permissions, _status = status, _isAdmin = isAdmin, _user = user, _tenant = tenant, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory UserAccess({String? id, String? permissions, bool? status, bool? isAdmin, User? user, Tenant? tenant}) {
    return UserAccess._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      permissions: permissions,
      status: status,
      isAdmin: isAdmin,
      user: user,
      tenant: tenant);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserAccess &&
      id == other.id &&
      _permissions == other._permissions &&
      _status == other._status &&
      _isAdmin == other._isAdmin &&
      _user == other._user &&
      _tenant == other._tenant;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("UserAccess {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("permissions=" + "$_permissions" + ", ");
    buffer.write("status=" + (_status != null ? _status!.toString() : "null") + ", ");
    buffer.write("isAdmin=" + (_isAdmin != null ? _isAdmin!.toString() : "null") + ", ");
    buffer.write("user=" + (_user != null ? _user!.toString() : "null") + ", ");
    buffer.write("tenant=" + (_tenant != null ? _tenant!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  UserAccess copyWith({String? permissions, bool? status, bool? isAdmin, User? user, Tenant? tenant}) {
    return UserAccess._internal(
      id: id,
      permissions: permissions ?? this.permissions,
      status: status ?? this.status,
      isAdmin: isAdmin ?? this.isAdmin,
      user: user ?? this.user,
      tenant: tenant ?? this.tenant);
  }
  
  UserAccess copyWithModelFieldValues({
    ModelFieldValue<String?>? permissions,
    ModelFieldValue<bool?>? status,
    ModelFieldValue<bool?>? isAdmin,
    ModelFieldValue<User?>? user,
    ModelFieldValue<Tenant?>? tenant
  }) {
    return UserAccess._internal(
      id: id,
      permissions: permissions == null ? this.permissions : permissions.value,
      status: status == null ? this.status : status.value,
      isAdmin: isAdmin == null ? this.isAdmin : isAdmin.value,
      user: user == null ? this.user : user.value,
      tenant: tenant == null ? this.tenant : tenant.value
    );
  }
  
  UserAccess.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _permissions = json['permissions'],
      _status = json['status'],
      _isAdmin = json['isAdmin'],
      _user = json['user'] != null
        ? json['user']['serializedData'] != null
          ? User.fromJson(new Map<String, dynamic>.from(json['user']['serializedData']))
          : User.fromJson(new Map<String, dynamic>.from(json['user']))
        : null,
      _tenant = json['tenant'] != null
        ? json['tenant']['serializedData'] != null
          ? Tenant.fromJson(new Map<String, dynamic>.from(json['tenant']['serializedData']))
          : Tenant.fromJson(new Map<String, dynamic>.from(json['tenant']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'permissions': _permissions, 'status': _status, 'isAdmin': _isAdmin, 'user': _user?.toJson(), 'tenant': _tenant?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'permissions': _permissions,
    'status': _status,
    'isAdmin': _isAdmin,
    'user': _user,
    'tenant': _tenant,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<UserAccessModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserAccessModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final PERMISSIONS = amplify_core.QueryField(fieldName: "permissions");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final ISADMIN = amplify_core.QueryField(fieldName: "isAdmin");
  static final USER = amplify_core.QueryField(
    fieldName: "user",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static final TENANT = amplify_core.QueryField(
    fieldName: "tenant",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Tenant'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserAccess";
    modelSchemaDefinition.pluralName = "UserAccesses";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["user_id"], name: "userAccessesByUser_id"),
      amplify_core.ModelIndex(fields: const ["tenant_id"], name: "userAccessesByTenant_id")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserAccess.PERMISSIONS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserAccess.STATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserAccess.ISADMIN,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: UserAccess.USER,
      isRequired: false,
      targetNames: ['user_id'],
      ofModelName: 'User'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: UserAccess.TENANT,
      isRequired: false,
      targetNames: ['tenant_id'],
      ofModelName: 'Tenant'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _UserAccessModelType extends amplify_core.ModelType<UserAccess> {
  const _UserAccessModelType();
  
  @override
  UserAccess fromJson(Map<String, dynamic> jsonData) {
    return UserAccess.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'UserAccess';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [UserAccess] in your schema.
 */
class UserAccessModelIdentifier implements amplify_core.ModelIdentifier<UserAccess> {
  final String id;

  /** Create an instance of UserAccessModelIdentifier using [id] the primary key. */
  const UserAccessModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'UserAccessModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserAccessModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}