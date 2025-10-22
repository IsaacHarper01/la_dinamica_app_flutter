import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/LocalPlan.dart';

final defaultPlanProvider = StateProvider<LocalPlan> ((ref) {
  return LocalPlan(
    type: "none",
    clases: 0,
    price: 0.0,
    client_id: "none",
    );
  }
);
