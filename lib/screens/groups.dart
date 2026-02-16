import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/add_students_to_gruop_provider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/widgets/groups_screen/students_List_widget.dart';

class GroupsPage extends ConsumerStatefulWidget {
  final List<Student> allStudents;
  final double screenHeight; 
  const GroupsPage({
    super.key,
    required this.allStudents,
    required this.screenHeight,
  });

  @override
  ConsumerState<GroupsPage> createState() => _nameState();
}

class _nameState extends ConsumerState<GroupsPage> {
  bool newGruop = false;
  bool onEdit = false;
  TextEditingController groupName = TextEditingController();
  TextEditingController groupDescription = TextEditingController();

  void setnewGroup(){
    setState(() {
      newGruop = !newGruop;
    });
  }

  void saveGroup() async{
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

  @override
  Widget build(BuildContext context) {
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
                        label: const Text(
                          'Nuevo grupo',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: const Icon(
                          Icons.group_add_rounded,
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
                        child: TextFormField(
                          controller: groupDescription,
                          decoration: InputDecoration(
                                            labelStyle: const TextStyle(
                                              color: Colors.white,),
                                            labelText:"Descripción del grupo",
                                            border: const OutlineInputBorder(),
                                          ),
                          )
                      ),
                      FilledButton.icon(
                        onPressed: ()=>saveGroup(),
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
                ]
          ],
        ),
      ),
    );
  }
}