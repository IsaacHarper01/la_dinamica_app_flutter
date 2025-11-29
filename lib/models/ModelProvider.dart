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

import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'AppPlan.dart';
import 'Attendance.dart';
import 'Evaluations.dart';
import 'ExamResults.dart';
import 'JoinMetric.dart';
import 'JoinResults.dart';
import 'LocalPlan.dart';
import 'Metric.dart';
import 'Payment.dart';
import 'Product.dart';
import 'Sale.dart';
import 'Student.dart';
import 'Tenant.dart';
import 'User.dart';
import 'UserAccess.dart';

export 'AppPlan.dart';
export 'Attendance.dart';
export 'Evaluations.dart';
export 'ExamResults.dart';
export 'JoinMetric.dart';
export 'JoinResults.dart';
export 'LocalPlan.dart';
export 'Metric.dart';
export 'Payment.dart';
export 'Product.dart';
export 'Sale.dart';
export 'Student.dart';
export 'Tenant.dart';
export 'User.dart';
export 'UserAccess.dart';

class ModelProvider implements amplify_core.ModelProviderInterface {
  @override
  String version = "9a2be017cf2c528080a871e42fbde151";
  @override
  List<amplify_core.ModelSchema> modelSchemas = [AppPlan.schema, Attendance.schema, Evaluations.schema, ExamResults.schema, JoinMetric.schema, JoinResults.schema, LocalPlan.schema, Metric.schema, Payment.schema, Product.schema, Sale.schema, Student.schema, Tenant.schema, User.schema, UserAccess.schema];
  @override
  List<amplify_core.ModelSchema> customTypeSchemas = [];
  static final ModelProvider _instance = ModelProvider();

  static ModelProvider get instance => _instance;
  
  amplify_core.ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
      case "AppPlan":
        return AppPlan.classType;
      case "Attendance":
        return Attendance.classType;
      case "Evaluations":
        return Evaluations.classType;
      case "ExamResults":
        return ExamResults.classType;
      case "JoinMetric":
        return JoinMetric.classType;
      case "JoinResults":
        return JoinResults.classType;
      case "LocalPlan":
        return LocalPlan.classType;
      case "Metric":
        return Metric.classType;
      case "Payment":
        return Payment.classType;
      case "Product":
        return Product.classType;
      case "Sale":
        return Sale.classType;
      case "Student":
        return Student.classType;
      case "Tenant":
        return Tenant.classType;
      case "User":
        return User.classType;
      case "UserAccess":
        return UserAccess.classType;
      default:
        throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
  }
}


class ModelFieldValue<T> {
  const ModelFieldValue.value(this.value);

  final T value;
}
