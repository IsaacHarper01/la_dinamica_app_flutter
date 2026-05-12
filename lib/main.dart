import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/config/theme/util.dart';
import 'package:la_dinamica_app/screens/app_gate_screen.dart';
import 'package:la_dinamica_app/screens/login.dart';

// import the Amplify API plugin
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import "amplifyconfiguration.dart";
import 'package:la_dinamica_app/models/ModelProvider.dart';

import 'config/provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify(); // ✅ Se asegura que se configure una sola vez
  //await Amplify.DataStore.stop();
  // await Amplify.DataStore.clear();
  // await Amplify.DataStore.start();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _configureAmplify() async {
  final datastorePlugin = AmplifyDataStore(modelProvider: ModelProvider.instance);
  final apiPlugin = AmplifyAPI();
  final storage = AmplifyStorageS3();
  final auth = AmplifyAuthCognito();
  
  if (!Amplify.isConfigured) {
    try {
      await Amplify.addPlugins([datastorePlugin, apiPlugin, storage, auth]);
      await Amplify.configure(amplifyconfig);
      safePrint('✅ Amplify configurado correctamente');
    } on AmplifyAlreadyConfiguredException {
      safePrint('⚠️ Amplify ya estaba configurado');
    } catch (e) {
      safePrint('❌ Error al configurar Amplify: $e');
    }
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    TextTheme textTheme = createTextTheme(context, "Mulish", "Work Sans");
    MaterialTheme theme = MaterialTheme(textTheme);

    return Authenticator(
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
            return CustomScaffold(
              state: state,
              // A prebuilt Sign In form from amplify_authenticator
              body: SignInForm(),
              // A custom footer with a button to take the user to sign up
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No tienes una cuenta?'),
                  TextButton(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signUp,
                    ),
                    child: const Text('Crear cuenta'),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.signUp:
            return CustomScaffold(
              state: state,
              // A prebuilt Sign Up form from amplify_authenticator
              body: SignUpForm(),
              // A custom footer with a button to take the user to sign in
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Ya tienes una cuenta?'),
                  TextButton(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signIn,
                    ),
                    child: const Text('Entrar'),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.confirmSignUp:
            return CustomScaffold(
              state: state,
              // A prebuilt Confirm Sign Up form from amplify_authenticator
              body: ConfirmSignUpForm(),
            );
          case AuthenticatorStep.resetPassword:
            return CustomScaffold(
              state: state,
              // A prebuilt Reset Password form from amplify_authenticator
              body: ResetPasswordForm(),
            );
          case AuthenticatorStep.confirmResetPassword:
            return CustomScaffold(
              state: state,
              // A prebuilt Confirm Reset Password form from amplify_authenticator
              body: const ConfirmResetPasswordForm(),
            );
          default:
            // Returning null defaults to the prebuilt authenticator for all other steps
            return null;
        }
      },
      
      child: MaterialApp(
        builder: Authenticator.builder(),
        title: 'La Dinamica del Movimiento',
        debugShowCheckedModeBanner: false,
        theme: theme.light(),
        darkTheme: theme.dark(),
        themeMode: themeMode,
        home: const AppGate(),
      )
    );
  }
}

