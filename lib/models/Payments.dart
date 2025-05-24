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


/** This is an auto generated class representing the Payments type in your schema. */
class Payments extends amplify_core.Model {
  static const classType = const _PaymentsModelType();
  final String id;
  final int? _userId;
  final double? _amount;
  final int? _clases;
  final String? _type;
  final amplify_core.TemporalDate? _date;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  PaymentsModelIdentifier get modelIdentifier {
      return PaymentsModelIdentifier(
        id: id
      );
  }
  
  int? get userId {
    return _userId;
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
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Payments._internal({required this.id, userId, amount, clases, type, date, createdAt, updatedAt}): _userId = userId, _amount = amount, _clases = clases, _type = type, _date = date, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Payments({String? id, int? userId, double? amount, int? clases, String? type, amplify_core.TemporalDate? date}) {
    return Payments._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      userId: userId,
      amount: amount,
      clases: clases,
      type: type,
      date: date);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Payments &&
      id == other.id &&
      _userId == other._userId &&
      _amount == other._amount &&
      _clases == other._clases &&
      _type == other._type &&
      _date == other._date;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Payments {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + (_userId != null ? _userId!.toString() : "null") + ", ");
    buffer.write("amount=" + (_amount != null ? _amount!.toString() : "null") + ", ");
    buffer.write("clases=" + (_clases != null ? _clases!.toString() : "null") + ", ");
    buffer.write("type=" + "$_type" + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Payments copyWith({int? userId, double? amount, int? clases, String? type, amplify_core.TemporalDate? date}) {
    return Payments._internal(
      id: id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      clases: clases ?? this.clases,
      type: type ?? this.type,
      date: date ?? this.date);
  }
  
  Payments copyWithModelFieldValues({
    ModelFieldValue<int?>? userId,
    ModelFieldValue<double?>? amount,
    ModelFieldValue<int?>? clases,
    ModelFieldValue<String?>? type,
    ModelFieldValue<amplify_core.TemporalDate?>? date
  }) {
    return Payments._internal(
      id: id,
      userId: userId == null ? this.userId : userId.value,
      amount: amount == null ? this.amount : amount.value,
      clases: clases == null ? this.clases : clases.value,
      type: type == null ? this.type : type.value,
      date: date == null ? this.date : date.value
    );
  }
  
  Payments.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _userId = (json['userId'] as num?)?.toInt(),
      _amount = (json['amount'] as num?)?.toDouble(),
      _clases = (json['clases'] as num?)?.toInt(),
      _type = json['type'],
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'userId': _userId, 'amount': _amount, 'clases': _clases, 'type': _type, 'date': _date?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'userId': _userId,
    'amount': _amount,
    'clases': _clases,
    'type': _type,
    'date': _date,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<PaymentsModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<PaymentsModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final AMOUNT = amplify_core.QueryField(fieldName: "amount");
  static final CLASES = amplify_core.QueryField(fieldName: "clases");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Payments";
    modelSchemaDefinition.pluralName = "Payments";
    
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
      key: Payments.USERID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Payments.AMOUNT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Payments.CLASES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Payments.TYPE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Payments.DATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
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

class _PaymentsModelType extends amplify_core.ModelType<Payments> {
  const _PaymentsModelType();
  
  @override
  Payments fromJson(Map<String, dynamic> jsonData) {
    return Payments.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Payments';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Payments] in your schema.
 */
class PaymentsModelIdentifier implements amplify_core.ModelIdentifier<Payments> {
  final String id;

  /** Create an instance of PaymentsModelIdentifier using [id] the primary key. */
  const PaymentsModelIdentifier({
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
  String toString() => 'PaymentsModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is PaymentsModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}