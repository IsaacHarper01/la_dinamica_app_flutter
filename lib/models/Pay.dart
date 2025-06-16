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


/** This is an auto generated class representing the Pay type in your schema. */
class Pay extends amplify_core.Model {
  static const classType = const _PayModelType();
  final String id;
  final String? _composite_key;
  final int? _user_id;
  final double? _amount;
  final int? _clases;
  final String? _type;
  final amplify_core.TemporalDate? _date;
  final String? _client_id;
  final String? _prof_id;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  PayModelIdentifier get modelIdentifier {
      return PayModelIdentifier(
        id: id
      );
  }
  
  String? get composite_key {
    return _composite_key;
  }
  
  int? get user_id {
    return _user_id;
  }
  
  double? get amount {
    return _amount;
  }
  
  int? get clases {
    return _clases;
  }
  
  String? get type {
    return _type;
  }
  
  amplify_core.TemporalDate? get date {
    return _date;
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
  
  const Pay._internal({required this.id, composite_key, user_id, amount, clases, type, date, client_id, prof_id, createdAt, updatedAt}): _composite_key = composite_key, _user_id = user_id, _amount = amount, _clases = clases, _type = type, _date = date, _client_id = client_id, _prof_id = prof_id, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Pay({String? id, String? composite_key, int? user_id, double? amount, int? clases, String? type, amplify_core.TemporalDate? date, String? client_id, String? prof_id}) {
    return Pay._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      composite_key: composite_key,
      user_id: user_id,
      amount: amount,
      clases: clases,
      type: type,
      date: date,
      client_id: client_id,
      prof_id: prof_id);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Pay &&
      id == other.id &&
      _composite_key == other._composite_key &&
      _user_id == other._user_id &&
      _amount == other._amount &&
      _clases == other._clases &&
      _type == other._type &&
      _date == other._date &&
      _client_id == other._client_id &&
      _prof_id == other._prof_id;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Pay {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("composite_key=" + "$_composite_key" + ", ");
    buffer.write("user_id=" + (_user_id != null ? _user_id!.toString() : "null") + ", ");
    buffer.write("amount=" + (_amount != null ? _amount!.toString() : "null") + ", ");
    buffer.write("clases=" + (_clases != null ? _clases!.toString() : "null") + ", ");
    buffer.write("type=" + "$_type" + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("client_id=" + "$_client_id" + ", ");
    buffer.write("prof_id=" + "$_prof_id" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Pay copyWith({String? composite_key, int? user_id, double? amount, int? clases, String? type, amplify_core.TemporalDate? date, String? client_id, String? prof_id}) {
    return Pay._internal(
      id: id,
      composite_key: composite_key ?? this.composite_key,
      user_id: user_id ?? this.user_id,
      amount: amount ?? this.amount,
      clases: clases ?? this.clases,
      type: type ?? this.type,
      date: date ?? this.date,
      client_id: client_id ?? this.client_id,
      prof_id: prof_id ?? this.prof_id);
  }
  
  Pay copyWithModelFieldValues({
    ModelFieldValue<String?>? composite_key,
    ModelFieldValue<int?>? user_id,
    ModelFieldValue<double?>? amount,
    ModelFieldValue<int?>? clases,
    ModelFieldValue<String?>? type,
    ModelFieldValue<amplify_core.TemporalDate?>? date,
    ModelFieldValue<String?>? client_id,
    ModelFieldValue<String?>? prof_id
  }) {
    return Pay._internal(
      id: id,
      composite_key: composite_key == null ? this.composite_key : composite_key.value,
      user_id: user_id == null ? this.user_id : user_id.value,
      amount: amount == null ? this.amount : amount.value,
      clases: clases == null ? this.clases : clases.value,
      type: type == null ? this.type : type.value,
      date: date == null ? this.date : date.value,
      client_id: client_id == null ? this.client_id : client_id.value,
      prof_id: prof_id == null ? this.prof_id : prof_id.value
    );
  }
  
  Pay.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _composite_key = json['composite_key'],
      _user_id = (json['user_id'] as num?)?.toInt(),
      _amount = (json['amount'] as num?)?.toDouble(),
      _clases = (json['clases'] as num?)?.toInt(),
      _type = json['type'],
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _client_id = json['client_id'],
      _prof_id = json['prof_id'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'composite_key': _composite_key, 'user_id': _user_id, 'amount': _amount, 'clases': _clases, 'type': _type, 'date': _date?.format(), 'client_id': _client_id, 'prof_id': _prof_id, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'composite_key': _composite_key,
    'user_id': _user_id,
    'amount': _amount,
    'clases': _clases,
    'type': _type,
    'date': _date,
    'client_id': _client_id,
    'prof_id': _prof_id,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<PayModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<PayModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final COMPOSITE_KEY = amplify_core.QueryField(fieldName: "composite_key");
  static final USER_ID = amplify_core.QueryField(fieldName: "user_id");
  static final AMOUNT = amplify_core.QueryField(fieldName: "amount");
  static final CLASES = amplify_core.QueryField(fieldName: "clases");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final CLIENT_ID = amplify_core.QueryField(fieldName: "client_id");
  static final PROF_ID = amplify_core.QueryField(fieldName: "prof_id");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Pay";
    modelSchemaDefinition.pluralName = "Pays";
    
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
      key: Pay.COMPOSITE_KEY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Pay.USER_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Pay.AMOUNT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Pay.CLASES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Pay.TYPE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Pay.DATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Pay.CLIENT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Pay.PROF_ID,
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

class _PayModelType extends amplify_core.ModelType<Pay> {
  const _PayModelType();
  
  @override
  Pay fromJson(Map<String, dynamic> jsonData) {
    return Pay.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Pay';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Pay] in your schema.
 */
class PayModelIdentifier implements amplify_core.ModelIdentifier<Pay> {
  final String id;

  /** Create an instance of PayModelIdentifier using [id] the primary key. */
  const PayModelIdentifier({
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
  String toString() => 'PayModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is PayModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}