import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/Student.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/image_fromS3_provider.dart';

class PreviewStudentContainer extends ConsumerWidget {

  final Student student;
  final Function()? onDismissed;

  const PreviewStudentContainer({
    super.key,
    required this.student,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight = isPortatil ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 2;
    final screenWidth = MediaQuery.of(context).size.width;
    final imageUrl = ref.watch(imageProvider(student.image!));
    final date = ref.watch(dateProvider).today;
    Color containerColor;

    if(student.expirationPlan != null){
      final remainingDays = student.expirationPlan!.getDateTime().difference(DateTime.parse(date)).inDays;
      if( remainingDays > 3){
        containerColor = Color.fromRGBO(24, 135, 240, 0.2);
      }else if( remainingDays > 1){
       containerColor = Color.fromRGBO(206, 209, 36, 0.2);
      }else if( remainingDays > 0 ){
        containerColor = Color.fromRGBO(241, 142, 28, 0.2);
      }else{
        containerColor = Colors.transparent;
    }
    }else if(student.remainClasses != null){
        if(student.remainClasses! > 3 ){
        containerColor = Color.fromRGBO(24, 135, 240, 0.2);
        }else if(student.remainClasses! > 1){
        containerColor = Color.fromRGBO(206, 209, 36, 0.2);
        }else if(student.remainClasses! > 0 ){
          containerColor = Color.fromRGBO(241, 142, 28, 0.2);
        }else{
          containerColor = Colors.transparent;
      }
    }else{
      containerColor = Colors.transparent;
    }
    
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmationDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: screenHeight * 0.11,
          width: screenWidth,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: containerColor),
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
                          student.name!,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Eliminar asistencia?'),
          content: const Text(
            '¿Estás seguro de que deseas eliminar esta asistencia?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (onDismissed != null) {
                  onDismissed!();
                }
                Navigator.of(context).pop(true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }
}
