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


/** This is an auto generated class representing the StudentExamResults type in your schema. */
class StudentExamResults extends amplify_core.Model {
  static const classType = const _StudentExamResultsModelType();
  final String id;
  final amplify_core.TemporalDate? _date;
  final String? _tenant_id;
  final String? _grades;
  final String? _tscores;
  final Evaluations? _evaluation;
  final Student? _student;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  StudentExamResultsModelIdentifier get modelIdentifier {
      return StudentExamResultsModelIdentifier(
        id: id
      );
  }
  
  amplify_core.TemporalDate? get date {
    return _date;
  }
  
  String? get tenant_id {
    return _tenant_id;
  }
  
  String? get grades {
    return _grades;
  }
  
  String? get tscores {
    return _tscores;
  }
  
  Evaluations? get evaluation {
    return _evaluation;
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
  
  const StudentExamResults._internal({required this.id, date, tenant_id, grades, tscores, evaluation, student, createdAt, updatedAt}): _date = date, _tenant_id = tenant_id, _grades = grades, _tscores = tscores, _evaluation = evaluation, _student = student, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory StudentExamResults({String? id, amplify_core.TemporalDate? date, String? tenant_id, String? grades, String? tscores, Evaluations? evaluation, Student? student}) {
    return StudentExamResults._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      date: date,
      tenant_id: tenant_id,
      grades: grades,
      tscores: tscores,
      evaluation: evaluation,
      student: student);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StudentExamResults &&
      id == other.id &&
      _date == other._date &&
      _tenant_id == other._tenant_id &&
      _grades == other._grades &&
      _tscores == other._tscores &&
      _evaluation == other._evaluation &&
      _student == other._student;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("StudentExamResults {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("tenant_id=" + "$_tenant_id" + ", ");
    buffer.write("grades=" + "$_grades" + ", ");
    buffer.write("tscores=" + "$_tscores" + ", ");
    buffer.write("evaluation=" + (_evaluation != null ? _evaluation!.toString() : "null") + ", ");
    buffer.write("student=" + (_student != null ? _student!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  StudentExamResults copyWith({amplify_core.TemporalDate? date, String? tenant_id, String? grades, String? tscores, Evaluations? evaluation, Student? student}) {
    return StudentExamResults._internal(
      id: id,
      date: date ?? this.date,
      tenant_id: tenant_id ?? this.tenant_id,
      grades: grades ?? this.grades,
      tscores: tscores ?? this.tscores,
      evaluation: evaluation ?? this.evaluation,
      student: student ?? this.student);
  }
  
  StudentExamResults copyWithModelFieldValues({
    ModelFieldValue<amplify_core.TemporalDate?>? date,
    ModelFieldValue<String?>? tenant_id,
    ModelFieldValue<String?>? grades,
    ModelFieldValue<String?>? tscores,
    ModelFieldValue<Evaluations?>? evaluation,
    ModelFieldValue<Student?>? student
  }) {
    return StudentExamResults._internal(
      id: id,
      date: date == null ? this.date : date.value,
      tenant_id: tenant_id == null ? this.tenant_id : tenant_id.value,
      grades: grades == null ? this.grades : grades.value,
      tscores: tscores == null ? this.tscores : tscores.value,
      evaluation: evaluation == null ? this.evaluation : evaluation.value,
      student: student == null ? this.student : student.value
    );
  }
  
  StudentExamResults.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _tenant_id = json['tenant_id'],
      _grades = json['grades'],
      _tscores = json['tscores'],
      _evaluation = json['evaluation'] != null
        ? json['evaluation']['serializedData'] != null
          ? Evaluations.fromJson(new Map<String, dynamic>.from(json['evaluation']['serializedData']))
          : Evaluations.fromJson(new Map<String, dynamic>.from(json['evaluation']))
        : null,
      _student = json['student'] != null
        ? json['student']['serializedData'] != null
          ? Student.fromJson(new Map<String, dynamic>.from(json['student']['serializedData']))
          : Student.fromJson(new Map<String, dynamic>.from(json['student']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'date': _date?.format(), 'tenant_id': _tenant_id, 'grades': _grades, 'tscores': _tscores, 'evaluation': _evaluation?.toJson(), 'student': _student?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'date': _date,
    'tenant_id': _tenant_id,
    'grades': _grades,
    'tscores': _tscores,
    'evaluation': _evaluation,
    'student': _student,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<StudentExamResultsModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<StudentExamResultsModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final TENANT_ID = amplify_core.QueryField(fieldName: "tenant_id");
  static final GRADES = amplify_core.QueryField(fieldName: "grades");
  static final TSCORES = amplify_core.QueryField(fieldName: "tscores");
  static final EVALUATION = amplify_core.QueryField(
    fieldName: "evaluation",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Evaluations'));
  static final STUDENT = amplify_core.QueryField(
    fieldName: "student",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Student'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "StudentExamResults";
    modelSchemaDefinition.pluralName = "StudentExamResults";
    
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
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["evaluation_id"], name: "studentExamResultsByEvaluation_id"),
      amplify_core.ModelIndex(fields: const ["student_id"], name: "studentExamResultsByStudent_id")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentExamResults.DATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentExamResults.TENANT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentExamResults.GRADES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentExamResults.TSCORES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: StudentExamResults.EVALUATION,
      isRequired: false,
      targetNames: ['evaluation_id'],
      ofModelName: 'Evaluations'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: StudentExamResults.STUDENT,
      isRequired: false,
      targetNames: ['student_id'],
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

class _StudentExamResultsModelType extends amplify_core.ModelType<StudentExamResults> {
  const _StudentExamResultsModelType();
  
  @override
  StudentExamResults fromJson(Map<String, dynamic> jsonData) {
    return StudentExamResults.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'StudentExamResults';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [StudentExamResults] in your schema.
 */
class StudentExamResultsModelIdentifier implements amplify_core.ModelIdentifier<StudentExamResults> {
  final String id;

  /** Create an instance of StudentExamResultsModelIdentifier using [id] the primary key. */
  const StudentExamResultsModelIdentifier({
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
  String toString() => 'StudentExamResultsModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is StudentExamResultsModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}