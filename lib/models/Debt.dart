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


/** This is an auto generated class representing the Debt type in your schema. */
class Debt extends amplify_core.Model {
  static const classType = const _DebtModelType();
  final String id;
  final String? _tenant_id;
  final double? _price;
  final Student? _student;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  DebtModelIdentifier get modelIdentifier {
      return DebtModelIdentifier(
        id: id
      );
  }
  
  String? get tenant_id {
    return _tenant_id;
  }
  
  double? get price {
    return _price;
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
  
  const Debt._internal({required this.id, tenant_id, price, student, createdAt, updatedAt}): _tenant_id = tenant_id, _price = price, _student = student, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Debt({String? id, String? tenant_id, double? price, Student? student}) {
    return Debt._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      tenant_id: tenant_id,
      price: price,
      student: student);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Debt &&
      id == other.id &&
      _tenant_id == other._tenant_id &&
      _price == other._price &&
      _student == other._student;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Debt {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("tenant_id=" + "$_tenant_id" + ", ");
    buffer.write("price=" + (_price != null ? _price!.toString() : "null") + ", ");
    buffer.write("student=" + (_student != null ? _student!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Debt copyWith({String? tenant_id, double? price, Student? student}) {
    return Debt._internal(
      id: id,
      tenant_id: tenant_id ?? this.tenant_id,
      price: price ?? this.price,
      student: student ?? this.student);
  }
  
  Debt copyWithModelFieldValues({
    ModelFieldValue<String?>? tenant_id,
    ModelFieldValue<double?>? price,
    ModelFieldValue<Student?>? student
  }) {
    return Debt._internal(
      id: id,
      tenant_id: tenant_id == null ? this.tenant_id : tenant_id.value,
      price: price == null ? this.price : price.value,
      student: student == null ? this.student : student.value
    );
  }
  
  Debt.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _tenant_id = json['tenant_id'],
      _price = (json['price'] as num?)?.toDouble(),
      _student = json['student'] != null
        ? json['student']['serializedData'] != null
          ? Student.fromJson(new Map<String, dynamic>.from(json['student']['serializedData']))
          : Student.fromJson(new Map<String, dynamic>.from(json['student']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'tenant_id': _tenant_id, 'price': _price, 'student': _student?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'tenant_id': _tenant_id,
    'price': _price,
    'student': _student,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<DebtModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<DebtModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TENANT_ID = amplify_core.QueryField(fieldName: "tenant_id");
  static final PRICE = amplify_core.QueryField(fieldName: "price");
  static final STUDENT = amplify_core.QueryField(
    fieldName: "student",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Student'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Debt";
    modelSchemaDefinition.pluralName = "Debts";
    
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
      amplify_core.ModelIndex(fields: const ["studentID"], name: "debtByStudent")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Debt.TENANT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Debt.PRICE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Debt.STUDENT,
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

class _DebtModelType extends amplify_core.ModelType<Debt> {
  const _DebtModelType();
  
  @override
  Debt fromJson(Map<String, dynamic> jsonData) {
    return Debt.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Debt';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Debt] in your schema.
 */
class DebtModelIdentifier implements amplify_core.ModelIdentifier<Debt> {
  final String id;

  /** Create an instance of DebtModelIdentifier using [id] the primary key. */
  const DebtModelIdentifier({
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
  String toString() => 'DebtModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is DebtModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}