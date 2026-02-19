import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/add_students_to_gruop_provider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/selected_group_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/edit_routine_screen.dart';
import 'package:la_dinamica_app/widgets/groups_screen/students_List_widget.dart';
import 'package:la_dinamica_app/widgets/groups_screen/students_by_group_list.dart';

class GroupsPage extends ConsumerStatefulWidget {
  final List<Student> allStudents;
  final double screenHeight; 
  const GroupsPage({
    super.key,
    required this.allStudents,
    required this.screenHeight,
  });

  @override
  ConsumerState<GroupsPage> createState() => NameState();
}

class NameState extends ConsumerState<GroupsPage> {
  Future<List<JoinGroups>>? joinGroups;
  UserLocal? user;
  bool newGruop = false;
  bool onEdit = false;
  TextEditingController groupName = TextEditingController();
  TextEditingController groupDescription = TextEditingController();
  Map<String, Set<Student>> groupStudentsMap = {};
  Map<String, String> groupStudentsDescriptionsMap = {};
  Set<String> setGroups = {};
  List<String> listGroups = [];
  bool showAllStudents = true;

  @override
  void initState() {
    super.initState();
    loadGroups();
  }

  void loadGroups()async{
    final _user = await ref.read(userProvider.future);
    setState(() {
      user = _user;
      joinGroups = DataStoreReadService().getJoinGroups(_user.tenant.tenant_id); 
    });
  }

  void setnewGroup(){
    setState(() {
      newGruop = !newGruop;
    });
  }


  void setShowAll(bool value){
    setState(() {
      showAllStudents = value;
    });
  }

  void setMap(List<JoinGroups> joinGroups){
    for(var member in joinGroups){
      String groupName = member.group!.name!;
      groupStudentsMap.putIfAbsent(groupName, ()=> <Student>{}).add(member.student!);
      groupStudentsDescriptionsMap.putIfAbsent(groupName, ()=>member.group!.description!);
      setGroups.add(groupName);
    }
    listGroups = setGroups.toList();
  }

  void saveGroup(BuildContext context) async{
    final user = await ref.watch(userProvider.future); 
    final tenantId = user.tenant.tenant_id;
    final studentsinGroup = ref.watch(groupStudentsProvider);
    final aws = DataStoreService();
    if(groupName.text == "" || groupDescription.text == "" || studentsinGroup.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Agrega nombre, descripción y miembros al grupo'),
              backgroundColor: Colors.red,),
                );
    }else{
       final newGroup = await aws.saveGroup(name: groupName.text, tenantId: tenantId, description: groupDescription.text);
       for(var student in studentsinGroup){
        await aws.saveJoinGroup(student: student, group: newGroup, tenantId: tenantId);
       }
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Grupo salvado correctamente'),
              backgroundColor: Colors.green),
                );
    }
  }

  Future<void> generateRutine(BuildContext context, String description, String groupName)async{
    final aws = DataStoreReadService();
    final String routine = await aws.generateRutineByGroup(description);
    await Navigator.push(
      context, MaterialPageRoute(
        builder:(context) => RoutineEditorPage(
          initialRoutine: routine, groupName: groupName)
          )
        );
      }

  
  @override
  Widget build(BuildContext context) {
    String selectedGroup = ref.watch(selectedGroupProvider);
    if (joinGroups == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return FutureBuilder<List<JoinGroups>>(
      future: joinGroups, 
      builder: (BuildContext context, AsyncSnapshot<List<JoinGroups>> snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
        setMap(snapshot.data!);
        
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(title: Center(child: Text("Grupos"))),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Row(
                    children: [
                      FilledButton.icon(
                            onPressed: (){setnewGroup();},
                            label: Text(
                              newGruop ? 'Cancelar':'Nuevo grupo',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: Icon(
                              newGruop ? Icons.cancel : Icons.group_add_rounded,
                              color: Colors.white,
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(colorList[3]),
                            ),
                          ),
                          const Spacer(),
                          FilledButton.icon(
                            onPressed: (){},
                            label: const Text(
                              'Editar',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(colorList[3]),
                            ),
                          ),
                      ],
                    ),
                  ),
                  DropdownButton<String>(
                    borderRadius: BorderRadius.circular(10),
                    hint: Text(selectedGroup != "" ? selectedGroup:setGroups.first),
                    isExpanded: true,
                    value: selectedGroup != "" ? selectedGroup:setGroups.first,
                    items: setGroups.map((String option){
                      return DropdownMenuItem(
                        alignment: Alignment.center,
                        value: option,
                        child: Text(option));
                    }).toList(), 
                  onChanged: (value) => ref.read(selectedGroupProvider.notifier).state = value!
                  ),
                  if(newGruop)...[
                      Column(
                        children: [
                          SizedBox(
                          width: double.maxFinite,
                            child: TextFormField(
                              controller: groupName,
                              decoration: InputDecoration(
                                                labelStyle: const TextStyle(
                                                  color: Colors.white,),
                                                labelText:"Nombre del grupo",
                                                border: const OutlineInputBorder(),
                                              ),
                              )
                          ),
                          StudentsListWidget(allstudents: widget.allStudents,screenHeight: widget.screenHeight,),
                          SizedBox(
                          height: widget.screenHeight*0.1,
                          width: double.maxFinite,
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextField(
                                  controller: groupDescription,
                                  maxLines: null,
                                  expands: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Descripción del grupo",
                                  ),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          FilledButton.icon(
                            onPressed: ()=>saveGroup(context),
                            label: const Text('Guardar',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(Icons.save,
                              color: Colors.white,
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(colorList[3]),
                            ),
                          ),
                        ]
                      )
                    ]else...[
                      Row(
                        children: [
                          Checkbox(
                          value: showAllStudents, 
                          onChanged: (value){setShowAll(value!);
                          }),
                          Text("Mostar todos")
                        ]
                      ),
                      StudentsByGroupListWidget(
                        allstudents: widget.allStudents, 
                        filterStudents: groupStudentsMap[selectedGroup != "" ? selectedGroup:setGroups.first]!.toList(), 
                        showAll: showAllStudents, 
                        screenHeight: widget.screenHeight),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: ElevatedButton.icon(
                          onPressed:()=>generateRutine(context,groupStudentsDescriptionsMap[selectedGroup]!,selectedGroup),
                          label: const Text("Generar Rutina"),
                          icon: const Icon(Icons.auto_fix_high),
                          style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      ),
                    )
                    ]
              ],
            ),
          ),
        );
        }
      }
    );
  }
}