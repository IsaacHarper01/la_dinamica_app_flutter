import 'package:la_dinamica_app/models/ModelProvider.dart';

class GroupState {
  final List<JoinGroups> groupJoinList;
  final Map<String, Set<Student>> groupList;
  final Map<String, String> groupDescriptions;
  final List<Student> filteredStudents;
  final Set<String> setGroups;
  final String actualGroup;

  GroupState(
    {
      this.groupJoinList = const [],
      this.groupList = const {},
      this.groupDescriptions = const {},
      this.filteredStudents = const [],
      this.setGroups = const {},
      this.actualGroup = "",
    }); 
  GroupState copyWith({
  List<JoinGroups>? groupJoinList,
  Map<String, Set<Student>>? groupList,
  Map<String, String>? groupDescriptions,
  List<Student>? filteredStudents,
  Set<String>? setGroups,
  String? actualGroup,
  }){
    return GroupState(
      groupJoinList: groupJoinList ?? this.groupJoinList,
      groupList: groupList ?? this.groupList,
      groupDescriptions: groupDescriptions ?? this.groupDescriptions,
      filteredStudents: filteredStudents ?? this.filteredStudents,
      setGroups: setGroups ?? this.setGroups,
      actualGroup: actualGroup ?? this.actualGroup, 
    );
  }
}