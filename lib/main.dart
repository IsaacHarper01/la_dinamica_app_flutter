import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/config/theme/util.dart';
import 'package:la_dinamica_app/screens/main_screen.dart';
// import the Amplify API plugin
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

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

    return MaterialApp(
      title: 'La Dinamica del Movimiento',
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: themeMode,
      home: const MainScreen(),
    );
  }
}

