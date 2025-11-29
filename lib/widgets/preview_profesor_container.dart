import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/image_fromS3_provider.dart';
import 'package:la_dinamica_app/screens/edit_profesors_screen.dart';

class PreviewProfesorContainer extends ConsumerWidget {
  final UserAccess access;
  final String image;
  final Function()? onDelete;
  final Function()? refreshData;

  const PreviewProfesorContainer({
    super.key,
    required this.access,
    required this.image,
    required this.onDelete ,
    required this.refreshData,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight = isPortatil ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 2;
    final screenWidth = MediaQuery.of(context).size.width;
    final imageUrl = ref.watch(imageProvider(image));
    final colorScheme = ColorScheme.of(context);

    return Card(
      color: access.isAdmin! ? colorScheme.surface.withGreen(70) : colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: screenHeight * 0.11,
            width: screenWidth,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: screenHeight * 0.09,
                      width: screenHeight * 0.09,
                      child: imageUrl.when(
                        data: (url) => Image.network(
                          url ?? "",
                          width: screenHeight * 0.06,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/default_profile.jpg',
                              width: screenHeight * 0.06,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        loading: () => SizedBox(
                          width: screenHeight * 0.06,
                          height: screenHeight * 0.06,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (_, __) => Image.asset(
                          'assets/images/default_profile.jpg',
                          width: screenHeight * 0.06,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          access.user!.name,
                          style: TextStyle(
                            fontSize: screenHeight * 0.025,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'delete') {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text('¿Eliminar Profesor?'),
                              content: const Text(
                                'Esta acción no se puede deshacer. ¿Estás seguro?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            ),
                      );
                      if (confirm == true) {
                        onDelete!();
                      }
                    }
                  if(value == 'update'){
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (_)=> 
                          EditPermissionsScreen(access: access)
                          )
                        ).then( (_){
                          refreshData!();
                        });
                    }
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem<String>(
                          value: 'update',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blueAccent),
                              SizedBox(width: 8),
                              Text('Editar'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.redAccent),
                              SizedBox(width: 8),
                              Text('Eliminar'),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
          ),
        ),
    );
  }

}