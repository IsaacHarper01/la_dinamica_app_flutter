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


/** This is an auto generated class representing the Attendance type in your schema. */
class Attendance extends amplify_core.Model {
  static const classType = const _AttendanceModelType();
  final String id;
  final amplify_core.TemporalDate? _date;
  final String? _client_id;
  final String? _prof_id;
  final bool? _status;
  final Student? _student;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  AttendanceModelIdentifier get modelIdentifier {
      return AttendanceModelIdentifier(
        id: id
      );
  }
  
  amplify_core.TemporalDate get date {
    try {
      return _date!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get client_id {
    return _client_id;
  }
  
  String? get prof_id {
    return _prof_id;
  }
  
  bool? get status {
    return _status;
  }
  
  Student? get student {
    return _student;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Attendance._internal({required this.id, required date, client_id, prof_id, status, student, createdAt, updatedAt}): _date = date, _client_id = client_id, _prof_id = prof_id, _status = status, _student = student, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Attendance({String? id, required amplify_core.TemporalDate date, String? client_id, String? prof_id, bool? status, Student? student}) {
    return Attendance._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      date: date,
      client_id: client_id,
      prof_id: prof_id,
      status: status,
      student: student);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Attendance &&
      id == other.id &&
      _date == other._date &&
      _client_id == other._client_id &&
      _prof_id == other._prof_id &&
      _status == other._status &&
      _student == other._student;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Attendance {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("client_id=" + "$_client_id" + ", ");
    buffer.write("prof_id=" + "$_prof_id" + ", ");
    buffer.write("status=" + (_status != null ? _status!.toString() : "null") + ", ");
    buffer.write("student=" + (_student != null ? _student!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Attendance copyWith({amplify_core.TemporalDate? date, String? client_id, String? prof_id, bool? status, Student? student}) {
    return Attendance._internal(
      id: id,
      date: date ?? this.date,
      client_id: client_id ?? this.client_id,
      prof_id: prof_id ?? this.prof_id,
      status: status ?? this.status,
      student: student ?? this.student);
  }
  
  Attendance copyWithModelFieldValues({
    ModelFieldValue<amplify_core.TemporalDate>? date,
    ModelFieldValue<String?>? client_id,
    ModelFieldValue<String?>? prof_id,
    ModelFieldValue<bool?>? status,
    ModelFieldValue<Student?>? student
  }) {
    return Attendance._internal(
      id: id,
      date: date == null ? this.date : date.value,
      client_id: client_id == null ? this.client_id : client_id.value,
      prof_id: prof_id == null ? this.prof_id : prof_id.value,
      status: status == null ? this.status : status.value,
      student: student == null ? this.student : student.value
    );
  }
  
  Attendance.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _client_id = json['client_id'],
      _prof_id = json['prof_id'],
      _status = json['status'],
      _student = json['student'] != null
        ? json['student']['serializedData'] != null
          ? Student.fromJson(new Map<String, dynamic>.from(json['student']['serializedData']))
          : Student.fromJson(new Map<String, dynamic>.from(json['student']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'date': _date?.format(), 'client_id': _client_id, 'prof_id': _prof_id, 'status': _status, 'student': _student?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'date': _date,
    'client_id': _client_id,
    'prof_id': _prof_id,
    'status': _status,
    'student': _student,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<AttendanceModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<AttendanceModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final CLIENT_ID = amplify_core.QueryField(fieldName: "client_id");
  static final PROF_ID = amplify_core.QueryField(fieldName: "prof_id");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final STUDENT = amplify_core.QueryField(
    fieldName: "student",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Student'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Attendance";
    modelSchemaDefinition.pluralName = "Attendances";
    
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
      key: Attendance.DATE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Attendance.CLIENT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Attendance.PROF_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Attendance.STATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Attendance.STUDENT,
      isRequired: false,
      targetNames: ['studentID'],
      ofModelName: 'Student'
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

class _AttendanceModelType extends amplify_core.ModelType<Attendance> {
  const _AttendanceModelType();
  
  @override
  Attendance fromJson(Map<String, dynamic> jsonData) {
    return Attendance.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Attendance';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Attendance] in your schema.
 */
class AttendanceModelIdentifier implements amplify_core.ModelIdentifier<Attendance> {
  final String id;

  /** Create an instance of AttendanceModelIdentifier using [id] the primary key. */
  const AttendanceModelIdentifier({
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
  String toString() => 'AttendanceModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is AttendanceModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}