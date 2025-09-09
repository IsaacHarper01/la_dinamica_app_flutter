// Provider to keep track of the selected value
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedDateProviderMetrics = StateProvider<int?>((ref) => 1);