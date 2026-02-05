import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';

class GroupsPage extends ConsumerStatefulWidget {
  const GroupsPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                SizedBox(
                  width: double.maxFinite,
                  child: Expanded(
                    child: TextFormField(
                      controller: groupName,
                      decoration: InputDecoration(
                                  labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 5, 152, 197),
                                          ))
                      )
                    ),
                )
              ]
        ],
      ),
    );
  }
}