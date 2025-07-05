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


/** This is an auto generated class representing the Metric type in your schema. */
class Metric extends amplify_core.Model {
  static const classType = const _MetricModelType();
  final String id;
  final int? _user_id;
  final String? _metric;
  final amplify_core.TemporalDate? _date;
  final double? _value;
  final String? _client_id;
  final String? _prof_id;
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
  
  int? get user_id {
    return _user_id;
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
  
  String? get client_id {
    return _client_id;
  }
  
  String? get prof_id {
    return _prof_id;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Metric._internal({required this.id, user_id, metric, date, value, client_id, prof_id, createdAt, updatedAt}): _user_id = user_id, _metric = metric, _date = date, _value = value, _client_id = client_id, _prof_id = prof_id, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Metric({String? id, int? user_id, String? metric, amplify_core.TemporalDate? date, double? value, String? client_id, String? prof_id}) {
    return Metric._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      user_id: user_id,
      metric: metric,
      date: date,
      value: value,
      client_id: client_id,
      prof_id: prof_id);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Metric &&
      id == other.id &&
      _user_id == other._user_id &&
      _metric == other._metric &&
      _date == other._date &&
      _value == other._value &&
      _client_id == other._client_id &&
      _prof_id == other._prof_id;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Metric {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + (_user_id != null ? _user_id.toString() : "null") + ", ");
    buffer.write("metric=" + "$_metric" + ", ");
    buffer.write("date=" + (_date != null ? _date.format() : "null") + ", ");
    buffer.write("value=" + (_value != null ? _value.toString() : "null") + ", ");
    buffer.write("client_id=" + "$_client_id" + ", ");
    buffer.write("prof_id=" + "$_prof_id" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Metric copyWith({int? user_id, String? metric, amplify_core.TemporalDate? date, double? value, String? client_id, String? prof_id}) {
    return Metric._internal(
      id: id,
      user_id: user_id ?? this.user_id,
      metric: metric ?? this.metric,
      date: date ?? this.date,
      value: value ?? this.value,
      client_id: client_id ?? this.client_id,
      prof_id: prof_id ?? this.prof_id);
  }
  
  Metric copyWithModelFieldValues({
    ModelFieldValue<int?>? user_id,
    ModelFieldValue<String?>? metric,
    ModelFieldValue<amplify_core.TemporalDate?>? date,
    ModelFieldValue<double?>? value,
    ModelFieldValue<String?>? client_id,
    ModelFieldValue<String?>? prof_id
  }) {
    return Metric._internal(
      id: id,
      user_id: user_id == null ? this.user_id : user_id.value,
      metric: metric == null ? this.metric : metric.value,
      date: date == null ? this.date : date.value,
      value: value == null ? this.value : value.value,
      client_id: client_id == null ? this.client_id : client_id.value,
      prof_id: prof_id == null ? this.prof_id : prof_id.value
    );
  }
  
  Metric.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = (json['user_id'] as num?)?.toInt(),
      _metric = json['metric'],
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _value = (json['value'] as num?)?.toDouble(),
      _client_id = json['client_id'],
      _prof_id = json['prof_id'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'metric': _metric, 'date': _date?.format(), 'value': _value, 'client_id': _client_id, 'prof_id': _prof_id, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'user_id': _user_id,
    'metric': _metric,
    'date': _date,
    'value': _value,
    'client_id': _client_id,
    'prof_id': _prof_id,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<MetricModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<MetricModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USER_ID = amplify_core.QueryField(fieldName: "user_id");
  static final METRIC = amplify_core.QueryField(fieldName: "metric");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final VALUE = amplify_core.QueryField(fieldName: "value");
  static final CLIENT_ID = amplify_core.QueryField(fieldName: "client_id");
  static final PROF_ID = amplify_core.QueryField(fieldName: "prof_id");
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
      key: Metric.USER_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Metric.METRIC,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Metric.DATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Metric.VALUE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Metric.CLIENT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Metric.PROF_ID,
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