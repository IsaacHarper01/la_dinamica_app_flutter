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


/** This is an auto generated class representing the Student type in your schema. */
class Student extends amplify_core.Model {
  static const classType = const _StudentModelType();
  final String id;
  final int? _user_id;
  final String? _name;
  final String? _address;
  final int? _age;
  final String? _phone;
  final amplify_core.TemporalDate? _birthday;
  final String? _email;
  final String? _image;
  final String? _client_id;
  final List<Grades>? _grades;
  final List<Debt>? _debts;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  StudentModelIdentifier get modelIdentifier {
      return StudentModelIdentifier(
        id: id
      );
  }
  
  int? get user_id {
    return _user_id;
  }
  
  String? get name {
    return _name;
  }
  
  String? get address {
    return _address;
  }
  
  int? get age {
    return _age;
  }
  
  String? get phone {
    return _phone;
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
  
  String? get client_id {
    return _client_id;
  }
  
  List<Grades>? get grades {
    return _grades;
  }
  
  List<Debt>? get debts {
    return _debts;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Student._internal({required this.id, user_id, name, address, age, phone, birthday, email, image, client_id, grades, debts, createdAt, updatedAt}): _user_id = user_id, _name = name, _address = address, _age = age, _phone = phone, _birthday = birthday, _email = email, _image = image, _client_id = client_id, _grades = grades, _debts = debts, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Student({String? id, int? user_id, String? name, String? address, int? age, String? phone, amplify_core.TemporalDate? birthday, String? email, String? image, String? client_id, List<Grades>? grades, List<Debt>? debts}) {
    return Student._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      user_id: user_id,
      name: name,
      address: address,
      age: age,
      phone: phone,
      birthday: birthday,
      email: email,
      image: image,
      client_id: client_id,
      grades: grades != null ? List<Grades>.unmodifiable(grades) : grades,
      debts: debts != null ? List<Debt>.unmodifiable(debts) : debts);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Student &&
      id == other.id &&
      _user_id == other._user_id &&
      _name == other._name &&
      _address == other._address &&
      _age == other._age &&
      _phone == other._phone &&
      _birthday == other._birthday &&
      _email == other._email &&
      _image == other._image &&
      _client_id == other._client_id &&
      DeepCollectionEquality().equals(_grades, other._grades) &&
      DeepCollectionEquality().equals(_debts, other._debts);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Student {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + (_user_id != null ? _user_id!.toString() : "null") + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("address=" + "$_address" + ", ");
    buffer.write("age=" + (_age != null ? _age!.toString() : "null") + ", ");
    buffer.write("phone=" + "$_phone" + ", ");
    buffer.write("birthday=" + (_birthday != null ? _birthday!.format() : "null") + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("image=" + "$_image" + ", ");
    buffer.write("client_id=" + "$_client_id" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Student copyWith({int? user_id, String? name, String? address, int? age, String? phone, amplify_core.TemporalDate? birthday, String? email, String? image, String? client_id, List<Grades>? grades, List<Debt>? debts}) {
    return Student._internal(
      id: id,
      user_id: user_id ?? this.user_id,
      name: name ?? this.name,
      address: address ?? this.address,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      email: email ?? this.email,
      image: image ?? this.image,
      client_id: client_id ?? this.client_id,
      grades: grades ?? this.grades,
      debts: debts ?? this.debts);
  }
  
  Student copyWithModelFieldValues({
    ModelFieldValue<int?>? user_id,
    ModelFieldValue<String?>? name,
    ModelFieldValue<String?>? address,
    ModelFieldValue<int?>? age,
    ModelFieldValue<String?>? phone,
    ModelFieldValue<amplify_core.TemporalDate?>? birthday,
    ModelFieldValue<String?>? email,
    ModelFieldValue<String?>? image,
    ModelFieldValue<String?>? client_id,
    ModelFieldValue<List<Grades>?>? grades,
    ModelFieldValue<List<Debt>?>? debts
  }) {
    return Student._internal(
      id: id,
      user_id: user_id == null ? this.user_id : user_id.value,
      name: name == null ? this.name : name.value,
      address: address == null ? this.address : address.value,
      age: age == null ? this.age : age.value,
      phone: phone == null ? this.phone : phone.value,
      birthday: birthday == null ? this.birthday : birthday.value,
      email: email == null ? this.email : email.value,
      image: image == null ? this.image : image.value,
      client_id: client_id == null ? this.client_id : client_id.value,
      grades: grades == null ? this.grades : grades.value,
      debts: debts == null ? this.debts : debts.value
    );
  }
  
  Student.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = (json['user_id'] as num?)?.toInt(),
      _name = json['name'],
      _address = json['address'],
      _age = (json['age'] as num?)?.toInt(),
      _phone = json['phone'],
      _birthday = json['birthday'] != null ? amplify_core.TemporalDate.fromString(json['birthday']) : null,
      _email = json['email'],
      _image = json['image'],
      _client_id = json['client_id'],
      _grades = json['grades']  is Map
        ? (json['grades']['items'] is List
          ? (json['grades']['items'] as List)
              .where((e) => e != null)
              .map((e) => Grades.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['grades'] is List
          ? (json['grades'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Grades.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _debts = json['debts']  is Map
        ? (json['debts']['items'] is List
          ? (json['debts']['items'] as List)
              .where((e) => e != null)
              .map((e) => Debt.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['debts'] is List
          ? (json['debts'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Debt.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'name': _name, 'address': _address, 'age': _age, 'phone': _phone, 'birthday': _birthday?.format(), 'email': _email, 'image': _image, 'client_id': _client_id, 'grades': _grades?.map((Grades? e) => e?.toJson()).toList(), 'debts': _debts?.map((Debt? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'user_id': _user_id,
    'name': _name,
    'address': _address,
    'age': _age,
    'phone': _phone,
    'birthday': _birthday,
    'email': _email,
    'image': _image,
    'client_id': _client_id,
    'grades': _grades,
    'debts': _debts,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<StudentModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<StudentModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USER_ID = amplify_core.QueryField(fieldName: "user_id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final ADDRESS = amplify_core.QueryField(fieldName: "address");
  static final AGE = amplify_core.QueryField(fieldName: "age");
  static final PHONE = amplify_core.QueryField(fieldName: "phone");
  static final BIRTHDAY = amplify_core.QueryField(fieldName: "birthday");
  static final EMAIL = amplify_core.QueryField(fieldName: "email");
  static final IMAGE = amplify_core.QueryField(fieldName: "image");
  static final CLIENT_ID = amplify_core.QueryField(fieldName: "client_id");
  static final GRADES = amplify_core.QueryField(
    fieldName: "grades",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Grades'));
  static final DEBTS = amplify_core.QueryField(
    fieldName: "debts",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Debt'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Student";
    modelSchemaDefinition.pluralName = "Students";
    
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
      key: Student.USER_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Student.NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Student.ADDRESS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Student.AGE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Student.PHONE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Student.BIRTHDAY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Student.EMAIL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Student.IMAGE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Student.CLIENT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Student.GRADES,
      isRequired: false,
      ofModelName: 'Grades',
      associatedKey: Grades.STUDENT
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Student.DEBTS,
      isRequired: false,
      ofModelName: 'Debt',
      associatedKey: Debt.STUDENT
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

class _StudentModelType extends amplify_core.ModelType<Student> {
  const _StudentModelType();
  
  @override
  Student fromJson(Map<String, dynamic> jsonData) {
    return Student.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Student';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Student] in your schema.
 */
class StudentModelIdentifier implements amplify_core.ModelIdentifier<Student> {
  final String id;

  /** Create an instance of StudentModelIdentifier using [id] the primary key. */
  const StudentModelIdentifier({
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
  String toString() => 'StudentModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is StudentModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}