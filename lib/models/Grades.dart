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


/** This is an auto generated class representing the Grades type in your schema. */
class Grades extends amplify_core.Model {
  static const classType = const _GradesModelType();
  final String id;
  final amplify_core.TemporalDate? _date;
  final String? _prof_id;
  final String? _tenant_id;
  final String? _grades;
  final String? _types;
  final String? _examTree;
  final String? _totals;
  final Student? _student;
  final Evaluations? _evaluation;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  GradesModelIdentifier get modelIdentifier {
      return GradesModelIdentifier(
        id: id
      );
  }
  
  amplify_core.TemporalDate? get date {
    return _date;
  }
  
  String? get prof_id {
    return _prof_id;
  }
  
  String? get tenant_id {
    return _tenant_id;
  }
  
  String? get grades {
    return _grades;
  }
  
  String? get types {
    return _types;
  }
  
  String? get examTree {
    return _examTree;
  }
  
  String? get totals {
    return _totals;
  }
  
  Student? get student {
    return _student;
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
  
  const Grades._internal({required this.id, date, prof_id, tenant_id, grades, types, examTree, totals, student, evaluation, createdAt, updatedAt}): _date = date, _prof_id = prof_id, _tenant_id = tenant_id, _grades = grades, _types = types, _examTree = examTree, _totals = totals, _student = student, _evaluation = evaluation, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Grades({String? id, amplify_core.TemporalDate? date, String? prof_id, String? tenant_id, String? grades, String? types, String? examTree, String? totals, Student? student, Evaluations? evaluation}) {
    return Grades._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      date: date,
      prof_id: prof_id,
      tenant_id: tenant_id,
      grades: grades,
      types: types,
      examTree: examTree,
      totals: totals,
      student: student,
      evaluation: evaluation);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Grades &&
      id == other.id &&
      _date == other._date &&
      _prof_id == other._prof_id &&
      _tenant_id == other._tenant_id &&
      _grades == other._grades &&
      _types == other._types &&
      _examTree == other._examTree &&
      _totals == other._totals &&
      _student == other._student &&
      _evaluation == other._evaluation;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Grades {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("prof_id=" + "$_prof_id" + ", ");
    buffer.write("tenant_id=" + "$_tenant_id" + ", ");
    buffer.write("grades=" + "$_grades" + ", ");
    buffer.write("types=" + "$_types" + ", ");
    buffer.write("examTree=" + "$_examTree" + ", ");
    buffer.write("totals=" + "$_totals" + ", ");
    buffer.write("student=" + (_student != null ? _student!.toString() : "null") + ", ");
    buffer.write("evaluation=" + (_evaluation != null ? _evaluation!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Grades copyWith({amplify_core.TemporalDate? date, String? prof_id, String? tenant_id, String? grades, String? types, String? examTree, String? totals, Student? student, Evaluations? evaluation}) {
    return Grades._internal(
      id: id,
      date: date ?? this.date,
      prof_id: prof_id ?? this.prof_id,
      tenant_id: tenant_id ?? this.tenant_id,
      grades: grades ?? this.grades,
      types: types ?? this.types,
      examTree: examTree ?? this.examTree,
      totals: totals ?? this.totals,
      student: student ?? this.student,
      evaluation: evaluation ?? this.evaluation);
  }
  
  Grades copyWithModelFieldValues({
    ModelFieldValue<amplify_core.TemporalDate?>? date,
    ModelFieldValue<String?>? prof_id,
    ModelFieldValue<String?>? tenant_id,
    ModelFieldValue<String?>? grades,
    ModelFieldValue<String?>? types,
    ModelFieldValue<String?>? examTree,
    ModelFieldValue<String?>? totals,
    ModelFieldValue<Student?>? student,
    ModelFieldValue<Evaluations?>? evaluation
  }) {
    return Grades._internal(
      id: id,
      date: date == null ? this.date : date.value,
      prof_id: prof_id == null ? this.prof_id : prof_id.value,
      tenant_id: tenant_id == null ? this.tenant_id : tenant_id.value,
      grades: grades == null ? this.grades : grades.value,
      types: types == null ? this.types : types.value,
      examTree: examTree == null ? this.examTree : examTree.value,
      totals: totals == null ? this.totals : totals.value,
      student: student == null ? this.student : student.value,
      evaluation: evaluation == null ? this.evaluation : evaluation.value
    );
  }
  
  Grades.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _prof_id = json['prof_id'],
      _tenant_id = json['tenant_id'],
      _grades = json['grades'],
      _types = json['types'],
      _examTree = json['examTree'],
      _totals = json['totals'],
      _student = json['student'] != null
        ? json['student']['serializedData'] != null
          ? Student.fromJson(new Map<String, dynamic>.from(json['student']['serializedData']))
          : Student.fromJson(new Map<String, dynamic>.from(json['student']))
        : null,
      _evaluation = json['evaluation'] != null
        ? json['evaluation']['serializedData'] != null
          ? Evaluations.fromJson(new Map<String, dynamic>.from(json['evaluation']['serializedData']))
          : Evaluations.fromJson(new Map<String, dynamic>.from(json['evaluation']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'date': _date?.format(), 'prof_id': _prof_id, 'tenant_id': _tenant_id, 'grades': _grades, 'types': _types, 'examTree': _examTree, 'totals': _totals, 'student': _student?.toJson(), 'evaluation': _evaluation?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'date': _date,
    'prof_id': _prof_id,
    'tenant_id': _tenant_id,
    'grades': _grades,
    'types': _types,
    'examTree': _examTree,
    'totals': _totals,
    'student': _student,
    'evaluation': _evaluation,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<GradesModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<GradesModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final PROF_ID = amplify_core.QueryField(fieldName: "prof_id");
  static final TENANT_ID = amplify_core.QueryField(fieldName: "tenant_id");
  static final GRADES = amplify_core.QueryField(fieldName: "grades");
  static final TYPES = amplify_core.QueryField(fieldName: "types");
  static final EXAMTREE = amplify_core.QueryField(fieldName: "examTree");
  static final TOTALS = amplify_core.QueryField(fieldName: "totals");
  static final STUDENT = amplify_core.QueryField(
    fieldName: "student",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Student'));
  static final EVALUATION = amplify_core.QueryField(
    fieldName: "evaluation",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Evaluations'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Grades";
    modelSchemaDefinition.pluralName = "Grades";
    
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
      amplify_core.ModelIndex(fields: const ["studentID"], name: "byStudent"),
      amplify_core.ModelIndex(fields: const ["evaluationID"], name: "byEvaluation")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Grades.DATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Grades.PROF_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Grades.TENANT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Grades.GRADES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Grades.TYPES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Grades.EXAMTREE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Grades.TOTALS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Grades.STUDENT,
      isRequired: false,
      targetNames: ['studentID'],
      ofModelName: 'Student'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Grades.EVALUATION,
      isRequired: false,
      targetNames: ['evaluationID'],
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

class _GradesModelType extends amplify_core.ModelType<Grades> {
  const _GradesModelType();
  
  @override
  Grades fromJson(Map<String, dynamic> jsonData) {
    return Grades.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Grades';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Grades] in your schema.
 */
class GradesModelIdentifier implements amplify_core.ModelIdentifier<Grades> {
  final String id;

  /** Create an instance of GradesModelIdentifier using [id] the primary key. */
  const GradesModelIdentifier({
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
  String toString() => 'GradesModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is GradesModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}