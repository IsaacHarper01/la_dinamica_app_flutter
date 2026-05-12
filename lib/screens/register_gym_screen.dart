import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RegisterGymScreen extends ConsumerStatefulWidget {

  const RegisterGymScreen({super.key});

  @override
  ConsumerState<RegisterGymScreen> createState() => _RegisterGymWidgetState();
}

class _RegisterGymWidgetState extends ConsumerState<RegisterGymScreen> {
  final gymNameController = TextEditingController();
  final sportController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ref.watch(userProvider).value;
    final label = "Registrar gimnasio";
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SignOutButton(),
          ],
        ),
      ),
      body: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorList[2],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code),
                    label: const Text('QR para nuevo acceso'),
                    onPressed: () async{
                        _showQrCodeDialog(context, '{"action":"newAccess","profID":"${userModel!.user}"}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      textStyle: textTheme.titleMedium,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                Text(label),
                SizedBox(height: 20),
                TextField(controller: gymNameController,
                          decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                color: Colors.white,),
                              labelText:"Nombre del gimnasio",
                              border: const OutlineInputBorder(),
                            ),),
                TextField(controller: sportController,
                          decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                color: Colors.white,),
                              labelText:"Giro del gimnasio",
                              border: const OutlineInputBorder(),
                            ),),
                SizedBox(height: 20),
                Row(children: [
                  Spacer(),
                  FilledButton(onPressed: ()async{
                    await ref.read(userProvider.notifier).registerGym(gymNameController.text, sportController.text, userModel!.user);
                    ref.read(userProvider.notifier).build();
                  }, child: Text("Registrar"))
                ],)
              ],
            ),
          ),
        ),
    );
  }
}


void _showQrCodeDialog(BuildContext context, String dataToEncode){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Este código contiene tu identificador de profesor para solicitar nuevos accesos',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              height: 250,
              child: QrImageView(
                      data: dataToEncode, 
                      size: 200,
                      backgroundColor: Colors.white,
                      ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.close),
              label: const Text('Cerrar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }