import 'package:flutter_riverpod/flutter_riverpod.dart';


final selectedStudentsProvider =
    StateNotifierProvider<SelectedStudentsNotifier, Set<int>>((ref) {
  return SelectedStudentsNotifier();
});

class SelectedStudentsNotifier extends StateNotifier<Set<int>> {
  SelectedStudentsNotifier() : super({});

  void toggle(int id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id}; 
    }
  }

  void add(int id) => state = {...state, id};
  void remove(int id) => state = {...state}..remove(id);
  void clear() => state = {};
}
