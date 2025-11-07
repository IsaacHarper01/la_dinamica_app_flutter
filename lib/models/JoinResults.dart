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


/** This is an auto generated class representing the JoinResults type in your schema. */
class JoinResults extends amplify_core.Model {
  static const classType = const _JoinResultsModelType();
  final String id;
  final String? _tenant_id;
  final Student? _student;
  final ExamResults? _result;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  JoinResultsModelIdentifier get modelIdentifier {
      return JoinResultsModelIdentifier(
        id: id
      );
  }
  
  String? get tenant_id {
    return _tenant_id;
  }
  
  Student? get student {
    return _student;
  }
  
  ExamResults? get result {
    return _result;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const JoinResults._internal({required this.id, tenant_id, student, result, createdAt, updatedAt}): _tenant_id = tenant_id, _student = student, _result = result, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory JoinResults({String? id, String? tenant_id, Student? student, ExamResults? result}) {
    return JoinResults._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      tenant_id: tenant_id,
      student: student,
      result: result);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JoinResults &&
      id == other.id &&
      _tenant_id == other._tenant_id &&
      _student == other._student &&
      _result == other._result;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("JoinResults {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("tenant_id=" + "$_tenant_id" + ", ");
    buffer.write("student=" + (_student != null ? _student!.toString() : "null") + ", ");
    buffer.write("result=" + (_result != null ? _result!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  JoinResults copyWith({String? tenant_id, Student? student, ExamResults? result}) {
    return JoinResults._internal(
      id: id,
      tenant_id: tenant_id ?? this.tenant_id,
      student: student ?? this.student,
      result: result ?? this.result);
  }
  
  JoinResults copyWithModelFieldValues({
    ModelFieldValue<String?>? tenant_id,
    ModelFieldValue<Student?>? student,
    ModelFieldValue<ExamResults?>? result
  }) {
    return JoinResults._internal(
      id: id,
      tenant_id: tenant_id == null ? this.tenant_id : tenant_id.value,
      student: student == null ? this.student : student.value,
      result: result == null ? this.result : result.value
    );
  }
  
  JoinResults.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _tenant_id = json['tenant_id'],
      _student = json['student'] != null
        ? json['student']['serializedData'] != null
          ? Student.fromJson(new Map<String, dynamic>.from(json['student']['serializedData']))
          : Student.fromJson(new Map<String, dynamic>.from(json['student']))
        : null,
      _result = json['result'] != null
        ? json['result']['serializedData'] != null
          ? ExamResults.fromJson(new Map<String, dynamic>.from(json['result']['serializedData']))
          : ExamResults.fromJson(new Map<String, dynamic>.from(json['result']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'tenant_id': _tenant_id, 'student': _student?.toJson(), 'result': _result?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'tenant_id': _tenant_id,
    'student': _student,
    'result': _result,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<JoinResultsModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<JoinResultsModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TENANT_ID = amplify_core.QueryField(fieldName: "tenant_id");
  static final STUDENT = amplify_core.QueryField(
    fieldName: "student",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Student'));
  static final RESULT = amplify_core.QueryField(
    fieldName: "result",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ExamResults'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "JoinResults";
    modelSchemaDefinition.pluralName = "JoinResults";
    
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
      amplify_core.ModelIndex(fields: const ["student_id"], name: "joinResultsByStudent_id"),
      amplify_core.ModelIndex(fields: const ["result_id"], name: "joinResultsByResult_id")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: JoinResults.TENANT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: JoinResults.STUDENT,
      isRequired: false,
      targetNames: ['student_id'],
      ofModelName: 'Student'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: JoinResults.RESULT,
      isRequired: false,
      targetNames: ['result_id'],
      ofModelName: 'ExamResults'
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

class _JoinResultsModelType extends amplify_core.ModelType<JoinResults> {
  const _JoinResultsModelType();
  
  @override
  JoinResults fromJson(Map<String, dynamic> jsonData) {
    return JoinResults.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'JoinResults';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [JoinResults] in your schema.
 */
class JoinResultsModelIdentifier implements amplify_core.ModelIdentifier<JoinResults> {
  final String id;

  /** Create an instance of JoinResultsModelIdentifier using [id] the primary key. */
  const JoinResultsModelIdentifier({
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
  String toString() => 'JoinResultsModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is JoinResultsModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}