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


/** This is an auto generated class representing the Sale type in your schema. */
class Sale extends amplify_core.Model {
  static const classType = const _SaleModelType();
  final String id;
  final String? _tenant_id;
  final double? _price;
  final amplify_core.TemporalDate? _date;
  final Product? _product;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  SaleModelIdentifier get modelIdentifier {
      return SaleModelIdentifier(
        id: id
      );
  }
  
  String? get tenant_id {
    return _tenant_id;
  }
  
  double? get price {
    return _price;
  }
  
  amplify_core.TemporalDate? get date {
    return _date;
  }
  
  Product? get product {
    return _product;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Sale._internal({required this.id, tenant_id, price, date, product, createdAt, updatedAt}): _tenant_id = tenant_id, _price = price, _date = date, _product = product, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Sale({String? id, String? tenant_id, double? price, amplify_core.TemporalDate? date, Product? product}) {
    return Sale._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      tenant_id: tenant_id,
      price: price,
      date: date,
      product: product);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Sale &&
      id == other.id &&
      _tenant_id == other._tenant_id &&
      _price == other._price &&
      _date == other._date &&
      _product == other._product;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Sale {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("tenant_id=" + "$_tenant_id" + ", ");
    buffer.write("price=" + (_price != null ? _price!.toString() : "null") + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("product=" + (_product != null ? _product!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Sale copyWith({String? tenant_id, double? price, amplify_core.TemporalDate? date, Product? product}) {
    return Sale._internal(
      id: id,
      tenant_id: tenant_id ?? this.tenant_id,
      price: price ?? this.price,
      date: date ?? this.date,
      product: product ?? this.product);
  }
  
  Sale copyWithModelFieldValues({
    ModelFieldValue<String?>? tenant_id,
    ModelFieldValue<double?>? price,
    ModelFieldValue<amplify_core.TemporalDate?>? date,
    ModelFieldValue<Product?>? product
  }) {
    return Sale._internal(
      id: id,
      tenant_id: tenant_id == null ? this.tenant_id : tenant_id.value,
      price: price == null ? this.price : price.value,
      date: date == null ? this.date : date.value,
      product: product == null ? this.product : product.value
    );
  }
  
  Sale.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _tenant_id = json['tenant_id'],
      _price = (json['price'] as num?)?.toDouble(),
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _product = json['product'] != null
        ? json['product']['serializedData'] != null
          ? Product.fromJson(new Map<String, dynamic>.from(json['product']['serializedData']))
          : Product.fromJson(new Map<String, dynamic>.from(json['product']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'tenant_id': _tenant_id, 'price': _price, 'date': _date?.format(), 'product': _product?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'tenant_id': _tenant_id,
    'price': _price,
    'date': _date,
    'product': _product,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<SaleModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<SaleModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TENANT_ID = amplify_core.QueryField(fieldName: "tenant_id");
  static final PRICE = amplify_core.QueryField(fieldName: "price");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final PRODUCT = amplify_core.QueryField(
    fieldName: "product",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Product'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Sale";
    modelSchemaDefinition.pluralName = "Sales";
    
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
      key: Sale.TENANT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Sale.PRICE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Sale.DATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Sale.PRODUCT,
      isRequired: false,
      targetNames: ['product_id'],
      ofModelName: 'Product'
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

class _SaleModelType extends amplify_core.ModelType<Sale> {
  const _SaleModelType();
  
  @override
  Sale fromJson(Map<String, dynamic> jsonData) {
    return Sale.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Sale';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Sale] in your schema.
 */
class SaleModelIdentifier implements amplify_core.ModelIdentifier<Sale> {
  final String id;

  /** Create an instance of SaleModelIdentifier using [id] the primary key. */
  const SaleModelIdentifier({
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
  String toString() => 'SaleModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is SaleModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}