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
import 'package:collection/collection.dart';


/** This is an auto generated class representing the Tenant type in your schema. */
class Tenant extends amplify_core.Model {
  static const classType = const _TenantModelType();
  final String? _tenant_id;
  final String? _name;
  final bool? _status;
  final String? _plan;
  final List<UserAccess>? _who_access;
  final List<Expense>? _expense;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => modelIdentifier.serializeAsString();
  
  TenantModelIdentifier get modelIdentifier {
    try {
      return TenantModelIdentifier(
        tenant_id: _tenant_id!
      );
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get tenant_id {
    try {
      return _tenant_id!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool? get status {
    return _status;
  }
  
  String? get plan {
    return _plan;
  }
  
  List<UserAccess>? get who_access {
    return _who_access;
  }
  
  List<Expense>? get expense {
    return _expense;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Tenant._internal({required tenant_id, required name, status, plan, who_access, expense, createdAt, updatedAt}): _tenant_id = tenant_id, _name = name, _status = status, _plan = plan, _who_access = who_access, _expense = expense, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Tenant({required String tenant_id, required String name, bool? status, String? plan, List<UserAccess>? who_access, List<Expense>? expense}) {
    return Tenant._internal(
      tenant_id: tenant_id,
      name: name,
      status: status,
      plan: plan,
      who_access: who_access != null ? List<UserAccess>.unmodifiable(who_access) : who_access,
      expense: expense != null ? List<Expense>.unmodifiable(expense) : expense);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Tenant &&
      _tenant_id == other._tenant_id &&
      _name == other._name &&
      _status == other._status &&
      _plan == other._plan &&
      DeepCollectionEquality().equals(_who_access, other._who_access) &&
      DeepCollectionEquality().equals(_expense, other._expense);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Tenant {");
    buffer.write("tenant_id=" + "$_tenant_id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("status=" + (_status != null ? _status!.toString() : "null") + ", ");
    buffer.write("plan=" + "$_plan" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Tenant copyWith({String? name, bool? status, String? plan, List<UserAccess>? who_access, List<Expense>? expense}) {
    return Tenant._internal(
      tenant_id: tenant_id,
      name: name ?? this.name,
      status: status ?? this.status,
      plan: plan ?? this.plan,
      who_access: who_access ?? this.who_access,
      expense: expense ?? this.expense);
  }
  
  Tenant copyWithModelFieldValues({
    ModelFieldValue<String>? name,
    ModelFieldValue<bool?>? status,
    ModelFieldValue<String?>? plan,
    ModelFieldValue<List<UserAccess>?>? who_access,
    ModelFieldValue<List<Expense>?>? expense
  }) {
    return Tenant._internal(
      tenant_id: tenant_id,
      name: name == null ? this.name : name.value,
      status: status == null ? this.status : status.value,
      plan: plan == null ? this.plan : plan.value,
      who_access: who_access == null ? this.who_access : who_access.value,
      expense: expense == null ? this.expense : expense.value
    );
  }
  
  Tenant.fromJson(Map<String, dynamic> json)  
    : _tenant_id = json['tenant_id'],
      _name = json['name'],
      _status = json['status'],
      _plan = json['plan'],
      _who_access = json['who_access']  is Map
        ? (json['who_access']['items'] is List
          ? (json['who_access']['items'] as List)
              .where((e) => e != null)
              .map((e) => UserAccess.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['who_access'] is List
          ? (json['who_access'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => UserAccess.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _expense = json['expense']  is Map
        ? (json['expense']['items'] is List
          ? (json['expense']['items'] as List)
              .where((e) => e != null)
              .map((e) => Expense.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['expense'] is List
          ? (json['expense'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Expense.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'tenant_id': _tenant_id, 'name': _name, 'status': _status, 'plan': _plan, 'who_access': _who_access?.map((UserAccess? e) => e?.toJson()).toList(), 'expense': _expense?.map((Expense? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'tenant_id': _tenant_id,
    'name': _name,
    'status': _status,
    'plan': _plan,
    'who_access': _who_access,
    'expense': _expense,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<TenantModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<TenantModelIdentifier>();
  static final TENANT_ID = amplify_core.QueryField(fieldName: "tenant_id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final PLAN = amplify_core.QueryField(fieldName: "plan");
  static final WHO_ACCESS = amplify_core.QueryField(
    fieldName: "who_access",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'UserAccess'));
  static final EXPENSE = amplify_core.QueryField(
    fieldName: "expense",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Expense'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Tenant";
    modelSchemaDefinition.pluralName = "Tenants";
    
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
      amplify_core.ModelIndex(fields: const ["tenant_id"], name: null)
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tenant.TENANT_ID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tenant.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tenant.STATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tenant.PLAN,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Tenant.WHO_ACCESS,
      isRequired: false,
      ofModelName: 'UserAccess',
      associatedKey: UserAccess.TENANT
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Tenant.EXPENSE,
      isRequired: false,
      ofModelName: 'Expense',
      associatedKey: Expense.TENANT
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

class _TenantModelType extends amplify_core.ModelType<Tenant> {
  const _TenantModelType();
  
  @override
  Tenant fromJson(Map<String, dynamic> jsonData) {
    return Tenant.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Tenant';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Tenant] in your schema.
 */
class TenantModelIdentifier implements amplify_core.ModelIdentifier<Tenant> {
  final String tenant_id;

  /** Create an instance of TenantModelIdentifier using [tenant_id] the primary key. */
  const TenantModelIdentifier({
    required this.tenant_id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'tenant_id': tenant_id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'TenantModelIdentifier(tenant_id: $tenant_id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is TenantModelIdentifier &&
      tenant_id == other.tenant_id;
  }
  
  @override
  int get hashCode =>
    tenant_id.hashCode;
}