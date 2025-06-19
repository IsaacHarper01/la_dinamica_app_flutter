import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/config/theme/util.dart';
import 'package:la_dinamica_app/screens/login.dart';
import 'package:la_dinamica_app/screens/main_screen.dart';
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
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _configureAmplify() async {
  final datastorePlugin = AmplifyDataStore(modelProvider: ModelProvider.instance);
  final apiPlugin = AmplifyAPI();

  if (!Amplify.isConfigured) {
    try {

      await Amplify.addPlugins([datastorePlugin, apiPlugin]);
      await Amplify.addPlugin(AmplifyAuthCognito());
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
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signUp,
                    ),
                    child: const Text('Sign Up'),
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
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signIn,
                    ),
                    child: const Text('Sign In'),
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
        home: const MainScreen(),
      )
    );
  }
}

