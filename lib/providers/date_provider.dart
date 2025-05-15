import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A global provider to store and access the currently selected date.
/// Default value is the current date.
/// 

final dateProvider = StateProvider<String>((ref) => DateTime.now().toString().split(' ')[0]);