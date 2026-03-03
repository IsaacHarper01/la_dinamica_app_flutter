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


/** This is an auto generated class representing the Groups type in your schema. */
class Groups extends amplify_core.Model {
  static const classType = const _GroupsModelType();
  final String id;
  final String? _name;
  final String? _description;
  final String? _tenant_id;
  final List<JoinGroups>? _joingroup;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  GroupsModelIdentifier get modelIdentifier {
      return GroupsModelIdentifier(
        id: id
      );
  }
  
  String? get name {
    return _name;
  }
  
  String? get description {
    return _description;
  }
  
  String? get tenant_id {
    return _tenant_id;
  }
  
  List<JoinGroups>? get joingroup {
    return _joingroup;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Groups._internal({required this.id, name, description, tenant_id, joingroup, createdAt, updatedAt}): _name = name, _description = description, _tenant_id = tenant_id, _joingroup = joingroup, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Groups({String? id, String? name, String? description, String? tenant_id, List<JoinGroups>? joingroup}) {
    return Groups._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      description: description,
      tenant_id: tenant_id,
      joingroup: joingroup != null ? List<JoinGroups>.unmodifiable(joingroup) : joingroup);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Groups &&
      id == other.id &&
      _name == other._name &&
      _description == other._description &&
      _tenant_id == other._tenant_id &&
      DeepCollectionEquality().equals(_joingroup, other._joingroup);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Groups {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("tenant_id=" + "$_tenant_id" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Groups copyWith({String? name, String? description, String? tenant_id, List<JoinGroups>? joingroup}) {
    return Groups._internal(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      tenant_id: tenant_id ?? this.tenant_id,
      joingroup: joingroup ?? this.joingroup);
  }
  
  Groups copyWithModelFieldValues({
    ModelFieldValue<String?>? name,
    ModelFieldValue<String?>? description,
    ModelFieldValue<String?>? tenant_id,
    ModelFieldValue<List<JoinGroups>?>? joingroup
  }) {
    return Groups._internal(
      id: id,
      name: name == null ? this.name : name.value,
      description: description == null ? this.description : description.value,
      tenant_id: tenant_id == null ? this.tenant_id : tenant_id.value,
      joingroup: joingroup == null ? this.joingroup : joingroup.value
    );
  }
  
  Groups.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _description = json['description'],
      _tenant_id = json['tenant_id'],
      _joingroup = json['joingroup']  is Map
        ? (json['joingroup']['items'] is List
          ? (json['joingroup']['items'] as List)
              .where((e) => e != null)
              .map((e) => JoinGroups.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['joingroup'] is List
          ? (json['joingroup'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => JoinGroups.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'description': _description, 'tenant_id': _tenant_id, 'joingroup': _joingroup?.map((JoinGroups? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'description': _description,
    'tenant_id': _tenant_id,
    'joingroup': _joingroup,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<GroupsModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<GroupsModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final TENANT_ID = amplify_core.QueryField(fieldName: "tenant_id");
  static final JOINGROUP = amplify_core.QueryField(
    fieldName: "joingroup",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'JoinGroups'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Groups";
    modelSchemaDefinition.pluralName = "Groups";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.READ,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Groups.NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Groups.DESCRIPTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Groups.TENANT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Groups.JOINGROUP,
      isRequired: false,
      ofModelName: 'JoinGroups',
      associatedKey: JoinGroups.GROUP
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

class _GroupsModelType extends amplify_core.ModelType<Groups> {
  const _GroupsModelType();
  
  @override
  Groups fromJson(Map<String, dynamic> jsonData) {
    return Groups.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Groups';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Groups] in your schema.
 */
class GroupsModelIdentifier implements amplify_core.ModelIdentifier<Groups> {
  final String id;

  /** Create an instance of GroupsModelIdentifier using [id] the primary key. */
  const GroupsModelIdentifier({
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
  String toString() => 'GroupsModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is GroupsModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}