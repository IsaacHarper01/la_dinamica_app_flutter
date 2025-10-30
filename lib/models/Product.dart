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


/** This is an auto generated class representing the Product type in your schema. */
class Product extends amplify_core.Model {
  static const classType = const _ProductModelType();
  final String id;
  final String? _code;
  final String? _name;
  final String? _tenant_id;
  final double? _price;
  final String? _image;
  final int? _stock;
  final String? _category;
  final List<Sale>? _sale;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ProductModelIdentifier get modelIdentifier {
      return ProductModelIdentifier(
        id: id
      );
  }
  
  String? get code {
    return _code;
  }
  
  String? get name {
    return _name;
  }
  
  String? get tenant_id {
    return _tenant_id;
  }
  
  double? get price {
    return _price;
  }
  
  String? get image {
    return _image;
  }
  
  int? get stock {
    return _stock;
  }
  
  String? get category {
    return _category;
  }
  
  List<Sale>? get sale {
    return _sale;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Product._internal({required this.id, code, name, tenant_id, price, image, stock, category, sale, createdAt, updatedAt}): _code = code, _name = name, _tenant_id = tenant_id, _price = price, _image = image, _stock = stock, _category = category, _sale = sale, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Product({String? id, String? code, String? name, String? tenant_id, double? price, String? image, int? stock, String? category, List<Sale>? sale}) {
    return Product._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      code: code,
      name: name,
      tenant_id: tenant_id,
      price: price,
      image: image,
      stock: stock,
      category: category,
      sale: sale != null ? List<Sale>.unmodifiable(sale) : sale);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Product &&
      id == other.id &&
      _code == other._code &&
      _name == other._name &&
      _tenant_id == other._tenant_id &&
      _price == other._price &&
      _image == other._image &&
      _stock == other._stock &&
      _category == other._category &&
      DeepCollectionEquality().equals(_sale, other._sale);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Product {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("code=" + "$_code" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("tenant_id=" + "$_tenant_id" + ", ");
    buffer.write("price=" + (_price != null ? _price!.toString() : "null") + ", ");
    buffer.write("image=" + "$_image" + ", ");
    buffer.write("stock=" + (_stock != null ? _stock!.toString() : "null") + ", ");
    buffer.write("category=" + "$_category" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Product copyWith({String? code, String? name, String? tenant_id, double? price, String? image, int? stock, String? category, List<Sale>? sale}) {
    return Product._internal(
      id: id,
      code: code ?? this.code,
      name: name ?? this.name,
      tenant_id: tenant_id ?? this.tenant_id,
      price: price ?? this.price,
      image: image ?? this.image,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      sale: sale ?? this.sale);
  }
  
  Product copyWithModelFieldValues({
    ModelFieldValue<String?>? code,
    ModelFieldValue<String?>? name,
    ModelFieldValue<String?>? tenant_id,
    ModelFieldValue<double?>? price,
    ModelFieldValue<String?>? image,
    ModelFieldValue<int?>? stock,
    ModelFieldValue<String?>? category,
    ModelFieldValue<List<Sale>?>? sale
  }) {
    return Product._internal(
      id: id,
      code: code == null ? this.code : code.value,
      name: name == null ? this.name : name.value,
      tenant_id: tenant_id == null ? this.tenant_id : tenant_id.value,
      price: price == null ? this.price : price.value,
      image: image == null ? this.image : image.value,
      stock: stock == null ? this.stock : stock.value,
      category: category == null ? this.category : category.value,
      sale: sale == null ? this.sale : sale.value
    );
  }
  
  Product.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _code = json['code'],
      _name = json['name'],
      _tenant_id = json['tenant_id'],
      _price = (json['price'] as num?)?.toDouble(),
      _image = json['image'],
      _stock = (json['stock'] as num?)?.toInt(),
      _category = json['category'],
      _sale = json['sale']  is Map
        ? (json['sale']['items'] is List
          ? (json['sale']['items'] as List)
              .where((e) => e != null)
              .map((e) => Sale.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['sale'] is List
          ? (json['sale'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Sale.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'code': _code, 'name': _name, 'tenant_id': _tenant_id, 'price': _price, 'image': _image, 'stock': _stock, 'category': _category, 'sale': _sale?.map((Sale? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'code': _code,
    'name': _name,
    'tenant_id': _tenant_id,
    'price': _price,
    'image': _image,
    'stock': _stock,
    'category': _category,
    'sale': _sale,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ProductModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ProductModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final CODE = amplify_core.QueryField(fieldName: "code");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final TENANT_ID = amplify_core.QueryField(fieldName: "tenant_id");
  static final PRICE = amplify_core.QueryField(fieldName: "price");
  static final IMAGE = amplify_core.QueryField(fieldName: "image");
  static final STOCK = amplify_core.QueryField(fieldName: "stock");
  static final CATEGORY = amplify_core.QueryField(fieldName: "category");
  static final SALE = amplify_core.QueryField(
    fieldName: "sale",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Sale'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Product";
    modelSchemaDefinition.pluralName = "Products";
    
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
      amplify_core.ModelIndex(fields: const ["code"], name: "byCode")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Product.CODE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Product.NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Product.TENANT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Product.PRICE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Product.IMAGE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Product.STOCK,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Product.CATEGORY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Product.SALE,
      isRequired: false,
      ofModelName: 'Sale',
      associatedKey: Sale.PRODUCT
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

class _ProductModelType extends amplify_core.ModelType<Product> {
  const _ProductModelType();
  
  @override
  Product fromJson(Map<String, dynamic> jsonData) {
    return Product.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Product';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Product] in your schema.
 */
class ProductModelIdentifier implements amplify_core.ModelIdentifier<Product> {
  final String id;

  /** Create an instance of ProductModelIdentifier using [id] the primary key. */
  const ProductModelIdentifier({
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
  String toString() => 'ProductModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ProductModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}