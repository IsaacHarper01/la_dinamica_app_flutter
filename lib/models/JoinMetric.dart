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


/** This is an auto generated class representing the JoinMetric type in your schema. */
class JoinMetric extends amplify_core.Model {
  static const classType = const _JoinMetricModelType();
  final String id;
  final String? _tenant_id;
  final Metric? _metric;
  final Evaluations? _evaluation;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  JoinMetricModelIdentifier get modelIdentifier {
      return JoinMetricModelIdentifier(
        id: id
      );
  }
  
  String? get tenant_id {
    return _tenant_id;
  }
  
  Metric? get metric {
    return _metric;
  }
  
  Evaluations? get evaluation {
    return _evaluation;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const JoinMetric._internal({required this.id, tenant_id, metric, evaluation, createdAt, updatedAt}): _tenant_id = tenant_id, _metric = metric, _evaluation = evaluation, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory JoinMetric({String? id, String? tenant_id, Metric? metric, Evaluations? evaluation}) {
    return JoinMetric._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      tenant_id: tenant_id,
      metric: metric,
      evaluation: evaluation);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JoinMetric &&
      id == other.id &&
      _tenant_id == other._tenant_id &&
      _metric == other._metric &&
      _evaluation == other._evaluation;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("JoinMetric {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("tenant_id=" + "$_tenant_id" + ", ");
    buffer.write("metric=" + (_metric != null ? _metric!.toString() : "null") + ", ");
    buffer.write("evaluation=" + (_evaluation != null ? _evaluation!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  JoinMetric copyWith({String? tenant_id, Metric? metric, Evaluations? evaluation}) {
    return JoinMetric._internal(
      id: id,
      tenant_id: tenant_id ?? this.tenant_id,
      metric: metric ?? this.metric,
      evaluation: evaluation ?? this.evaluation);
  }
  
  JoinMetric copyWithModelFieldValues({
    ModelFieldValue<String?>? tenant_id,
    ModelFieldValue<Metric?>? metric,
    ModelFieldValue<Evaluations?>? evaluation
  }) {
    return JoinMetric._internal(
      id: id,
      tenant_id: tenant_id == null ? this.tenant_id : tenant_id.value,
      metric: metric == null ? this.metric : metric.value,
      evaluation: evaluation == null ? this.evaluation : evaluation.value
    );
  }
  
  JoinMetric.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _tenant_id = json['tenant_id'],
      _metric = json['metric'] != null
        ? json['metric']['serializedData'] != null
          ? Metric.fromJson(new Map<String, dynamic>.from(json['metric']['serializedData']))
          : Metric.fromJson(new Map<String, dynamic>.from(json['metric']))
        : null,
      _evaluation = json['evaluation'] != null
        ? json['evaluation']['serializedData'] != null
          ? Evaluations.fromJson(new Map<String, dynamic>.from(json['evaluation']['serializedData']))
          : Evaluations.fromJson(new Map<String, dynamic>.from(json['evaluation']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'tenant_id': _tenant_id, 'metric': _metric?.toJson(), 'evaluation': _evaluation?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'tenant_id': _tenant_id,
    'metric': _metric,
    'evaluation': _evaluation,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<JoinMetricModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<JoinMetricModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TENANT_ID = amplify_core.QueryField(fieldName: "tenant_id");
  static final METRIC = amplify_core.QueryField(
    fieldName: "metric",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Metric'));
  static final EVALUATION = amplify_core.QueryField(
    fieldName: "evaluation",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Evaluations'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "JoinMetric";
    modelSchemaDefinition.pluralName = "JoinMetrics";
    
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
      amplify_core.ModelIndex(fields: const ["metric_id"], name: "joinMetricsByMetric_id"),
      amplify_core.ModelIndex(fields: const ["evaluation_id"], name: "joinMetricsByEvaluation_id")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: JoinMetric.TENANT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: JoinMetric.METRIC,
      isRequired: false,
      targetNames: ['metric_id'],
      ofModelName: 'Metric'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: JoinMetric.EVALUATION,
      isRequired: false,
      targetNames: ['evaluation_id'],
      ofModelName: 'Evaluations'
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

class _JoinMetricModelType extends amplify_core.ModelType<JoinMetric> {
  const _JoinMetricModelType();
  
  @override
  JoinMetric fromJson(Map<String, dynamic> jsonData) {
    return JoinMetric.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'JoinMetric';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [JoinMetric] in your schema.
 */
class JoinMetricModelIdentifier implements amplify_core.ModelIdentifier<JoinMetric> {
  final String id;

  /** Create an instance of JoinMetricModelIdentifier using [id] the primary key. */
  const JoinMetricModelIdentifier({
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
  String toString() => 'JoinMetricModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is JoinMetricModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}