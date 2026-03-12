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


/** This is an auto generated class representing the Expense type in your schema. */
class Expense extends amplify_core.Model {
  static const classType = const _ExpenseModelType();
  final String id;
  final String? _name;
  final double? _amount;
  final amplify_core.TemporalDate? _date;
  final String? _description;
  final Tenant? _tenant;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ExpenseModelIdentifier get modelIdentifier {
      return ExpenseModelIdentifier(
        id: id
      );
  }
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get amount {
    try {
      return _amount!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
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
  
  String? get description {
    return _description;
  }
  
  Tenant? get tenant {
    return _tenant;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Expense._internal({required this.id, required name, required amount, required date, description, tenant, createdAt, updatedAt}): _name = name, _amount = amount, _date = date, _description = description, _tenant = tenant, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Expense({String? id, required String name, required double amount, required amplify_core.TemporalDate date, String? description, Tenant? tenant}) {
    return Expense._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      amount: amount,
      date: date,
      description: description,
      tenant: tenant);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Expense &&
      id == other.id &&
      _name == other._name &&
      _amount == other._amount &&
      _date == other._date &&
      _description == other._description &&
      _tenant == other._tenant;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Expense {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("amount=" + (_amount != null ? _amount!.toString() : "null") + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("tenant=" + (_tenant != null ? _tenant!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Expense copyWith({String? name, double? amount, amplify_core.TemporalDate? date, String? description, Tenant? tenant}) {
    return Expense._internal(
      id: id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
      tenant: tenant ?? this.tenant);
  }
  
  Expense copyWithModelFieldValues({
    ModelFieldValue<String>? name,
    ModelFieldValue<double>? amount,
    ModelFieldValue<amplify_core.TemporalDate>? date,
    ModelFieldValue<String?>? description,
    ModelFieldValue<Tenant?>? tenant
  }) {
    return Expense._internal(
      id: id,
      name: name == null ? this.name : name.value,
      amount: amount == null ? this.amount : amount.value,
      date: date == null ? this.date : date.value,
      description: description == null ? this.description : description.value,
      tenant: tenant == null ? this.tenant : tenant.value
    );
  }
  
  Expense.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _amount = (json['amount'] as num?)?.toDouble(),
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _description = json['description'],
      _tenant = json['tenant'] != null
        ? json['tenant']['serializedData'] != null
          ? Tenant.fromJson(new Map<String, dynamic>.from(json['tenant']['serializedData']))
          : Tenant.fromJson(new Map<String, dynamic>.from(json['tenant']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'amount': _amount, 'date': _date?.format(), 'description': _description, 'tenant': _tenant?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'amount': _amount,
    'date': _date,
    'description': _description,
    'tenant': _tenant,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ExpenseModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ExpenseModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final AMOUNT = amplify_core.QueryField(fieldName: "amount");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final TENANT = amplify_core.QueryField(
    fieldName: "tenant",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Tenant'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Expense";
    modelSchemaDefinition.pluralName = "Expenses";
    
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
      key: Expense.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Expense.AMOUNT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Expense.DATE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Expense.DESCRIPTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Expense.TENANT,
      isRequired: false,
      targetNames: ['tenant_id'],
      ofModelName: 'Tenant'
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

class _ExpenseModelType extends amplify_core.ModelType<Expense> {
  const _ExpenseModelType();
  
  @override
  Expense fromJson(Map<String, dynamic> jsonData) {
    return Expense.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Expense';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Expense] in your schema.
 */
class ExpenseModelIdentifier implements amplify_core.ModelIdentifier<Expense> {
  final String id;

  /** Create an instance of ExpenseModelIdentifier using [id] the primary key. */
  const ExpenseModelIdentifier({
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
  String toString() => 'ExpenseModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ExpenseModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}