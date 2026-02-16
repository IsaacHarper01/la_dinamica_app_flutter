import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class GroupStudentsNotifier extends StateNotifier<Set<Student>>{
  GroupStudentsNotifier() : super({});

  void add(Student student){
    state = {...state,student};
    safePrint(state);
  } 

  void remove(Student student){
    state = state.where((s)=>s.user_id != student.user_id).toSet();
  }

  void clear(){
    state = {};
  }
}

final groupStudentsProvider = 
  StateNotifierProvider<GroupStudentsNotifier,Set<Student>>(
      (ref)=>GroupStudentsNotifier());