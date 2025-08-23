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


/** This is an auto generated class representing the JoinSubMetric type in your schema. */
class JoinSubMetric extends amplify_core.Model {
  static const classType = const _JoinSubMetricModelType();
  final String id;
  final String? _tenant_id;
  final SubMetric? _submetric;
  final SingleMetric? _metric;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  JoinSubMetricModelIdentifier get modelIdentifier {
      return JoinSubMetricModelIdentifier(
        id: id
      );
  }
  
  String? get tenant_id {
    return _tenant_id;
  }
  
  SubMetric? get submetric {
    return _submetric;
  }
  
  SingleMetric? get metric {
    return _metric;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const JoinSubMetric._internal({required this.id, tenant_id, submetric, metric, createdAt, updatedAt}): _tenant_id = tenant_id, _submetric = submetric, _metric = metric, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory JoinSubMetric({String? id, String? tenant_id, SubMetric? submetric, SingleMetric? metric}) {
    return JoinSubMetric._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      tenant_id: tenant_id,
      submetric: submetric,
      metric: metric);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JoinSubMetric &&
      id == other.id &&
      _tenant_id == other._tenant_id &&
      _submetric == other._submetric &&
      _metric == other._metric;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("JoinSubMetric {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("tenant_id=" + "$_tenant_id" + ", ");
    buffer.write("submetric=" + (_submetric != null ? _submetric!.toString() : "null") + ", ");
    buffer.write("metric=" + (_metric != null ? _metric!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  JoinSubMetric copyWith({String? tenant_id, SubMetric? submetric, SingleMetric? metric}) {
    return JoinSubMetric._internal(
      id: id,
      tenant_id: tenant_id ?? this.tenant_id,
      submetric: submetric ?? this.submetric,
      metric: metric ?? this.metric);
  }
  
  JoinSubMetric copyWithModelFieldValues({
    ModelFieldValue<String?>? tenant_id,
    ModelFieldValue<SubMetric?>? submetric,
    ModelFieldValue<SingleMetric?>? metric
  }) {
    return JoinSubMetric._internal(
      id: id,
      tenant_id: tenant_id == null ? this.tenant_id : tenant_id.value,
      submetric: submetric == null ? this.submetric : submetric.value,
      metric: metric == null ? this.metric : metric.value
    );
  }
  
  JoinSubMetric.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _tenant_id = json['tenant_id'],
      _submetric = json['submetric'] != null
        ? json['submetric']['serializedData'] != null
          ? SubMetric.fromJson(new Map<String, dynamic>.from(json['submetric']['serializedData']))
          : SubMetric.fromJson(new Map<String, dynamic>.from(json['submetric']))
        : null,
      _metric = json['metric'] != null
        ? json['metric']['serializedData'] != null
          ? SingleMetric.fromJson(new Map<String, dynamic>.from(json['metric']['serializedData']))
          : SingleMetric.fromJson(new Map<String, dynamic>.from(json['metric']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'tenant_id': _tenant_id, 'submetric': _submetric?.toJson(), 'metric': _metric?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'tenant_id': _tenant_id,
    'submetric': _submetric,
    'metric': _metric,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<JoinSubMetricModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<JoinSubMetricModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TENANT_ID = amplify_core.QueryField(fieldName: "tenant_id");
  static final SUBMETRIC = amplify_core.QueryField(
    fieldName: "submetric",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'SubMetric'));
  static final METRIC = amplify_core.QueryField(
    fieldName: "metric",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'SingleMetric'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "JoinSubMetric";
    modelSchemaDefinition.pluralName = "JoinSubMetrics";
    
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
      amplify_core.ModelIndex(fields: const ["metric_id"], name: "joinSubMetricsByMetric_id"),
      amplify_core.ModelIndex(fields: const ["submetric_id"], name: "joinSubMetricsBySubmetric_id")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: JoinSubMetric.TENANT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: JoinSubMetric.SUBMETRIC,
      isRequired: false,
      targetNames: ['submetric_id'],
      ofModelName: 'SubMetric'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: JoinSubMetric.METRIC,
      isRequired: false,
      targetNames: ['metric_id'],
      ofModelName: 'SingleMetric'
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

class _JoinSubMetricModelType extends amplify_core.ModelType<JoinSubMetric> {
  const _JoinSubMetricModelType();
  
  @override
  JoinSubMetric fromJson(Map<String, dynamic> jsonData) {
    return JoinSubMetric.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'JoinSubMetric';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [JoinSubMetric] in your schema.
 */
class JoinSubMetricModelIdentifier implements amplify_core.ModelIdentifier<JoinSubMetric> {
  final String id;

  /** Create an instance of JoinSubMetricModelIdentifier using [id] the primary key. */
  const JoinSubMetricModelIdentifier({
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
  String toString() => 'JoinSubMetricModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is JoinSubMetricModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}