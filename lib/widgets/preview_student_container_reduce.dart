import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/image_fromS3_provider.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class PreviewStudentContainerReduce extends ConsumerWidget{
  final Student student;
  final Color backgroundColor;
  final Icon? trailingIcon;

  const PreviewStudentContainerReduce({
    super.key,
    required this.student,
    required this.backgroundColor,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final date = ref.watch(dateProvider).today;
    final screenHeight = isPortatil ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 2;
    final screenWidth = MediaQuery.of(context).size.width;
    final imageUrl = ref.watch(imageProvider(student.image!));
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
        containerColor = backgroundColor;
    }
    }else{
        if(student.remainClasses! > 3 ){
        containerColor = Color.fromRGBO(24, 135, 240, 0.2);
        }else if(student.remainClasses! > 1){
        containerColor = Color.fromRGBO(206, 209, 36, 0.2);
        }else if(student.remainClasses! > 0 ){
          containerColor = Color.fromRGBO(241, 142, 28, 0.2);
        }else{
          containerColor = backgroundColor;
      }
    }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: screenHeight * 0.07,
            width: screenWidth,
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child:
                    imageUrl.when(
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            student.name!,
                            style: GoogleFonts.gochiHand(
                              fontSize: screenHeight * 0.03,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                          ),
                        ),
                        Text(
                          'ID: ${student.user_id}',
                          style: GoogleFonts.gochiHand(
                            fontSize: screenHeight * 0.017,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child:
                  trailingIcon != null
                      ? Padding(
                    key: ValueKey('icon-${student.user_id}'),
                    padding: const EdgeInsets.only(right: 12.0),
                    child: trailingIcon,
                  )
                      : SizedBox.shrink(key: ValueKey('empty-${student.user_id}')),
                ),
              ],
            ),
          ),
        );
  }  
}
