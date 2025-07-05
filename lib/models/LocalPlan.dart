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


/** This is an auto generated class representing the LocalPlan type in your schema. */
class LocalPlan extends amplify_core.Model {
  static const classType = const _LocalPlanModelType();
  final String id;
  final String? _type;
  final int? _clases;
  final double? _price;
  final String? _client_id;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  LocalPlanModelIdentifier get modelIdentifier {
      return LocalPlanModelIdentifier(
        id: id
      );
  }
  
  String? get type {
    return _type;
  }
  
  int? get clases {
    return _clases;
  }
  
  double? get price {
    return _price;
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
  
  const LocalPlan._internal({required this.id, type, clases, price, client_id, createdAt, updatedAt}): _type = type, _clases = clases, _price = price, _client_id = client_id, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory LocalPlan({String? id, String? type, int? clases, double? price, String? client_id}) {
    return LocalPlan._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      type: type,
      clases: clases,
      price: price,
      client_id: client_id);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LocalPlan &&
      id == other.id &&
      _type == other._type &&
      _clases == other._clases &&
      _price == other._price &&
      _client_id == other._client_id;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("LocalPlan {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("type=" + "$_type" + ", ");
    buffer.write("clases=" + (_clases != null ? _clases.toString() : "null") + ", ");
    buffer.write("price=" + (_price != null ? _price.toString() : "null") + ", ");
    buffer.write("client_id=" + "$_client_id" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  LocalPlan copyWith({String? type, int? clases, double? price, String? client_id}) {
    return LocalPlan._internal(
      id: id,
      type: type ?? this.type,
      clases: clases ?? this.clases,
      price: price ?? this.price,
      client_id: client_id ?? this.client_id);
  }
  
  LocalPlan copyWithModelFieldValues({
    ModelFieldValue<String?>? type,
    ModelFieldValue<int?>? clases,
    ModelFieldValue<double?>? price,
    ModelFieldValue<String?>? client_id
  }) {
    return LocalPlan._internal(
      id: id,
      type: type == null ? this.type : type.value,
      clases: clases == null ? this.clases : clases.value,
      price: price == null ? this.price : price.value,
      client_id: client_id == null ? this.client_id : client_id.value
    );
  }
  
  LocalPlan.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _type = json['type'],
      _clases = (json['clases'] as num?)?.toInt(),
      _price = (json['price'] as num?)?.toDouble(),
      _client_id = json['client_id'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'type': _type, 'clases': _clases, 'price': _price, 'client_id': _client_id, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'type': _type,
    'clases': _clases,
    'price': _price,
    'client_id': _client_id,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<LocalPlanModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<LocalPlanModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final CLASES = amplify_core.QueryField(fieldName: "clases");
  static final PRICE = amplify_core.QueryField(fieldName: "price");
  static final CLIENT_ID = amplify_core.QueryField(fieldName: "client_id");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "LocalPlan";
    modelSchemaDefinition.pluralName = "LocalPlans";
    
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
      key: LocalPlan.TYPE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: LocalPlan.CLASES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: LocalPlan.PRICE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: LocalPlan.CLIENT_ID,
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

class _LocalPlanModelType extends amplify_core.ModelType<LocalPlan> {
  const _LocalPlanModelType();
  
  @override
  LocalPlan fromJson(Map<String, dynamic> jsonData) {
    return LocalPlan.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'LocalPlan';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [LocalPlan] in your schema.
 */
class LocalPlanModelIdentifier implements amplify_core.ModelIdentifier<LocalPlan> {
  final String id;

  /** Create an instance of LocalPlanModelIdentifier using [id] the primary key. */
  const LocalPlanModelIdentifier({
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
  String toString() => 'LocalPlanModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is LocalPlanModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}