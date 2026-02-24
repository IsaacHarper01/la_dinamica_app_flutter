import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/group_state.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

final seletedGroupProvider = StateNotifierProvider<GroupNotifier, AsyncValue<GroupState>>((ref)=>GroupNotifier(ref));

class GroupNotifier extends StateNotifier<AsyncValue<GroupState>> {
  final Ref ref;

  GroupNotifier(this.ref): super(const AsyncValue.loading()){
    _init();
  }

  Future<void> _init()async{
    try {
      final user = await ref.watch(userProvider.future);
      final newGroupState = await setGroupState(user.tenant.tenant_id);
      state = AsyncData(newGroupState);
    } catch (e,st) {
      state = AsyncError(e,st);
    }
  }

  Future<GroupState> setGroupState(tenantId)async{ 
    Map<String, Set<Student>> groupStudentsMap = {};
    Map<String, String> groupStudentsDescriptionsMap = {};
    Set<String> setGroups = {};
    List<String> listGroups = [];
    String actualGroup = "";

    final joinGroups = await DataStoreReadService().getJoinGroups(tenantId);
    for(var member in joinGroups){
        String groupName = member.group!.name!;
        groupStudentsMap.putIfAbsent(groupName, ()=> <Student>{}).add(member.student!);
        groupStudentsDescriptionsMap.putIfAbsent(groupName, ()=>member.group!.description!);
        setGroups.add(groupName);
      }
    listGroups = setGroups.toList();
    actualGroup = listGroups[0];

    return GroupState(
      groupJoinList: joinGroups,
      groupList: groupStudentsMap,
      groupDescriptions: groupStudentsDescriptionsMap,
      filteredStudents: groupStudentsMap[actualGroup]!.toList(),
      setGroups: setGroups,
      actualGroup: actualGroup,
    );
    }
  
  void changeActualGroup(String newGroup){
    state.whenData((currentState){
      state = AsyncData(currentState.copyWith(
        actualGroup: newGroup,
        filteredStudents: currentState.groupList[newGroup]!.toList()
        )); 
    });
  }

}

