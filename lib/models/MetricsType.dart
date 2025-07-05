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


/** This is an auto generated class representing the MetricsType type in your schema. */
class MetricsType extends amplify_core.Model {
  static const classType = const _MetricsTypeModelType();
  final String id;
  final String? _name;
  final double? _min_value;
  final double? _max_value;
  final String? _category;
  final String? _client_id;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  MetricsTypeModelIdentifier get modelIdentifier {
      return MetricsTypeModelIdentifier(
        id: id
      );
  }
  
  String? get name {
    return _name;
  }
  
  double? get min_value {
    return _min_value;
  }
  
  double? get max_value {
    return _max_value;
  }
  
  String? get category {
    return _category;
  }
  
  String? get client_id {
    return _client_id;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const MetricsType._internal({required this.id, name, min_value, max_value, category, client_id, createdAt, updatedAt}): _name = name, _min_value = min_value, _max_value = max_value, _category = category, _client_id = client_id, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory MetricsType({String? id, String? name, double? min_value, double? max_value, String? category, String? client_id}) {
    return MetricsType._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      min_value: min_value,
      max_value: max_value,
      category: category,
      client_id: client_id);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MetricsType &&
      id == other.id &&
      _name == other._name &&
      _min_value == other._min_value &&
      _max_value == other._max_value &&
      _category == other._category &&
      _client_id == other._client_id;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("MetricsType {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("min_value=" + (_min_value != null ? _min_value.toString() : "null") + ", ");
    buffer.write("max_value=" + (_max_value != null ? _max_value.toString() : "null") + ", ");
    buffer.write("category=" + "$_category" + ", ");
    buffer.write("client_id=" + "$_client_id" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  MetricsType copyWith({String? name, double? min_value, double? max_value, String? category, String? client_id}) {
    return MetricsType._internal(
      id: id,
      name: name ?? this.name,
      min_value: min_value ?? this.min_value,
      max_value: max_value ?? this.max_value,
      category: category ?? this.category,
      client_id: client_id ?? this.client_id);
  }
  
  MetricsType copyWithModelFieldValues({
    ModelFieldValue<String?>? name,
    ModelFieldValue<double?>? min_value,
    ModelFieldValue<double?>? max_value,
    ModelFieldValue<String?>? category,
    ModelFieldValue<String?>? client_id
  }) {
    return MetricsType._internal(
      id: id,
      name: name == null ? this.name : name.value,
      min_value: min_value == null ? this.min_value : min_value.value,
      max_value: max_value == null ? this.max_value : max_value.value,
      category: category == null ? this.category : category.value,
      client_id: client_id == null ? this.client_id : client_id.value
    );
  }
  
  MetricsType.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _min_value = (json['min_value'] as num?)?.toDouble(),
      _max_value = (json['max_value'] as num?)?.toDouble(),
      _category = json['category'],
      _client_id = json['client_id'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'min_value': _min_value, 'max_value': _max_value, 'category': _category, 'client_id': _client_id, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'min_value': _min_value,
    'max_value': _max_value,
    'category': _category,
    'client_id': _client_id,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<MetricsTypeModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<MetricsTypeModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final MIN_VALUE = amplify_core.QueryField(fieldName: "min_value");
  static final MAX_VALUE = amplify_core.QueryField(fieldName: "max_value");
  static final CATEGORY = amplify_core.QueryField(fieldName: "category");
  static final CLIENT_ID = amplify_core.QueryField(fieldName: "client_id");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "MetricsType";
    modelSchemaDefinition.pluralName = "MetricsTypes";
    
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
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MetricsType.NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MetricsType.MIN_VALUE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MetricsType.MAX_VALUE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MetricsType.CATEGORY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MetricsType.CLIENT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
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

class _MetricsTypeModelType extends amplify_core.ModelType<MetricsType> {
  const _MetricsTypeModelType();
  
  @override
  MetricsType fromJson(Map<String, dynamic> jsonData) {
    return MetricsType.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'MetricsType';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [MetricsType] in your schema.
 */
class MetricsTypeModelIdentifier implements amplify_core.ModelIdentifier<MetricsType> {
  final String id;

  /** Create an instance of MetricsTypeModelIdentifier using [id] the primary key. */
  const MetricsTypeModelIdentifier({
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
  String toString() => 'MetricsTypeModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is MetricsTypeModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}