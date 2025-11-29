import 'package:flutter/material.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/widgets/preview_profesor_container.dart';

class ProfesorsScreen extends StatefulWidget {
   final UserLocal user;

   const ProfesorsScreen(
    {super.key, 
    required this.user,
    });

  @override
  State<ProfesorsScreen> createState() => _nameState();
}

class _nameState extends State<ProfesorsScreen> {
  List<UserAccess> profesors = [];

  @override
  void initState() {
    super.initState();
    loadProfesors();
  }

  void loadProfesors()async{
    final aws = DataStoreReadService();
    List<UserAccess> profesors = await aws.getUserPermisions(widget.user.tenant.tenant_id);
    setState(() {
      this.profesors = profesors;
    });
  }

  @override
  Widget build(BuildContext context) {
    final awsDelete = DataStoreDeleteService(); 
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Profesores"))),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
        child: Center(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: profesors.length,
            itemBuilder: (context, index) {
              final access = profesors[index];
              return PreviewProfesorContainer(
                access: access,
                image: '',
                refreshData: () {
                  loadProfesors();
                },
                onDelete: () async {
                  await awsDelete.deleteUserAccess(access);
                  setState(() {
                    profesors.removeAt(index);
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

  
