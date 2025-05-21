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


/** This is an auto generated class representing the General type in your schema. */
class General extends amplify_core.Model {
  static const classType = const _GeneralModelType();
  final String id;
  final String? _name;
  final String? _address;
  final String? _phone;
  final int? _age;
  final amplify_core.TemporalDate? _birthday;
  final String? _email;
  final String? _image;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  GeneralModelIdentifier get modelIdentifier {
      return GeneralModelIdentifier(
        id: id
      );
  }
  
  String? get name {
    return _name;
  }
  
  String? get address {
    return _address;
  }
  
  String? get phone {
    return _phone;
  }
  
  int? get age {
    return _age;
  }
  
  amplify_core.TemporalDate? get birthday {
    return _birthday;
  }
  
  String? get email {
    return _email;
  }
  
  String? get image {
    return _image;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const General._internal({required this.id, name, address, phone, age, birthday, email, image, createdAt, updatedAt}): _name = name, _address = address, _phone = phone, _age = age, _birthday = birthday, _email = email, _image = image, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory General({String? id, String? name, String? address, String? phone, int? age, amplify_core.TemporalDate? birthday, String? email, String? image}) {
    return General._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      address: address,
      phone: phone,
      age: age,
      birthday: birthday,
      email: email,
      image: image);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is General &&
      id == other.id &&
      _name == other._name &&
      _address == other._address &&
      _phone == other._phone &&
      _age == other._age &&
      _birthday == other._birthday &&
      _email == other._email &&
      _image == other._image;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("General {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("address=" + "$_address" + ", ");
    buffer.write("phone=" + "$_phone" + ", ");
    buffer.write("age=" + (_age != null ? _age!.toString() : "null") + ", ");
    buffer.write("birthday=" + (_birthday != null ? _birthday!.format() : "null") + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("image=" + "$_image" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  General copyWith({String? name, String? address, String? phone, int? age, amplify_core.TemporalDate? birthday, String? email, String? image}) {
    return General._internal(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      birthday: birthday ?? this.birthday,
      email: email ?? this.email,
      image: image ?? this.image);
  }
  
  General copyWithModelFieldValues({
    ModelFieldValue<String?>? name,
    ModelFieldValue<String?>? address,
    ModelFieldValue<String?>? phone,
    ModelFieldValue<int?>? age,
    ModelFieldValue<amplify_core.TemporalDate?>? birthday,
    ModelFieldValue<String?>? email,
    ModelFieldValue<String?>? image
  }) {
    return General._internal(
      id: id,
      name: name == null ? this.name : name.value,
      address: address == null ? this.address : address.value,
      phone: phone == null ? this.phone : phone.value,
      age: age == null ? this.age : age.value,
      birthday: birthday == null ? this.birthday : birthday.value,
      email: email == null ? this.email : email.value,
      image: image == null ? this.image : image.value
    );
  }
  
  General.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _address = json['address'],
      _phone = json['phone'],
      _age = (json['age'] as num?)?.toInt(),
      _birthday = json['birthday'] != null ? amplify_core.TemporalDate.fromString(json['birthday']) : null,
      _email = json['email'],
      _image = json['image'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'address': _address, 'phone': _phone, 'age': _age, 'birthday': _birthday?.format(), 'email': _email, 'image': _image, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'address': _address,
    'phone': _phone,
    'age': _age,
    'birthday': _birthday,
    'email': _email,
    'image': _image,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<GeneralModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<GeneralModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final ADDRESS = amplify_core.QueryField(fieldName: "address");
  static final PHONE = amplify_core.QueryField(fieldName: "phone");
  static final AGE = amplify_core.QueryField(fieldName: "age");
  static final BIRTHDAY = amplify_core.QueryField(fieldName: "birthday");
  static final EMAIL = amplify_core.QueryField(fieldName: "email");
  static final IMAGE = amplify_core.QueryField(fieldName: "image");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "General";
    modelSchemaDefinition.pluralName = "Generals";
    
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
      key: General.NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: General.ADDRESS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: General.PHONE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: General.AGE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: General.BIRTHDAY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: General.EMAIL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: General.IMAGE,
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

class _GeneralModelType extends amplify_core.ModelType<General> {
  const _GeneralModelType();
  
  @override
  General fromJson(Map<String, dynamic> jsonData) {
    return General.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'General';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [General] in your schema.
 */
class GeneralModelIdentifier implements amplify_core.ModelIdentifier<General> {
  final String id;

  /** Create an instance of GeneralModelIdentifier using [id] the primary key. */
  const GeneralModelIdentifier({
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
  String toString() => 'GeneralModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is GeneralModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}