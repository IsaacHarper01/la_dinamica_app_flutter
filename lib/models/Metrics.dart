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


/** This is an auto generated class representing the Metrics type in your schema. */
class Metrics extends amplify_core.Model {
  static const classType = const _MetricsModelType();
  final String id;
  final String? _userId;
  final String? _metric;
  final amplify_core.TemporalDate? _date;
  final double? _value;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  MetricsModelIdentifier get modelIdentifier {
      return MetricsModelIdentifier(
        id: id
      );
  }
  
  String? get userId {
    return _userId;
  }
  
  String? get metric {
    return _metric;
  }
  
  amplify_core.TemporalDate? get date {
    return _date;
  }
  
  double? get value {
    return _value;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Metrics._internal({required this.id, userId, metric, date, value, createdAt, updatedAt}): _userId = userId, _metric = metric, _date = date, _value = value, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Metrics({String? id, String? userId, String? metric, amplify_core.TemporalDate? date, double? value}) {
    return Metrics._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      userId: userId,
      metric: metric,
      date: date,
      value: value);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Metrics &&
      id == other.id &&
      _userId == other._userId &&
      _metric == other._metric &&
      _date == other._date &&
      _value == other._value;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Metrics {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("metric=" + "$_metric" + ", ");
    buffer.write("date=" + (_date != null ? _date.format() : "null") + ", ");
    buffer.write("value=" + (_value != null ? _value.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Metrics copyWith({String? userId, String? metric, amplify_core.TemporalDate? date, double? value}) {
    return Metrics._internal(
      id: id,
      userId: userId ?? this.userId,
      metric: metric ?? this.metric,
      date: date ?? this.date,
      value: value ?? this.value);
  }
  
  Metrics copyWithModelFieldValues({
    ModelFieldValue<String?>? userId,
    ModelFieldValue<String?>? metric,
    ModelFieldValue<amplify_core.TemporalDate?>? date,
    ModelFieldValue<double?>? value
  }) {
    return Metrics._internal(
      id: id,
      userId: userId == null ? this.userId : userId.value,
      metric: metric == null ? this.metric : metric.value,
      date: date == null ? this.date : date.value,
      value: value == null ? this.value : value.value
    );
  }
  
  Metrics.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _userId = json['userId'],
      _metric = json['metric'],
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _value = (json['value'] as num?)?.toDouble(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'userId': _userId, 'metric': _metric, 'date': _date?.format(), 'value': _value, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'userId': _userId,
    'metric': _metric,
    'date': _date,
    'value': _value,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<MetricsModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<MetricsModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final METRIC = amplify_core.QueryField(fieldName: "metric");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final VALUE = amplify_core.QueryField(fieldName: "value");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Metrics";
    modelSchemaDefinition.pluralName = "Metrics";
    
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
      key: Metrics.USERID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Metrics.METRIC,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Metrics.DATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Metrics.VALUE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
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

class _MetricsModelType extends amplify_core.ModelType<Metrics> {
  const _MetricsModelType();
  
  @override
  Metrics fromJson(Map<String, dynamic> jsonData) {
    return Metrics.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Metrics';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Metrics] in your schema.
 */
class MetricsModelIdentifier implements amplify_core.ModelIdentifier<Metrics> {
  final String id;

  /** Create an instance of MetricsModelIdentifier using [id] the primary key. */
  const MetricsModelIdentifier({
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
  String toString() => 'MetricsModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is MetricsModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}