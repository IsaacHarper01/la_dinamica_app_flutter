import 'package:flutter_riverpod/flutter_riverpod.dart';


final selectedStudentsProvider =
    StateNotifierProvider<SelectedStudentsNotifier, Set<String>>((ref) {
  return SelectedStudentsNotifier();
});

class SelectedStudentsNotifier extends StateNotifier<Set<String>> {
  SelectedStudentsNotifier() : super({});

  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }

  void add(String id) => state = {...state, id};
  void remove(String id) => state = {...state}..remove(id);
  void clear() => state = {};
}
