import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/widgets/stop_wacth_widget.dart';

final stopwatchProvider = StateNotifierProvider<StopwatchNotifier, String>(
  (ref) => StopwatchNotifier(),
);
