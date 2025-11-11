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
import 'package:collection/collection.dart';


/** This is an auto generated class representing the ExamResults type in your schema. */
class ExamResults extends amplify_core.Model {
  static const classType = const _ExamResultsModelType();
  final String id;
  final amplify_core.TemporalDate? _date;
  final String? _prof_id;
  final String? _tenant_id;
  final String? _grades;
  final String? _types;
  final String? _tscore;
  final String? _higgerBetter;
  final Evaluations? _evaluation;
  final List<JoinResults>? _joinresult;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ExamResultsModelIdentifier get modelIdentifier {
      return ExamResultsModelIdentifier(
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
  
  String? get tscore {
    return _tscore;
  }
  
  String? get higgerBetter {
    return _higgerBetter;
  }
  
  Evaluations? get evaluation {
    return _evaluation;
  }
  
  List<JoinResults>? get joinresult {
    return _joinresult;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ExamResults._internal({required this.id, date, prof_id, tenant_id, grades, types, tscore, higgerBetter, evaluation, joinresult, createdAt, updatedAt}): _date = date, _prof_id = prof_id, _tenant_id = tenant_id, _grades = grades, _types = types, _tscore = tscore, _higgerBetter = higgerBetter, _evaluation = evaluation, _joinresult = joinresult, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ExamResults({String? id, amplify_core.TemporalDate? date, String? prof_id, String? tenant_id, String? grades, String? types, String? tscore, String? higgerBetter, Evaluations? evaluation, List<JoinResults>? joinresult}) {
    return ExamResults._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      date: date,
      prof_id: prof_id,
      tenant_id: tenant_id,
      grades: grades,
      types: types,
      tscore: tscore,
      higgerBetter: higgerBetter,
      evaluation: evaluation,
      joinresult: joinresult != null ? List<JoinResults>.unmodifiable(joinresult) : joinresult);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExamResults &&
      id == other.id &&
      _date == other._date &&
      _prof_id == other._prof_id &&
      _tenant_id == other._tenant_id &&
      _grades == other._grades &&
      _types == other._types &&
      _tscore == other._tscore &&
      _higgerBetter == other._higgerBetter &&
      _evaluation == other._evaluation &&
      DeepCollectionEquality().equals(_joinresult, other._joinresult);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ExamResults {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("prof_id=" + "$_prof_id" + ", ");
    buffer.write("tenant_id=" + "$_tenant_id" + ", ");
    buffer.write("grades=" + "$_grades" + ", ");
    buffer.write("types=" + "$_types" + ", ");
    buffer.write("tscore=" + "$_tscore" + ", ");
    buffer.write("higgerBetter=" + "$_higgerBetter" + ", ");
    buffer.write("evaluation=" + (_evaluation != null ? _evaluation!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ExamResults copyWith({amplify_core.TemporalDate? date, String? prof_id, String? tenant_id, String? grades, String? types, String? tscore, String? higgerBetter, Evaluations? evaluation, List<JoinResults>? joinresult}) {
    return ExamResults._internal(
      id: id,
      date: date ?? this.date,
      prof_id: prof_id ?? this.prof_id,
      tenant_id: tenant_id ?? this.tenant_id,
      grades: grades ?? this.grades,
      types: types ?? this.types,
      tscore: tscore ?? this.tscore,
      higgerBetter: higgerBetter ?? this.higgerBetter,
      evaluation: evaluation ?? this.evaluation,
      joinresult: joinresult ?? this.joinresult);
  }
  
  ExamResults copyWithModelFieldValues({
    ModelFieldValue<amplify_core.TemporalDate?>? date,
    ModelFieldValue<String?>? prof_id,
    ModelFieldValue<String?>? tenant_id,
    ModelFieldValue<String?>? grades,
    ModelFieldValue<String?>? types,
    ModelFieldValue<String?>? tscore,
    ModelFieldValue<String?>? higgerBetter,
    ModelFieldValue<Evaluations?>? evaluation,
    ModelFieldValue<List<JoinResults>?>? joinresult
  }) {
    return ExamResults._internal(
      id: id,
      date: date == null ? this.date : date.value,
      prof_id: prof_id == null ? this.prof_id : prof_id.value,
      tenant_id: tenant_id == null ? this.tenant_id : tenant_id.value,
      grades: grades == null ? this.grades : grades.value,
      types: types == null ? this.types : types.value,
      tscore: tscore == null ? this.tscore : tscore.value,
      higgerBetter: higgerBetter == null ? this.higgerBetter : higgerBetter.value,
      evaluation: evaluation == null ? this.evaluation : evaluation.value,
      joinresult: joinresult == null ? this.joinresult : joinresult.value
    );
  }
  
  ExamResults.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _prof_id = json['prof_id'],
      _tenant_id = json['tenant_id'],
      _grades = json['grades'],
      _types = json['types'],
      _tscore = json['tscore'],
      _higgerBetter = json['higgerBetter'],
      _evaluation = json['evaluation'] != null
        ? json['evaluation']['serializedData'] != null
          ? Evaluations.fromJson(new Map<String, dynamic>.from(json['evaluation']['serializedData']))
          : Evaluations.fromJson(new Map<String, dynamic>.from(json['evaluation']))
        : null,
      _joinresult = json['joinresult']  is Map
        ? (json['joinresult']['items'] is List
          ? (json['joinresult']['items'] as List)
              .where((e) => e != null)
              .map((e) => JoinResults.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['joinresult'] is List
          ? (json['joinresult'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => JoinResults.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'date': _date?.format(), 'prof_id': _prof_id, 'tenant_id': _tenant_id, 'grades': _grades, 'types': _types, 'tscore': _tscore, 'higgerBetter': _higgerBetter, 'evaluation': _evaluation?.toJson(), 'joinresult': _joinresult?.map((JoinResults? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'date': _date,
    'prof_id': _prof_id,
    'tenant_id': _tenant_id,
    'grades': _grades,
    'types': _types,
    'tscore': _tscore,
    'higgerBetter': _higgerBetter,
    'evaluation': _evaluation,
    'joinresult': _joinresult,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ExamResultsModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ExamResultsModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final PROF_ID = amplify_core.QueryField(fieldName: "prof_id");
  static final TENANT_ID = amplify_core.QueryField(fieldName: "tenant_id");
  static final GRADES = amplify_core.QueryField(fieldName: "grades");
  static final TYPES = amplify_core.QueryField(fieldName: "types");
  static final TSCORE = amplify_core.QueryField(fieldName: "tscore");
  static final HIGGERBETTER = amplify_core.QueryField(fieldName: "higgerBetter");
  static final EVALUATION = amplify_core.QueryField(
    fieldName: "evaluation",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Evaluations'));
  static final JOINRESULT = amplify_core.QueryField(
    fieldName: "joinresult",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'JoinResults'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ExamResults";
    modelSchemaDefinition.pluralName = "ExamResults";
    
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
      amplify_core.ModelIndex(fields: const ["evaluation_id"], name: "examResultsByEvaluation_id")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ExamResults.DATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ExamResults.PROF_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ExamResults.TENANT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ExamResults.GRADES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ExamResults.TYPES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ExamResults.TSCORE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ExamResults.HIGGERBETTER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: ExamResults.EVALUATION,
      isRequired: false,
      targetNames: ['evaluation_id'],
      ofModelName: 'Evaluations'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ExamResults.JOINRESULT,
      isRequired: false,
      ofModelName: 'JoinResults',
      associatedKey: JoinResults.RESULT
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

class _ExamResultsModelType extends amplify_core.ModelType<ExamResults> {
  const _ExamResultsModelType();
  
  @override
  ExamResults fromJson(Map<String, dynamic> jsonData) {
    return ExamResults.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ExamResults';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ExamResults] in your schema.
 */
class ExamResultsModelIdentifier implements amplify_core.ModelIdentifier<ExamResults> {
  final String id;

  /** Create an instance of ExamResultsModelIdentifier using [id] the primary key. */
  const ExamResultsModelIdentifier({
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
  String toString() => 'ExamResultsModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ExamResultsModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}