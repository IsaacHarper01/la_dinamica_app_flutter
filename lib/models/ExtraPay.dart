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


/** This is an auto generated class representing the ExtraPay type in your schema. */
class ExtraPay extends amplify_core.Model {
  static const classType = const _ExtraPayModelType();
  final String id;
  final double? _amount;
  final amplify_core.TemporalDate? _date;
  final String? _category;
  final String? _prof_id;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ExtraPayModelIdentifier get modelIdentifier {
      return ExtraPayModelIdentifier(
        id: id
      );
  }
  
  double? get amount {
    return _amount;
  }
  
  amplify_core.TemporalDate? get date {
    return _date;
  }
  
  String? get category {
    return _category;
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
  
  const ExtraPay._internal({required this.id, amount, date, category, prof_id, createdAt, updatedAt}): _amount = amount, _date = date, _category = category, _prof_id = prof_id, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ExtraPay({String? id, double? amount, amplify_core.TemporalDate? date, String? category, String? prof_id}) {
    return ExtraPay._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      amount: amount,
      date: date,
      category: category,
      prof_id: prof_id);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExtraPay &&
      id == other.id &&
      _amount == other._amount &&
      _date == other._date &&
      _category == other._category &&
      _prof_id == other._prof_id;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ExtraPay {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("amount=" + (_amount != null ? _amount!.toString() : "null") + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("category=" + "$_category" + ", ");
    buffer.write("prof_id=" + "$_prof_id" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ExtraPay copyWith({double? amount, amplify_core.TemporalDate? date, String? category, String? prof_id}) {
    return ExtraPay._internal(
      id: id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      prof_id: prof_id ?? this.prof_id);
  }
  
  ExtraPay copyWithModelFieldValues({
    ModelFieldValue<double?>? amount,
    ModelFieldValue<amplify_core.TemporalDate?>? date,
    ModelFieldValue<String?>? category,
    ModelFieldValue<String?>? prof_id
  }) {
    return ExtraPay._internal(
      id: id,
      amount: amount == null ? this.amount : amount.value,
      date: date == null ? this.date : date.value,
      category: category == null ? this.category : category.value,
      prof_id: prof_id == null ? this.prof_id : prof_id.value
    );
  }
  
  ExtraPay.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _amount = (json['amount'] as num?)?.toDouble(),
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _category = json['category'],
      _prof_id = json['prof_id'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'amount': _amount, 'date': _date?.format(), 'category': _category, 'prof_id': _prof_id, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'amount': _amount,
    'date': _date,
    'category': _category,
    'prof_id': _prof_id,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ExtraPayModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ExtraPayModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final AMOUNT = amplify_core.QueryField(fieldName: "amount");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final CATEGORY = amplify_core.QueryField(fieldName: "category");
  static final PROF_ID = amplify_core.QueryField(fieldName: "prof_id");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ExtraPay";
    modelSchemaDefinition.pluralName = "ExtraPays";
    
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
      key: ExtraPay.AMOUNT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ExtraPay.DATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ExtraPay.CATEGORY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ExtraPay.PROF_ID,
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

class _ExtraPayModelType extends amplify_core.ModelType<ExtraPay> {
  const _ExtraPayModelType();
  
  @override
  ExtraPay fromJson(Map<String, dynamic> jsonData) {
    return ExtraPay.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ExtraPay';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ExtraPay] in your schema.
 */
class ExtraPayModelIdentifier implements amplify_core.ModelIdentifier<ExtraPay> {
  final String id;

  /** Create an instance of ExtraPayModelIdentifier using [id] the primary key. */
  const ExtraPayModelIdentifier({
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
  String toString() => 'ExtraPayModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ExtraPayModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}