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


/** This is an auto generated class representing the Metric type in your schema. */
class Metric extends amplify_core.Model {
  static const classType = const _MetricModelType();
  final String id;
  final String? _name;
  final String? _tenant_id;
  final String? _description;
  final String? _type;
  final bool? _higgerBetter;
  final List<JoinMetric>? _access;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  MetricModelIdentifier get modelIdentifier {
      return MetricModelIdentifier(
        id: id
      );
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
  
  String? get description {
    return _description;
  }
  
  String? get type {
    return _type;
  }
  
  bool? get higgerBetter {
    return _higgerBetter;
  }
  
  List<JoinMetric>? get access {
    return _access;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Metric._internal({required this.id, required name, required tenant_id, description, type, higgerBetter, access, createdAt, updatedAt}): _name = name, _tenant_id = tenant_id, _description = description, _type = type, _higgerBetter = higgerBetter, _access = access, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Metric({String? id, required String name, required String tenant_id, String? description, String? type, bool? higgerBetter, List<JoinMetric>? access}) {
    return Metric._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      tenant_id: tenant_id,
      description: description,
      type: type,
      higgerBetter: higgerBetter,
      access: access != null ? List<JoinMetric>.unmodifiable(access) : access);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Metric &&
      id == other.id &&
      _name == other._name &&
      _tenant_id == other._tenant_id &&
      _description == other._description &&
      _type == other._type &&
      _higgerBetter == other._higgerBetter &&
      DeepCollectionEquality().equals(_access, other._access);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Metric {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("tenant_id=" + "$_tenant_id" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("type=" + "$_type" + ", ");
    buffer.write("higgerBetter=" + (_higgerBetter != null ? _higgerBetter!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Metric copyWith({String? name, String? tenant_id, String? description, String? type, bool? higgerBetter, List<JoinMetric>? access}) {
    return Metric._internal(
      id: id,
      name: name ?? this.name,
      tenant_id: tenant_id ?? this.tenant_id,
      description: description ?? this.description,
      type: type ?? this.type,
      higgerBetter: higgerBetter ?? this.higgerBetter,
      access: access ?? this.access);
  }
  
  Metric copyWithModelFieldValues({
    ModelFieldValue<String>? name,
    ModelFieldValue<String>? tenant_id,
    ModelFieldValue<String?>? description,
    ModelFieldValue<String?>? type,
    ModelFieldValue<bool?>? higgerBetter,
    ModelFieldValue<List<JoinMetric>?>? access
  }) {
    return Metric._internal(
      id: id,
      name: name == null ? this.name : name.value,
      tenant_id: tenant_id == null ? this.tenant_id : tenant_id.value,
      description: description == null ? this.description : description.value,
      type: type == null ? this.type : type.value,
      higgerBetter: higgerBetter == null ? this.higgerBetter : higgerBetter.value,
      access: access == null ? this.access : access.value
    );
  }
  
  Metric.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _tenant_id = json['tenant_id'],
      _description = json['description'],
      _type = json['type'],
      _higgerBetter = json['higgerBetter'],
      _access = json['access']  is Map
        ? (json['access']['items'] is List
          ? (json['access']['items'] as List)
              .where((e) => e != null)
              .map((e) => JoinMetric.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['access'] is List
          ? (json['access'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => JoinMetric.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'tenant_id': _tenant_id, 'description': _description, 'type': _type, 'higgerBetter': _higgerBetter, 'access': _access?.map((JoinMetric? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'tenant_id': _tenant_id,
    'description': _description,
    'type': _type,
    'higgerBetter': _higgerBetter,
    'access': _access,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<MetricModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<MetricModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final TENANT_ID = amplify_core.QueryField(fieldName: "tenant_id");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final HIGGERBETTER = amplify_core.QueryField(fieldName: "higgerBetter");
  static final ACCESS = amplify_core.QueryField(
    fieldName: "access",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'JoinMetric'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Metric";
    modelSchemaDefinition.pluralName = "Metrics";
    
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
      key: Metric.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Metric.TENANT_ID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Metric.DESCRIPTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Metric.TYPE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Metric.HIGGERBETTER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Metric.ACCESS,
      isRequired: false,
      ofModelName: 'JoinMetric',
      associatedKey: JoinMetric.METRIC
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

class _MetricModelType extends amplify_core.ModelType<Metric> {
  const _MetricModelType();
  
  @override
  Metric fromJson(Map<String, dynamic> jsonData) {
    return Metric.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Metric';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Metric] in your schema.
 */
class MetricModelIdentifier implements amplify_core.ModelIdentifier<Metric> {
  final String id;

  /** Create an instance of MetricModelIdentifier using [id] the primary key. */
  const MetricModelIdentifier({
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
  String toString() => 'MetricModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is MetricModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}